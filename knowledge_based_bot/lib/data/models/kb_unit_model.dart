
///PageDto
class ApidogModel {
    List<KnowledgeUnitsResDto> data;
    PageMetaDto meta;

    ApidogModel({
        required this.data,
        required this.meta,
    });

    ApidogModel copyWith({
        List<KnowledgeUnitsResDto>? data,
        PageMetaDto? meta,
    }) => 
        ApidogModel(
            data: data ?? this.data,
            meta: meta ?? this.meta,
        );
}


///KnowledgeUnitsResDto
class KnowledgeUnitsResDto {
  DateTime createdAt;
  String? createdBy;
  String id;
  String knowledgeId;
  String name;
  String type;
  int size;
  bool status;
  DateTime? updatedAt;
  String? updatedBy;
  DateTime? deletedAt;
  String userId;
  List<String> openAiFileIds;

  KnowledgeUnitsResDto({
    required this.createdAt,
    this.createdBy,
    required this.id,
    required this.knowledgeId,
    required this.name,
    required this.type,
    required this.size,
    required this.status,
    this.updatedAt,
    this.updatedBy,
    this.deletedAt,
    required this.userId,
    required this.openAiFileIds,
  });

  KnowledgeUnitsResDto copyWith({
    DateTime? createdAt,
    String? createdBy,
    String? id,
    String? knowledgeId,
    String? name,
    String? type,
    int? size,
    bool? status,
    DateTime? updatedAt,
    String? updatedBy,
    DateTime? deletedAt,
    String? userId,
    List<String>? openAiFileIds,
  }) =>
      KnowledgeUnitsResDto(
        createdAt: createdAt ?? this.createdAt,
        createdBy: createdBy ?? this.createdBy,
        id: id ?? this.id,
        knowledgeId: knowledgeId ?? this.knowledgeId,
        name: name ?? this.name,
        type: type ?? this.type,
        size: size ?? this.size,
        status: status ?? this.status,
        updatedAt: updatedAt ?? this.updatedAt,
        updatedBy: updatedBy ?? this.updatedBy,
        deletedAt: deletedAt ?? this.deletedAt,
        userId: userId ?? this.userId,
        openAiFileIds: openAiFileIds ?? this.openAiFileIds,
      );

  factory KnowledgeUnitsResDto.fromMap(Map<String, dynamic> map) {
    return KnowledgeUnitsResDto(
      createdAt: DateTime.parse(map['createdAt']),
      createdBy: map['createdBy'],
      id: map['id'],
      knowledgeId: map['knowledgeId'],
      name: map['name'],
      type: map['type'],
      size: map['size'],
      status: map['status'],
      updatedAt: map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : null,
      updatedBy: map['updatedBy'],
      deletedAt: map['deletedAt'] != null ? DateTime.parse(map['deletedAt']) : null,
      userId: map['userId'],
      openAiFileIds: List<String>.from(map['openAiFileIds']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'createdAt': createdAt.toIso8601String(),
      'createdBy': createdBy,
      'id': id,
      'knowledgeId': knowledgeId,
      'name': name,
      'type': type,
      'size': size,
      'status': status,
      'updatedAt': updatedAt?.toIso8601String(),
      'updatedBy': updatedBy,
      'deletedAt': deletedAt?.toIso8601String(),
      'userId': userId,
      'openAiFileIds': openAiFileIds,
    };
  }
}


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