import 'package:fluent_ui/fluent_ui.dart';
import '../config/page.dart';

class ComboBoxPage extends StatefulWidget {
  const ComboBoxPage({super.key});

  @override
  State<ComboBoxPage> createState() => _ComboBoxPageState();
}

class _ComboBoxPageState extends State<ComboBoxPage> with PageMixin {
  String? selectedColor = 'Green';
  String? selectedCat;
  double fontSize = 20.0;
  bool disabled = false;
  final comboboxKey = GlobalKey<ComboBoxState>(debugLabel: 'Combobox Key');

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage.scrollable(
      header: PageHeader(
        title: const Text('ComboBox'),
        commandBar: ToggleSwitch(
          checked: disabled,
          onChanged: (v) {
            setState(() => disabled = v);
          },
          content: const Text('Disabled'),
        ),
      ),
      children: [
        Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            ComboBox<String>(
              isExpanded: false,
              popupColor: colors[selectedColor],
              value: selectedColor,
              items: colors.entries.map((e) {
                return ComboBoxItem(
                  value: e.key,
                  child: Text(e.key),
                );
              }).toList(),
              onChanged: disabled
                  ? null
                  : (color) {
                setState(() => selectedColor = color);
              },
            ),
            Container(
              margin: const EdgeInsetsDirectional.only(top: 8.0),
              height: 30,
              width: 100,
              color: colors[selectedColor],
            ),
          ]
        ),
      ],
    );
  }

  Map<String, Color> colors = {
    'Blue': Colors.blue,
    'Green': Colors.green,
    'Red': Colors.red,
    'Yellow': Colors.yellow,
    'Grey': Colors.grey,
    'Magenta': Colors.magenta,
    'Orange': Colors.orange,
    'Purple': Colors.purple,
    'Teal': Colors.teal,
  };

  static const fontSizes = <double>[
    8,
    9,
    10,
    11,
    12,
    14,
    16,
    18,
    20,
    24,
    28,
    36,
    48,
    72,
  ];
}
