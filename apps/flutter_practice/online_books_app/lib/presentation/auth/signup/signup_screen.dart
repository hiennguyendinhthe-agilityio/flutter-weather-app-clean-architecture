import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:online_books_app/core/theme/custom_button_style.dart';
import 'package:online_books_app/core/theme/custom_text_style.dart';
import 'package:online_books_app/core/theme/theme_helper.dart';
import 'package:online_books_app/core/utils/date_time_utils.dart';
import 'package:online_books_app/core/utils/image_constant.dart';
import 'package:online_books_app/core/utils/size_utils.dart';
import 'package:online_books_app/presentation/auth/signup/controller/signup_controller.dart';
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
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: IconButton(
          icon: CustomImageView(
            imagePath: ImageConstant.imgArrowLeft,
            height: 24.h,
            width: 24.w,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        backgroundColor: appTheme.yellow700,
        elevation: 0,
      ),
      backgroundColor: appTheme.yellow700,
      body: SafeArea(
        child: FormBuilder(
          key: controller.formKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: 32.h,
            ),
            child: LayoutBuilder(
              builder: (context, constraints) => IntrinsicHeight(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
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
                      _buildCustomDropDown(),
                      SizedBox(
                        height: 30.h,
                      ),
                      _buildPasswordInput(),
                      SizedBox(
                        height: 10.h,
                      ),
                      _buildTermsAgreementCheckbox(),
                      SizedBox(
                        height: 96.h,
                      ),
                      _buildSignUpButton(),
                      SizedBox(height: 56.h),
                      _buildLoginOption(context),
                      SizedBox(height: 28.h),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  CustomDropDown _buildCustomDropDown() {
    return CustomDropDown(
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
      hintText: "lbl_occupation".tr,
      items: controller.signupModelObj.value.dropdownItemList.value,
      prefix: Container(
        margin: EdgeInsets.fromLTRB(8.h, 12.h, 6.h, 12.h),
        child: CustomImageView(
          imagePath: ImageConstant.imgUser,
          height: 22.h,
          width: 22.h,
          fit: BoxFit.contain,
        ),
      ),
      prefixIconConstraints: BoxConstraints(
        maxHeight: 48.h,
      ),
      contentPadding: EdgeInsets.fromLTRB(8.h, 12.h, 14.h, 12.h),
    );
  }

  /// Section Widget
  /// First Name Input
  Widget _buildFirstNameInput() {
    return CustomTextFormField(
      autofocus: true,
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
      prefixConstraints: BoxConstraints(maxHeight: 48.h),
      contentPadding: EdgeInsets.fromLTRB(8.h, 12.h, 14.h, 12.h),
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.required(),
      ]),
    );
  }

  Widget _buildLastNameInput() {
    return CustomTextFormField(
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
    );
  }

  Widget _buildEmailInput() {
    return CustomTextFormField(
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
    );
  }

  Widget _buildDateOfBirthInput() {
    return CustomTextFormField(
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
    );
  }

  /// Section Widget
  Widget _buildPasswordInput() {
    return Obx(
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
            controller.isShowPassword.value = !controller.isShowPassword.value;
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
    );
  }

  /// Section Widget
  Widget _buildTermsAgreementCheckbox() {
    return Obx(
      () => CustomCheckboxButton(
        overflow: TextOverflow.ellipsis,
        richText: TextSpan(
          style: TextStyle(
            color: Colors.grey[700],
            fontSize: 14,
          ),
          children: [
            TextSpan(
              text: 'i agree to the ',
              style: theme.textTheme.bodyLarge,
            ),
            TextSpan(
              text: 'terms',
              style: CustomTextStyles.titleMediumGray50,
            ),
            TextSpan(
              text: ' and ',
              style: theme.textTheme.bodyLarge,
            ),
            TextSpan(
              text: 'privacy policy.',
              style: CustomTextStyles.titleMediumGray50,
            ),
          ],
        ),
        value: controller.termAgreementCheckBox.value,
        onChange: (value) {
          controller.termAgreementCheckBox.value = value;
        },
      ),
    );
  }

  /// Section Widget
  Widget _buildSignUpButton() {
    return Obx(
      () => CustomElevatedButton(
        height: 40.h,
        text: controller.isLoading.value ? "Signing Up..." : "lbl_sign_up".tr,
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

  Widget _buildLoginOption(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.symmetric(horizontal: 2.h),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 12.h),
                  child: Divider(),
                ),
              ),
              SizedBox(
                width: 10.w,
              ),
              Align(
                alignment: Alignment.center,
                child: Text(
                  "lbl_or_log_in_with".tr,
                  style: theme.textTheme.titleLarge,
                ),
              ),
              SizedBox(
                width: 10.w,
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 12.h),
                  child: Divider(),
                ),
              ),
            ],
          ),
          SizedBox(height: 23.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.1,
                height: MediaQuery.of(context).size.width * 0.1,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                        MediaQuery.of(context).size.width * 0.1),
                    border: Border.all(
                      color: appTheme.blueGray900,
                      width: 1.h,
                    ),
                  ),
                  child: IconButton(
                    onPressed: () {},
                    padding: EdgeInsets.all(12.h),
                    icon: CustomImageView(
                      imagePath: ImageConstant.imgGoogle,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 16.h),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.1,
                height: MediaQuery.of(context).size.width * 0.1,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                        MediaQuery.of(context).size.width * 0.1),
                    border: Border.all(
                      color: appTheme.blueGray900,
                      width: 1.h,
                    ),
                  ),
                  child: IconButton(
                    onPressed: () {},
                    padding: EdgeInsets.all(12.h),
                    icon: CustomImageView(
                      imagePath: ImageConstant.imgFacebook,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
