import 'package:flutter/material.dart';
import 'package:moyasar/moyasar.dart';

class PaymentDetailsView extends StatefulWidget {
  final double amount;

  const PaymentDetailsView({super.key, required this.amount});

  @override
  State<PaymentDetailsView> createState() => _PaymentDetailsViewState();
}

class _PaymentDetailsViewState extends State<PaymentDetailsView> {
  static const Color primaryColor = Color(0xffB60F1A);

  static const String publishableKey =
      'pk_test_KjwSRo48mqBCT3H2ZiWQFcVg4vg32L6pHv7u9s3M';

  late final PaymentConfig paymentConfig;

  @override
  void initState() {
    super.initState();

    paymentConfig = PaymentConfig(
      publishableApiKey: publishableKey,
      amount: (widget.amount * 100).round(),
      description: 'Restaurant order payment',
      metadata: const {'source': 'sufra_app'},
    );
  }

  void _onPaymentResult(dynamic result) {
    if (!mounted) return;

    if (result is PaymentResponse) {
      if (result.status == PaymentStatus.paid) {
        _showResultDialog(
          success: true,
          title: 'تم الدفع بنجاح',
          message:
              'تمت عملية الدفع التجريبية بنجاح.\n\n'
              'رقم العملية:\n${result.id}',
        );
        return;
      }

      _showResultDialog(
        success: false,
        title: 'لم تكتمل عملية الدفع',
        message: 'حالة العملية: ${result.status.name}',
      );

      return;
    }

    if (result is ValidationError) {
      _showResultDialog(
        success: false,
        title: 'تحقق من بيانات الدفع',
        message: result.message,
      );

      return;
    }

    if (result is PaymentCanceledError) {
      _showResultDialog(
        success: false,
        title: 'تم إلغاء الدفع',
        message: 'لم يتم خصم أي مبلغ.',
      );

      return;
    }

    _showResultDialog(
      success: false,
      title: 'تعذر إتمام الدفع',
      message: 'حدث خطأ أثناء عملية الدفع. حاول مرة أخرى.',
    );
  }

  Future<void> _showResultDialog({
    required bool success,
    required String title,
    required String message,
  }) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          contentPadding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: success
                      ? const Color(0xffE8F5E9)
                      : const Color(0xffFDECEC),
                ),
                child: Icon(
                  success ? Icons.check_rounded : Icons.error_outline_rounded,
                  size: 34,
                  color: success ? Colors.green : primaryColor,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  height: 1.5,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 22),
              SizedBox(
                width: double.infinity,
                height: 46,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);

                    if (success && mounted) {
                      Navigator.pop(context, true);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13),
                    ),
                  ),
                  child: Text(success ? 'متابعة' : 'حسنًا'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xffF8F8F8),
        appBar: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            'الدفع الإلكتروني',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: const Color(0xffEEEEEE)),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'إجمالي الدفع',
                        style: TextStyle(fontSize: 13, color: Colors.black54),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${widget.amount.toStringAsFixed(2)} ر.س',
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w900,
                          color: primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                const Row(
                  children: [
                    Icon(
                      Icons.lock_outline_rounded,
                      size: 18,
                      color: Colors.black54,
                    ),
                    SizedBox(width: 7),
                    Expanded(
                      child: Text(
                        'بيانات الدفع تتم معالجتها بشكل آمن من خلال بوابة الدفع.',
                        style: TextStyle(fontSize: 11, color: Colors.black54),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                CreditCard(
                  config: paymentConfig,
                  onPaymentResult: _onPaymentResult,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
