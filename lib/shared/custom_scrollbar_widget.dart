import 'package:flutter/material.dart';

class MyScrollbar extends StatefulWidget {
  final ScrollableWidgetBuilder builder;
  final ScrollController? scrollController;
  final double? thickness;
  final Color? thumbColor, trackColor;
  final Animation<double>? fadeoutOpacityAnimation;

  const MyScrollbar(
      {Key? key,
      this.scrollController,
      required this.builder,
      this.thickness,
      this.thumbColor,
      this.trackColor,
      this.fadeoutOpacityAnimation})
      : assert(builder != null),
        super(key: key);

  @override
  _MyScrollbarState createState() => _MyScrollbarState();
}

class _MyScrollbarState extends State<MyScrollbar> {
  ScrollbarPainter? _scrollbarPainter;
  ScrollController? _scrollController;
  Orientation? _orientation;

  @override
  void initState() {
    super.initState();
    _scrollController = widget.scrollController ?? ScrollController();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _updateScrollPainter(_scrollController!.position);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scrollbarPainter = _buildMaterialScrollbarPainter();
  }

  @override
  void dispose() {
    _scrollbarPainter?.dispose();
    super.dispose();
  }

  ScrollbarPainter _buildMaterialScrollbarPainter() {
    return ScrollbarPainter(
      color: widget.thumbColor ?? Colors.black.withOpacity(0.5),
      trackColor: widget.trackColor ?? Colors.transparent,
      textDirection: Directionality.of(context),
      radius: Radius.circular(20),
      thickness: widget.thickness ?? 3,
      padding: EdgeInsets.zero,
      fadeoutOpacityAnimation: widget.fadeoutOpacityAnimation ??
          const AlwaysStoppedAnimation<double>(1.0),
    );
  }

  bool _updateScrollPainter(ScrollMetrics position) {
    _scrollbarPainter?.update(
      position,
      position.axisDirection,
    );
    return false;
  }

  @override
  void didUpdateWidget(MyScrollbar oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateScrollPainter(_scrollController!.position);
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        _orientation ??= orientation;
        if (orientation != _orientation) {
          _orientation = orientation;
          _updateScrollPainter(_scrollController!.position);
        }
        return NotificationListener<ScrollNotification>(
          onNotification: (notification) =>
              _updateScrollPainter(notification.metrics),
          child: CustomPaint(
            painter: _scrollbarPainter,
            child: widget.builder(context, _scrollController!),
          ),
        );
      },
    );
  }
}
