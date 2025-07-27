import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:time_attend_recognition/core/dependancy_injection/dependancy_injection.dart';
import 'package:time_attend_recognition/core/helper/extension.dart';
import 'package:time_attend_recognition/core/network/end_points.dart';
import 'package:time_attend_recognition/core/routing/routes.dart';
import 'package:time_attend_recognition/core/utils/colors.dart';
import 'package:time_attend_recognition/core/utils/image_manager.dart';
import 'package:time_attend_recognition/core/widget/custom_button.dart';
import 'package:time_attend_recognition/core/widget/custom_text.dart';
import 'package:time_attend_recognition/core/widget/custom_text_form_field.dart';
import 'package:time_attend_recognition/core/widget/emit_loading_item.dart';
import 'package:time_attend_recognition/core/widget/sec_tab_bar.dart';
import 'package:time_attend_recognition/core/widget/svg_icons.dart';
import 'package:time_attend_recognition/core/widget/toastification_widget.dart';
import 'package:toastification/toastification.dart';

import '../cubit/login_cubit.dart';
import '../cubit/login_states.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint("screenWidth ${context.screenWidth}");

    return BlocProvider(
      create: (context) => getIt<LogInCubit>(),
      child: const LoginBody(),
    );
  }
}

class LoginBody extends StatelessWidget {
  const LoginBody({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<LogInCubit>();

    return Scaffold(
      backgroundColor: AppColors.mainBackground,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onDoubleTap: () {
                  cubit.urlController.text = ApiConstants.cachedUrl();
                  showDialog(
                    context: context,
                    builder: (context) {
                      return BlocProvider.value(
                        value: cubit,
                        child: AlertDialog(
                          backgroundColor: AppColors.white,
                          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Flexible(
                                child: CustomText(
                                  text: "اللينك",
                                  color: AppColors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20,
                                  maxLines: 3,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: Image.asset(
                                  ImageManager.cancelCircle,
                                  height: 28,
                                ),
                              ),
                            ],
                          ),
                          content: Container(
                            height: 120,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            width: context.screenWidth * 0.3,
                            child: CustomTextFormField(
                              title: 'اللينك',
                              controller: cubit.urlController,
                              hintText: "اللينك",
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "أدخل اللينك !";
                                }
                                return null;
                              },
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                if (cubit.urlController.text.isNotEmpty) {
                                  cubit.setBaseUrl();
                                  MagicRouter.pop();
                                  showToastificationWidget(
                                    message: "تم الحفظ",
                                    context: context,
                                    notificationType: ToastificationType.success,
                                  );
                                }
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10.w),
                                child: const CustomText(
                                  text: "حفظ",
                                  color: AppColors.primary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: AppColors.primary,
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(12),
                    child: SvgIcon(
                      icon: ImageManager.graduate,
                      color: AppColors.white,
                      height: 40,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const CustomText(
                text: "نظام حضور الطلاب",
                color: AppColors.black,
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
              const SizedBox(height: 10),
              const CustomText(
                text: "قم بالتسجيل الدخول للوصول إلى النظام",
                color: AppColors.grey,
                fontWeight: FontWeight.w400,
                fontSize: 16,
              ),
              const SizedBox(height: 30),
              Container(
                margin: const EdgeInsetsDirectional.symmetric(horizontal: 15),
                padding: const EdgeInsetsDirectional.all(20),
                width: 500,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.border2),
                ),
                child: SingleChildScrollView(
                  child: Form(
                    key: cubit.formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 10),
                        const CustomText(
                          text: "مرحبا بك في نظام تسجيل حضور الطلاب باستخدام التعرف على الوجوه",
                          color: AppColors.grey,
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          maxLines: 10,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        DefaultTabController(
                          length: 2,
                          child: BlocBuilder<LogInCubit, LogInStates>(
                            builder: (context, state) {
                              return SecTabBar(
                                tabs: const ["مدير", "موظف"],
                                onTap: (index) {
                                  if (index == 0) {
                                    cubit.role = "admin";
                                  } else {
                                    cubit.role = "employee";
                                  }
                                },
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        CustomTextFormField(
                          title: "اسم المستخدم".tr(),
                          controller: cubit.userNameController,
                          filledColor: AppColors.white,
                          titleColor: AppColors.grey8,
                          titleFontSize: 15,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "اسم المستخدم مطلوب";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        BlocBuilder<LogInCubit, LogInStates>(
                          builder: (context, state) {
                            return CustomTextFormField(
                              title: "كلمة المرور".tr(),
                              controller: cubit.passwordController,
                              filledColor: AppColors.white,
                              titleColor: AppColors.grey8,
                              titleFontSize: 15,
                              maxLines: 1,
                              suffixIcon: IconButton(
                                onPressed: () {
                                  cubit.changeVisibility();
                                },
                                icon: Icon(
                                  cubit.isObscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                                  color: AppColors.grey,
                                ),
                              ),
                              obscureText: cubit.isObscure,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "كلمة المرور مطلوبة";
                                }
                                return null;
                              },
                              isLastInput: true,
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                        BlocConsumer<LogInCubit, LogInStates>(
                          listener: (context, state) {
                            if (state is LogInSuccessState) {
                              context.pushNamedAndRemoveUntil(
                                Routes.home,
                                predicate: (Route<dynamic> route) => false,
                              );
                            } else if (state is LogInFailState) {
                              showToastificationWidget(
                                message: state.message,
                                context: context,
                              );
                            }
                          },
                          builder: (context, state) {
                            if (state is LogInLoadingState) {
                              return const EmitLoadingItem();
                            }
                            return CustomButton(
                              height: 50,
                              borderRadius: 10,
                              text: "تسجيل الدخول".tr(),
                              onTap: () {
                                cubit.login();
                              },
                            );
                          },
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
