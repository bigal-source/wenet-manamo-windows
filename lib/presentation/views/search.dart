import 'package:fluent_ui/fluent_ui.dart';


class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasFluentTheme(context));
    bool selected = true;
    String? comboboxValue;
    return ScaffoldPage.scrollable(
      header:  PageHeader(
        title: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 100,
              child: ComboBox<String>(
                value: comboboxValue,
                items: searchTypes.entries.map((e) {
                  return ComboBoxItem(
                    value: e.key,
                    child: Text(e.key),
                  );
                }).toList(),
                isExpanded: true,
                onChanged: (v) => comboboxValue = v,
              ),
            ),
            const Expanded(
              child: TextBox(
                readOnly: false,
                placeholder: 'Search',
                style: TextStyle(
                  fontFamily: 'Arial',
                  fontStyle: FontStyle.italic,
                ),
              ),
            )
          ],
        ),
      ),
      children: [
        SingleChildScrollView(
          child: Center(
            child: Container(
              margin : const EdgeInsets.only( left: 12,top: 12,right: 12,bottom: 0),
              padding: const EdgeInsets.only( left: 12,top: 12,right: 12,bottom: 0),
              child:  ComboBox<String>(
                isExpanded: true,
                items: searchTypes.entries.map((e) {
                  return ComboBoxItem(
                    value: e.key,
                    child: Text(e.key),
                  );
                }).toList(),
              ),
            ),
          ),
        )
      ],
    );
  }
}
Map<String, String> searchTypes = {
  '全文検索': 'solr',
  '簡易検索': 'normal',
};
