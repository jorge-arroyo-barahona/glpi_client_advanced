import 'package:json_annotation/json_annotation.dart';

part 'response_model.g.dart';

@JsonSerializable()
class ApiResponseModel {
  final bool success;
  final String? message;
  final dynamic data;
  final int? code;
  final Map<String, dynamic>? metadata;

  const ApiResponseModel({
    required this.success,
    this.message,
    this.data,
    this.code,
    this.metadata,
  });

  factory ApiResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ApiResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ApiResponseModelToJson(this);

  factory ApiResponseModel.success({
    dynamic data,
    String? message,
    Map<String, dynamic>? metadata,
  }) => ApiResponseModel(
    success: true,
    data: data,
    message: message ?? 'Operation completed successfully',
    metadata: metadata,
  );

  factory ApiResponseModel.error({
    required String message,
    int? code,
    dynamic data,
  }) => ApiResponseModel(
    success: false,
    message: message,
    code: code,
    data: data,
  );
}

@JsonSerializable()
class SearchResponseModel {
  final int totalcount;
  final int count;
  final int start;
  final List<dynamic> data;
  final String? order;
  final String? sort;
  final Map<String, dynamic>? criteria;

  const SearchResponseModel({
    required this.totalcount,
    required this.count,
    required this.start,
    required this.data,
    this.order,
    this.sort,
    this.criteria,
  });

  factory SearchResponseModel.fromJson(Map<String, dynamic> json) =>
      _$SearchResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$SearchResponseModelToJson(this);

  bool get hasMore => (start + count) < totalcount;
  int get nextOffset => start + count;
}

@JsonSerializable()
class PaginationModel {
  final int total;
  final int count;
  final int perPage;
  final int currentPage;
  final int totalPages;
  final Map<String, dynamic>? links;

  const PaginationModel({
    required this.total,
    required this.count,
    required this.perPage,
    required this.currentPage,
    required this.totalPages,
    this.links,
  });

  factory PaginationModel.fromJson(Map<String, dynamic> json) =>
      _$PaginationModelFromJson(json);

  Map<String, dynamic> toJson() => _$PaginationModelToJson(this);

  bool get hasNextPage => currentPage < totalPages;
  bool get hasPreviousPage => currentPage > 1;
  int get nextPage => currentPage + 1;
  int get previousPage => currentPage - 1;
}