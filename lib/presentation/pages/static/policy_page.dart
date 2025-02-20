import 'package:fluent_ui/fluent_ui.dart';
import 'package:get/get.dart';
import '../../controllers/static/static_controller.dart';

class PolicyPage extends GetView<StaticController> {
  const PolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    Typography typography = FluentTheme.of(context).typography;
    double scale          = 1.0;
    return Obx(() => ScaffoldPage.scrollable(
      header:  PageHeader( title: FittedBox( fit: BoxFit.scaleDown, alignment: Alignment.centerLeft, child: Text(controller.title.value),),),
      children: [
        SingleChildScrollView(
          child: Container(),
        )
      ],
    ));
  }

}

