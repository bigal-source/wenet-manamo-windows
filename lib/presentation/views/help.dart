import 'package:fluent_ui/fluent_ui.dart';

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              headerText('1.使い方'),
              spacing(),
              spacing(),
              titleText('1.1.書籍を閲覧する'),
              spacing(),
              rowText('①', [
                spacing(),
                bodyText('メニューから「HOME」もしくは「カテゴリ」をクリックします。'),
                bodyText('「カテゴリ」ではカテゴリ別に書籍の絞り込みができます。'),
              ]),
              spacing(),
              rowText('②', [
                spacing(),
                bodyText('閲覧する書籍をクリックします。'),
              ]),
              spacing(),
              rowText('③', [
                spacing(),
                bodyText('読み込みが完了したら「読む」ボタンをクリックするとビューアが起動します。'),
              ]),
              spacing(),
              rowText('④', [
                spacing(),
                bodyText('初めて開いた書籍の場合、読み込みが始まります。読み込みが100%になるまで待ちます。'),
              ]),
              spacing(),
              rowText('⑤', [
                spacing(),
                bodyText('読み込みが完了したら「読む」ボタンをクリックするとビューアが起動します。'),
              ]),
              spacing(),
              rowImage([
                image('assets/images/help_page/1.png', context),
              ]),
              spacing(),
              spacing(),
              titleText('1.2.オフラインで書籍を閲覧する'),
              spacing(),
              rowText('①', [
                spacing(),
                bodyText('メニューの「本棚」をクリックするとオフラインで閲覧できる書籍が表示されます。'),
              ]),
              rowText(' ※', [
                spacing(),
                bodyText('HOME・カテゴリで読み込みが完了した書籍が本棚に表示されます。'),
              ], numSize: 30),
              spacing(),
              rowText('②', [
                spacing(),
                bodyText('閲覧する書籍をクリックするとビューアが起動します。'),
              ]),
              rowText(' ※', [
                spacing(),
                bodyText('オフライン時の書籍の書き込みは、オンラインになった時点で自動でサーバに同期され、他端末でも書き込みを確認することができます。'),
              ], numSize: 30),
              spacing(),
              rowImage([
                image('assets/images/help_page/2.png', context),
              ]),
              spacing(),
              spacing(),
              titleText('1.3.書籍の本文からワード検索する'),
              spacing(),
              rowText('①', [
                spacing(),
                bodyText('メニューの「検索」をクリックします。'),
              ]),
              spacing(),
              rowText('②', [
                spacing(),
                bodyText('検索ワードを入力して検索します。'),
                bodyText('HOME・カテゴリに並んでいる書籍の本文から入力したワードを検索します。'),
              ]),
              spacing(),
              rowImage([
                image('assets/images/help_page/3.png', context),
              ]),
              spacing(height: 30),
              headerText('2.推奨環境'),
              spacing(),
              table(),
              spacing(height: 50)
            ],
          ),
        ),
      ],
    );
  }

  Widget headerText(String header) {
    return Text(header, style: const TextStyle(fontSize: 23, fontWeight: FontWeight.bold),);
  }
  Widget titleText(String title) {
    return Text(title, style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),);
  }
  Widget bodyText(String body) {
    return Text(body, style: const TextStyle(fontSize: 17));
  }
  Widget rowText(String num, List<Widget> row, {double numSize = 30}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        number(num, numSize: numSize),
        const SizedBox(
          width: 5,
        ),
        Expanded(
          flex: 9,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: row,
          ),
        )
      ],
    );
  }
  Widget number(String num, {double numSize = 30}) {
    return Text(num, style: TextStyle(fontSize: numSize, fontWeight: FontWeight.w300));
  }
  Widget rowImage(List<Widget> listImage) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: listImage,
    );
  }
  Widget image(String image, BuildContext context) {
    return Expanded(child: Image.asset(image, fit: BoxFit.contain,));
  }
  Widget spacing({double height = 5}) {
    return SizedBox(height: height);
  }
  Widget tableCell(String text, {bool isHeader = false}) {
    return Container(
      color: isHeader ? Colors.transparent : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Text(
          text,
          style: TextStyle(fontSize: 16, fontWeight: isHeader ? FontWeight.bold : FontWeight.w400),
        ),
      ),
    );
  }
  Widget table() {
    return Table(
      border: TableBorder.all(color: Colors.black, width: 1),
      columnWidths: const {
        0: FlexColumnWidth(1),
        1: FlexColumnWidth(1),
      },
      children: [
        TableRow(
          decoration: BoxDecoration(
            color: Colors.grey[30],
          ),
          children: [
            tableCell("Windows", isHeader: true),
            tableCell("Windows 11 以降"),
          ],
        ),
        TableRow(
          decoration: BoxDecoration(
            color: Colors.grey[30],
          ),
          children: [
            tableCell("Mac", isHeader: true),
            tableCell("macOS 13.0 以降"),
          ],),
        TableRow(
          decoration: BoxDecoration(
            color: Colors.grey[30],
          ),
          children: [
            tableCell("iOS", isHeader: true),
            tableCell("iOS 15.0 以降"),
          ],),
        TableRow(
          decoration: BoxDecoration(
            color: Colors.grey[30],
          ),
          children: [
            tableCell("Android", isHeader: true),
            tableCell("Android 13 以降"),
          ],),
        TableRow(
          decoration: BoxDecoration(
            color: Colors.grey[30],
          ),
          children: [
            tableCell("Chromebook", isHeader: true),
            tableCell("最新版"),
          ],),
      ],
    );
  }

}