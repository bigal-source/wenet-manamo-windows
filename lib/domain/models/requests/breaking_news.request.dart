

import '../../../app/utils/constants/nums.dart';

class BreakingNewsRequest {
  final String apiKey;
  final String sources;
  final int page;
  final int pageSize;

  BreakingNewsRequest({
    this.apiKey = "",
    this.sources = 'bbc-news, abc-news',
    this.page = 1,
    this.pageSize = defaultPageSize,
  });
}
