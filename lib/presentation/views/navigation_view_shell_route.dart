import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:window_manager/window_manager.dart';

class NavigationViewShellRoute extends StatelessWidget {
  const NavigationViewShellRoute({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationView(
      appBar: NavigationAppBar(
        title: () {
          const title = Text('NavigationView');

          if (kIsWeb) return title;

          return const DragToMoveArea(child: title);
        }(),
        leading: IconButton(
          icon: const Icon(FluentIcons.back),
          onPressed: () => context.pop(),
        ),
      ),
      content: const ScaffoldPage(
        header: PageHeader(
          title: Text('New Page'),
        ),
        content: Center(
          child: Text('This is a new page'),
        ),
      ),
    );
  }
}