import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:men/shared/cubit/cubit.dart';
import 'package:men/shared/cubit/states.dart';
import '../models/item_model.dart';
import 'items_page.dart';
import 'second_page.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  static const List<String> selectedItems = [
    'الزوج',
    'الزوجة',
    'الأب',
    'الأم',
    'الجد',
    'الجدة لأب',
    'الجدة لأم',
    'الأخت الشقيقة',
    'الأخت لأب',
    'الأخوة لأم',
    'البنت',
    'بنت الابن',
    'الابن',
    'ابن الابن',
    'الأخ الشقيق',
    'الأخ لأب',
    'ابن الأخ الشقيق',
    'ابن الأخ لأب',
    'العم الشقيق',
    'العم لأب',
    'ابن العم الشقيق',
    'ابن العم لأب',
  ];

  static const List<String> category1 = ["الزوج", "الزوجة"];
  static const List<String> category2 = ["الأب", "الجد"];
  static const List<String> category3 = ["الأم", "الجدة لأب", "الجدة لأم"];
  static const List<String> category4 = [
    "البنت",
    "بنت الابن",
    "الأخت الشقيقة",
    "الأخت لأب",
    "الأخوة لأم"
  ];

  final List<List<TextValue>> multiList = [
    firstList,
    secondList,
    thirdList,
    fourthList,
    fifthList,
  ];

  static List<TextValue> firstList = [];
  static List<TextValue> secondList = [];
  static List<TextValue> thirdList = [];
  static List<TextValue> fourthList = [];
  static List<TextValue> fifthList = [];

  final InheritanceState inheritanceState = InheritanceState();
  String? selectedItem;
  bool color = false;

  @override
  void initState() {
    super.initState();
    color = false;
  }

  bool get buttonLuck {
    final hasItems = firstList.isNotEmpty ||
        secondList.isNotEmpty ||
        thirdList.isNotEmpty ||
        fourthList.isNotEmpty ||
        fifthList.isNotEmpty;

    setState(() => color = hasItems);
    return color;
  }

  void addTextValue(String value) {
    final textValue = TextValue(value, true, true, true);

    if (category1.contains(value)) {
      if (!firstList.any((e) => e.textValue == value)) {
        firstList.add(textValue);
        inheritanceState.heirsCount[value] = 1;
      }
    } else if (category2.contains(value)) {
      if (!secondList.any((e) => e.textValue == value)) {
        secondList.add(textValue);
        inheritanceState.heirsCount[value] = 1;
      }
    } else if (category3.contains(value)) {
      if (!thirdList.any((e) => e.textValue == value)) {
        thirdList.add(textValue);
        inheritanceState.heirsCount[value] = 1;
      }
    } else if (category4.contains(value)) {
      if (!fourthList.any((e) => e.textValue == value)) {
        fourthList.add(textValue);
        inheritanceState.heirsCount[value] = 1;
      }
    } else if (!fifthList.any((e) => e.textValue == value)) {
      fifthList.add(textValue);
      inheritanceState.heirsCount[value] = 1;
    }
  }

  String callBack(String value, int num) {
    switch (value) {
      case 'الابن':
        return "$num من الأبناء";
      case 'ابن الابن':
        return "$num من أبناء الابن";
      case 'البنت':
        return "$num من البنات";
      case 'بنت الابن':
        return "$num من بنات الابن";
      case 'الأخ الشقيق':
        return "$num من الأشقاء";
      case 'الأخت الشقيقة':
        return "$num من الشقيقات";
      default:
        return "أكثر من $value";
    }
  }

  void _removeItem(TextValue e) {
    setState(() {
      if (firstList.contains(e)) {
        firstList.remove(e);
      } else if (secondList.contains(e)) {
        secondList.remove(e);
      } else if (thirdList.contains(e)) {
        thirdList.remove(e);
      } else if (fourthList.contains(e)) {
        fourthList.remove(e);
      } else {
        fifthList.remove(e);
      }

      inheritanceState.heirsCount.remove(e.textValue);
    });
    buttonLuck;
  }

  void _handleItemTap(TextValue e) {
    setState(() {
      const fixedItems = [
        'الأب',
        'الأم',
        'الزوج',
        'الجد',
        'الجدة لأب',
        'الجدة لأم'
      ];
      const incrementableItems = [
        'الابن', 'ابن الابن', 'الأخ الشقيق', 'الأخ لأب',
        'البنت', 'بنت الابن', 'الأخت الشقيقة', 'الأخت لأب'
      ];

      if (fixedItems.contains(e.textValue)) {
        e.toggle = true;
      } else if (incrementableItems.contains(e.textValue)) {
        e.toggle = false;
        if (!e.toggle) {
          e.sum++;
          inheritanceState.heirsCount[e.textValue] = e.sum;
        }
      } else {
        e.toggle = !e.toggle;
      }
    });
  }

  void check() {
    inheritanceState.reset();
    for (final list in multiList) {
      for (final item in list) {
        inheritanceState.heirsCount[item.textValue] = item.sum;
      }
    }

    InheritanceManager.distribute(inheritanceState);

    if (inheritanceState.dataset.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء إضافة ورثة صالحين للإرث')),
      );
      return;
    }

    CubitData.get(context).insertData(
        dataSet: inheritanceState.dataset,
        details: inheritanceState.heirsDetails
    ).whenComplete(() =>
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SecondPage(),
          ),
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer(
        listener: (context, state) {
          if (state is DataErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(state.error),
                backgroundColor: Colors.red.shade700));
          }
        },
        builder: (context, state) =>
        Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            backgroundColor: Colors.grey[900],
            appBar: AppBar(
              elevation: 0.0,
              scrolledUnderElevation: 0.0,
              backgroundColor: Colors.grey[900],
              title: const Text(
                "مواريث",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            body: Column(
              children: [
                const SizedBox(height: 50),
                const Text(
                  "مات وترك ؟",
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadiusDirectional.all(
                        Radius.circular(5)),
                  ),
                  child: DropdownButton<String>(
                    menuMaxHeight: 200,
                    hint: const Text(
                        'أختر', style: TextStyle(color: Colors.white)),
                    value: selectedItem,
                    dropdownColor: Colors.grey[800],
                    borderRadius: BorderRadius.circular(10),
                    items: selectedItems.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                            value, style: const TextStyle(color: Colors.white)),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      if (value != null && value.isNotEmpty) {
                        setState(() {
                          selectedItem = value;
                          addTextValue(value);
                          buttonLuck;
                        });
                      }
                    },
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: GridView.count(
                      physics: const BouncingScrollPhysics(),
                      crossAxisCount: 3,
                      crossAxisSpacing: 3,
                      mainAxisSpacing: 8,
                      childAspectRatio: 0.9,
                      children: multiList.expand((list) => list).map((e) {
                        return GestureDetector(
                          onTap: () => _handleItemTap(e),
                          child: Card(
                            color: Colors.grey,
                            child: Stack(
                              children: [
                                if (e.icon)
                                  Align(
                                    alignment: AlignmentDirectional.topStart,
                                    child: IconButton(
                                      iconSize: 20,
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                      icon: const Icon(
                                        Icons.highlight_remove_outlined,
                                        color: Colors.white70,
                                      ),
                                      onPressed: () => _removeItem(e),
                                    ),
                                  ),
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      e.toggle ? e.textValue : callBack(
                                          e.textValue, e.sum),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: e.backgroundColor
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                                if (!e.toggle)
                                  Positioned(
                                    bottom: 4,
                                    right: 4,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                        '${e.sum}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  color: color ? Colors.amber : Colors.grey,
                  child: MaterialButton(
                    onPressed: buttonLuck ? check : null,
                    child: state is DataLoadingState ?
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(child: CircularProgressIndicator(
                          color: Colors.black))):
                    const Text(
                      'أحسب',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }
}





