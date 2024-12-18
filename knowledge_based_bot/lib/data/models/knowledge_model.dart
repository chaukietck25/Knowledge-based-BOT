
///PageDto
class ApidogModel {
  List<KnowledgeResDto> data;
  PageMetaDto meta;

  ApidogModel({
    required this.data,
    required this.meta,
  });

  ApidogModel copyWith({
    List<KnowledgeResDto>? data,
    PageMetaDto? meta,
  }) =>
      ApidogModel(
        data: data ?? this.data,
        meta: meta ?? this.meta,
      );

      
}

class KnowledgeResDto {
  DateTime createdAt;
  String? createdBy;
  String description;
  String knowledgeName;
  DateTime? updatedAt;
  String? updatedBy;
  DateTime? deletedAt;
  String id;
  String userId;
  int numUnits;
  int totalSize;

  KnowledgeResDto({
    required this.createdAt,
    this.createdBy,
    required this.description,
    required this.knowledgeName,
    this.updatedAt,
    this.updatedBy,
    this.deletedAt,
    required this.id,
    required this.userId,
    required this.numUnits,
    required this.totalSize,
  });

  KnowledgeResDto copyWith({
    DateTime? createdAt,
    String? createdBy,
    String? description,
    String? knowledgeName,
    DateTime? updatedAt,
    String? updatedBy,
    DateTime? deletedAt,
    String? id,
    String? userId,
    int? numUnits,
    int? totalSize,
  }) =>
      KnowledgeResDto(
        createdAt: createdAt ?? this.createdAt,
        createdBy: createdBy ?? this.createdBy,
        description: description ?? this.description,
        knowledgeName: knowledgeName ?? this.knowledgeName,
        updatedAt: updatedAt ?? this.updatedAt,
        updatedBy: updatedBy ?? this.updatedBy,
        deletedAt: deletedAt ?? this.deletedAt,
        id: id ?? this.id,
        userId: userId ?? this.userId,
        numUnits: numUnits ?? this.numUnits,
        totalSize: totalSize ?? this.totalSize,
      );

  factory KnowledgeResDto.fromMap(Map<String, dynamic> map) {
    return KnowledgeResDto(
      createdAt: DateTime.parse(map['createdAt']),
      createdBy: map['createdBy'],
      description: map['description'],
      knowledgeName: map['knowledgeName'],
      updatedAt: map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : null,
      updatedBy: map['updatedBy'],
      deletedAt: map['deletedAt'] != null ? DateTime.parse(map['deletedAt']) : null,
      id: map['id'],
      userId: map['userId'],
      numUnits: map['numUnits'],
      totalSize: map['totalSize'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'createdAt': createdAt.toIso8601String(),
      'createdBy': createdBy,
      'description': description,
      'knowledgeName': knowledgeName,
      'updatedAt': updatedAt?.toIso8601String(),
      'updatedBy': updatedBy,
      'deletedAt': deletedAt?.toIso8601String(),
      'id': id,
      'userId': userId,
      'numUnits': numUnits,
      'totalSize': totalSize,
    };
  }

  factory KnowledgeResDto.fromJson(Map<String, dynamic> json) => KnowledgeResDto(
        createdAt: DateTime.parse(json["createdAt"]),
        createdBy: json["createdBy"],
        description: json["description"],
        knowledgeName: json["knowledgeName"],
        updatedAt: json["updatedAt"] != null ? DateTime.parse(json["updatedAt"]) : null,
        updatedBy: json["updatedBy"],
        deletedAt: json["deletedAt"] != null ? DateTime.parse(json["deletedAt"]) : null,
        id: json["id"],
        userId: json["userId"],
        numUnits: json["numUnits"],
        totalSize: json["totalSize"],
      );

  Map<String, dynamic> toJson() {
    return {
      'createdAt': createdAt.toIso8601String(),
      'createdBy': createdBy,
      'description': description,
      'knowledgeName': knowledgeName,
      'updatedAt': updatedAt?.toIso8601String(),
      'updatedBy': updatedBy,
      'deletedAt': deletedAt?.toIso8601String(),
      'id': id,
      'userId': userId,
      'numUnits': numUnits,
      'totalSize': totalSize,
    };
  }
}
///KnowledgeResDto
// class KnowledgeResDto {
//   DateTime createdAt;
//   String? createdBy;
//   String description;
//   String knowledgeName;
//   DateTime? updatedAt;
//   String? updatedBy;
//   String userId;

//   KnowledgeResDto({
//     required this.createdAt,
//     this.createdBy,
//     required this.description,
//     required this.knowledgeName,
//     this.updatedAt,
//     this.updatedBy,
//     required this.userId,
//   });

//   KnowledgeResDto copyWith({
//     DateTime? createdAt,
//     String? createdBy,
//     String? description,
//     String? knowledgeName,
//     DateTime? updatedAt,
//     String? updatedBy,
//     String? userId,
//   }) =>
//       KnowledgeResDto(
//         createdAt: createdAt ?? this.createdAt,
//         createdBy: createdBy ?? this.createdBy,
//         description: description ?? this.description,
//         knowledgeName: knowledgeName ?? this.knowledgeName,
//         updatedAt: updatedAt ?? this.updatedAt,
//         updatedBy: updatedBy ?? this.updatedBy,
//         userId: userId ?? this.userId,
//       );
//   factory KnowledgeResDto.fromMap(Map<String, dynamic> map) {
//     return KnowledgeResDto(
//       createdAt: DateTime.parse(map['createdAt']),
//       createdBy: map['createdBy'],
//       description: map['description'],
//       knowledgeName: map['knowledgeName'],
//       updatedAt:
//           map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : null,
//       updatedBy: map['updatedBy'],
//       userId: map['userId'],
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return {
//       'createdAt': createdAt.toIso8601String(),
//       'createdBy': createdBy,
//       'description': description,
//       'knowledgeName': knowledgeName,
//       'updatedAt': updatedAt?.toIso8601String(),
//       'updatedBy': updatedBy,
//       'userId': userId,
//     };
//   }

//   factory KnowledgeResDto.fromJson(Map<String, dynamic> json) => KnowledgeResDto(
//         createdAt: DateTime.parse(json["createdAt"]),
//         createdBy: json["createdBy"],
//         description: json["description"],
//         knowledgeName: json["knowledgeName"],
//         updatedAt: json["updatedAt"] != null ? DateTime.parse(json["updatedAt"]) : null,
//         updatedBy: json["updatedBy"],
//         userId: json["userId"],
//       );
// }

///PageMetaDto
class PageMetaDto {
  bool hasNext;
  double limit;
  double offset;
  double total;

  PageMetaDto({
    required this.hasNext,
    required this.limit,
    required this.offset,
    required this.total,
  });

  PageMetaDto copyWith({
    bool? hasNext,
    double? limit,
    double? offset,
    double? total,
  }) =>
      PageMetaDto(
        hasNext: hasNext ?? this.hasNext,
        limit: limit ?? this.limit,
        offset: offset ?? this.offset,
        total: total ?? this.total,
      );
}
