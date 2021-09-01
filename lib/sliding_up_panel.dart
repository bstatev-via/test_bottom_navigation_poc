import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

typedef SlidingPanelBuilder = Widget Function(ScrollController sc);

/// Wrapper for the [SlidingUpPanel] that animates the panel between states.
class SlidingUpPanelStateAnimator extends StatefulWidget {
  const SlidingUpPanelStateAnimator({
    required this.minHeightFactor,
    required this.maxHeightFactor,
    required this.controller,
    required this.builder,
    this.borderRadius = BorderRadius.zero,
    Key? key,
  }) : super(key: key);

  final double minHeightFactor;
  final double maxHeightFactor;
  final PanelController controller;
  final SlidingPanelBuilder builder;
  final BorderRadius borderRadius;

  @override
  _SlidingUpPanelStateAnimatorState createState() =>
      _SlidingUpPanelStateAnimatorState();
}

class _SlidingUpPanelStateAnimatorState
    extends State<SlidingUpPanelStateAnimator> with TickerProviderStateMixin {
  late Animation<double> minHeightAnimation;
  late Animation<double> maxHeightAnimation;
  late AnimationController controller;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _buildAndStartAnimation(widget);
  }

  @override
  void didUpdateWidget(SlidingUpPanelStateAnimator oldWidget) {
    super.didUpdateWidget(oldWidget);

    // widget parameters updated, maybe time to restart animation
    if (oldWidget.minHeightFactor != widget.minHeightFactor ||
        oldWidget.maxHeightFactor != widget.maxHeightFactor) {
      _buildAndStartAnimation(oldWidget);
    }
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: maxHeightAnimation,
        builder: (context, child) => AnimatedBuilder(
          animation: minHeightAnimation,
          builder: (context, child) => SlidingUpPanel(
            borderRadius: widget.borderRadius,
            minHeight: _screenHeight(context) * minHeightAnimation.value,
            maxHeight: _screenHeight(context) * maxHeightAnimation.value,
            panelBuilder: (scrollController) => Navigator(
              onGenerateRoute: (settings) => MaterialPageRoute(
                settings: settings,
                builder: (context) => widget.builder(scrollController),
              ),
            ),
            controller: widget.controller,
          ),
        ),
      );

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _buildAndStartAnimation(SlidingUpPanelStateAnimator oldWidget) {
    minHeightAnimation = Tween<double>(
      begin: oldWidget.minHeightFactor,
      end: widget.minHeightFactor,
    ).animate(controller);

    maxHeightAnimation = Tween<double>(
      begin: oldWidget.maxHeightFactor,
      end: widget.maxHeightFactor,
    ).animate(controller);

    controller.forward(from: 0);
  }
}

double _screenHeight(BuildContext context) =>
    MediaQuery.of(context).size.height;
