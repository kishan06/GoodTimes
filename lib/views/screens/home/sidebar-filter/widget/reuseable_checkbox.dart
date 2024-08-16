import 'package:flutter/material.dart';
import 'package:good_times/utils/constant.dart';
import 'package:good_times/views/widgets/subscriptionmodule.dart';

class CheckboxList extends StatelessWidget {
  final List options;
  List mapoption;
  final List<bool> checkBoxValues;
  final Function(bool?, int) onChangedCallback;
  List storedpreferencelist;
  bool preference;
  bool hasSubscription;
  CheckboxList({
    super.key,
    required this.options,
    this.mapoption = const [],
    required this.checkBoxValues,
    required this.onChangedCallback,
    this.storedpreferencelist = const [],
    this.preference = false,
    this.hasSubscription = false,
  });

  @override
  Widget build(BuildContext context) {
    print(storedpreferencelist);
    print(preference);
    return Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: Column(
          children: List.generate(
            options.length,
            (index) => GestureDetector(
              onTap: () {
                if (preference && !hasSubscription) {
                  if (storedpreferencelist.contains(mapoption[index]['id'])) {
                    bool newValue = !checkBoxValues[index];
                    onChangedCallback(newValue, index);
                  } else {
                    Subscriptionmodule(context, "event_user");
                  }
                } else {
                  bool newValue = !checkBoxValues[index];
                  onChangedCallback(newValue, index);
                }
              },
              child: Row(
                children: [
                  Checkbox(
                    checkColor: Colors.white,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    activeColor:
                        kPrimaryColor, // Replace with your desired active color
                    side: BorderSide(
                        color: preference && !hasSubscription
                            ? storedpreferencelist
                                    .contains(mapoption[index]['id'])
                                ? kPrimaryColor
                                : kTextgrey
                            : kPrimaryColor), // Replace with your desired side color
                    value: checkBoxValues[index],
                    onChanged: (value) {
                      onChangedCallback(value, index);
                    },
                  ),
                  const SizedBox(width: 10),
                  Text(
                    options[index],
                    style: TextStyle(
                      fontSize: 12,
                      color: preference && !hasSubscription
                          ? storedpreferencelist.contains(mapoption[index]['id'])
                              ? Color(0xffE6E6E6)
                              : kTextgrey
                          : Color(0xffE6E6E6),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
