import 'dart:typed_data';

/// Represents the Document enity
class DocumentModel {
  /// Creates a [DocumentModel] instance
  const DocumentModel({
    required this.id,
    required this.uid,
    required this.createdAt,
    required this.title,
    required this.content,
    required this.image,
  });

  /// A function to convert a json to a instance of DocumentModel
  factory DocumentModel.fromJson(Map<String, dynamic> json) => DocumentModel(
        id: json['_id'],
        uid: json['uid'],
        createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt']),
        title: json['title'],
        content: List<dynamic>.from(
          json['content'],
        ),
        image: json['image'],
      );

  /// A function to copy a DocumentModel instance
  DocumentModel copyWith({
    String? id,
    String? uid,
    DateTime? createdAt,
    String? title,
    List<dynamic>? content,
    Uint8List? image,
  }) {
    return DocumentModel(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      createdAt: createdAt ?? this.createdAt,
      title: title ?? this.title,
      content: content ?? this.content,
      image: image ?? this.image,
    );
  }

  /// The unique id of a document
  final String id;

  /// The id of the user that create this document
  final String uid;

  /// The creation date of a document
  final DateTime createdAt;

  /// The title of a document
  final String title;

  /// The contents of a document
  final List<dynamic> content;

  /// A captured image of the document in a DocumentCard widget
  final Uint8List? image;

  /// To create a JSON representation of a DocumentModel instance
  Map<String, dynamic> toJson() => <String, dynamic>{
        'title': title,
        'content': content,
        'createdAt': DateTime.now().millisecondsSinceEpoch,
      };
}
