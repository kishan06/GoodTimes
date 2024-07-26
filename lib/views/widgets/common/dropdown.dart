import 'package:flutter/material.dart';
import 'package:good_times/utils/constant.dart';

class CustomDropdown extends StatefulWidget {
  final String selectedValue;
  final String? errorValue;
  final Widget? hintText;
  final List<String> items;
  final void Function(String) onChanged;
  final Function()? onAddVenueClicked; // Callback for Add Venue clicked

  const CustomDropdown({
    Key? key,
    required this.selectedValue,
    this.hintText,
    this.errorValue,
    required this.items,
    required this.onChanged,
    this.onAddVenueClicked, // Initialize the callback
  }) : super(key: key);

  @override
  _CustomDropdownState createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  late String _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.selectedValue;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: DropdownButtonHideUnderline(
        child: DropdownButtonFormField<String>(
          hint: widget.hintText,
          value: _selectedValue,
          icon: const Icon(Icons.keyboard_arrow_down),
          onChanged: (String? newValue) {
            setState(() {
              _selectedValue = newValue!;
              widget.onChanged(newValue);
            });
          },
          decoration: const InputDecoration(
            // errorBorder: UnderlineInputBorder(borderSide: BorderSide(color: kPrimaryColor,width: 1)),
            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: kPrimaryColor,width: 1)),
            // focusedErrorBorder: UnderlineInputBorder(borderSide: BorderSide(color: kPrimaryColor,width: 1)),
            // disabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: kPrimaryColor,width: 1)),
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: kPrimaryColor,width: 1)),
            border: UnderlineInputBorder(borderSide: BorderSide(color: kPrimaryColor,width: 1)),
          ),
          dropdownColor: const Color(0xff525252).withOpacity(1),
          padding: const EdgeInsets.all(0),
          borderRadius: BorderRadius.circular(5),
          items: [
            if (widget.hintText != null)
              DropdownMenuItem<String>(
                value: '',
                child: widget.hintText!,
              ),
            ...widget.items
                .asMap()
                .entries
                .map<DropdownMenuItem<String>>(
                  (item) => DropdownMenuItem<String>(
                    value: item.value,
                    child: item.value == 'Add Venue'?
                    GestureDetector(
                      onTap: (){
                        if (widget.onAddVenueClicked != null) {
                           widget.onAddVenueClicked!(); // Call the callback
                           }
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [Text(item.value, style: paragraphStyle.copyWith(color: kPrimaryColor))],
                      ),
                    ):
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [Text(item.value, style: paragraphStyle)],
                    ),
                  ),
                )
                .toList(),
          ],
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select a ${widget.errorValue}';
            }
            return null;
          },
        ),
      ),
    );
  }
}
