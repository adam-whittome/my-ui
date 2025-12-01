import 'package:flutter/widgets.dart';

class Popover extends StatefulWidget {
  final Widget child;
  final AxisDirection preferredDirection;

  const Popover({super.key, required this.child, this.preferredDirection = AxisDirection.down});

  @override
  State<Popover> createState() => _PopoverState();
}

class _PopoverState extends State<Popover> {
  bool shown = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Stack(
        clipBehavior: Clip.none,
        children: [Positioned(
          left: widget.preferredDirection == AxisDirection.right ? constraints.maxWidth : null,
          right: widget.preferredDirection == AxisDirection.left ? constraints.maxWidth : null,
          top: widget.preferredDirection == AxisDirection.down ? constraints.maxHeight : null,
          bottom: widget.preferredDirection == AxisDirection.up ? constraints.maxHeight : null,
          child: widget.child
        )],
      )
    );
  }
}