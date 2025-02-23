import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_constants.dart';
import '../../constants/text_styles.dart';

class CustomDropdownInput<T> extends StatelessWidget {
  final String label;
  final FormFieldValidator<dynamic>? validator;
  final Widget? prefix;
  final VoidCallback? onSelect;
  final void Function(T)? onChanged;
  final List<DropdownMenuItem> items;
  final List<Widget>? selectedItemBuilder;
  final T value;
  final String hint;
  final bool isOptional;
  final bool isDisabled;
  final String? errorText;

  const CustomDropdownInput({
    super.key,
    required this.label,
    this.validator,
    this.prefix,
    this.onSelect,
    this.onChanged,
    required this.items,
    this.selectedItemBuilder,
    this.hint = "",
    required this.value,
    this.isOptional = false,
    this.isDisabled = false,
    this.errorText,
  });

  bool get _isRequired => validator != null || !isOptional;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // if (label.isNotEmpty) ...[
        //   Text(
        //     (label.isNotEmpty) ? '$label${_isRequired ? ' *' : ''}' : '',
        //     style: TextStyles.regular16.copyWith(
        //       color: AppColors.label,
        //     ),
        //   ),
        //   AppSpaces.small,
        // ],
        DropdownButtonFormField(
          onTap:
              isDisabled
                  ? () {
                    if (onSelect != null) {
                      onSelect!();
                    }
                  }
                  : null,
          isExpanded: true,
          menuMaxHeight: size.height * .5,
          selectedItemBuilder:
              selectedItemBuilder != null
                  ? (context) => selectedItemBuilder!
                  : null,
          items: items,
          value: value,
          onChanged: (value) {
            if (onChanged != null) {
              onChanged!(value);
            }
          },
          dropdownColor: AppColors.white,
          style: TextStyles.regular14.copyWith(color: AppColors.lightText),
          decoration: InputDecoration(
            labelText: label,
            hintText: hint,
            labelStyle: TextStyles.regular14.copyWith(
              color: AppColors.border.withOpacity(0.6),
            ),
            hintStyle: TextStyles.regular14.copyWith(
              color: AppColors.border.withOpacity(0.6),
            ),
            errorText: errorText,
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
          ),
          validator: isOptional ? null : validator,
        ),
      ],
    );
  }
}

class CustomDropdownMenuItem<T> extends StatelessWidget
    implements DropdownMenuItem {
  final T itemValue;
  final String? title;
  final bool isEnabled;
  const CustomDropdownMenuItem({
    super.key,
    required this.itemValue,
    required this.title,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownMenuItem(value: value, enabled: enabled, child: child);
  }

  @override
  AlignmentGeometry get alignment => Alignment.centerLeft;

  @override
  Widget get child => Text(
    title ?? '',
    style: TextStyles.regular14.copyWith(
      color: AppColors.lightText,
      fontFamily: AppConstants.poppins,
    ),
  );

  @override
  bool get enabled => isEnabled;

  @override
  VoidCallback? get onTap => null;

  @override
  get value => itemValue;
}

class SelectedDropdownItem extends StatelessWidget {
  final String? title;
  const SelectedDropdownItem({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title ?? '',
      style: TextStyles.regular14.copyWith(
        color: AppColors.lightText,
        fontFamily: AppConstants.poppins,
      ),
    );
  }
}
