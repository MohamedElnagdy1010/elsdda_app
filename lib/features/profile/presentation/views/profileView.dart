import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sufra_app/core/dependency_injection/dependency_injection.dart';
import 'package:sufra_app/core/styles/widgets/app_status_dialog.dart';
import 'package:sufra_app/features/authentication/presentation/cubit/logout/logout_cubit.dart';
import 'package:sufra_app/features/authentication/presentation/cubit/logout/logout_state.dart';
import 'package:sufra_app/features/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:sufra_app/features/profile/presentation/cubit/profile/profile_cubit.dart';
import 'package:sufra_app/features/profile/presentation/cubit/profile/profile_state.dart';
import 'package:sufra_app/features/profile/presentation/widgets/profile_field.dart';
import 'package:sufra_app/features/profile/presentation/widgets/profile_header.dart';
import 'package:sufra_app/features/profile/presentation/widgets/profile_save_button.dart';
import 'package:sufra_app/welcomeView.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<ProfileCubit>()..getProfile()),
        BlocProvider(create: (_) => getIt<LogoutCubit>()),
      ],
      child: const _ProfileBody(),
    );
  }
}

class _ProfileBody extends StatefulWidget {
  const _ProfileBody();

  @override
  State<_ProfileBody> createState() => _ProfileBodyState();
}

