
import 'package:fluent_ui/fluent_ui.dart';
class BodyTextView extends StatelessWidget {
  const BodyTextView({super.key, required this.txtText, required this.type, required this.scale});
  final String txtText;
  final TextAlign type;
  final double scale;

  @override
  Widget build(BuildContext context) {
    Typography typography = FluentTheme.of(context).typography;
    return Container(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(txtText, textAlign: type, style: typography.body?.apply(fontSizeFactor: scale), strutStyle: const StrutStyle( fontFamily: 'Roboto', fontSize: 8, height: 2, leading: 2,),),
    );
  }
}
class BodyStrongTextView extends StatelessWidget {
  const BodyStrongTextView({super.key, required this.txtText, required this.type, required this.scale});
  final String txtText;
  final TextAlign type;
  final double scale;

  @override
  Widget build(BuildContext context) {
    Typography typography = FluentTheme.of(context).typography;
    return Container(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(txtText, textAlign: type, style: typography.bodyStrong?.apply(fontSizeFactor: scale), strutStyle: const StrutStyle( fontFamily: 'Roboto', fontSize: 8, height: 2, leading: 2,),),
    );
  }
}
class BodyTextColorView extends StatelessWidget {
  const BodyTextColorView({super.key, required this.txtText, required this.type, required this.scale, this.color});
  final String txtText;
  final TextAlign type;
  final double scale;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    Typography typography = FluentTheme.of(context).typography;
    return Container(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        txtText,
        textAlign: type, style: typography.body?.apply(fontSizeFactor: scale, color: color),
        strutStyle: const StrutStyle( fontFamily: 'Roboto', fontSize: 8, height: 2, leading: 2,),
      ),
    );
  }
}

class TitleTextView extends StatelessWidget {
  const TitleTextView({super.key, required this.txtText, required this.type, required this.scale});
  final String txtText;
  final TextAlign type;
  final double scale;

  @override
  Widget build(BuildContext context) {
    Typography typography = FluentTheme.of(context).typography;
    return Container(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        txtText,
        textAlign: type, style: typography.title?.apply(fontSizeFactor: scale),
        strutStyle: const StrutStyle( fontFamily: 'Roboto', fontSize: 8, height: 2, leading: 2,),
      ),
    );
  }
}
class SubTitleTextView extends StatelessWidget {
  const SubTitleTextView({super.key, required this.txtText, required this.type, required this.scale});
  final String txtText;
  final TextAlign type;
  final double scale;

  @override
  Widget build(BuildContext context) {
    Typography typography = FluentTheme.of(context).typography;
    return Container(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        txtText,
        textAlign: type, style: typography.subtitle?.apply(fontSizeFactor: scale),
        strutStyle: const StrutStyle( fontFamily: 'Roboto', fontSize: 8, height: 2, leading: 2,),
      ),
    );
  }
}



