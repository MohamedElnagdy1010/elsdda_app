const {setGlobalOptions} = require("firebase-functions");
const {onCall, HttpsError} = require("firebase-functions/v2/https");
const {initializeApp} = require("firebase-admin/app");
const {getFirestore, FieldValue} = require("firebase-admin/firestore");

initializeApp();

setGlobalOptions({
  maxInstances: 10,
});

const db = getFirestore();

const DELIVERY_FEE = 10;
const MAX_ITEM_QUANTITY = 20;
const MAX_CART_ITEMS = 50;

exports.createOrder = onCall(async (request) => {
  // =========================
  // 1. Authentication
  // =========================

  if (!request.auth) {
    throw new HttpsError(
        "unauthenticated",
        "You must be logged in to create an order.",
    );
  }

  const userId = request.auth.uid;
  const data = request.data;

  // =========================
  // 2. Validate request
  // =========================

  if (!data || typeof data !== "object") {
    throw new HttpsError(
        "invalid-argument",
        "Invalid order data.",
    );
  }

  const address =
    typeof data.address === "string" ? data.address.trim() : "";

  const paymentMethod =
    typeof data.paymentMethod === "string" ?
      data.paymentMethod.trim() :
      "";

  const items = data.items;

  if (address.length < 5 || address.length > 300) {
    throw new HttpsError(
        "invalid-argument",
        "Invalid delivery address.",
    );
  }

  if (paymentMethod !== "cash") {
    throw new HttpsError(
        "invalid-argument",
        "Unsupported payment method.",
    );
  }

  if (!Array.isArray(items) || items.length === 0) {
    throw new HttpsError(
        "invalid-argument",
        "The cart is empty.",
    );
  }

  if (items.length > MAX_CART_ITEMS) {
    throw new HttpsError(
        "invalid-argument",
        "Too many items in the order.",
    );
  }

  // =========================
  // 3. Validate basic item data
  // =========================

  const normalizedItems = items.map((item) => {
    if (!item || typeof item !== "object") {
      throw new HttpsError(
          "invalid-argument",
          "Invalid cart item.",
      );
    }

    const productId =
      typeof item.productId === "string" ?
        item.productId.trim() :
        "";

    const quantity = item.quantity;

    const selectedOption =
      typeof item.selectedOption === "string" ?
        item.selectedOption.trim() :
        null;

    if (!productId) {
      throw new HttpsError(
          "invalid-argument",
          "Product ID is required.",
      );
    }

    if (
      !Number.isInteger(quantity) ||
      quantity < 1 ||
      quantity > MAX_ITEM_QUANTITY
    ) {
      throw new HttpsError(
          "invalid-argument",
          "Invalid product quantity.",
      );
    }

    return {
      productId,
      quantity,
      selectedOption:
        selectedOption && selectedOption.length > 0 ?
          selectedOption :
          null,
    };
  });

  // =========================
  // 4. Read real products
  // =========================

  const uniqueProductIds = [
    ...new Set(normalizedItems.map((item) => item.productId)),
  ];

  const productRefs = uniqueProductIds.map(
      (productId) => db.collection("products").doc(productId),
  );

  let productSnapshots;

  try {
    productSnapshots = await db.getAll(...productRefs);
  } catch (error) {
    console.error("Failed to load products:", error);

    throw new HttpsError(
        "internal",
        "Could not validate products.",
    );
  }

  const productsById = new Map();

  for (const snapshot of productSnapshots) {
    if (!snapshot.exists) {
      throw new HttpsError(
          "failed-precondition",
          "One or more products no longer exist.",
      );
    }

    productsById.set(snapshot.id, snapshot.data());
  }

  // =========================
  // 5. Calculate prices server-side
  // =========================

  let subtotal = 0;
  const orderItems = [];

  for (const item of normalizedItems) {
    const product = productsById.get(item.productId);

    if (!product) {
      throw new HttpsError(
          "failed-precondition",
          "Product not found.",
      );
    }

    if (product.isAvailable !== true) {
      throw new HttpsError(
          "failed-precondition",
          "One or more products are unavailable.",
      );
    }

    const basePrice = Number(product.price);

    if (!Number.isFinite(basePrice) || basePrice < 0) {
      throw new HttpsError(
          "failed-precondition",
          "Invalid product price.",
      );
    }

    const productOptions =
      Array.isArray(product.options) ?
        product.options :
        [];

    let selectedOptionName = null;
    let optionAdditionalPrice = 0;

    if (item.selectedOption !== null) {
      const matchingOption = productOptions.find((option) => {
        return option &&
          typeof option.name === "string" &&
          option.name.trim() === item.selectedOption;
      });

      if (!matchingOption) {
        throw new HttpsError(
            "failed-precondition",
            "Selected product option is no longer available.",
        );
      }

      selectedOptionName = matchingOption.name.trim();

      optionAdditionalPrice = Number(
    matchingOption.additionalPrice != null ?
      matchingOption.additionalPrice :
      0,
      );

      if (
        !Number.isFinite(optionAdditionalPrice) ||
  optionAdditionalPrice < 0
      ) {
        throw new HttpsError(
            "failed-precondition",
            "Invalid product option price.",
        );
      }
    }

    const unitPrice = roundMoney(
        basePrice + optionAdditionalPrice,
    );

    const itemTotal = roundMoney(
        unitPrice * item.quantity,
    );

    subtotal = roundMoney(subtotal + itemTotal);

    orderItems.push({
      productId: item.productId,
      name:
        typeof product.name === "string" ?
          product.name :
          "",
      image:
        typeof product.image === "string" ?
          product.image :
          "",
      price: unitPrice,
      quantity: item.quantity,
      selectedOption: selectedOptionName,
      optionAdditionalPrice,
    });
  }

  // =========================
  // 6. Final total
  // =========================

  const deliveryFee = DELIVERY_FEE;
  const total = roundMoney(subtotal + deliveryFee);

  // =========================
  // 7. Create trusted order
  // =========================

  const orderRef = db.collection("orders").doc();

  const orderData = {
    userId,
    items: orderItems,
    subtotal,
    deliveryFee,
    total,
    address,
    paymentMethod,
    status: "pending",
    createdAt: FieldValue.serverTimestamp(),
  };

  try {
    await orderRef.set(orderData);
  } catch (error) {
    console.error("Failed to create order:", error);

    throw new HttpsError(
        "internal",
        "Could not create the order.",
    );
  }

  // =========================
  // 8. Return trusted result
  // =========================

  return {
    orderId: orderRef.id,
    subtotal,
    deliveryFee,
    total,
    status: "pending",
  };
});

/**
 * Rounds a monetary value to two decimal places.
 *
 * @param {number} value The monetary value to round.
 * @return {number} The rounded monetary value.
 */
function roundMoney(value) {
  return Math.round((value + Number.EPSILON) * 100) / 100;
}
