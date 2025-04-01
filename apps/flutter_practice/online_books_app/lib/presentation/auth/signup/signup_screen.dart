import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:online_books_app/core/utils/date_time_utils.dart';
import 'package:online_books_app/core/utils/image_constant.dart';
import 'package:online_books_app/core/utils/size_utils.dart';
import 'package:online_books_app/presentation/auth/signup/controller/signup_controller.dart';
import 'package:online_books_app/theme/custom_button_style.dart';
import 'package:online_books_app/theme/custom_text_style.dart';
import 'package:online_books_app/theme/theme_helper.dart';
import 'package:online_books_app/widgets/custom_checkbox_button.dart';
import 'package:online_books_app/widgets/custom_drop_down.dart';
import 'package:online_books_app/widgets/custom_elevated_button.dart';
import 'package:online_books_app/widgets/custom_image_view.dart';
import 'package:online_books_app/widgets/custom_text_form_field.dart';

class SignupScreen extends GetView<SignupController> {
  SignupScreen({super.key});

  @override
  final SignupController controller = Get.find<SignupController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appTheme.yellow700,
        elevation: 0,
      ),
      resizeToAvoidBottomInset: false,
      backgroundColor: appTheme.yellow700,
      body: SafeArea(
        child: FormBuilder(
          key: controller.formKey,
          child: Container(
            width: double.maxFinite,
            padding: EdgeInsets.only(
              left: 32.h,
              right: 32.h,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "lbl_create_account".tr,
                    style: theme.textTheme.headlineLarge,
                  ),
                  SizedBox(
                    height: 68.h,
                  ),
                  _buildFirstNameInput(),
                  SizedBox(
                    height: 30.h,
                  ),
                  _buildLastNameInput(),
                  SizedBox(
                    height: 30.h,
                  ),
                  _buildEmailInput(),
                  SizedBox(
                    height: 30.h,
                  ),
                  _buildDateOfBirthInput(),
                  SizedBox(
                    height: 28.h,
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 6.h),
                    child: CustomDropDown(
                      icon: Container(
                        margin: EdgeInsets.only(
                          left: 16.h,
                        ),
                        child: CustomImageView(
                          imagePath: ImageConstant.imgArrowCaretdown,
                          height: 22.h,
                          width: 24.w,
                          fit: BoxFit.contain,
                        ),
                      ),
                      iconSize: 22.h,
                      hintText: "lbl_occupation".tr,
                      items: controller
                          .signupModelObj.value.dropdownItemList.value,
                      prefix: Container(
                        margin: EdgeInsets.fromLTRB(8.h, 12.h, 6.h, 12.h),
                        child: CustomImageView(
                          imagePath: ImageConstant.imgUser,
                          height: 22.h,
                          width: 22.w,
                          fit: BoxFit.contain,
                        ),
                      ),
                      prefixConstraints: BoxConstraints(
                        minWidth: 48.w,
                      ),
                      contentPadding:
                          EdgeInsets.fromLTRB(8.h, 12.h, 14.h, 12.h),
                    ),
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  _buildPasswordInput(),
                  SizedBox(
                    height: 10.h,
                  ),
                  _buildTermsAgreementCheckbox(),
                  SizedBox(
                    height: 42.h,
                  ),
                  _buildSignUpButton(),
                  SizedBox(height: 30.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Section Widget
  /// First Name Input
  Widget _buildFirstNameInput() {
    return Padding(
      padding: EdgeInsets.only(right: 6.h),
      child: CustomTextFormField(
        controller: controller.firstNameInputController,
        hintText: "msg_legal_first_name".tr,
        prefix: Container(
          margin: EdgeInsets.fromLTRB(8.h, 12.h, 6.h, 12.h),
          child: CustomImageView(
            imagePath: ImageConstant.imgUser,
            height: 22.h,
            width: 22.w,
            fit: BoxFit.contain,
          ),
        ),
        prefixConstraints: BoxConstraints(maxHeight: 48),
        contentPadding: EdgeInsets.fromLTRB(8.h, 12.h, 14.h, 12.h),
        validator: FormBuilderValidators.compose([
          FormBuilderValidators.required(),
        ]),
      ),
    );
  }

  Widget _buildLastNameInput() {
    return Padding(
      padding: EdgeInsets.only(right: 6.h),
      child: CustomTextFormField(
        controller: controller.lastNameInputController,
        hintText: "lbl_legal_last_name".tr,
        prefix: Container(
          margin: EdgeInsets.fromLTRB(8.h, 12.h, 6.h, 12.h),
          child: CustomImageView(
            imagePath: ImageConstant.imgUser,
            height: 22.h,
            width: 22.w,
            fit: BoxFit.contain,
          ),
        ),
        prefixConstraints: BoxConstraints(
          maxHeight: 48.h,
        ),
        contentPadding: EdgeInsets.fromLTRB(8.h, 12.h, 14.h, 12.h),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return "Please enter your last name";
          }
          return null;
        },
      ),
    );
  }

  Widget _buildEmailInput() {
    return Padding(
      padding: EdgeInsets.only(right: 6.h),
      child: CustomTextFormField(
        controller: controller.emailInputController,
        hintText: "lbl_email_adress".tr,
        textInputType: TextInputType.emailAddress,
        prefix: Container(
          margin: EdgeInsets.fromLTRB(8.h, 12.h, 6.h, 12.h),
          child: CustomImageView(
            imagePath: ImageConstant.imgCheckmark,
            height: 22.h,
            width: 24.w,
            fit: BoxFit.contain,
          ),
        ),
        prefixConstraints: BoxConstraints(
          maxHeight: 48.h,
        ),
        contentPadding: EdgeInsets.fromLTRB(8.h, 12.h, 14.h, 12.h),
        borderDecoration: TextFormFieldStyleHelper.outlineGrayTL12,
        validator: FormBuilderValidators.compose(
          [
            FormBuilderValidators.required(),
            FormBuilderValidators.email(),
          ],
        ),
      ),
    );
  }

  Widget _buildDateOfBirthInput() {
    return Padding(
      padding: EdgeInsets.only(right: 6.h),
      child: CustomTextFormField(
        readOnly: true,
        controller: controller.dateOfBirthInputController,
        hintText: "lbl_data_of_birth".tr,
        prefix: Container(
          margin: EdgeInsets.fromLTRB(8.h, 12.h, 6.h, 12.h),
          child: CustomImageView(
            imagePath: ImageConstant.imgCalendar,
            height: 22.h,
            width: 20.w,
            fit: BoxFit.contain,
          ),
        ),
        prefixConstraints: BoxConstraints(
          maxHeight: 48.h,
        ),
        contentPadding: EdgeInsets.fromLTRB(8.h, 12.h, 14.h, 12.h),
        onTap: () {
          onTapDateOfBirthInput();
        },
        validator: FormBuilderValidators.compose(
          [
            FormBuilderValidators.required(),
          ],
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildPasswordInput() {
    return Padding(
      padding: EdgeInsets.only(right: 6.h),
      child: Obx(
        () => CustomTextFormField(
          controller: controller.passwordInputController,
          hintText: "lbl_password".tr,
          textInputAction: TextInputAction.done,
          textInputType: TextInputType.visiblePassword,
          prefix: Container(
            margin: EdgeInsets.fromLTRB(8.h, 12.h, 6.h, 12.h),
            child: CustomImageView(
              imagePath: ImageConstant.imgLock,
              height: 22.h,
              width: 24.w,
              fit: BoxFit.fill,
            ),
          ),
          prefixConstraints: BoxConstraints(
            maxHeight: 48.h,
          ),
          suffix: InkWell(
            onTap: () {
              controller.isShowPassword.value =
                  !controller.isShowPassword.value;
            },
            child: Container(
              margin: EdgeInsets.fromLTRB(16.h, 12.h, 14.h, 12.h),
              child: CustomImageView(
                imagePath: ImageConstant.imgEye,
                height: 22.h,
                width: 22.w,
                fit: BoxFit.contain,
              ),
            ),
          ),
          suffixConstraints: BoxConstraints(
            maxHeight: 48.h,
          ),
          obscureText: controller.isShowPassword.value,
          contentPadding: EdgeInsets.fromLTRB(8.h, 12.h, 14.h, 12.h),
          borderDecoration: TextFormFieldStyleHelper.outlineGrayTL12,
          validator: FormBuilderValidators.compose(
            [
              FormBuilderValidators.required(),
              FormBuilderValidators.minLength(6),
            ],
          ),
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildTermsAgreementCheckbox() {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.all(8.0),
        child: CustomCheckboxButton(
          overflow: TextOverflow.ellipsis,
          text: "msg_i_agree_to_the_terms".tr,
          value: controller.termAgreementCheckBox.value,
          onChange: (value) {
            controller.termAgreementCheckBox.value = value;
          },
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildSignUpButton() {
    return Obx(
      () => CustomElevatedButton(
        height: 40.h,
        text: controller.isLoading.value ? "Signing Up..." : "lbl_sign_up".tr,
        margin: EdgeInsets.only(right: 8.h),
        buttonStyle: CustomButtonStyles.outlinePrimaryTL12,
        buttonTextStyle: CustomTextStyles.titleLargeDosisGray50,
        onPressed: controller.isLoading.value
            ? null
            : () {
                controller.signUp();
              },
      ),
    );
  }

  Future<void> onTapDateOfBirthInput() async {
    DateTime? dateTime = await showDatePicker(
      context: Get.context!,
      firstDate: DateTime(1970),
      lastDate: DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
      ),
      initialDate: controller.signupModelObj.value.selecDateOfBirthInput!.value,
    );
    if (dateTime != null) {
      controller.signupModelObj.value.selecDateOfBirthInput!.value = dateTime;
      controller.dateOfBirthInputController.text =
          dateTime.format(pattern: dateTimeFormatPattern);
    }
  }
}
