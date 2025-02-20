import 'package:fluent_ui/fluent_ui.dart';
import '../../app/config/page.dart';
import 'bodyTexView.dart';

class PolicyView extends StatefulWidget {
  const PolicyView({super.key});

  @override
  State<PolicyView> createState() => _PolicyViewState();
}
class _PolicyViewState extends State<PolicyView> with PageMixin {

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasFluentTheme(context));
    return ScaffoldPage.scrollable(
      header: const PageHeader(
        title: Text('プライバシーポリシー'),
      ),
      children: [
        SingleChildScrollView(
          child: Container(
            margin : const EdgeInsets.only( left: 12,top: 12,right: 12,bottom: 0),
            padding: const EdgeInsets.only( left: 12,top: 12,right: 12,bottom: 0),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children:  [
                BodyTextView(txtText: "株式会社ウイネット（以下「当社」といいます。）は、個人を識別しうる情報（以下「個人情報」といいます。）の重要性に鑑み、個人情報の安全管理を社会的責任と認識し、ここに個人情報保護方針を定め、役員及び全従業員に周知徹底し、個人情報の確実な履行に努めます。", type: TextAlign.justify, scale: 1.0,),
                BodyStrongTextView(txtText: "■ 適正な個人情報の収集・利用・提供", type: TextAlign.justify, scale: 1.0,),
                BodyTextView(txtText: "当社は、個人情報の収集に際して、下記「個人情報の取扱い」に基づき利用目的を明確に定め、適法かつ公正な手段により行います。収集した個人情報は、あらかじめお客様等の同意がある場合や法令の規定等がある場合を除き、その利用目的以外の利用や第三者への提供を行いません。", type: TextAlign.justify, scale: 1.0,),
                BodyStrongTextView(txtText: "■ 安全対策の実施", type: TextAlign.justify, scale: 1.0,),
                BodyTextView(txtText: "当社は、個人情報の正確性及び安全性を確保するため、管理体制を確立するとともに適切な安全対策を実施し、個人情報への不正アクセス、個人情報の紛失、破壊、改ざん及び漏えい等の予防並びに是正に努めます。", type: TextAlign.justify, scale: 1.0,),
                BodyStrongTextView(txtText: "■ 個人の権利尊重", type: TextAlign.justify, scale: 1.0,),
                BodyTextView(txtText: "当社は個人の権利を尊重し、当社が保有する個人情報に関して、個人から情報の開示、訂正、利用停止等を求められた場合、関連する法令や社会通念等に照らし適切に対応します。", type: TextAlign.justify, scale: 1.0,),
                BodyStrongTextView(txtText: "■ 法令・規範の遵守", type: TextAlign.justify, scale: 1.0,),
                BodyTextView(txtText: "当社は、個人情報の取扱いにおいて個人情報の保護に適用される法令及びその他の規範を遵守します。", type: TextAlign.justify, scale: 1.0,),
                BodyStrongTextView(txtText: "■ 個人情報の取扱い", type: TextAlign.justify, scale: 1.0,),
                BodyTextView(txtText: "＜個人情報の収集目的と収集内容＞", type: TextAlign.justify, scale: 1.0,),
                BodyTextView(txtText: "当社は商品のお届けやサービス ・情報の提供、確認、ご請求等の為に氏名・郵便番号・住所・電話番号・Eメールアドレスを収集しています。", type: TextAlign.justify, scale: 1.0,),
                BodyTextView(txtText: "・ご注文いただいた商品・資料等のお届けのため（配送を委託しております業者から連絡がある場合も含みます）\n・当社取扱商品や各種サービスに関するご案内、返品・交換等のサービスの遂行のため\n・その他、当社および関連会社より新商品や各種サービス\n・情報（カタログやDM等）の提供、アンケートのお願い、お客様に連絡をとる場合が生じた時等のため", type: TextAlign.justify, scale: 1.0,),
                BodyStrongTextView(txtText: "■ Cookieについて", type: TextAlign.justify, scale: 1.0,),
                BodyTextView(txtText: "当社では、本サイトの各種サービスを快適にご利用いただくため、Cookieを使用しています。", type: TextAlign.justify, scale: 1.0,),
                Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BodyStrongTextView(txtText: "1. Cookieとは？", type: TextAlign.justify, scale: 1.0,),
                      BodyTextView(txtText: "Cookieとは、ウェブページを利用したときに、ブラウザとサーバーとの間で送受信した利用履歴や入力内容などを、お客様のコンピュータにファイルとして保存しておく仕組みです。", type: TextAlign.justify, scale: 1.0,),
                      BodyTextView(txtText: "次回、同じページにアクセスすると、Cookieの情報を使って、ページの運営者はお客様ごとに表示を変えたりすることができます。", type: TextAlign.justify, scale: 1.0,),
                      BodyTextView(txtText: "お客様がブラウザの設定でCookieの送受信を許可している場合、ウェブサイトは、お客様のブラウザからCookieを取得できます。なお、Cookieとして送るファイルには、個人を特定するような情報は含んでいません。", type: TextAlign.justify, scale: 1.0,),
                      BodyStrongTextView(txtText: "２．Cookieの設定について", type: TextAlign.justify, scale: 1.0,),
                      BodyTextView(txtText: "お客様は、Cookieの送受信に関する設定を「すべてのCookieを許可する」、「すべてのCookieを拒否する」、「Cookieを受信したらユーザーに通知する」などから選択できます。設定方法は、ブラウザにより異なります。", type: TextAlign.justify, scale: 1.0,),
                      BodyTextView(txtText: "Cookieに関する設定方法は、お使いのブラウザの「ヘルプ」メニューでご確認ください。なお、すべてのCookieを拒否する設定を選択されますと、各種サービスの利用上、制約を受ける場合がありますのでご注意ください。", type: TextAlign.justify, scale: 1.0,),
                      BodyStrongTextView(txtText: "３．Cookieを使用して行っていること", type: TextAlign.justify, scale: 1.0,),
                      BodyTextView(txtText: "以下の目的のため、当社はCookieを利用しています。", type: TextAlign.justify, scale: 1.0,),
                      BodyTextView(txtText: "・お客様が認証サービスにログインされるとき、保存されているお客様の登録情報を参照して、お客様ごとにカスタマイズされたサービスを提供できるようにするため。\n・当社サイトの利用者数やトラフィックを調査し、当社サービスを改善するため。", type: TextAlign.justify, scale: 1.0,),

                    ],
                  ),

                )
              ],
            ),
          ),
        )
      ],
    );
  }
}

