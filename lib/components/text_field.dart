import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  // ---------------------------- CONSTRUCTORS ----------------------------
  const CustomTextField({
    Key key,
    this.value = '',
    this.errorText,
    this.onChanged,
  }) : super(key: key);

  // ------------------------------- FIELDS -------------------------------
  final String value;
  final String errorText;
  final ValueChanged<String> onChanged;

  // ------------------------------- METHODS ------------------------------
  @override
  _UkuyaTextFieldState createState() => _UkuyaTextFieldState();
}

class _UkuyaTextFieldState extends State<CustomTextField> {
  // ------------------------------- FIELDS -------------------------------
  final _controller = TextEditingController();
  int _previousSelectionOffset = 0;
  int _previousExtentOffset = 0;

  // ------------------------------- METHODS ------------------------------
  @override
  Widget build(BuildContext context) {
    return _TextField(
      controller: _controller,
      errorText: widget.errorText,
      onChanged: widget.onChanged,
    );
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
  }

  @override
  void reassemble() {
    super.reassemble();
    _controller.removeListener(_onTextChanged);
    _controller.addListener(_onTextChanged);
  }

  @override
  void didUpdateWidget(CustomTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != null) {
      var selectionOffset = _previousSelectionOffset;
      if (selectionOffset > widget.value.length) {
        selectionOffset = widget.value.length;
      }

      var extentOffset = _previousExtentOffset == null
          ? selectionOffset
          : _previousExtentOffset;
      if (extentOffset > widget.value.length) {
        extentOffset = widget.value.length;
      }

      _controller.value = TextEditingValue(
        text: widget.value,
        selection: TextSelection(
          baseOffset: selectionOffset,
          extentOffset: extentOffset,
        ),
      );
    } else {
      _controller.value = TextEditingValue(
        text: '',
        selection: TextSelection(
          baseOffset: 0,
          extentOffset: 0,
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {
      _previousSelectionOffset = _controller.selection.baseOffset;
      _previousExtentOffset =
      _controller.selection.extentOffset == _controller.selection.baseOffset
          ? null
          : _controller.selection.extentOffset;
    });
  }
}

class _TextField extends StatelessWidget {
  // ---------------------------- CONSTRUCTORS ----------------------------
  const _TextField({
    Key key,
    this.controller,
    this.errorText,
    this.onChanged,
  }) : super(key: key);

  // ------------------------------- FIELDS -------------------------------
  final TextEditingController controller;
  final String errorText;
  final ValueChanged<String> onChanged;

  // ------------------------------- METHODS ------------------------------
  @override
  Widget build(BuildContext context) {
    final hasError = errorText?.isNotEmpty == true;

    return TextField(
      controller: controller,
      minLines: 7,
      maxLines: 15,
      autocorrect: false,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
          hintText: 'Please key in your To-Do title here',
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          errorText: errorText,
      ),
      onChanged: onChanged,

    );
  }
}