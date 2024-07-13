import 'package:dio/dio.dart';
import 'package:docs_ai/models/document_model.dart';
import 'package:docs_ai/models/error_model.dart';
import 'package:docs_ai/utils/constant.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Allow to store the documentRepository inside the provider and access them globaly
final Provider<DocumentRepository> documentRepositoryProvider =
    Provider<DocumentRepository>(
  (ProviderRef<Object?> ref) => DocumentRepository(
    dioClient: dioClient,
  ),
);

/// Represents the document service and contains all the functions needed to interact with a document
class DocumentRepository {
  /// Creates a [DocumentRepository] instance
  const DocumentRepository({
    required Dio dioClient,
  }) : _dioClient = dioClient;

  final Dio _dioClient;

  /// A function used to create an empty document
  Future<ErrorModel> createDocument(String token) async {
    try {
      final Response<dynamic> result = await _dioClient.post(
        '/doc/create',
        data: <String, int>{
          'createdAt': DateTime.now().millisecondsSinceEpoch,
        },
        options: Options(
          headers: <String, dynamic>{
            'x-auth-token': token,
          },
        ),
      );
      if (result.statusCode == 201) {
        return ErrorModel(
          data: DocumentModel.fromJson(
            result.data['document'] as Map<String, dynamic>,
          ),
        );
      }

      return ErrorModel(data: null, error: result.statusMessage);
    } on DioException catch (e) {
      return ErrorModel(
        data: null,
        error: e.message,
      );
    }
  }

  /// A function used to retrieve the documents created by the connected user
  Future<ErrorModel> meDocument(String token) async {
    try {
      final Response<dynamic> result = await _dioClient.get(
        '/doc/me',
        options: Options(
          headers: <String, dynamic>{
            'x-auth-token': token,
          },
        ),
      );
      if (result.statusCode == 200 && result.data['documents'] != null) {
        return ErrorModel(
          data: (result.data['documents'] as List<dynamic>)
              .map<DocumentModel>(
                (dynamic document) => DocumentModel.fromJson(
                  document as Map<String, dynamic>,
                ),
              )
              .toList(),
        );
      }

      return ErrorModel(data: null, error: result.data['message']);
    } on DioException catch (e) {
      return ErrorModel(
        data: null,
        error: e.message,
      );
    }
  }

  /// A function used to update the title of a document
  Future<ErrorModel> updateTitleDocument({
    required String docId,
    required String token,
    required String newTitle,
  }) async {
    try {
      final Response<dynamic> result = await _dioClient.put(
        '/doc/title',
        data: <String, String>{
          'id': docId,
          'title': newTitle,
        },
        options: Options(
          headers: <String, dynamic>{
            'x-auth-token': token,
          },
        ),
      );
      if (result.statusCode == 200 && result.data['document'] != null) {
        return ErrorModel(
          data: DocumentModel.fromJson(
            result.data['document'],
          ),
        );
      }

      return ErrorModel(data: null, error: result.data['message']);
    } on DioException catch (e) {
      return ErrorModel(
        data: null,
        error: e.message,
      );
    }
  }

  /// A function used to update the content of a document
  Future<ErrorModel> updateContentDocument({
    required String docId,
    required String token,
    required List<dynamic> content,
  }) async {
    try {
      final Response<dynamic> result = await _dioClient.put(
        '/doc/content',
        data: <String, dynamic>{
          'id': docId,
          'content': content,
        },
        options: Options(
          headers: <String, dynamic>{
            'x-auth-token': token,
          },
        ),
      );
      if (result.statusCode == 200 && result.data['document'] != null) {
        return ErrorModel(
          data: DocumentModel.fromJson(
            result.data['document'],
          ),
        );
      }

      return ErrorModel(data: null, error: result.data['message']);
    } on DioException catch (e) {
      return ErrorModel(
        data: null,
        error: e.message,
      );
    }
  }

  /// A function to get a document by his id
  Future<ErrorModel> getDocumentById({
    required String docId,
    required String token,
  }) async {
    try {
      final Response<dynamic> result = await _dioClient.get(
        '/doc/$docId',
        options: Options(
          headers: <String, dynamic>{
            'x-auth-token': token,
          },
        ),
      );

      if (result.statusCode == 200 && result.data['document'] != null) {
        return ErrorModel(
          data: DocumentModel.fromJson(
            result.data['document'],
          ),
        );
      }

      return ErrorModel(data: null, error: result.data['message']);
    } on DioException catch (e) {
      return ErrorModel(
        data: null,
        error: e.message,
      );
    }
  }
}
