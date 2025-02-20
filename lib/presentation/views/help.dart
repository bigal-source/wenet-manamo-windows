import 'package:fluent_ui/fluent_ui.dart';

import 'bodyTexView.dart';

class HelpView extends StatelessWidget {
  const HelpView({super.key});

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasFluentTheme(context));
    return ScaffoldPage.scrollable(
      header: const PageHeader(
        title: Text('ヘルプ'),
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
                const TitleTextView(txtText: "1. 操作方法", type: TextAlign.justify, scale: 1.0,),
                const Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SubTitleTextView(txtText: "■ コンテンツを探す", type: TextAlign.justify, scale: 1.0,),
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            BodyStrongTextView(txtText: "1. キーワードで探す", type: TextAlign.justify, scale: 1.0,),
                            BodyTextView(txtText: "複数のコンテンツから任意のキーワードで検索できます。\n全文からテキスト情報を抽出し、合致するキーワードを検索できるので、読みたいコンテンツを探し出すことができます。\n検索結果がハイライト表示されるので、キーワードの位置がすぐに確認できます。", type: TextAlign.justify, scale: 1.0,),
                            BodyStrongTextView(txtText: "2. カテゴリから探す", type: TextAlign.justify, scale: 1.0,),
                            BodyTextView(txtText: "「カタログ」「チラシ」「広報誌」「資格・講座」などのカテゴリから、コンテンツを探すことができます。", type: TextAlign.justify, scale: 1.0,),
                          ],
                        ),

                      ),
                      SubTitleTextView(txtText: "■ コンテンツの閲覧方法", type: TextAlign.justify, scale: 1.0,),
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            BodyStrongTextView(txtText: "1. コンテンツを選択する", type: TextAlign.justify, scale: 1.0,),
                            BodyTextView(txtText: "HOME画面の中から閲覧したいコンテンツを選んでください。\nまた、キーワード検索や、カテゴリからコンテンツを探すこともできます。", type: TextAlign.justify, scale: 1.0,),
                            BodyStrongTextView(txtText: "2. コンテンツの詳細を確認する", type: TextAlign.justify, scale: 1.0,),
                            BodyTextView(txtText: "コンテンツを選ぶと、詳細画面が表示されます。\nさらに「読む」ボタンを押すと、閲覧ビューアが開きます。\n詳細情報が設定されていない場合は、直接閲覧ビューアが開きます。", type: TextAlign.justify, scale: 1.0,),
                            BodyStrongTextView(txtText: "3. コンテンツを閲覧する", type: TextAlign.justify, scale: 1.0,),
                            BodyTextView(txtText: "ビューアが開くと、コンテンツの閲覧ができます。", type: TextAlign.justify, scale: 1.0,),
                          ],
                        ),

                      ),
                      SubTitleTextView(txtText: "■ 資料請求する", type: TextAlign.justify, scale: 1.0,),
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            BodyTextView(txtText: "企業のカタログや広報誌などを資料請求する機能です。\n   ※資料請求設定しているコンテンツのみ\n お客様の必要に応じてデジタル版及び紙版が選択できます。 \n資料請求のお申込み後には、システムから確認メールが届きます。", type: TextAlign.justify, scale: 1.0,),
                          ],
                        ),

                      ),
                    ],
                  ),

                ),
                const TitleTextView(txtText: "2. 動作環境", type: TextAlign.justify, scale: 1.0,),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SubTitleTextView(txtText: "PC", type: TextAlign.justify, scale: 1.0,),
                      const SubTitleTextView(txtText: "■ 閲覧環境", type: TextAlign.justify, scale: 1.0,),
                      Padding(
                        padding: const EdgeInsets.only(left: 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Table(
                              border: TableBorder(
                                right: BorderSide(
                                    color: Colors.grey[50]
                                ),
                                left: BorderSide(
                                    color: Colors.grey[50]
                                ),
                                top: BorderSide(
                                    color: Colors.grey[50]
                                ),
                                bottom: BorderSide(
                                    color: Colors.grey[50]
                                ),
                              ),
                              columnWidths: const {0: FractionColumnWidth(.3), 1: FractionColumnWidth(.7)},
                              children: [
                                TableRow(
                                    decoration: BoxDecoration(
                                        color: Colors.grey[50],
                                        border: Border.all(color: Colors.grey[50], width: 0)
                                    ),
                                    children: [
                                      leftCol(context,'Windows'),
                                      rightCol(context,''),
                                    ]
                                ),
                                TableRow(
                                  decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      border: Border.all(color: Colors.grey[50])
                                  ),
                                    children: [
                                      leftCol(context,'OS'),
                                      rightCol(context,'Microsoft Windows10、Windows11'),
                                    ]
                                ),

                                TableRow(
                                    children: [
                                      leftCol(context,'ブラウザ'),
                                      rightCol(context,'Microsoft Edge（最新）、Mozilla Firefox（最新）、Google Chrome（最新）'),
                                    ]
                                ),
                              ],
                            )
                          ],
                        ),

                      ),
                      const SizedBox(height: 20,),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Table(
                              border: TableBorder(
                                right: BorderSide(
                                    color: Colors.grey[50]
                                ),
                                left: BorderSide(
                                    color: Colors.grey[50]
                                ),
                                top: BorderSide(
                                    color: Colors.grey[50]
                                ),
                                bottom: BorderSide(
                                    color: Colors.grey[50]
                                ),
                              ),
                              columnWidths: const {0: FractionColumnWidth(.3), 1: FractionColumnWidth(.7)},
                              children: [
                                TableRow(
                                    decoration: BoxDecoration(
                                        color: Colors.grey[50],
                                        border: Border.all(color: Colors.grey[50], width: 0)
                                    ),
                                    children: [
                                      leftCol(context,'Macintosh'),
                                      rightCol(context,''),
                                    ]
                                ),
                                TableRow(
                                    decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        border: Border.all(color: Colors.grey[50])
                                    ),
                                    children: [
                                      leftCol(context,'OS'),
                                      rightCol(context,'MacOS 10.13以降'),
                                    ]
                                ),
                                TableRow(
                                    children: [
                                      leftCol(context,'ブラウザ'),
                                      rightCol(context,'Safari（最新）、Mozilla Firefox（最新）、Google Chrome（最新）'),
                                    ]
                                ),
                              ],
                            )
                          ],
                        ),

                      ),
                      //todo: MOBILE
                      const SizedBox(height: 20,),
                      const SubTitleTextView(txtText: "iOS", type: TextAlign.justify, scale: 1.0,),
                      const SubTitleTextView(txtText: "■ 閲覧環境", type: TextAlign.justify, scale: 1.0,),
                      Padding(
                        padding: const EdgeInsets.only(left: 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Table(
                              border: TableBorder(
                                right: BorderSide(
                                    color: Colors.grey[50]
                                ),
                                left: BorderSide(
                                    color: Colors.grey[50]
                                ),
                                top: BorderSide(
                                    color: Colors.grey[50]
                                ),
                                bottom: BorderSide(
                                    color: Colors.grey[50]
                                ),
                              ),
                              columnWidths: const {0: FractionColumnWidth(.3), 1: FractionColumnWidth(.7)},
                              children: [
                                TableRow(
                                    children: [
                                      leftCol(context,'OS'),
                                      rightCol(context,'iOS 11以降'),
                                    ]
                                ),
                              ],
                            )
                          ],
                        ),

                      ),
                      const SizedBox(height: 20,),
                      const SubTitleTextView(txtText: "Android", type: TextAlign.justify, scale: 1.0,),
                      const SubTitleTextView(txtText: "■ 閲覧環境", type: TextAlign.justify, scale: 1.0,),
                      Padding(
                        padding: const EdgeInsets.only(left: 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Table(
                              border: TableBorder(
                                right: BorderSide(
                                    color: Colors.grey[50]
                                ),
                                left: BorderSide(
                                    color: Colors.grey[50]
                                ),
                                top: BorderSide(
                                    color: Colors.grey[50]
                                ),
                                bottom: BorderSide(
                                    color: Colors.grey[50]
                                ),
                              ),
                              columnWidths: const {0: FractionColumnWidth(.3), 1: FractionColumnWidth(.7)},
                              children: [
                                TableRow(
                                    children: [
                                      leftCol(context,'OS'),
                                      rightCol(context,'Android 11以降'),
                                    ]
                                ),
                              ],
                            )
                          ],
                        ),

                      ),
                    ],
                  ),

                ),
              ],
            ),
          ),
        )
      ],
    );
  }
  Container leftCol(BuildContext context, String txtStr){
    Typography typography = FluentTheme.of(context).typography;
    return Container(
      padding: const EdgeInsets.all(8),
      // decoration: const BoxDecoration(
      //   color: Color(0xFFF0F0F1)
      // ),
      child: Text(
        txtStr,
        textAlign: TextAlign.justify, style: typography.bodyLarge?.apply(fontSizeFactor: 1.0),
        strutStyle: const StrutStyle( fontFamily: 'Lucida Grande,Hiragino Kaku Gothic Pro, Pro W3,Meiryo,MS PGothic,Osaka,Verdana,Arial,Helvetica,sans-serif', fontSize: 8, height: 2, leading: 2,),
      ),
    );
  }
  Container rightCol(BuildContext context, String txtStr){
    Typography typography = FluentTheme.of(context).typography;
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border(
          left: BorderSide(color: Colors.grey[50])
        )
      ),
      child: Text(
        txtStr,
        textAlign: TextAlign.justify, style: typography.bodyLarge?.apply(fontSizeFactor: 1.0),
        strutStyle: const StrutStyle( fontFamily: 'Lucida Grande,Hiragino Kaku Gothic Pro, Pro W3,Meiryo,MS PGothic,Osaka,Verdana,Arial,Helvetica,sans-serif', fontSize: 8, height: 2, leading: 2,),
      ),
    );
  }
}

