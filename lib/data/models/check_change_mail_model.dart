class EmailReview {
  int? idx;
  String? email;
  int? mailChangeFlg;
  EmailReview({
    this.idx,
    this.email,
    this.mailChangeFlg,
  });
  EmailReview.fromJson(Map<String, dynamic> json) {
    idx                  = json['idx'] ?? 0;
    email                = json['email']  ?? "null";
    mailChangeFlg        = json['mailchange_flg']  ?? 0;
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['idx']                  = idx;
    data['email']                = email;
    data['mailchange_flg']       = mailChangeFlg;
    return data;
  }
}