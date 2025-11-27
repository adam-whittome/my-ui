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
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: style.borderColor,
          shape: BoxShape.circle
        )
      )
    );
  }
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

  @override
  Widget build(BuildContext context) {
    final SliderStyle style;
    if (widget.style == null) {
      style = Provider.of<Theme>(context).sliderStyle;
    } else {
      style = widget.style!;
    }
    return LayoutBuilder(
      builder:(context, constraints) => Stack(
        alignment: AlignmentGeometry.center,
        children: [
          Positioned(
            left: ratio * constraints.maxWidth,
            child: widget.handle
          ),
          Positioned.fill(
            child: Align(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: widget.height),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: style.colorRightOfHandle,
                    border: BoxBorder.all(
                      color: style.borderColor,
                      width: style.borderWidth
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(widget.height / 2))
                  ),
                )
              )
            )
          )
        ],
      )
    );
  }
}