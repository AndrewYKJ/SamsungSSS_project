import 'package:flutter/material.dart';
import 'package:samsung_sss_flutter/const/analytics_constant.dart';
import 'package:samsung_sss_flutter/const/app_image.dart';
import 'package:samsung_sss_flutter/dio/api/auth_api.dart';

import '../../../const/app_color.dart';
import '../../../const/app_font.dart';
import '../../../const/app_page_constant.dart';
import '../../../const/utils.dart';
import '../../../routes/approutes.dart';
import '../../../widgets/custom_textfield.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SignUpScreen();
  }
}

class _SignUpScreen extends State<SignUpScreen> with WidgetsBindingObserver {
  int currentPage = 0;
  bool isLoading = true;

  var emailController = TextEditingController();
  var pwdController = TextEditingController();
  var cfmPwdController = TextEditingController();
  var fullNameController = TextEditingController();
  var dobController = TextEditingController();
  var phoneNoController = TextEditingController();
  var companyController = TextEditingController();
  var designationController = TextEditingController();
  var departmentController = TextEditingController();

  final _page1FormKey = GlobalKey<FormState>();
  final _page2FormKey = GlobalKey<FormState>();
  late AuthApi _authApi;

  //Overrides starts here
  @override
  void initState() {
    super.initState();
    Utils.setFirebaseAnalyticsCurrentScreen(
        AnalyticsConstant.ANALYTICS_SIGN_UP_EMAIL_SCREEN);
    WidgetsBinding.instance.addObserver(this);
    _authApi = AuthApi(context);
  }

