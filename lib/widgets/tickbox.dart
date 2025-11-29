import 'package:my_ui/widgets.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class TickboxStyle {
  final Color unsetColor;
  final Color setColor;
  final Color borderColor;
  final double borderWidth;
  final double borderRadius;

  const TickboxStyle({
    required this.unsetColor,
    required this.setColor,
    required this.borderColor,
    this.borderWidth = 1,
    this.borderRadius = 5
  });
}

class Tickbox extends StatefulWidget {
  final double size;
  final bool initialState;
  final TickboxStyle? style;

  const Tickbox({super.key, required this.size, required this.initialState, this.style});

  @override
  State<Tickbox> createState() => _TickboxState();
}

class _TickboxState extends State<Tickbox> {
  late bool state;

  @override
  void initState() {
    super.initState();
    state = widget.initialState;
  }

  void onClick() {
    setState(() {
      state = !state;
    });
  }

  @override
  Widget build(BuildContext context) {
    final TickboxStyle style;
    if (widget.style == null) {
      style = Provider.of<Theme>(context).tickboxStyle;
    } else {
      style = widget.style!;
    }
    return Clickable(
      changeCursor: false,
      onClickUp: (details) => onClick(),
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: state ? style.setColor : style.unsetColor,
            border: BoxBorder.all(
              color: style.borderColor,
              width: style.borderWidth
            ),
            borderRadius: BorderRadius.circular(style.borderRadius)
          ),
          child: Icon(
            Symbols.check,
            color: style.unsetColor,
            size: widget.size
          ),
        ),
      )
    );
  }
}