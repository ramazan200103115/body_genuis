import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FMRoute {
  Route generateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      // case LoginPage.route:
      //   return CupertinoPageRoute(
      //     builder: (context) => const LoginPage(),
      //   );
      // case NavigationPage.route:
      //   return CupertinoPageRoute(
      //     builder: (context) => const NavigationPage(),
      //   );
      // case ListProfilesPage.route:
      //   return CupertinoPageRoute(
      //     builder: (context) => const ListProfilesPage(),
      //   );
      // case AddAccountPage.route:
      //   return CupertinoPageRoute(
      //     builder: (context) =>
      //         AddAccountPage(email: routeSettings.arguments as String),
      //   );
      // case NewsTilePage.route:
      //   return CupertinoPageRoute(
      //     builder: (context) => NewsTilePage(
      //       newsModel: routeSettings.arguments as NewsModel,
      //     ),
      //   );
      // case ChatsPage.route:
      //   return CupertinoPageRoute(
      //     builder: (context) => const ChatsPage(),
      //   );
      // case InfosPage.route:
      //   return CupertinoPageRoute(
      //     builder: (context) => const InfosPage(),
      //   );
      // case SupportPage.route:
      //   return CupertinoPageRoute(
      //     builder: (context) => const SupportPage(),
      //   );
      // case TrenirovkaPage.route:
      //   return CupertinoPageRoute(
      //     builder: (context) => TrenirovkaPage(
      //       idTrenirovka: routeSettings.arguments as int,
      //     ),
      //   );
      // case SchoolInfoPage.route:
      //   return CupertinoPageRoute(
      //     builder: (context) => SchoolInfoPage(
      //       // idSchool: routeSettings.arguments as int,
      //       idSchool: routeSettings.arguments as SchoolInfoModel,
      //     ),
      //   );
      // case EditEmailPage.route:
      //   return CupertinoPageRoute(
      //     builder: (context) => const EditEmailPage(),
      //   );
      // case CodeVerificationPage.route:
      //   return CupertinoPageRoute(
      //     builder: (context) => CodeVerificationPage(
      //       email: routeSettings.arguments as String,
      //     ),
      //   );
      // case MatchPage.route:
      //   return CupertinoPageRoute(
      //     builder: (context) => MatchPage(
      //       id: routeSettings.arguments as int,
      //     ),
      //   );
      default:
        return CupertinoPageRoute(
          builder: (context) => CupertinoPageScaffold(
            navigationBar: const CupertinoNavigationBar(
              middle: Text('Роутинг'),
            ),
            child: Center(
              child: Text(
                'Не найден роут для ${routeSettings.name}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.red,
                ),
              ),
            ),
          ),
        );
    }
  }
}
