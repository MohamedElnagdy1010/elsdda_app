const {setGlobalOptions} = require("firebase-functions");
const {onCall, HttpsError} = require("firebase-functions/v2/https");
const {initializeApp} = require("firebase-admin/app");
const {getFirestore, FieldValue} = require("firebase-admin/firestore");
const {onDocumentUpdated} = require("firebase-functions/v2/firestore");
const admin = require("firebase-admin");
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


  const branchId =
  typeof data.branchId === "string" ?
    data.branchId.trim() :
    "";

if (!branchId || branchId.length > 128) {
  throw new HttpsError(
      "invalid-argument",
      "A valid branch is required.",
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
    branchId,
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
    branchId,
  };
});

exports.onOrderStatusChanged = onDocumentUpdated(
    "orders/{orderId}",
    async (event) => {
      const before = event.data.before.data();
      const after = event.data.after.data();

      if (!before || !after) {
        return;
      }

      const oldStatus = before.status;
      const newStatus = after.status;

      // مفيش تغيير في حالة الطلب
      if (oldStatus === newStatus) {
        return;
      }

      const userId = after.userId;

      if (!userId) {
        console.log("Order has no userId");
        return;
      }

      const notification = getStatusNotification(newStatus);

      if (!notification) {
        console.log(`No notification configured for: ${newStatus}`);
        return;
      }

      const devicesSnapshot = await admin
          .firestore()
          .collection("users")
          .doc(userId)
          .collection("devices")
          .get();

      if (devicesSnapshot.empty) {
        console.log(`No devices found for user: ${userId}`);
        return;
      }

      const tokens = devicesSnapshot.docs
          .map((doc) => doc.data().token)
          .filter((token) => typeof token === "string" && token.length > 0);

      if (tokens.length === 0) {
        console.log(`No valid tokens for user: ${userId}`);
        return;
      }

      const message = {
        tokens,
        notification: {
          title: notification.title,
          body: notification.body,
        },
        data: {
          type: "order_status",
          orderId: event.params.orderId,
          status: String(newStatus),
        },
        android: {
          priority: "high",
          notification: {
            channelId: "order_updates",
          },
        },
        apns: {
          payload: {
            aps: {
              sound: "default",
            },
          },
        },
      };

      const response = await admin.messaging().sendEachForMulticast(message);

      console.log(
          `Order ${event.params.orderId}: ` +
        `${response.successCount} notifications sent, ` +
        `${response.failureCount} failed`,
      );

      // حذف Tokens المنتهية أو غير الصالحة
      const invalidTokens = [];

      response.responses.forEach((result, index) => {
        if (result.success) {
          return;
        }

        const code = result.error ? result.error.code : null;

        if (
          code === "messaging/registration-token-not-registered" ||
        code === "messaging/invalid-registration-token"
        ) {
          invalidTokens.push(tokens[index]);
        }
      });

      await Promise.all(
          invalidTokens.map((token) =>
            admin
                .firestore()
                .collection("users")
                .doc(userId)
                .collection("devices")
                .doc(token)
                .delete(),
          ),
      );
    },
);
/**
 * Returns notification content for an order status.
 *
 * @param {string} status The new order status.
 * @return {{title: string, body: string}|null} Notification content.
 */
function getStatusNotification(status) {
  switch (status) {
    case "pending":
      return {
        title: "تم استلام طلبك 🧾",
        body: "استلمنا طلبك وجارٍ مراجعته.",
      };

    case "preparing":
      return {
        title: "طلبك قيد التحضير 🍳",
        body: "بدأنا تجهيز طلبك الآن.",
      };

    case "ready":
      return {
        title: "طلبك جاهز ✅",
        body: "تم تجهيز طلبك وهو جاهز للمرحلة التالية.",
      };

    case "delivered":
      return {
        title: "تم توصيل طلبك 🎉",
        body: "بالهناء والشفاء، ونتمنى لك تجربة سعيدة مع SUFRA.",
      };

    case "cancelled":
      return {
        title: "تم إلغاء الطلب",
        body: "تم تحديث حالة طلبك إلى ملغي.",
      };

    default:
      return null;
  }
}

/**
 * Rounds a monetary value to two decimal places.
 *
 * @param {number} value The monetary value to round.
 * @return {number} The rounded monetary value.
 */
function roundMoney(value) {
  return Math.round((value + Number.EPSILON) * 100) / 100;
}
let branchSnapshot;

try {
  branchSnapshot = await db.collection("branches").doc(branchId).get();
} catch (error) {
  console.error("Failed to load branch:", error);

  throw new HttpsError(
      "internal",
      "Could not validate branch.",
  );
}

if (!branchSnapshot.exists ||
    branchSnapshot.data().isActive !== true) {
  throw new HttpsError(
      "failed-precondition",
      "Selected branch is unavailable.",
  );
}


