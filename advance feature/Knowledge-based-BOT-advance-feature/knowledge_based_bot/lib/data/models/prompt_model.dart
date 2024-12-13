// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class Prompt extends Equatable {
  final String id;
  final String createdAt;
  final String updatedAt;
  final String category;
  final String content;
  final String description;
  final bool isPublic;
  final String language;
  final String title;
  final String userId;
  final String userName;
  final bool isFavorite;

  const Prompt({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.category,
    required this.content,
    required this.description,
    required this.isPublic,
    required this.language,
    required this.title,
    required this.userId,
    required this.userName,
    required this.isFavorite,
  });

  @override
  List<Object> get props {
    return [
      id,
      createdAt,
      updatedAt,
      category,
      content,
      description,
      isPublic,
      language,
      title,
      userId,
      userName,
      isFavorite,
    ];
  }


  // @override
  // List<Object> get props => [];
  

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'category': category,
      'content': content,
      'description': description,
      'isPublic': isPublic,
      'language': language,
      'title': title,
      'userId': userId,
      'userName': userName,
      'isFavorite': isFavorite,
    };
  }

  factory Prompt.fromMap(Map<String, dynamic> map) {
    return Prompt(
      id: map['id'] as String,
      createdAt: map['createdAt'] as String,
      updatedAt: map['updatedAt'] as String,
      category: map['category'] as String,
      content: map['content'] as String,
      description: map['description'] as String,
      isPublic: map['isPublic'] as bool,
      language: map['language'] as String,
      title: map['title'] as String,
      userId: map['userId'] as String,
      userName: map['userName'] as String,
      isFavorite: map['isFavorite'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory Prompt.fromJson(String source) => Prompt.fromMap(json.decode(source) as Map<String, dynamic>);

  Prompt copyWith({
    String? id,
    String? createdAt,
    String? updatedAt,
    String? category,
    String? content,
    String? description,
    bool? isPublic,
    String? language,
    String? title,
    String? userId,
    String? userName,
    bool? isFavorite,
  }) {
    return Prompt(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      category: category ?? this.category,
      content: content ?? this.content,
      description: description ?? this.description,
      isPublic: isPublic ?? this.isPublic,
      language: language ?? this.language,
      title: title ?? this.title,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  bool get stringify => true;
}
