import 'package:fluent_ui/fluent_ui.dart';
import '/app/extensions/color.dart';
import 'package:system_theme/system_theme.dart';

class ItemHover extends StatefulWidget {
  final String txtTitle;
  const ItemHover({Key? key, required this.txtTitle}) : super(key: key);
  @override
  State<ItemHover> createState() => _ItemHover();
}
class _ItemHover extends State<ItemHover> {
  bool _highlight = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (e) => setState(() {
        _highlight = true;
      }),
      onExit: (e) => setState(() {
        _highlight = false;
      }),
      child: Container(
          height: 60,
          margin: const EdgeInsets.only(bottom: 10,top: 10, left: 10, right: 10),
          color:  _highlight ? HexColor('#34c3eb') : SystemTheme.accentColor.accent.toAccentColor(),
          child: ListTile(
              title: Text(widget.txtTitle),
              trailing:  const Icon(FluentIcons.chevron_right))
      ),
    );
  }
}