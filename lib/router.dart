import 'package:docs_ai/screens/custom_splash_screen.dart';
import 'package:docs_ai/screens/document/document_screen.dart';
import 'package:docs_ai/screens/home.dart';
import 'package:docs_ai/screens/login/login.dart';
import 'package:docs_ai/screens/login/login_mobile_view.dart';
import 'package:docs_ai/screens/picture/upload_picture.dart';
import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

// const MaterialPage<dynamic>(
//           child: CustomSplashScreen(),
//         )

/// Contains the routes available when the user is logOut
final RouteMap loggedOutRoute = RouteMap(
  routes: <String, PageBuilder>{
    '/': (RouteData route) => const MaterialPage<dynamic>(
          child: CustomSplashScreen(),
        ),
    '/login': (RouteData route) => const MaterialPage<dynamic>(
          child: Login(),
        ),
    '/login-mobile': (RouteData route) => const MaterialPage<dynamic>(
          child: LoginViewWithBtn(),
        ),
  },
);

/// Contains the routes available when the user is logIn
final RouteMap loggedInRoute = RouteMap(
  routes: <String, PageBuilder>{
    '/': (RouteData route) => const MaterialPage<dynamic>(
          child: Home(),
        ),
    '/upload-picture': (RouteData route) => const MaterialPage<dynamic>(
          child: UploadPicture(),
        ),
    '/document/:id': (RouteData route) => MaterialPage<dynamic>(
          child: DocumentScreen(
            id: route.pathParameters['id'] ?? '',
          ),
        ),
  },
);
