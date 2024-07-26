import 'package:flutter/material.dart';
import 'package:good_times/utils/constant.dart';

class CheckboxList extends StatelessWidget {
  final List<String> options;
  final List<bool> checkBoxValues;
  final Function(bool?, int) onChangedCallback;

  const CheckboxList({super.key, 
    required this.options,
    required this.checkBoxValues,
    required this.onChangedCallback,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: Column(
        children: List.generate(
          options.length,
          (index) => GestureDetector(
            onTap: (){
              bool newValue = !checkBoxValues[index];
              onChangedCallback(newValue, index);
            },
            child: Row(
            children: [
              Checkbox(
                checkColor: Colors.white,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                activeColor: kPrimaryColor, // Replace with your desired active color
                side: const BorderSide(color: kPrimaryColor), // Replace with your desired side color
                value: checkBoxValues[index],
                onChanged: (value) {
                  onChangedCallback(value, index);
                },
              ),
              const SizedBox(width: 10),
              Text(
                options[index],
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xffE6E6E6),
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}