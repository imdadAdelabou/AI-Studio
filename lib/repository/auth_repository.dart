import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:docs_ai/models/error_model.dart';
import 'package:docs_ai/models/pricing.dart';
import 'package:docs_ai/models/user.dart';
import 'package:docs_ai/repository/local_storage_repository.dart';
import 'package:docs_ai/utils/app_text.dart';
import 'package:docs_ai/utils/constant.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Contains all the functions using for authentification (SignIn, Logout, getUserData)
/// and Provider allow to access the service globaly
final Provider<AuthRepository> authRepositoryProvider =
    Provider<AuthRepository>(
  (ProviderRef<Object?> ref) => AuthRepository(
    googleSignIn: GoogleSignIn(),
    dioClient: dioClient,
    localStorageRepository: LocalStorageRepository(),
    providerRef: ref,
  ),
);

//StateProvider to create a provider for variables
/// Contains a provider for the UserModel that allow it to be access from any component
final StateProvider<UserModel?> userProvider = StateProvider<UserModel?>(
  (StateProviderRef<UserModel?> ref) => null,
);

/// Represent the Authentification service
class AuthRepository {
  /// Creates a [AuthRepository] instance
  AuthRepository({
    required GoogleSignIn googleSignIn,
    required Dio dioClient,
    required LocalStorageRepository localStorageRepository,
    required ProviderRef<Object?> providerRef,
  })  : _googleSignIn = googleSignIn,
        _dioClient = dioClient,
        _localStorageRepository = localStorageRepository,
        _providerRef = providerRef;
  final GoogleSignIn _googleSignIn;
  final Dio _dioClient;
  final LocalStorageRepository _localStorageRepository;
  final ProviderRef<Object?> _providerRef;

