import 'package:docs_ai/models/pricing.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

/// Represents the user data
@JsonSerializable()
class UserModel {
  /// Creates [UserModel] instance
  const UserModel({
    required this.email,
    required this.name,
    required this.photoUrl,
    required this.token,
    required this.id,
    required this.provider,
    required this.pricing,
    this.isNewUser,
  });

  /// A function to convert a JSON to a UserModel instance
  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  /// The unique id of a user
  final String id;

  /// The token used to grant access to a certain features to a user
  final String token;

  /// Contains the email of a user
  final String email;

  /// Contains the name of a user
  final String name;

  /// Contains the profile picture of a user
  final String photoUrl;

  /// To know if the current user is a new user or not
  final bool? isNewUser;

  /// The provider used to sign-in the user
  final String provider;

  /// The current pricing plan of the user
  final Pricing? pricing;

  /// A function that returns a JSON representation of the UserModel instance
  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  /// A function to get the pricing plan of the user
  Pricing get getPricing => pricing!;

  /// A function to change the pricing plan of the user
  UserModel changePricing(Pricing newPricing) {
    return copyWith(pricing: newPricing);
  }

  /// A function to make a copy of the UserModel instance
  UserModel copyWith({
    String? email,
    String? name,
    String? photoUrl,
    String? token,
    String? id,
    bool? isNewUser,
    String? provider,
    Pricing? pricing,
  }) =>
      UserModel(
        email: email ?? this.email,
        name: name ?? this.name,
        photoUrl: photoUrl ?? this.photoUrl,
        token: token ?? this.token,
        id: id ?? this.id,
        isNewUser: isNewUser ?? this.isNewUser,
        provider: provider ?? this.provider,
        pricing: pricing ?? this.pricing,
      );
}
