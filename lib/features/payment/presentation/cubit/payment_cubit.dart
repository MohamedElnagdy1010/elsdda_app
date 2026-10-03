import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/payment_method_entity.dart';
import '../../domain/entities/payment_result_entity.dart';
import '../../domain/use_cases/process_payment_use_case.dart';
import 'payment_state.dart';

class PaymentCubit extends Cubit<PaymentState> {
  final ProcessPaymentUseCase? processPaymentUseCase;

  PaymentCubit({this.processPaymentUseCase}) : super(const PaymentState());

  void selectMethod(PaymentMethodType method) {
    if (state.isProcessing) return;

    emit(
      state.copyWith(
        selectedMethod: method,
        status: PaymentProcessStatus.idle,
        clearResult: true,
        clearError: true,
      ),
    );
  }

  Future<void> processPayment({required double amount}) async {
    if (state.isProcessing) return;

    final useCase = processPaymentUseCase;

    if (useCase == null) {
      emit(
        state.copyWith(
          status: PaymentProcessStatus.failure,
          errorMessage:
              'بوابة الدفع غير مرتبطة بعد. سيتم تفعيلها حسب مزود الدفع الخاص بالتاجر.',
          clearResult: true,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        status: PaymentProcessStatus.processing,
        clearResult: true,
        clearError: true,
      ),
    );

    try {
      final result = await useCase(
        amount: amount,
        method: state.selectedMethod,
      );

      switch (result.status) {
        case PaymentResultStatus.success:
          emit(
            state.copyWith(
              status: PaymentProcessStatus.success,
              result: result,
              clearError: true,
            ),
          );
          break;

        case PaymentResultStatus.failed:
          emit(
            state.copyWith(
              status: PaymentProcessStatus.failure,
              result: result,
              errorMessage: result.message ?? 'تعذر إتمام عملية الدفع.',
            ),
          );
          break;

        case PaymentResultStatus.cancelled:
          emit(
            state.copyWith(
              status: PaymentProcessStatus.cancelled,
              result: result,
              errorMessage: result.message ?? 'تم إلغاء عملية الدفع.',
            ),
          );
          break;
      }
    } catch (_) {
      emit(
        state.copyWith(
          status: PaymentProcessStatus.failure,
          errorMessage: 'حدث خطأ أثناء عملية الدفع. حاول مرة أخرى.',
          clearResult: true,
        ),
      );
    }
  }

  void reset() {
    emit(PaymentState(selectedMethod: state.selectedMethod));
  }
}
