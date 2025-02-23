import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_constants.dart';
import '../../constants/app_spaces.dart';
import '../../constants/text_styles.dart';
import '../../helpers/debouncer.dart';

enum InputType { positiveInteger, positiveDouble, text }

class CustomInput extends StatefulWidget {
  final String label;
  final String hint;
  final TextEditingController? controller;
  final String? initialValue;
  final TextInputType textInputType;
  final bool isPassword;
  final FormFieldValidator<String>? validator;
  final Widget? suffix;
  final Widget? prefix;
  final bool readOnly;
  final bool isDisabled;
  final VoidCallback? onTap;
  final int? maxLines;
  final int? minLines;
  final Function(String)? onSubmit;
  final Function(String)? onChanged;
  final bool centerContent;
  final int? maxLength;
  final bool alignLabelWithHint;
  final bool useDebouncer;
  final TextInputAction? textInputAction;
  final String? errorText;
  final InputType inputType;
  const CustomInput({
    super.key,
    this.label = '',
    this.hint = '',
    this.controller,
    this.initialValue,
    this.textInputType = TextInputType.text,
    this.isPassword = false,
    this.validator,
    this.prefix,
    this.suffix,
    this.readOnly = false,
    this.isDisabled = false,
    this.onTap,
    this.maxLines,
    this.minLines,
    this.onSubmit,
    this.onChanged,
    this.centerContent = false,
    this.maxLength,
    this.alignLabelWithHint = false,
    this.useDebouncer = false,
    this.textInputAction,
    this.errorText,
    this.inputType = InputType.text,
  });

  @override
  State<CustomInput> createState() => _CustomInputState();
}

class _CustomInputState extends State<CustomInput> {
  late bool isObsecureText = widget.isPassword;

  late final bool _isRequired = widget.validator != null;

  final _debouncer = Debouncer();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label.isNotEmpty) ...[
          Text(
            (widget.label.isNotEmpty) ? widget.label : '',
            style: TextStyles.medium16.copyWith(color: AppColors.black),
          ),
          AppSpaces.small,
        ],
        PhysicalModel(
          color: AppColors.transparent,
          shadowColor: AppColors.shadow,
          elevation: 12,
          child: TextFormField(
            controller: widget.controller,
            initialValue: widget.initialValue,
            obscureText: isObsecureText,
            readOnly: widget.readOnly,
            enabled: !widget.isDisabled,
            onTap: () {
              widget.onTap?.call();
            },
            textInputAction: widget.textInputAction ?? TextInputAction.next,
            onChanged: (value) {
              if (widget.useDebouncer) {
                _debouncer.run(() => widget.onChanged?.call(value));
              } else {
                widget.onChanged?.call(value);
              }
            },
            onFieldSubmitted: (value) => widget.onSubmit?.call(value),
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.white,
              hintText: widget.hint,
              // labelText: widget.label,
              // labelStyle: TextStyles.regular14.copyWith(
              //   color: AppColors.border.withOpacity(0.6),
              // ),
              hintStyle: TextStyles.regular14.copyWith(
                color: AppColors.border.withOpacity(0.6),
              ),
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(AppConstants.borderRadius),
                ),
                borderSide: BorderSide(color: AppColors.border, width: 1),
              ),
              enabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(AppConstants.borderRadius),
                ),
                borderSide: BorderSide(color: AppColors.border, width: 1),
              ),
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(AppConstants.borderRadius),
                ),
                borderSide: BorderSide(color: AppColors.primary, width: 1),
              ),
              errorBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(AppConstants.borderRadius),
                ),
                borderSide: BorderSide(color: AppColors.danger, width: 1),
              ),
              focusedErrorBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(AppConstants.borderRadius),
                ),
                borderSide: BorderSide(color: AppColors.danger, width: 1),
              ),
              errorText: widget.errorText,
              prefixIcon: widget.prefix,
              suffixIcon:
                  widget.suffix ??
                  (widget.isPassword
                      ? IconButton(
                        onPressed: () {
                          setState(() {
                            isObsecureText = !isObsecureText;
                          });
                        },
                        icon:
                            isObsecureText
                                ? const Icon(
                                  Icons.visibility_off_outlined,
                                  color: AppColors.border,
                                )
                                : const Icon(
                                  Icons.visibility_outlined,
                                  color: AppColors.border,
                                ),
                        iconSize: 20,
                      )
                      : null),
              errorMaxLines: 3,
            ),
            inputFormatters: [
              // ** Restricting Emoji
              FilteringTextInputFormatter.deny(
                RegExp(
                  '(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])',
                ),
              ),
              if (widget.inputType == InputType.positiveInteger) ...[
                FilteringTextInputFormatter.deny(RegExp(r'[-,. ]')),
              ] else if (widget.inputType == InputType.positiveDouble) ...[
                FilteringTextInputFormatter.deny(RegExp(r'[-, ]')),
              ],
            ],
            textAlign:
                widget.centerContent ? TextAlign.center : TextAlign.start,
            maxLength: widget.maxLength,
            cursorColor: AppColors.primary,
            keyboardType: widget.textInputType,
            style: TextStyles.regular14.copyWith(
              color:
                  widget.isDisabled ? AppColors.veryLightText : AppColors.black,
            ),
            minLines: widget.minLines,
            maxLines: widget.isPassword ? 1 : widget.maxLines,
            validator: widget.validator,
          ),
        ),
      ],
    );
  }
}
