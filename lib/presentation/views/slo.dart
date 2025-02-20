import 'package:fluent_ui/fluent_ui.dart';
class SloView extends StatelessWidget {
  const SloView({super.key});

  @override
  Widget build(BuildContext context) {
    Typography typography = FluentTheme.of(context).typography;
    double scale          = 1.0;
    return ScaffoldPage.scrollable(
      header: const PageHeader(
        title: Text('SLOガイドライン'),
      ),
      children: [
        SingleChildScrollView(
          child: Container(
            margin : const EdgeInsets.only( left: 12,top: 12,right: 12,bottom: 0),
            padding: const EdgeInsets.only( left: 12,top: 12,right: 12,bottom: 0),
            child:  Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children:  [
                constTextBody("株式会社ウイネット（以下「当社」という）では、お客様に安心してManaMoをご利用いただくために、サービスレベル目標（以下「本SLO」という）を定め運用しております。",TextAlign.justify,typography,scale),
                constTextBody("本SLOはサービス品質を保証するものではありませんが、皆様に快適にご利用いただくために定期的な計測および改善活動を行い、目標を維持できるよう努めています。",TextAlign.justify,typography,scale),
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8,),
                      constTextBodyStrong("(1) 対象サービス",TextAlign.justify,typography,scale),
                      constTextBody("電子書籍配信システム「ManaMo」",TextAlign.justify,typography,scale),
                      const SizedBox(height: 8,),
                      constTextBodyStrong("(2）可用性及び信頼性",TextAlign.justify,typography,scale),
                      constTextBody("当社は、個人情報の正確性及び安全性を確保するため、管理体制を確立するとともに適切な安全対策を実施し、個人情報への不正アクセス、個人情報の紛失、破壊、改ざん及び漏えい等の予防並びに是正に努めます。",TextAlign.justify,typography,scale),
                    ],
                  ),
                ),
                const SizedBox(height: 8,),
                constTextBodyStrong("■ 個人の権利尊重",TextAlign.justify,typography,scale),
                constTextBodyStrong("① サービス提供時間",TextAlign.justify,typography,scale),
                constTextBody("24時間365日稼働します（メンテナンスを除く）。",TextAlign.justify,typography,scale),
                constTextBody("※サーバーメンテナンスなどによる計画停止を行う場合は、ManaMoの「お知らせ」欄への掲載等を通じて事前通知を行います。なお、臨時メンテナンスを行う場合は、計画停止時と同様に随時「お知らせ」欄にて通知を行います。",TextAlign.justify,typography,scale),
                constTextBodyStrong("② サービス稼働率",TextAlign.justify,typography,scale),
                constTextBody("99.9%以上を目標に運用します。",TextAlign.justify,typography,scale),
                constTextBodyStrong("③ 障害時対応及び障害時報告",TextAlign.justify,typography,scale),
                constTextBody("障害時には当社規定に従い対応するとともに障害発生を当社が確認してから60分以内に「お知らせ」欄等で通知することを目標とします。また、著しくパフォーマンスに影響を及ぼす障害等が発生した場合、一部機能の利用を制限させていただく場合があります。",TextAlign.justify,typography,scale),
                constTextBodyStrong("④ バージョンアップ",TextAlign.justify,typography,scale),
                constTextBody("ManaMoのバージョンアップを実施する場合は、すべてのテナント、利用者に対して一斉に行います。",TextAlign.justify,typography,scale),
                constTextBody("Windows又はiOS等のバージョンアップ、新バージョンのリリース対応は順次検証を行い対応します。",TextAlign.justify,typography,scale),
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      constTextBodyStrong("(3) サポート",TextAlign.justify,typography,scale),
                      constTextBody("当社は、ManaMoをご利用中の皆様に対して以下のサポート体制を提供しています。",TextAlign.justify,typography,scale),
                      constTextBody("・電話によるサポートサービス",TextAlign.justify,typography,scale),
                      constTextBody("    連絡先：025-246-9172",TextAlign.justify,typography,scale),
                      constTextBody("    提供時間：平日（土日祝日除く）10時～17時",TextAlign.justify,typography,scale),
                      constTextBody("・お問合せフォームによるサポートサービス",TextAlign.justify,typography,scale),
                      constTextBody("    連絡先：当社お問い合わせフォーム（https://www.wenet.co.jp/inquiry/）からの受付",TextAlign.justify,typography,scale),
                      constTextBody("    提供時間：24時間365日　なお、ご回答は電話によるサポート提供時間に準じます。",TextAlign.justify,typography,scale),
                      constTextBodyStrong("(４) データ管理",TextAlign.justify,typography,scale),
                      constTextBody("強固なセキュリティ対策や耐震性などの対策が施された、国内のデータセンターでシステム運用を行っています。また、大規模障害や災害が発生した場合でも、データが損失しないよう、定期的にデータのバックアップを行います。バックアップデータは、日次で取得し、30日間保管しています。",TextAlign.justify,typography,scale),
                      constTextBodyStrong("(５）セキュリティ",TextAlign.justify,typography,scale),
                    ],
                  ),

                ),
                constTextBodyStrong("① 通信の暗号化",TextAlign.justify,typography,scale),
                constTextBodyStrong("② 脆弱性管理",TextAlign.justify,typography,scale),
                constTextBody("OS、ミドルウェア、OSS等のセキュリティ情報を収集し、リスクに応じてパッチ適用を実施します。",TextAlign.justify,typography,scale),
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      constTextBodyStrong("(６) 本SLOの適用範囲外",TextAlign.justify,typography,scale),
                      constTextBody("本SLOの不達成が、以下の要因によって生じた場合は、本SLOは適用されません。",TextAlign.justify,typography,scale),
                      constTextBody("・当社の合理的な管理・統制の及ばない現象（天変地異、不可抗力、通信遮断等のインフラ障害、ハードウェア・ミドルウェアにおける不可避の障害を含む）",TextAlign.justify,typography,scale),
                      constTextBody("・本システムではなく、個々のPC、又は他社提供のサービス（回線など）に依存する問題に起因する現象",TextAlign.justify,typography,scale),
                      constTextBody("・事前通知済の計画停止実施時間帯での利用（お客様の事情により、登録されたお客様の連絡先が更新されていなかったことに起因する通知未達を含む）",TextAlign.justify,typography,scale),
                      constTextBody("・お客様の作為に起因する場合（又は、お客様が承諾しプラットフォームID・PWを割り当てた第三者の作為に起因する場合）",TextAlign.justify,typography,scale),
                      constTextBody("・暗号化されていない通信（HTTP通信）の利用",TextAlign.justify,typography,scale),
                    ],
                  ),

                ),
                const SizedBox(height: 12,),
                constTextBodyStrong("以上",TextAlign.justify,typography,scale),
                const SizedBox(height: 20,)
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget constTextBody(String text, TextAlign type , Typography typography, double scale ){
    return  Container(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(text, textAlign: type, style: typography.body?.apply(fontSizeFactor: scale)),
    );
  }
  Widget constTextBodyStrong(String text, TextAlign type , Typography typography, double scale ){
    return  Container(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(text, textAlign: type, style: typography.bodyStrong?.apply(fontSizeFactor: scale)),
    );
  }
  Widget constTextBodyLarge(String text, TextAlign type , Typography typography, double scale ){
    return  Container(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(text, textAlign: type, style: typography.bodyLarge?.apply(fontSizeFactor: scale)),
    );
  }
}

