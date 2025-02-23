import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../constants/app_constants.dart';
import '../../constants/app_spaces.dart';
import '../loader/custom_circular_loader.dart';
import 'custom_inkwell.dart';

class TappableText extends StatelessWidget {
  final bool isLoading;
  final String text;
  final TextStyle? style;
  final VoidCallback onTap;
  final EdgeInsets padding;
  final Widget? leading;
  final Widget? trailing;
  final Widget? loader;
  const TappableText({
    super.key,
    required this.text,
    required this.onTap,
    this.style,
    this.padding = const EdgeInsets.all(AppConstants.gesturePadding),
    this.isLoading = false,
    this.leading,
    this.trailing,
    this.loader,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return loader ??
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 4),
            child: CustomCircularLoader(size: 22),
          );
    }
    return Skeleton.unite(
      child: CustomInkWell(
        onTap: () => onTap.call(),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (leading != null) ...[
              leading!,
              AppSpaces.verySmallWidth,
            ],
            Padding(
              padding: padding,
              child: Text(
                text,
                style: style,
              ),
            ),
            if (trailing != null) ...[
              AppSpaces.verySmallWidth,
              trailing!,
            ],
          ],
        ),
      ),
    );
  }
}