  void signUp() {
    _authApi
        .register(
      emailController.text,
      pwdController.text,
      cfmPwdController.text,
      fullNameController.text,
      Utils.getServerFormatDob(dobController.text),
      '60${phoneNoController.text}',
      departmentController.text,
      designationController.text,
      companyController.text,
    )
        .then((_) {
      Navigator.pushNamedAndRemoveUntil(
          context, AppRoutes.signUpSuccessRoute, (route) => false);
    }).onError((error, _) {
      Utils.handleError(context, error);
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    emailController.dispose();
    pwdController.dispose();
    cfmPwdController.dispose();
    fullNameController.dispose();
    dobController.dispose();
    phoneNoController.dispose();
    companyController.dispose();
    designationController.dispose();
    departmentController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double availableHeight = screenHeight -
        MediaQuery.of(context).viewPadding.top -
        MediaQuery.of(context).viewPadding.bottom -
        kToolbarHeight;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: signUpPageAppbar(),
      body: WillPopScope(
        onWillPop: () async {
          setState(() {
            if (currentPage == 0) {
              Navigator.pop(context);
            } else {
              currentPage = 0;
            }
          });
          return false;
        },
        child: SafeArea(
          child: GestureDetector(
            onTap: () => Utils.unfocusContext(context),
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: availableHeight,
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  color: Colors.white,
                  width: screenWidth,
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                        _signUpPageTitle(screenWidth, context),
                        _signUpPageDesc(screenWidth, context),
                        Stack(
                          children: [
                            currentPage == 0
                                ? page1(screenWidth)
                                : page2(screenWidth, context)
                          ],
                        ),
                        const Spacer(),
                        _bottomBtn(screenWidth)
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget page1(double screenWidth) {
    return Form(
      key: _page1FormKey,
      child: Column(
        children: [
          _emailAddress(screenWidth),
          _password(screenWidth),
          _cfmpassword(screenWidth)
        ],
      ),
    );
  }

  Widget page2(double screenWidth, BuildContext context) {
    return Container(
      width: screenWidth,
      margin: const EdgeInsets.only(
        bottom: 8,
      ),
      child: Form(
        key: _page2FormKey,
        child: Column(
          children: [
            _fullName(screenWidth, context),
            Column(
              children: [
                Container(
                  width: screenWidth,
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    Utils.getTranslated(
                        context, AppPageConstants.SIGNUPPAGE, 'dobFieldTitle'),
                    style: AppFont.helveticaNeueRegular(
                      16,
                      color: AppColor.wordingColorBlack,
                    ),
                  ),
                ),
                Container(
                  width: screenWidth,
                  margin: const EdgeInsets.only(bottom: 40),
                  child: CustomTextField(
                    controller: dobController,
                    readOnly: true,
                    onTap: () {
                      showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      ).then((value) {
                        if (value != null) {
                          dobController.text =
                              Utils.displayDateFormat.format(value);
                        }
                      });
                    },
                    validator: (value) {
                      return Utils.requiredValidator(context, value);
                    },
                    hintText: Utils.getTranslated(context,
                        AppPageConstants.SIGNUPPAGE, 'unselectHintTitle'),
                    suffix: Container(
                      padding: const EdgeInsets.all(10),
                      child: Image.asset(AppImage.dropdownButton),
                    ),
                  ),
                ),
              ],
            ),
            _phoneNo(screenWidth, context),
            Column(
              children: [
                Container(
                  width: screenWidth,
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    Utils.getTranslated(context, AppPageConstants.SIGNUPPAGE,
                        'departmentFieldTitle'),
                    style: AppFont.helveticaNeueRegular(
                      16,
                      color: AppColor.wordingColorBlack,
                    ),
                  ),
                ),
                Container(
                  width: screenWidth,
                  margin: const EdgeInsets.only(bottom: 40),
                  child: CustomTextField(
                    controller: departmentController,
                    validator: (value) {
                      return Utils.requiredValidator(context, value);
                    },
                    hintText: Utils.getTranslated(context,
                        AppPageConstants.SIGNUPPAGE, 'departmentHintTitle'),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Container(
                  width: screenWidth,
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    Utils.getTranslated(context, AppPageConstants.SIGNUPPAGE,
                        'designationFieldTitle'),
                    style: AppFont.helveticaNeueRegular(
                      16,
                      color: AppColor.wordingColorBlack,
                    ),
                  ),
                ),
                Container(
                  width: screenWidth,
                  margin: const EdgeInsets.only(bottom: 40),
                  child: CustomTextField(
                    controller: designationController,
                    validator: (value) {
                      return Utils.requiredValidator(context, value);
                    },
                    hintText: Utils.getTranslated(context,
                        AppPageConstants.SIGNUPPAGE, 'designationHintTitle'),
                  ),
                ),
              ],
            ),
            _companyName(screenWidth, context),
          ],
        ),
      ),
    );
  }

  Column _companyName(double screenWidth, BuildContext context) {
    return Column(
      children: [
        Container(
          width: screenWidth,
          margin: const EdgeInsets.only(bottom: 10),
          child: Text(
            Utils.getTranslated(
                context, AppPageConstants.SIGNUPPAGE, 'companyNameFieldTitle'),
            style: AppFont.helveticaNeueRegular(
              16,
              color: AppColor.wordingColorBlack,
            ),
          ),
        ),
        Container(
          width: screenWidth,
          margin: const EdgeInsets.only(bottom: 40),
          child: CustomTextField(
            controller: companyController,
            validator: (value) {
              return Utils.requiredValidator(context, value);
            },
            hintText: Utils.getTranslated(
                context, AppPageConstants.SIGNUPPAGE, 'companyNameHintText'),
          ),
        ),
      ],
    );
  }

  Column _phoneNo(double screenWidth, BuildContext context) {
    return Column(
      children: [
        Container(
          width: screenWidth,
          margin: const EdgeInsets.only(bottom: 10),
          child: Text(
            Utils.getTranslated(
                context, AppPageConstants.SIGNUPPAGE, 'phoneNoFieldTitle'),
            style: AppFont.helveticaNeueRegular(
              16,
              color: AppColor.wordingColorBlack,
            ),
          ),
        ),
        Container(
          width: screenWidth,
          margin: const EdgeInsets.only(bottom: 40),
          child: CustomTextField(
            controller: phoneNoController,
            validator: (value) {
              return Utils.phoneValidator(context, value);
            },
            prefix: Utils.getTranslated(
                context, AppPageConstants.SIGNUPPAGE, 'phoneNoHintText'),
          ),
        ),
      ],
    );
  }

  Column _fullName(double screenWidth, BuildContext context) {
    return Column(
      children: [
        Container(
          width: screenWidth,
          margin: const EdgeInsets.only(bottom: 10),
          child: Text(
            Utils.getTranslated(
                context, AppPageConstants.SIGNUPPAGE, 'fullNameFieldTitle'),
            style: AppFont.helveticaNeueRegular(
              16,
              color: AppColor.wordingColorBlack,
            ),
          ),
        ),
        Container(
          width: screenWidth,
          margin: const EdgeInsets.only(bottom: 40),
          child: CustomTextField(
            controller: fullNameController,
            validator: (value) {
              return Utils.requiredValidator(context, value);
            },
            hintText: Utils.getTranslated(
                context, AppPageConstants.SIGNUPPAGE, 'fullNameHintTitle'),
          ),
        ),
      ],
    );
  }

  Container _signUpPageTitle(double screenWidth, BuildContext context) {
    return Container(
      width: screenWidth,
      margin: const EdgeInsets.only(
        bottom: 11,
      ),
      child: Row(
        children: [
          Text(
            Utils.getTranslated(context, AppPageConstants.SIGNUPPAGE, 'signUp'),
            style: AppFont.helveticaNeueBold(30, color: AppColor.samsungBlue),
          ),
          const SizedBox(
            width: 12,
          ),
          Text(
            "${currentPage + 1} / 2",
            style: AppFont.helveticaNeueBold(30, color: AppColor.samsungBlue),
          ),
        ],
      ),
    );
  }

  Container _signUpPageDesc(double screenWidth, BuildContext context) {
    return Container(
      width: screenWidth,
      margin: const EdgeInsets.only(
        bottom: 50,
      ),
      child: Text(
        currentPage == 0
            ? Utils.getTranslated(
                context, AppPageConstants.SIGNUPPAGE, 'signUpDesc')
            : Utils.getTranslated(
                context, AppPageConstants.SIGNUPPAGE, 'signUpDescPage2'),
        style:
            AppFont.helveticaNeueRegular(16, color: AppColor.wordingColorBlack),
      ),
    );
  }

  AppBar signUpPageAppbar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      leading: Builder(builder: (BuildContext context) {
        return IconButton(
          icon: Image.asset(AppImage.backButton),
          onPressed: () {
            setState(() {
              if (currentPage == 0) {
                Navigator.pop(context);
              } else {
                currentPage = 0;
                isLoading = true;
              }
            });
          },
        );
      }),
    );
  }

  Widget _bottomBtn(double screenWidth) {
    return InkWell(
      onTap: () {
        if (currentPage == 0 && _page1FormKey.currentState!.validate()) {
          _authApi
              .registerCheck(emailController.text, pwdController.text,
                  cfmPwdController.text)
              .then(
            (_) {
              setState(() {
                currentPage = 1;
                isLoading = true;
                Utils.setFirebaseAnalyticsCurrentScreen(
                    AnalyticsConstant.ANALYTICS_SIGN_UP_DETAILS_SCREEN);
              });
            },
          ).onError((error, _) {
            Utils.printInfo(error ?? '');
            Utils.handleError(context, error);
          });
        } else {
          if (_page2FormKey.currentState?.validate() ?? false) {
            signUp();
          }
        }
      },
      child: Container(
        height: 50,
        padding: const EdgeInsets.symmetric(vertical: 16),
        margin: const EdgeInsets.only(bottom: 93),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: AppColor.samsungBlue),
        child: Center(
          child: Text(
            currentPage == 0
                ? Utils.getTranslated(
                    context, AppPageConstants.SIGNUPPAGE, 'nextBtn')
                : Utils.getTranslated(
                        context, AppPageConstants.SIGNUPPAGE, 'signUp')
                    .toUpperCase(),
            style: AppFont.helveticaNeueBold(16,
                color: AppColor.wordingColorWhite),
          ),
        ),
      ),
    );
  }

  Widget _emailAddress(double screenWidth) {
    return Column(
      children: [
        Container(
          width: screenWidth,
          margin: const EdgeInsets.only(bottom: 10),
          child: Text(
            Utils.getTranslated(
                context, AppPageConstants.SIGNUPPAGE, 'emailAddressFieldTitle'),
            style: AppFont.helveticaNeueRegular(
              16,
              color: AppColor.wordingColorBlack,
            ),
          ),
        ),
        Container(
          width: screenWidth,
          margin: const EdgeInsets.only(bottom: 40),
          child: CustomTextField(
            controller: emailController,
            validator: (value) {
              return Utils.emailValidator(context, value);
            },
            hintText: Utils.getTranslated(
                context, AppPageConstants.SIGNUPPAGE, 'emailAddressHintText'),
          ),
        ),
      ],
    );
  }

  Widget _password(double screenWidth) {
    return Column(
      children: [
        Container(
          width: screenWidth,
          margin: const EdgeInsets.only(bottom: 10),
          child: Text(
            Utils.getTranslated(
                context, AppPageConstants.SIGNUPPAGE, 'passwordFieldTitle'),
            style: AppFont.helveticaNeueRegular(
              16,
              color: AppColor.wordingColorBlack,
            ),
          ),
        ),
        Container(
          width: screenWidth,
          margin: const EdgeInsets.only(bottom: 40),
          child: CustomTextField(
            controller: pwdController,
            validator: (value) {
              return Utils.passwordValidator(context, value);
            },
            obsure: true,
            hintText: Utils.getTranslated(
                context, AppPageConstants.SIGNUPPAGE, 'passwordHintText'),
          ),
        ),
      ],
    );
  }

  Widget _cfmpassword(double screenWidth) {
    return Column(
      children: [
        Container(
          width: screenWidth,
          margin: const EdgeInsets.only(bottom: 10),
          child: Text(
            Utils.getTranslated(
                context, AppPageConstants.SIGNUPPAGE, 'cfmpasswordFieldTitle'),
            style: AppFont.helveticaNeueRegular(
              16,
              color: AppColor.wordingColorBlack,
            ),
          ),
        ),
        Container(
          width: screenWidth,
          margin: const EdgeInsets.only(bottom: 40),
          child: CustomTextField(
            controller: cfmPwdController,
            validator: (value) {
              return Utils.confirmPasswordValidator(
                context,
                pwdController.text,
                value,
              );
            },
            obsure: true,
            hintText: Utils.getTranslated(
                context, AppPageConstants.SIGNUPPAGE, 'cfmpasswordHintText'),
          ),
        ),
      ],
    );
  }
}