class _ProfileBodyState extends State<_ProfileBody> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();

  bool controllersInitialized = false;

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.dispose();
  }

  void _fillControllers(ProfileLoaded state) {
    if (controllersInitialized) return;

    nameController.text = state.user.name;
    phoneController.text = state.user.phone;
    addressController.text = state.user.address;

    controllersInitialized = true;
  }

  String? _validateProfile() {
    final name = nameController.text.trim();
    final phone = phoneController.text.trim();
    final address = addressController.text.trim();

    if (name.isEmpty) {
      return 'من فضلك أدخل الاسم';
    }

    if (name.length < 2) {
      return 'من فضلك أدخل اسمًا صحيحًا';
    }

    if (phone.isEmpty) {
      return 'من فضلك أدخل رقم الهاتف';
    }

    final normalizedPhone = phone.replaceAll(RegExp(r'[\s-]'), '');

    if (!RegExp(r'^\+?[0-9]{8,15}$').hasMatch(normalizedPhone)) {
      return 'من فضلك أدخل رقم هاتف صحيحًا';
    }

    if (address.isEmpty) {
      return 'من فضلك أدخل العنوان';
    }

    if (address.length < 3) {
      return 'من فضلك أدخل عنوانًا صحيحًا';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LogoutCubit, LogoutState>(
      listener: (context, state) {
        if (state is LogoutSuccess) {
          context.read<FavoritesCubit>().clearFavorites();

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const WelcomeView()),
            (route) => false,
          );
        }

        if (state is LogoutFailure) {
          AppStatusDialog.showError(
            context,
            title: 'تعذر تسجيل الخروج',
            message: state.message,
          );
        }
      },
      child: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ProfileFailure) {
            AppStatusDialog.showError(
              context,
              title: 'تعذر تحميل الحساب',
              message: state.message,
            );
          }

          if (state is ProfileUpdateSuccess) {
            nameController.text = state.user.name;
            phoneController.text = state.user.phone;
            addressController.text = state.user.address;

            AppStatusDialog.showSuccess(
              context,
              title: 'تم الحفظ',
              message: 'تم تحديث بياناتك بنجاح',
            );
          }

          if (state is ProfileUpdateFailure) {
            AppStatusDialog.showError(
              context,
              title: 'تعذر الحفظ',
              message: state.message,
            );
          }
        },
        builder: (context, state) {
          if (state is ProfileLoaded) {
            _fillControllers(state);
          }

          return GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: Scaffold(
              backgroundColor: const Color(0xffFAFAFA),
              appBar: _buildAppBar(context),
              body: _buildBody(context, state),
            ),
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xffFAFAFA),
      surfaceTintColor: const Color(0xffFAFAFA),
      elevation: 0,
      automaticallyImplyLeading: false,
      centerTitle: true,
      title: const Text(
        'حسابي',
        style: TextStyle(
          color: Color(0xff202020),
          fontSize: 20,
          fontWeight: FontWeight.w800,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: BlocBuilder<LogoutCubit, LogoutState>(
            builder: (context, state) {
              if (state is LogoutLoading) {
                return const SizedBox(
                  width: 48,
                  child: Center(
                    child: SizedBox(
                      width: 19,
                      height: 19,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Color(0xffB60F1A),
                      ),
                    ),
                  ),
                );
              }

              return IconButton(
                tooltip: 'تسجيل الخروج',
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  _showLogoutConfirmation(context);
                },
                icon: const Icon(
                  Icons.logout_rounded,
                  color: Color(0xffB60F1A),
                  size: 23,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context, ProfileState state) {
    if (state is ProfileLoading || state is ProfileInitial) {
      return const Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: Color(0xffB60F1A),
        ),
      );
    }

    if (state is ProfileFailure) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(
                  color: Color(0xffF8EEEE),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person_off_outlined,
                  size: 30,
                  color: Color(0xffB60F1A),
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'تعذر تحميل بيانات الحساب',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 6),
              Text(
                state.message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 11.5,
                  color: Color(0xff888888),
                ),
              ),
              const SizedBox(height: 18),
              OutlinedButton(
                onPressed: () {
                  controllersInitialized = false;
                  context.read<ProfileCubit>().getProfile();
                },
                child: const Text('إعادة المحاولة'),
              ),
            ],
          ),
        ),
      );
    }

    final user = _getUserFromState(state);

    if (user == null) {
      return const SizedBox.shrink();
    }

    final isUpdating = state is ProfileUpdating;

    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 125),
        child: Column(
          children: [
            ProfileHeader(
              name: user.name,
              address: user.address,
              profileImage: user.profileImage,
              avatarId: user.avatarId,
            ),

            const SizedBox(height: 28),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xffEEEEEE)),
              ),
              child: Column(
                children: [
                  ProfileField.editable(
                    title: 'الاسم',
                    controller: nameController,
                    icon: Icons.person_outline_rounded,
                    enabled: !isUpdating,
                  ),

                  const SizedBox(height: 15),

                  ProfileField.readOnly(
                    title: 'البريد الإلكتروني',
                    value: user.email,
                    icon: Icons.email_outlined,
                  ),

                  const SizedBox(height: 15),

                  ProfileField.editable(
                    title: 'رقم الهاتف',
                    controller: phoneController,
                    icon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                    enabled: !isUpdating,
                  ),

                  const SizedBox(height: 15),

                  ProfileField.editable(
                    title: 'العنوان',
                    controller: addressController,
                    icon: Icons.location_on_outlined,
                    enabled: !isUpdating,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            ProfileSaveButton(
              isLoading: isUpdating,
              onPressed: () => _saveProfile(context),
            ),
          ],
        ),
      ),
    );
  }

  void _saveProfile(BuildContext context) {
    FocusScope.of(context).unfocus();

    final error = _validateProfile();

    if (error != null) {
      AppStatusDialog.showWarning(
        context,
        title: 'تحقق من البيانات',
        message: error,
      );
      return;
    }

    context.read<ProfileCubit>().updateProfile(
      name: nameController.text.trim(),
      phone: phoneController.text.trim(),
      address: addressController.text.trim(),
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'تسجيل الخروج',
            textAlign: TextAlign.right,
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
          content: const Text(
            'هل أنت متأكد من تسجيل الخروج من حسابك؟',
            textAlign: TextAlign.right,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('إلغاء'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                context.read<LogoutCubit>().logout();
              },
              child: const Text(
                'تسجيل الخروج',
                style: TextStyle(
                  color: Color(0xffB60F1A),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  dynamic _getUserFromState(ProfileState state) {
    if (state is ProfileLoaded) {
      return state.user;
    }

    if (state is ProfileUpdating) {
      return state.user;
    }

    if (state is ProfileUpdateSuccess) {
      return state.user;
    }

    if (state is ProfileUpdateFailure) {
      return state.user;
    }

    return null;
  }
}
