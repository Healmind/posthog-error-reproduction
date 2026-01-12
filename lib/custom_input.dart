import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomInputText extends StatefulWidget {
  const CustomInputText({
    required this.title,
    required this.colorCardHome,
    this.fieldKey,
    this.iconCardLogin,
    this.isObscureText = false,
    this.isRequired = false,
    this.onChanged,
    this.validator,
    this.successMessage,
    this.controllerText,
    super.key,
    this.iconCalendar = false,
    this.readOnly = false,
    this.maskPattern,
  });

  final String title;
  final String? fieldKey;
  final Widget? iconCardLogin;
  final Color colorCardHome;
  final bool isObscureText;
  final bool isRequired;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;
  final String? successMessage;
  final String? controllerText;
  final bool iconCalendar;
  final bool readOnly;
  final String? maskPattern; // Pattern for text masking (e.g., "(###) ###-####" for phone)

  @override
  State<CustomInputText> createState() => _CustomInputTextState();
}

class _CustomInputTextState extends State<CustomInputText> {
  TextEditingController? _controller;
  final FocusNode _focusNode = FocusNode();
  String? _errorMessage = "";
  bool _isObscureVisible = false;

  @override
  void initState() {
    super.initState();

    // Si el controller es proporcionado desde afuera, lo usamos. Si no, creamos uno local.
    if (widget.controllerText != null) {
      _controller = TextEditingController(text: widget.controllerText);
    } else {
      _controller = TextEditingController();
    }

    // Escuchamos los cambios de foco
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void didUpdateWidget(covariant CustomInputText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controllerText != null &&
        widget.controllerText != oldWidget.controllerText) {
      _controller ??= TextEditingController(text: widget.controllerText);
      _controller!.value = _controller!.value.copyWith(
        text: widget.controllerText,
        selection: TextSelection.fromPosition(
          TextPosition(offset: widget.controllerText?.length ?? 0),
        ),
      );
    }
  }

  // Método para manejar el cambio de foco
  void _onFocusChange() {
    if (!_focusNode.hasFocus) {
      // Si pierde el foco
      if (widget.validator != null) {
        final error = widget.validator!(_controller?.text ?? '');
        if (mounted) {
          setState(() {
            _errorMessage = error;
          });
        }
      }
    }
  }

  String _applyMask(String text, String? pattern) {
    if (pattern == null || pattern.isEmpty) {
      return text;
    }
    
    // Remove all non-alphanumeric characters for processing (allow letters and numbers)
    String alphanumericOnly = text.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '');
    String masked = '';
    int charIndex = 0;
    
    for (int i = 0; i < pattern.length && charIndex < alphanumericOnly.length; i++) {
      if (pattern[i] == '#') {
        masked += alphanumericOnly[charIndex];
        charIndex++;
      } else {
        masked += pattern[i];
      }
    }
    
    return masked;
  }

  void _onChangedHandler(String value) {
    String processedValue = value;
    
    // Apply mask if pattern is provided
    if (widget.maskPattern != null) {
      processedValue = _applyMask(value, widget.maskPattern);
      if (_controller != null && _controller!.text != processedValue) {
        final selection = _controller!.selection;
        _controller!.value = TextEditingValue(
          text: processedValue,
          selection: TextSelection.collapsed(
            offset: processedValue.length,
          ),
        );
        // Try to restore cursor position
        if (selection.isValid && selection.end <= processedValue.length) {
          _controller!.selection = selection;
        }
      }
    }
    
    if (widget.onChanged != null) {
      _errorMessage = "";
      widget.onChanged!(processedValue);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    _focusNode.dispose(); // Liberamos el FocusNode
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            if (!_focusNode.hasFocus && !widget.readOnly) {
              _focusNode.requestFocus();
            }
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 56.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
              color: Colors.grey[200],
            ),
            child: Padding(
              padding: EdgeInsets.only(
                left: 16.w,
                right: 0,
                top: 4.h,
                bottom: 4.h,
              ),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        child: RichText(
                          text: TextSpan(
                            text: widget.title,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12.sp,
                            ),
                            children: widget.isRequired
                                ? [
                                    const TextSpan(
                                      text: ' *',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ]
                                : [],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.only(bottom: 7.h),
                          child: TextFormField(
                            readOnly: widget.readOnly,
                            controller: _controller ??
                                TextEditingController(),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              isDense: true,
                            ),
                            focusNode: _focusNode,
                            onChanged: _onChangedHandler,
                            obscureText: widget.isObscureText && !_isObscureVisible,
                            style: TextStyle(
                              color: widget.isObscureText && _isObscureVisible
                                  ? Colors.grey
                                  : Colors.black,
                              fontSize: 16.sp,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (widget.iconCardLogin != null)
                    Positioned(
                      top: 9.h,
                      right: 10.w,
                      child: GestureDetector(
                        onTap: () async {
                          if (widget.iconCalendar) {
                            DateTime? selectedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime.now(),
                            );
                            if (selectedDate != null) {
                              String formattedDate =
                                  DateFormat('yyyy-MM-dd').format(selectedDate);
                              _controller?.text = formattedDate;
                              _onChangedHandler(formattedDate);
                            }
                          } else {
                            setState(() {
                              _isObscureVisible = !_isObscureVisible;
                            });
                          }
                        },
                        child: widget.iconCardLogin,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        if (_errorMessage != null && _errorMessage!.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(
              left: 16.w,
              top: 4.h,
            ),
            child: Text(
              _errorMessage!,
              style: TextStyle(color: Colors.red, fontSize: 11.sp),
            ),
          ),
        if (_errorMessage == null && widget.successMessage != null)
          Padding(
            padding: EdgeInsets.only(
              left: 16.w,
              top: 4.h,
            ),
            child: Text(
              widget.successMessage!,
              style: TextStyle(
                color: Colors.green,
                fontSize: 11.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
      ],
    );
  }
}
