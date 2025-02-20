import 'package:fluent_ui/fluent_ui.dart';

import '../../app/config/page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with PageMixin {
  bool selected = true;
  String? comboboxValue;

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasFluentTheme(context));
    final theme = FluentTheme.of(context);

    return ScaffoldPage.scrollable(
      header: const PageHeader(
        title: Text('HOME'),
      ),
      children: const [
      ],
    );
  }
}

class SponsorButton extends StatelessWidget {
  const SponsorButton({
    super.key,
    required this.imageUrl,
    required this.username,
  });

  final String imageUrl;
  final String username;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        height: 60,
        width: 60,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(imageUrl),
          ),
          shape: BoxShape.circle,
        ),
      ),
      Text(username),
    ]);
  }
}
