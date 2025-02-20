import 'package:fluent_ui/fluent_ui.dart';


class BookShelfPage extends StatelessWidget {
  const BookShelfPage({super.key});

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasFluentTheme(context));
    return ScaffoldPage.scrollable(
      header: const PageHeader(
        title: Text('本棚'),
      ),
      children: [
        SingleChildScrollView(
          child: Center(
            child: Container(
              margin : const EdgeInsets.only( left: 12,top: 12,right: 12,bottom: 0),
              padding: const EdgeInsets.only( left: 12,top: 12,right: 12,bottom: 0),
              child: const Text(""),
            ),
          ),
        )
      ],
    );
  }
}

