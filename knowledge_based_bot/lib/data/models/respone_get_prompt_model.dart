import 'dart:convert';

class ApidogModel {
    final bool hasNext;
    final List<Item> items;
    final int limit;
    final int offset;
    final int total;

    ApidogModel({
        required this.hasNext,
        required this.items,
        required this.limit,
        required this.offset,
        required this.total,
    });

    ApidogModel copyWith({
        bool? hasNext,
        List<Item>? items,
        int? limit,
        int? offset,
        int? total,
    }) => 
        ApidogModel(
            hasNext: hasNext ?? this.hasNext,
            items: items ?? this.items,
            limit: limit ?? this.limit,
            offset: offset ?? this.offset,
            total: total ?? this.total,
        );

    factory ApidogModel.fromRawJson(String str) => ApidogModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory ApidogModel.fromJson(Map<String, dynamic> json) => ApidogModel(
        hasNext: json["hasNext"],
        items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
        limit: json["limit"],
        offset: json["offset"],
        total: json["total"],
    );

    Map<String, dynamic> toJson() => {
        "hasNext": hasNext,
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
        "limit": limit,
        "offset": offset,
        "total": total,
    };
}

class Item {
    final String? id;
    final String? category;
    final String? content;
    final String? createdAt;
    final String? description;
    final bool? isFavorite;
    final bool? isPublic;
    final String? language;
    final String? title;
    final String? updatedAt;
    final String? userId;
    final String? userName;

    Item({
        required this.id,
        required this.category,
        required this.content,
        required this.createdAt,
        required this.description,
        required this.isFavorite,
        required this.isPublic,
        required this.language,
        required this.title,
        required this.updatedAt,
        required this.userId,
        required this.userName,
    });

    Item copyWith({
        String? id,
        String? category,
        String? content,
        String? createdAt,
        String? description,
        bool? isFavorite,
        bool? isPublic,
        String? language,
        String? title,
        String? updatedAt,
        String? userId,
        String? userName,
    }) => 
        Item(
            id: id ?? this.id,
            category: category ?? this.category,
            content: content ?? this.content,
            createdAt: createdAt ?? this.createdAt,
            description: description ?? this.description,
            isFavorite: isFavorite ?? this.isFavorite,
            isPublic: isPublic ?? this.isPublic,
            language: language ?? this.language,
            title: title ?? this.title,
            updatedAt: updatedAt ?? this.updatedAt,
            userId: userId ?? this.userId,
            userName: userName ?? this.userName,
        );

    factory Item.fromRawJson(String str) => Item.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Item.fromJson(Map<String, dynamic> json) => Item(
        id: json["_id"],
        category: json["category"],
        content: json["content"],
        createdAt: json["createdAt"],
        description: json["description"],
        isFavorite: json["isFavorite"],
        isPublic: json["isPublic"],
        language: json["language"],
        title: json["title"],
        updatedAt: json["updatedAt"],
        userId: json["userId"],
        userName: json["userName"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "category": category,
        "content": content,
        "createdAt": createdAt,
        "description": description,
        "isFavorite": isFavorite,
        "isPublic": isPublic,
        "language": language,
        "title": title,
        "updatedAt": updatedAt,
        "userId": userId,
        "userName": userName,
    };
}