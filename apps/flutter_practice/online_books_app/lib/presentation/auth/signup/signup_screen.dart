import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:online_books_app/core/theme/custom_button_style.dart';
import 'package:online_books_app/core/theme/custom_text_style.dart';
import 'package:online_books_app/core/theme/theme_helper.dart';
import 'package:online_books_app/core/utils/image_constant.dart';
import 'package:online_books_app/core/utils/size_utils.dart';
import 'package:online_books_app/presentation/auth/signup/controller/signup_controller.dart';
import 'package:online_books_app/widgets/custom_checkbox_button.dart';
import 'package:online_books_app/widgets/custom_drop_down.dart';
import 'package:online_books_app/widgets/custom_elevated_button.dart';
import 'package:online_books_app/widgets/custom_image_view.dart';
import 'package:online_books_app/widgets/custom_text_form_field.dart';

class SignupScreen extends GetView<SignupController> {
  const SignupScreen({super.key});

  @override
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
            controller: controller.scrollController,
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
                      _buildDateOfBirthInput(context),
                      SizedBox(
                        height: 30.h,
                      ),
                      _buildAgeInput(),
                      SizedBox(
                        height: 30.h,
                      ),
                      _buildIsStudentCheckbox(),
                      Obx(
                        () => controller.isStudent.value
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 30.h),
                                  _buildSchoolNameInput(),
                                  SizedBox(height: 30.h),
                                  _buildSchoolIdInput(),
                                ],
                              )
                            : SizedBox.shrink(),
                      ),
                      SizedBox(
                        height: 30.h,
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

  Widget _buildIsStudentCheckbox() {
    return Obx(
      () => CustomCheckboxButton(
        text: "lbl_are_you_a_student".tr,
        value: controller.isStudent.value,
        onChange: (bool? value) {
          controller.isStudent.value = value ?? false;
        },
      ),
    );
  }

  Widget _buildSchoolNameInput() {
    return CustomTextFormField(
      name: "schoolName",
      controller: controller.schoolNameController,
      hintText: "lbl_school_name".tr,
      prefix: Container(
        margin: EdgeInsets.fromLTRB(8.h, 12.h, 6.h, 12.h),
        child: Icon(Icons.school, color: theme.colorScheme.primary),
      ),
      prefixConstraints: BoxConstraints(maxHeight: 48.h),
      contentPadding: EdgeInsets.fromLTRB(8.h, 12.h, 14.h, 12.h),
      validator: (value) => controller.validateSchoolName(value),
    );
  }

  Widget _buildSchoolIdInput() {
    return CustomTextFormField(
      name: "schoolId",
      controller: controller.schoolIdController,
      hintText: "lbl_student_id".tr,
      prefix: Container(
        margin: EdgeInsets.fromLTRB(8.h, 12.h, 6.h, 12.h),
        child: Icon(Icons.badge, color: theme.colorScheme.primary),
      ),
      prefixConstraints: BoxConstraints(maxHeight: 48.h),
      contentPadding: EdgeInsets.fromLTRB(8.h, 12.h, 14.h, 12.h),
      validator: (value) => controller.validateSchoolId(value),
    );
  }

  CustomDropDown _buildCustomDropDown() {
    return CustomDropDown(
      key: controller.occupationDropdownKey,
      icon: Container(
        margin: EdgeInsets.only(
          left: 16.h,
        ),
        child: CustomImageView(
          imagePath: ImageConstant.imgArrowCaretdown,
          height: 22.h,
          width: 20.w,
          fit: BoxFit.contain,
        ),
      ),
      hintText: "lbl_occupation".tr,
      items: controller.signupModelObj.value.dropdownItemList.value,
      onMenuWillOpen: () {
        controller.ensureDropdownVisible(controller.occupationDropdownKey);
      },
      onChanged: (selectedValue) {
        debugPrint("Selected: ${selectedValue.title}");
      },
      prefix: Container(
        margin: EdgeInsets.fromLTRB(8.h, 12.h, 1.h, 12.h),
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
      contentPadding: EdgeInsets.fromLTRB(4.h, 12.h, 14.h, 12.h),
    );
  }

  /// Section Widget
  /// First Name Input
  Widget _buildFirstNameInput() {
    return Obx(
      () => CustomTextFormField(
        name: "firstName",
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
        errorText: controller.firstNameError.value.isEmpty
            ? null
            : controller.firstNameError.value,
        onChanged: (value) {
          controller.validateFirstName(value);
        },
      ),
    );
  }

  Widget _buildLastNameInput() {
    return Obx(
      () => CustomTextFormField(
        name: "lastName",
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
        errorText: controller.lastNameError.value.isEmpty
            ? null
            : controller.lastNameError.value,
        onChanged: (value) {
          controller.validateLastName(value);
        },
      ),
    );
  }

  Widget _buildEmailInput() {
    return Obx(
      () => CustomTextFormField(
        name: "email",
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
        errorText: controller.emailError.value.isEmpty
            ? null
            : controller.emailError.value,
        onChanged: (value) {
          controller.validateEmail(value);
        },
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
        errorText: controller.passwordError.value.isEmpty
            ? null
            : controller.passwordError.value,
        onChanged: (value) {
          controller.validatePassword(value);
        },
        obscureText: controller.isShowPassword.value,
        contentPadding: EdgeInsets.fromLTRB(8.h, 12.h, 14.h, 12.h),
        borderDecoration: TextFormFieldStyleHelper.outlineGrayTL12,
        validator: (value) {
          controller.validatePassword(value ?? '');
          return controller.passwordError.value.isEmpty
              ? null
              : controller.passwordError.value;
        },
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

  Widget _buildDateOfBirthInput(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Obx(
                () => TextField(
                  controller: controller.dayController,
                  focusNode: controller.dayFocusNode,
                  keyboardType: TextInputType.number,
                  maxLength: 2,
                  textInputAction: TextInputAction.next,
                  onSubmitted: (_) {
                    FocusScope.of(context)
                        .requestFocus(controller.monthFocusNode);
                  },
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.h),
                      borderSide: BorderSide(color: appTheme.gray500),
                    ),
                    focusColor: appTheme.gray50,
                    filled: true,
                    fillColor: appTheme.gray50,
                    labelText: "Day",
                    labelStyle: TextStyle(
                      color: theme.colorScheme.primary,
                    ),
                    border: TextFormFieldStyleHelper.outlineGrayTL12,
                    errorText: controller.dayError.value.isEmpty
                        ? null
                        : controller.dayError.value,
                    counterText: "",
                  ),
                  onChanged: (value) {
                    controller.day.value = value;
                    if (value.isNotEmpty) {
                      controller.validateDay(value);
                      controller.updateDateFromTextFields();
                    }
                  },
                ),
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Obx(
                () => TextField(
                  controller: controller.monthController,
                  focusNode: controller.monthFocusNode,
                  keyboardType: TextInputType.number,
                  maxLength: 2,
                  textInputAction: TextInputAction.next,
                  onSubmitted: (_) {
                    FocusScope.of(context)
                        .requestFocus(controller.yearFocusNode);
                  },
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.h),
                      borderSide: BorderSide(color: appTheme.gray500),
                    ),
                    focusColor: appTheme.gray50,
                    filled: true,
                    fillColor: appTheme.gray50,
                    labelText: "Month",
                    labelStyle: TextStyle(
                      color: theme.colorScheme.primary,
                    ),
                    border: TextFormFieldStyleHelper.outlineGrayTL12,
                    errorText: controller.monthError.value.isEmpty
                        ? null
                        : controller.monthError.value,
                    counterText: "",
                  ),
                  onChanged: (value) {
                    controller.month.value = value;
                    if (value.isNotEmpty) {
                      controller.validateMonth(value);
                      controller.updateDateFromTextFields();
                    }
                  },
                ),
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Obx(
                () => TextField(
                  controller: controller.yearController,
                  focusNode: controller.yearFocusNode,
                  keyboardType: TextInputType.number,
                  maxLength: 4,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.h),
                      borderSide: BorderSide(color: appTheme.gray500),
                    ),
                    focusColor: appTheme.gray50,
                    filled: true,
                    labelStyle: TextStyle(
                      color: theme.colorScheme.primary,
                    ),
                    fillColor: appTheme.gray50,
                    labelText: "Year",
                    border: TextFormFieldStyleHelper.outlineGrayTL12,
                    errorText: controller.yearError.value.isEmpty
                        ? null
                        : controller.yearError.value,
                    counterText: "",
                  ),
                  onChanged: (value) {
                    controller.year.value = value;
                    if (value.isNotEmpty) {
                      controller.validateYear(value);
                      controller.updateDateFromTextFields();
                    }
                  },
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 30.h),
        Obx(
          () => CustomTextFormField(
            readOnly: true,
            hintText: "lbl_date_of_birth".tr,
            controller: TextEditingController(
              text: controller.selectedDate.value != null
                  ? '${controller.selectedDate.value!.day}/${controller.selectedDate.value!.month}/${controller.selectedDate.value!.year}'
                  : '',
            ),
            prefix: Container(
              margin: EdgeInsets.fromLTRB(10.h, 12.h, 6.h, 12.h),
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
            onTap: () async {
              final DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: controller.selectedDate.value,
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
              );

              if (pickedDate != null &&
                  pickedDate != controller.selectedDate.value) {
                controller.selectedDate.value = pickedDate;
                controller.updateTextFieldsFromDate(pickedDate);
              }
            },
          ),
        ),
      ],
    );
  }

  /// Section Widget
  Widget _buildSignUpButton() {
    return Obx(
      () => CustomElevatedButton(
        height: 40.h,
        text: controller.isLoading.value ? "Signing Up..." : "lbl_sign_up".tr,
        buttonStyle: controller.isFormValid && !controller.isLoading.value
            ? CustomButtonStyles.outlinePrimaryTL12
            : CustomButtonStyles.outlinePrimaryTL12.copyWith(
                backgroundColor: WidgetStateProperty.all(appTheme.gray500),
                foregroundColor: WidgetStateProperty.all(appTheme.gray50),
              ),
        buttonTextStyle: CustomTextStyles.titleLargeDosisGray50,
        onPressed: controller.isLoading.value || !controller.isFormValid
            ? null
            : () {
                controller.signUp();
              },
      ),
    );
  }

  Widget _buildAgeInput() {
    return Obx(
      () => CustomTextFormField(
        controller:
            TextEditingController(text: controller.age.value.toString()),
        hintText: "lbl_age".tr,
        readOnly: true,
        prefix: Container(
          margin: EdgeInsets.fromLTRB(8.h, 12.h, 6.h, 12.h),
          child: Icon(Icons.cake, color: theme.colorScheme.primary),
        ),
        prefixConstraints: BoxConstraints(maxHeight: 48.h),
        contentPadding: EdgeInsets.fromLTRB(8.h, 12.h, 14.h, 12.h),
      ),
    );
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
