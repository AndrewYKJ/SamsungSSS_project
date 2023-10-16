import 'package:flutter/material.dart';
import 'package:samsung_sss_flutter/controllers/aboutus/about_us.dart';
import 'package:samsung_sss_flutter/controllers/account/account_info.dart';
import 'package:samsung_sss_flutter/controllers/account/edit_account.dart';
import 'package:samsung_sss_flutter/controllers/auth/forgot_pwd/forgot_pwd.dart';
import 'package:samsung_sss_flutter/controllers/auth/forgot_pwd/forgot_pwd_success.dart';
import 'package:samsung_sss_flutter/controllers/auth/sign_up/sign_up_success.dart';
import 'package:samsung_sss_flutter/controllers/chemical_register/chemical_details.dart';
import 'package:samsung_sss_flutter/controllers/chemical_register/sds_summary.dart';
import 'package:samsung_sss_flutter/controllers/cranelocation/crane_location.dart';
import 'package:samsung_sss_flutter/controllers/chemical_register/chemical_register_category.dart';
import 'package:samsung_sss_flutter/controllers/chemical_register/chemical_register_subcategory.dart';
import 'package:samsung_sss_flutter/controllers/home/home.dart';
import 'package:samsung_sss_flutter/controllers/loto/loto_station_map.dart';
import 'package:samsung_sss_flutter/models/json/chemical_register/chemical_model.dart';
import 'package:samsung_sss_flutter/models/page_argument/chemical_subcategory_argument.dart';
import 'package:samsung_sss_flutter/models/page_argument/gallery_argument.dart';
import 'package:samsung_sss_flutter/models/page_argument/pdf.dart';
import 'package:samsung_sss_flutter/widgets/gallery_view.dart';
import 'package:samsung_sss_flutter/widgets/pdf_view.dart';

import '../controllers/auth/login/login.dart';
import '../controllers/auth/sign_up/sign_up.dart';
import '../controllers/landing/splash_screen.dart';
import '../controllers/loto/loto_list.dart';
import '../controllers/loto/loto_station_details.dart';
import '../models/page_argument/loto_building_argument.dart';

class AppRoutes {
  static const String splashScreenRoute = "splashRoute";

  static const String homeRoute = "homeRoute";

  static const String signUpRoute = "signUpRoute";
  static const String signUpSuccessRoute = "signUpSuccessRoute";
  static const String loginRoute = "loginRoute";

  static const String forgotPwdRoute = "forgotPwdRoute";
  static const String forgotPwdSuccessRoute = "forgotPwdSuccessRoute";

  static const String accountInfoRoute = 'accountInfoRoute';
  static const String editAccountRoute = "editAccountRoute";

  static const String aboutUsRoute = 'aboutUsRoute';

  static const String craneLocationRoute = 'craneLocationRoute';
  static const String lotoListRoute = "lotoListRoute";
  static const String lotoMapRoute = "lotoMapRoute";
  static const String lotoPanelDetailRoute = "lotoPanelDetailRoute";

  static const String chemicalRegisterCategoryListRoute =
      "chemicalRegisterCategoryListRoute";
  static const String chemicalRegisterSubCategoryListRoute =
      "chemicalRegisterSubCategoryListRoute";
  static const String chemicalDetailRoute = "chemicalDetailRoute";
  static const String sdsSummary = "sdsSummaryRoute";

  static const String pdfViewRoute = 'pdfViewRoute';
  static const String galleryViewRoute = 'galleryViewRoute';

  static Route<dynamic> generatedRoute(RouteSettings settings) {
    switch (settings.name) {
      case splashScreenRoute:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case homeRoute:
        return MaterialPageRoute(builder: (_) => const HomeScreen());

      case signUpRoute:
        return MaterialPageRoute(builder: (_) => const SignUpScreen());
      case signUpSuccessRoute:
        return MaterialPageRoute(builder: (_) => const SignUpSuccessScreen());

      case loginRoute:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case forgotPwdRoute:
        return MaterialPageRoute(builder: (_) => const ForgotPwdScreen());
      case forgotPwdSuccessRoute:
        return MaterialPageRoute(
            builder: (_) => const ForgotPwdSuccessScreen());
      case accountInfoRoute:
        return MaterialPageRoute(builder: (_) => const AccountInfoScreen());
      case editAccountRoute:
        return MaterialPageRoute(builder: (_) => const EditAccountScreen());

      case aboutUsRoute:
        return MaterialPageRoute(builder: (_) => const AboutUsScreen());

      case craneLocationRoute:
        return MaterialPageRoute(builder: (_) => const CraneLocationScreen());
      case lotoListRoute:
        return MaterialPageRoute(builder: (_) => const LotoListScreen());
      case lotoMapRoute:
        return MaterialPageRoute(builder: (_) {
          LotoBuildingArguments arguments =
              settings.arguments as LotoBuildingArguments;
          return StationMapScreen(
            buildingId: arguments,
          );
        });
      case lotoPanelDetailRoute:
        return MaterialPageRoute(builder: (_) {
          LotoPanelArguments arguments =
              settings.arguments as LotoPanelArguments;
          return PanelDetailScreen(
            building: arguments,
          );
        });

      case chemicalRegisterCategoryListRoute:
        return MaterialPageRoute(
            builder: (_) => const ChemicalRegisterCategory());

      case chemicalRegisterSubCategoryListRoute:
        return MaterialPageRoute(builder: (_) {
          ChemicalSubCategoryArguments arguments =
              settings.arguments as ChemicalSubCategoryArguments;
          return ChemicalRegisterSubCategory(
            title: arguments.name,
            id: arguments.id,
          );
        });

      case chemicalDetailRoute:
        ChemicalModel chemicalModel = settings.arguments as ChemicalModel;
        return MaterialPageRoute(
          builder: (_) => ChemicalDetails(
            chemical: chemicalModel,
          ),
        );

      case sdsSummary:
        String url = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => SdsSummary(
            url: url,
          ),
        );

      case pdfViewRoute:
        PdfPropeties pdfPropeties = settings.arguments as PdfPropeties;
        return MaterialPageRoute(
          builder: (_) => PdfView(
            pdfName: pdfPropeties.name,
            pdfUrl: pdfPropeties.url,
          ),
        );

      case galleryViewRoute:
        GalleryArguments args = settings.arguments as GalleryArguments;
        return MaterialPageRoute(
          builder: (_) => GalleryPhotoView(
            images: args.images,
            initialIndex: args.initialIndex,
            scrollDirection: args.scrollDirection,
          ),
        );

      default:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
    }
  }
}
