import 'package:flutter/material.dart';
import 'package:samsung_sss_flutter/cache/app_cache.dart';
import 'package:samsung_sss_flutter/const/analytics_constant.dart';
import 'package:samsung_sss_flutter/const/app_image.dart';
import 'package:samsung_sss_flutter/dio/api/user_api.dart';
import 'package:samsung_sss_flutter/models/json/user/user_model.dart';
import 'package:samsung_sss_flutter/widgets/custom_page_title.dart';

import '../../../const/app_color.dart';
import '../../../const/app_font.dart';
import '../../../const/app_page_constant.dart';
import '../../../const/utils.dart';
import '../../widgets/custom_textfield.dart';

class EditAccountScreen extends StatefulWidget {
  const EditAccountScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _EditAccountScreen();
  }
}

class _EditAccountScreen extends State<EditAccountScreen>
    with WidgetsBindingObserver {
  double? emtpySpace;
  bool isLoading = true;
  var currentUI = GlobalKey<ScaffoldState>();
  var bottomUI = GlobalKey<ScaffoldState>();

  final emailController = TextEditingController();
  final fullNameController = TextEditingController();

  final dobController = TextEditingController();
  final phoneNoController = TextEditingController();

  final companyController = TextEditingController();
  final designationController = TextEditingController();

  final departmentController = TextEditingController();
  late UserModel user;

  final _formKey = GlobalKey<FormState>();

  //Overrides starts here
  @override
  void initState() {
    super.initState();
    Utils.setFirebaseAnalyticsCurrentScreen(
        AnalyticsConstant.ANALYTICS_EDIT_ACCOUNT_SCREEN);
    WidgetsBinding.instance.addObserver(this);
    fillUserProfile();
  }

  //API Functions starts here
  Future<void> fillUserProfile() async {
    UserApi userApi = UserApi(context);
    await userApi.getUser().then((user) {
      fullNameController.text = user.name ?? '';
      emailController.text = user.username ?? '';
      companyController.text = user.company ?? '';
      designationController.text = user.designation ?? '';
      departmentController.text = user.department ?? '';
      dobController.text = user.dob != null
          ? Utils.displayDateFormat.format(DateTime.parse(user.dob!))
          : '';
      phoneNoController.text = user.mobileNo?.substring(2) ?? '';
    }).onError((error, _) {
      Utils.handleError(context, error);
    });
  }

  Future<void> updateUser() async {
    showDialog(
      barrierDismissible: false,
      builder: (ctx) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
      context: context,
    );

    String serverFormatDob = Utils.getServerFormatDob(dobController.text);

    final user = UserModel(
      name: fullNameController.text,
      username: emailController.text,
      company: companyController.text,
      designation: designationController.text,
      department: departmentController.text,
      dob: serverFormatDob,
      mobileNo: '60${phoneNoController.text}',
    );
    UserApi userApi = UserApi(context);
    final newUser = await userApi.updateUser(user: user);
    AppCache.me = newUser;

    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _editAccPageAppBar(),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => Utils.unfocusContext(context),
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              color: Colors.white,
              width: screenWidth,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    key: currentUI,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _editAccPageTitle(screenWidth, context),
                      _editAccFormField(screenWidth, context)
                    ],
                  ),
                  _bottomBtn(screenWidth)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _editAccFormField(double screenWidth, BuildContext context) {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          _fullName(screenWidth, context),
          _emailAddress(screenWidth),
          _dob(screenWidth, context),
          _phoneNo(screenWidth, context),
          _department(screenWidth, context),
          _designation(screenWidth, context),
          _companyName(screenWidth, context),
        ],
      ),
    );
  }

  Column _designation(double screenWidth, BuildContext context) {
    return Column(
      children: [
        Container(
          width: screenWidth,
          margin: const EdgeInsets.only(bottom: 10),
          child: Text(
            Utils.getTranslated(
                context, AppPageConstants.SIGNUPPAGE, 'designationFieldTitle'),
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
            hintText: Utils.getTranslated(
                context, AppPageConstants.SIGNUPPAGE, 'designationHintTitle'),
          ),
        ),
      ],
    );
  }

  Column _department(double screenWidth, BuildContext context) {
    return Column(
      children: [
        Container(
          width: screenWidth,
          margin: const EdgeInsets.only(bottom: 10),
          child: Text(
            Utils.getTranslated(
                context, AppPageConstants.SIGNUPPAGE, 'departmentFieldTitle'),
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
            hintText: Utils.getTranslated(
                context, AppPageConstants.SIGNUPPAGE, 'departmentHintTitle'),
          ),
        ),
      ],
    );
  }

  Column _dob(double screenWidth, BuildContext context) {
    return Column(
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
                  dobController.text = Utils.displayDateFormat.format(value);
                }
              });
            },
            validator: (value) {
              return Utils.requiredValidator(context, value);
            },
            hintText: Utils.getTranslated(
                context, AppPageConstants.SIGNUPPAGE, 'unselectHintTitle'),
            suffix: Container(
              padding: const EdgeInsets.all(10),
              child: Image.asset(AppImage.dropdownButton),
            ),
          ),
        ),
      ],
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
          margin: const EdgeInsets.only(bottom: 38),
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

  Widget _editAccPageTitle(double screenWidth, BuildContext context) {
    return CustomPageTitle(
      title: Utils.getTranslated(
          context, AppPageConstants.EDITACCOUNT, 'editPageTitle'),
      margin: const EdgeInsets.only(
        bottom: 30,
      ),
    );
  }

  AppBar _editAccPageAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      leading: Builder(builder: (BuildContext context) {
        return IconButton(
          icon: Image.asset(AppImage.backButton),
          onPressed: () {
            setState(() {
              Navigator.pop(context);
            });
          },
        );
      }),
    );
  }

  Widget _bottomBtn(double screenWidth) {
    return InkWell(
      key: bottomUI,
      onTap: () async {
        if (_formKey.currentState!.validate()) {
          await updateUser();
          Navigator.pop(context, true);
        }
      },
      child: Container(
        width: screenWidth,
        height: 50,
        padding: const EdgeInsets.symmetric(vertical: 16),
        margin: const EdgeInsets.only(bottom: 48),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: AppColor.samsungBlue),
        child: Center(
          child: Text(
            Utils.getTranslated(
              context,
              AppPageConstants.EDITACCOUNT,
              'saveBtn',
            ).toUpperCase(),
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
                context, AppPageConstants.LOGINPAGE, 'emailAddressFieldTitle'),
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
            active: false,
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
}
