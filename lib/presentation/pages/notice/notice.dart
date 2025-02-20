import 'package:fluent_ui/fluent_ui.dart';
import 'package:get/get.dart';
import '../../../app/utils/date_utils.dart';
import '../../controllers/notice/notice_controller.dart';
import '../../views/bodyTexView.dart';

class NoticePage extends StatelessWidget{

  NoticePage({Key? key}) : super(key: key);
  var controller    = Get.put(NoticeController());
  final expanderKey = GlobalKey<ExpanderState>(debugLabel: 'Expander key');
  bool crostOpen    = false;

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage.scrollable(
      header:  const PageHeader( title: FittedBox( fit: BoxFit.scaleDown, alignment: Alignment.centerLeft, child: Text('お知らせ'),),),
      children:  [
        SingleChildScrollView(
          child: Obx(() => controller.loading.isFalse ? Column(
            children: [
              for(var item in controller.info.value.infoList!)
                Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                  child: Expander(
                    header: Text('${item.title}'),
                    onStateChanged: (open) => crostOpen = open,
                    trailing: crostOpen ? null : Text('${DateUtil.jDate(dateStr: item.updateDate)}', style: FluentTheme.of(context).typography.caption,),
                    content:
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          BodyTextView(txtText: item.title!, type: TextAlign.justify, scale: 1.0,),
                        ]
                    ),
                  ),
                ),
            ],
          ) : Container()),
        )
      ],
    );
  }
}
