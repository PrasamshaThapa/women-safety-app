import 'package:flutter/material.dart';

import '../../constants/app_constants.dart';
import '../../constants/app_spaces.dart';
import '../loader/custom_circular_loader.dart';

class CustomRefresher extends StatefulWidget {
  final ScrollController? scrollController;
  final Widget? child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onRefresh;
  final VoidCallback? onLoad;
  final bool canPaginate;
  final bool isPaginationLoading;
  const CustomRefresher({
    super.key,
    this.scrollController,
    this.child,
    this.padding,
    this.onRefresh,
    this.onLoad,
    this.canPaginate = false,
    this.isPaginationLoading = false,
  });

  @override
  State<CustomRefresher> createState() => _CustomRefresherState();
}

class _CustomRefresherState extends State<CustomRefresher> {
  @override
  void initState() {
    super.initState();
    if (widget.scrollController != null && widget.onLoad != null) {
      widget.scrollController!.addListener(_handleScrollController);
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    return RefreshIndicator.adaptive(
      onRefresh: () async => widget.onRefresh?.call(),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: height,
          maxHeight: height,
        ),
        child: SingleChildScrollView(
          controller: widget.scrollController,
          padding: widget.padding,
          physics: const AlwaysScrollableScrollPhysics(
            parent: AppConstants.physics,
          ),
          child: Column(
            children: [
              widget.child ?? const SizedBox(),
              if (widget.canPaginate && widget.isPaginationLoading) ...[
                AppSpaces.medium,
                const CustomCircularLoader(size: 15),
              ],
              AppSpaces.medium,
            ],
          ),
        ),
      ),
    );
  }

  void _handleScrollController() {
    final scrollPosition = widget.scrollController!.position;
    if ((scrollPosition.pixels >= scrollPosition.maxScrollExtent * .95) &&
        !scrollPosition.outOfRange &&
        widget.canPaginate &&
        !widget.isPaginationLoading) {
      widget.onLoad?.call();
    }
  }
}
