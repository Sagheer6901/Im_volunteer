
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:i_am_volunteer/ui/auth/forgot_password.dart';

import '../../controllers/auth_controller.dart';
import '../../painters/login_painter.dart';
import '../../routes/app_routes.dart';
import '../../utils/app_assets.dart';
import '../../utils/app_colors.dart';
import '../../utils/constants.dart';
import '../../utils/ui_utils.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/input_field.dart';
import '../../widgets/styled_button.dart';

class Login extends StatelessWidget {
  final controller = Get.find<AuthController>();
  Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            _topIllustration(),
            SizedBox(height: 20,),

            Expanded(
              child: _body(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _topIllustration() {
    return CustomPaint(
      painter: RegisterPainter(),
      child: SizedBox(
        // color: Colors.pink,
        height: Get.height * 0.2,
        child: Column(
          children: [
            UiUtils.vertSpace20,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Image.asset(
                    AppAssets.manCreativity,
                    height: 120,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _body() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15,vertical: 20),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Form(
          key: controller.loginFormKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 15.0,left: 15),
                child: CustomText(
                  text: 'Login',
                  color: AppColors.primary,
                  weight: FontWeight.w700,
                  fontSize: 36,
                  // enableShadow: true,
                ),
              ),

              InputField(
                paddingVertical: 10,
                controller: controller.emailController,
                hint: 'EMAIL',
                suffixIcon: Icons.mail_outline,
                validator: emailValidator,
              ),
              InputField(
                paddingVertical: 10,
                controller: controller.passwordController,
                hint: 'PASSWORD',
                suffixIcon: Icons.password,
                hideText: true,
                validator: passwordValidator,
              ),
              // iAmNotRobotContainer(),
              UiUtils.vertSpace20,
              Padding(
                padding: const EdgeInsets.only(
                  left: 30,
                  right: 30,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Obx(
                      () => controller.loading.value
                          ? UiUtils.loader
                          : StyledButton(
                              onTap: controller.login,
                              label: 'Sign In',
                            ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 30,
                  right: 30,
                ),
                child: GestureDetector(
                    onTap: () {
                      Get.to(()=>ForgotPasswordScreen());
                    },
                    child: Text(
                      'Forgot Password',
                      style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                          fontSize: 15),
                    )),
              ),
              // const SizedBox(
              //   height: 15,
              // ),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 20),
              //   child: Column(
              //     children: [
              //       Row(
              //         children: [
              //           Expanded(
              //             child: Container(
              //               height: 1,
              //               color: AppColors.heading.withOpacity(0.1),
              //             ),
              //           ),
              //           CustomText(
              //             text: '  Or sign in with   ',
              //             color: AppColors.heading.withOpacity(0.5),
              //           ),
              //           Expanded(
              //             child: Container(
              //               height: 1,
              //               color: AppColors.heading.withOpacity(0.1),
              //             ),
              //           ),
              //         ],
              //       ),
              //       const SizedBox(
              //         height: 10,
              //       ),
              //       Container(
              //         height: 50,
              //         width: 50,
              //         decoration: BoxDecoration(
              //             color: AppColors.white,
              //             borderRadius: BorderRadius.circular(10),
              //             boxShadow: [
              //               BoxShadow(
              //                 color: AppColors.heading.withOpacity(0.1),
              //               )
              //             ]),
              //         child: Center(
              //           child: Image.asset(
              //             AppAssets.googleIcon,
              //             height: 30,
              //           ),
              //         ),
              //       )
              //     ],
              //   ),
              // ),
              const SizedBox(
                height: 30,
              ),
              customTextWidget()
            ],
          ),
        ),
      ),
    );
  }

  Widget iAmNotRobotContainer() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
      child: Container(
        width: Get.width / 2,
        height: 45,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                  color: AppColors.primary.withOpacity(0.07), blurRadius: 7)
            ]),
        child: Row(
          children: [
            Icon(
              Icons.check,
              color: AppColors.primary,
            ),
            const SizedBox(
              width: 3,
            ),
            Expanded(
                child: CustomText(
              text: 'I\'m not a robot',
              color: AppColors.heading,
            )),
            Image.asset(
              AppAssets.captcha,
              height: 30,
            )
          ],
        ),
      ),
    );
  }

  Widget customTextWidget() {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30, top: 10, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Not a member? ',
            style: TextStyle(
                color: AppColors.heading,
                fontWeight: FontWeight.w600,
                fontSize: 15),
          ),
          GestureDetector(
              onTap: () {
                Get.offNamed(AppRoutes.register);
              },
              child: Text(
                'Register Now',
                style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 15),
              )),
        ],
      ),
    );
  }
}