  /// A function used to sign out a user from the app
  Future<bool> signOut() async {
    try {
      final String provider = _providerRef.watch(userProvider)!.provider;

      if (provider == 'GOOGLE') {
        await _googleSignIn.signOut();
      }

      final bool isRemove = await LocalStorageRepository().removeToken();
      if (isRemove) {
        _providerRef
            .read(userProvider.notifier)
            .update((UserModel? state) => null);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  /// A function used to sign-in a user to the app
  Future<ErrorModel> signInWithGoogle() async {
    ErrorModel error = const ErrorModel(
      error: 'ServerError',
      data: null,
    );

    try {
      final GoogleSignInAccount? user = await _googleSignIn.signIn();
      if (user != null) {
        log('Photo Url: ${user.photoUrl}');
        final UserModel userData = UserModel(
          email: user.email,
          name: user.displayName ?? '',
          photoUrl: user.photoUrl ?? '',
          token: '',
          id: '',
          provider: 'GOOGLE',
          pricing: null,
        );

        final Response<dynamic> res = await _dioClient.post(
          '/signup',
          data: userData.toJson(),
        );
        switch (res.statusCode) {
          case 201:
            {
              final UserModel newUser = userData.copyWith(
                id: res.data['user']['_id'],
                token: res.data['token'],
                isNewUser: res.data['isNewUser'],
                photoUrl: res.data['user']['photoUrl'],
                pricing: Pricing.fromJson(
                  res.data['user']['pricing'],
                ),
              );

              error = ErrorModel(data: newUser);
              await _localStorageRepository.setToken(token: newUser.token);
              break;
            }
        }
      }
    } catch (e) {
      error = ErrorModel(data: null, error: e.toString());
    }

    return error;
  }

  /// A function used to sign-in a user to the app with email and password
  Future<ErrorModel> registerWithEmailAndPassword({
    required String email,
    required String name,
    required String password,
  }) async {
    ErrorModel errorModel = const ErrorModel(data: null);

    try {
      final Response<dynamic> res = await _dioClient.post(
        '/register-with-email-and-password',
        data: <String, dynamic>{
          'email': email,
          'name': name,
          'password': password,
        },
      );

      if (res.statusCode == 201) {
        final Map<String, dynamic> data = res.data as Map<String, dynamic>;

        log("uSER tOKEN ${data['token']}");
        errorModel = ErrorModel(
          data: UserModel.fromJson(
            data['user'],
          ).copyWith(
            token: data['token'],
          ),
        );
        await _localStorageRepository.setToken(token: data['token']);
        return errorModel;
      }

      return ErrorModel(error: res.statusMessage, data: null);
    } on DioException catch (error) {
      final Response<dynamic>? response = error.response;

      if (response != null &&
          response.statusCode != null &&
          response.statusCode == 409) {
        return const ErrorModel(
          data: null,
          error: AppText.accountAlreadyExist,
        );
      }

      return const ErrorModel(
        data: null,
        error: AppText.errorHappened,
      );
    }
  }

  /// A function used to sign-in a user to the app with email and password
  Future<ErrorModel> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    ErrorModel errorModel = const ErrorModel(data: null);
    log(email);
    log(password);

    try {
      final Response<dynamic> res = await _dioClient.post(
        '/login',
        data: <String, dynamic>{
          'email': email,
          'password': password,
        },
      );

      if (res.statusCode == 200) {
        final Map<String, dynamic> data = res.data as Map<String, dynamic>;

        log("uSER tOKEN ${data['token']}");
        errorModel = ErrorModel(
          data: UserModel.fromJson(
            data['user'],
          ).copyWith(
            token: data['token'],
          ),
        );
        await _localStorageRepository.setToken(token: data['token']);
        return errorModel;
      }

      return ErrorModel(error: res.statusMessage, data: null);
    } on DioException catch (error) {
      final Response<dynamic>? response = error.response;

      if (response != null &&
          response.statusCode != null &&
          response.statusCode == 404) {
        return const ErrorModel(
          data: null,
          error: AppText.accountDoesNotExist,
        );
      }

      if (response != null &&
          response.statusCode != null &&
          response.statusCode == 401) {
        return const ErrorModel(
          data: null,
          error: AppText.wrongPassword,
        );
      }

      return const ErrorModel(
        data: null,
        error: AppText.errorHappened,
      );
    }
  }

  /// A function to get a data of the connected user
  Future<ErrorModel> getUserData() async {
    ErrorModel errorModel = const ErrorModel(data: null);

    try {
      final String? token = await _localStorageRepository.getToken();

      if (token != null) {
        final Response<dynamic> res = await _dioClient.get(
          '/me',
          options: Options(
            headers: <String, dynamic>{
              'x-auth-token': token,
            },
          ),
        );

        res.data['user']['token'] = '';
        errorModel = ErrorModel(
          data: UserModel.fromJson(
            res.data['user'],
          ).copyWith(token: token),
        );
        return errorModel;
      }

      return const ErrorModel(
        error: 'Bad request',
        data: null,
      );
    } catch (e) {
      return const ErrorModel(
        data: null,
        error: AppText.unauthorized,
      );
    }
  }

  /// A function to update the user pricing
  Future<ErrorModel> updateUserPricing({required String pricingId}) async {
    ErrorModel errorModel = const ErrorModel(data: null);

    try {
      final String? token = await _localStorageRepository.getToken();

      if (token != null) {
        final Response<dynamic> res = await _dioClient.put(
          '/user/pricing',
          data: <String, dynamic>{
            'pricingId': pricingId,
          },
          options: Options(
            headers: <String, dynamic>{
              'x-auth-token': token,
            },
          ),
        );

        errorModel = ErrorModel(
          data: UserModel.fromJson(
            res.data['user'],
          ).copyWith(token: token),
        );
        return errorModel;
      }

      return const ErrorModel(
        error: 'Bad request',
        data: null,
      );
    } catch (e) {
      return const ErrorModel(
        data: null,
        error: AppText.unauthorized,
      );
    }
  }
}
