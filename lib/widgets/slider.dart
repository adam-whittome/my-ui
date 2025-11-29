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

  @override
  Widget build(BuildContext context) {
    final SliderStyle style;
    if (widget.style == null) {
      style = Provider.of<Theme>(context).sliderStyle;
    } else {
      style = widget.style!;
    }
    return LayoutBuilder(
      builder: (context, constraints) => Stack(
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
          CustomSingleChildLayout(
            delegate: HandleLayoutDelegate(ratio: ratio),
            child: widget.handle
          )
        ],
      )
    );
  }
}