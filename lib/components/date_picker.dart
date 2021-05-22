import 'package:flutter/material.dart';

import 'package:norsyaza_etiqa_assestment/todoapp.dart';

class CustomDatePicker extends StatefulWidget {
  // ---------------------------- CONSTRUCTORS ----------------------------
  const CustomDatePicker({
    @required this.value,
    @required this.initialDate,
    @required this.firstDate,
    @required this.lastDate,
    this.onDateSelected,
  });

  // ------------------------------- FIELDS -------------------------------
  final DateTime value;
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final ValueChanged<DateTime> onDateSelected;

  @override
  _CustomDatePickerState createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  // ------------------------------- FIELDS -------------------------------
  final _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final textValue = widget.value != null ? widget.value.dateFormattedString : '';
    _controller.value = TextEditingValue(text: textValue);
    return InkWell(
      onTap: () => _openPicker(context),
      child: Stack(
        children: [
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: 'Select a date',
              filled: true,
              fillColor: Colors.white,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              suffixIcon: Icon(
                Icons.date_range_outlined,
              ),
            ),
            keyboardType: TextInputType.datetime,
          ),
          Positioned(
            top: 0.0,
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
            child: Container(color: Colors.transparent),
          )
        ],
      ),
    );
  }

  Future<void> _openPicker(BuildContext context) async {
    final result = await showDatePicker(
      context: context,
      initialDate: widget.initialDate,
      firstDate: widget.firstDate,
      lastDate: widget.lastDate,
    );

    if (result == null) {
      return;
    }

    widget.onDateSelected?.call(result);
  }
}
