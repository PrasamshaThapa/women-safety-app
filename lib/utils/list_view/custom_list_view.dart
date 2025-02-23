import 'package:flutter/widgets.dart';

class CustomListView<T> extends StatelessWidget {
  final ScrollController? controller;
  final Iterable<T>? items;
  final EdgeInsetsGeometry? padding;
  final ScrollPhysics? physics;
  final Widget Function(BuildContext context, int index) itemBuilder;
  final Widget? separator;
  final Widget? emptyWidget;
  final Axis scrollDirection;
  final bool showEmptyWidget;
  const CustomListView({
    super.key,
    this.controller,
    required this.items,
    required this.itemBuilder,
    this.separator,
    this.emptyWidget,
    this.physics,
    this.padding,
    this.scrollDirection = Axis.vertical,
    this.showEmptyWidget = true,
  });

  @override
  Widget build(BuildContext context) {
    if ((items?.isEmpty ?? true) && showEmptyWidget) {
      return SizedBox(
        height: MediaQuery.sizeOf(context).height * .7,
        child: Center(
          child: emptyWidget ?? const Text('No Data'),
        ),
      );
    }
    return ListView.separated(
      controller: controller,
      shrinkWrap: true,
      physics: physics ?? const NeverScrollableScrollPhysics(),
      scrollDirection: scrollDirection,
      padding: padding,
      itemCount: items?.length ?? 0,
      itemBuilder: itemBuilder,
      separatorBuilder: (context, index) =>
          separator ?? const SizedBox.shrink(),
    );
  }
}
