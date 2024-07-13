import 'package:dio/dio.dart';
import 'package:docs_ai/models/pricing.dart';
import 'package:flutter/material.dart';

/// Represents the type of a text form field
enum TextFormFieldType {
  /// Represents a text form field
  text,

  /// Represents a password form field
  password
}

/// Contains the base url of the api
const String baseApiUrl = 'https://docsai-0273dc8c6d35.herokuapp.com';

/// Contains the stripe publishable key
const String kStripePublishableKey =
    'pk_test_51PEQdbDJoBHbjuPPfWql8aNb2akhFc1k47vM828GUntan5l6dpLrjZakLpVIZnK4nGq1ufeHwPbYzVM6pA1dKS6C00jBSlKAox';

/// Contains the base url of the api
const String apiHost = '$baseApiUrl/api';

// 172.20.10.2
// 192.168.1.23:3001

/// Contains the base url of the api
const String apiHostWs = baseApiUrl;

// 10.10.170.219

/// Represents the states of the a view (app screen)
enum ViewState {
  /// Idle, the widget is a rest state
  idle,

  /// The widget is doing some task
  busy,

  /// The widget is handled an error
  error,

  /// The widget finish a task and retrieved a data
  retrieved,
}

/// An instance of Dio service to communicate with an API
final Dio dioClient = Dio(
  BaseOptions(
    baseUrl: apiHost,
    headers: <String, dynamic>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  ),
);

/// A list of test pricing for the application
const List<Pricing> pricingTest = <Pricing>[
  Pricing(
    id: '0',
    labelColor: Colors.red,
    label: 'Basic',
    price: 0,
    currency: 'USD',
    description:
        'This is a basic plan. You will have access to all the platform features but only for 03 days.',
    advantages: <String>[
      'Access to all features',
      'Access to all AI models',
      '03 days trial',
      r'10$/month after trial',
    ],
  ),
  Pricing(
    id: '1',
    labelColor: Colors.green,
    label: 'Pro',
    price: 10,
    currency: 'USD',
    description:
        'This is a pro plan. You will have access to all the platform features for unlimited time.',
    advantages: <String>[
      'Access to all features',
      'Access to all AI models',
      'Unlimited access',
      r'03 months free and then 10$/month',
    ],
  ),
];
