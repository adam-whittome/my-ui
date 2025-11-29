import 'package:my_ui/widgets.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class Handle extends StatelessWidget {
  final double size;
  final SliderStyle? style;

  const Handle({super.key, required this.size, this.style});

  @override
  Widget build(BuildContext context) {
    final SliderStyle style;
    if (this.style == null) {
      style = Provider.of<Theme>(context).sliderStyle;
    } else {
      style = this.style!;
    }
    return SizedBox(
      width: size,
      height: size,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: style.borderColor,
          shape: BoxShape.circle
        )
      )
    );
  }
}

class HandleLayoutDelegate extends SingleChildLayoutDelegate {
  final double ratio;

  const HandleLayoutDelegate({required this.ratio});

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    return Offset(
      size.width * ratio - childSize.width / 2,
      size.height / 2 - childSize.width / 2
    );
  }

  @override
  bool shouldRelayout(covariant SingleChildLayoutDelegate oldDelegate) => true;
}

enum SlidingState {
  none,
  hovered,
  draggedInRegion,
  draggedOutOfRegion,
}

class Slider extends StatefulWidget {
  final Widget handle;
  final double height;
  final double initialRatio;

  final SliderStyle? style;

  const Slider({super.key, required this.handle, required this.height, this.initialRatio=0, this.style});

  @override
  State<Slider> createState() => _SliderState();
}

class _SliderState extends State<Slider> {
  late double ratio;
  SlidingState state = SlidingState.none;

  @override void initState() {
    super.initState();
    ratio = widget.initialRatio;
  }

  void transitionState(SlidingState to) {
    setState(() {
      state = to;
    });
  }

  void tryTransitionState(SlidingState from, SlidingState to) {
    if (state == from) {
      setState(() {
        state = to;
      });
    }
  }

  void onPanUpdate(DragUpdateDetails details, BoxConstraints constraints) {
    Offset globalPosition = (context.findRenderObject()! as RenderBox).localToGlobal(Offset.zero);
    double targetRatio = (details.globalPosition.dx - globalPosition.dx) / constraints.maxWidth;
    setState(() {
      ratio = targetRatio.clamp(0, 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final SliderStyle style;
    if (widget.style == null) {
      style = Provider.of<Theme>(context).sliderStyle;
    } else {
      style = widget.style!;
    }
    return LayoutBuilder(
      builder: (context, constraints) => SizedBox(
        height: widget.height + 2 * style.borderWidth,
        width: constraints.maxWidth,
        child: GestureDetector(
          onPanStart: (details) => transitionState(SlidingState.draggedInRegion),
          onTapDown:(details) => onPanUpdate(DragUpdateDetails(globalPosition: details.globalPosition), constraints),
          onPanUpdate: (details) => onPanUpdate(details, constraints),
          onPanEnd: (details) {
            tryTransitionState(SlidingState.draggedInRegion, SlidingState.hovered);
            tryTransitionState(SlidingState.draggedOutOfRegion, SlidingState.none);
          },
          child: MouseRegion(
            onEnter: (event) {
              tryTransitionState(SlidingState.none, SlidingState.hovered);
              tryTransitionState(SlidingState.draggedOutOfRegion, SlidingState.draggedInRegion);
            },
            onExit: (event) {
              tryTransitionState(SlidingState.hovered, SlidingState.none);
              tryTransitionState(SlidingState.draggedInRegion, SlidingState.draggedOutOfRegion);
            },
            child: Stack(
              alignment: AlignmentGeometry.center,
              clipBehavior: Clip.none,
              children: [
                SizedBox(
                  height: widget.height,
                  width: constraints.maxWidth,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: style.colorRightOfHandle,
                      border: BoxBorder.all(
                        color: style.borderColor,
                        width: style.borderWidth
                      ),
                      borderRadius: BorderRadius.circular(widget.height / 2)
                    )
                  )
                ),
                ClipRRect(
                  borderRadius: BorderRadiusGeometry.circular(widget.height / 2),
                  child: SizedBox(
                    width: constraints.maxWidth,
                    height: widget.height,
                    child: Align(
                      alignment: AlignmentGeometry.centerLeft,
                      child: SizedBox(
                        width: constraints.maxWidth * ratio,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: style.colorLeftOfHandle,
                            border: BoxBorder.all(
                              color: style.borderColor,
                              width: style.borderWidth
                            ),
                          )
                        )
                      )
                    )
                  )
                ),
                OverflowBox(
                  maxHeight: constraints.maxHeight,
                  child: CustomSingleChildLayout(
                    delegate: HandleLayoutDelegate(ratio: ratio),
                    child: widget.handle
                  ) 
                )
              ],
            )
          )
        )
      )
    );
  }
}