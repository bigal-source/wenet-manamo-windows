import '../../providers/network/api_endpoint.dart';
import '../../providers/network/api_provider.dart';
import '../../providers/network/api_request_representable.dart';


enum BookType { fetchHeadline, fetchNews, saveBook }

class BookAPI implements APIRequestRepresentable {
  final BookType type;
  String? keyword;
  int? page;
  int? pageSize;

  BookAPI._({required this.type, this.keyword, this.page, this.pageSize});
  BookAPI.fetchHeadline(int page, int pageSize): this._(type: BookType.fetchHeadline, page: page, pageSize: pageSize);
  BookAPI.fetchNews(String keyword, int page, int pageSize): this._(type: BookType.fetchNews,keyword: keyword,page: page,pageSize: pageSize);
  BookAPI.bookDetail(String keyword): this._(type: BookType.saveBook);

  @override
  String get endpoint => APIEndpoint.bookApi;

  @override
  String get path {
    switch (type) {
      case BookType.fetchNews:
        return "/top-headlines";
      case BookType.fetchHeadline:
        return "/top-headlines";
      case BookType.saveBook:
        return "/saveBookDetail";
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
      case BookType.fetchHeadline:
        return {"country": "us", "page": "$page", "pageSize": "$pageSize"};
      case BookType.fetchNews:
        return {"page": "$page", "pageSize": "$pageSize", "q": keyword ?? ""};
      case BookType.saveBook:
        return {"page": "$page", "pageSize": "$pageSize", "q": keyword ?? ""};
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
