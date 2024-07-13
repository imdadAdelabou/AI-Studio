import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Allow us to access the localStorageRepository globally via the provider
final Provider<LocalStorageRepository> localStorageRepositoryProvider =
    Provider<LocalStorageRepository>(
  (ProviderRef<Object?> ref) => LocalStorageRepository(),
);

/// Reprensents the localStorage repository
/// of service and contains all the function needed to interact with the local storage of the device
class LocalStorageRepository {
  /// A function used to store the token of user connected inside the local storage
  Future<void> setToken({required String token}) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    await sharedPreferences.setString('x-auth-token', token);
  }

  /// A function used to get the token of the connected user
  Future<String?> getToken() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    return sharedPreferences.getString('x-auth-token');
  }

  /// A function used to remove the token of the connected user
  Future<bool> removeToken() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    return sharedPreferences.remove('x-auth-token');
  }
}
