
import '../api_endpoint.dart';
import '../api_provider.dart';
import '../api_request_representable.dart';

enum ArticleType { fetchHome, fetchCate}

class CategoryRemoteAPI implements APIRequestRepresentable {
  final ArticleType type;
  final String userId;
  String? cateId;

  CategoryRemoteAPI._({required this.type, required this.userId, this.cateId});
  CategoryRemoteAPI.fetchBookInHome(String userId): this._(type: ArticleType.fetchHome, userId: userId);
  CategoryRemoteAPI.fetchBookInCate(String userId): this._(type: ArticleType.fetchCate, userId: userId);


  @override
  String get endpoint => APIEndpoint.wiseBookApi;

  @override
  String get path {
    switch (type) {
      case ArticleType.fetchHome:
        return "/listBookByCategory.json";
      case ArticleType.fetchCate:
        return "/top-headlines";
    }
  }

  @override
  HTTPMethod get method {
    return HTTPMethod.get;
  }

  @override
  Map<String, String> get headers => {'X-Wisebook-Authorization': '1ijxlnyrgbyfdldqztwoj093p4u8vqpxcefkhgs2i6humzcsnkm5araewtb7vo_HEUNuMyWVlmq6keYZ8iBsovLTbDO1nPJGXI2F45wd7j0rRC93fptzhKgxaAQSc'};

  @override
  Map<String, String> get query {
    switch (type) {
      case ArticleType.fetchHome:
        return {"idx": userId};
      case ArticleType.fetchCate:
        return {"idx": userId};
    }
  }

  @override
  get body => null;

  @override
  Future request() {
    return APIProvider.instance.request(this);
  }

  @override
  String get url => endpoint + path;
}
