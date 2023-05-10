import 'package:flutter/material.dart';

class ResizableBox extends StatefulWidget {
  const ResizableBox({
    super.key,
    required this.width,
    required this.childLeft,
    required this.childRight,
  });
  final double width;
  final Widget childLeft;
  final Widget childRight;

  @override
  ResizableBoxState createState() => ResizableBoxState();
}

class ResizableBoxState extends State<ResizableBox> {
  double _leftWidth = 0;
  double _rightWidth = 0;

  @override
  void initState() {
    super.initState();
    _leftWidth = widget.width / 2;
    _rightWidth = widget.width / 2;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: _leftWidth,
          child: ConstrainedBox(
            constraints: const BoxConstraints(),
            child: widget.childLeft,
          ),
        ),
        MouseRegion(
          cursor: SystemMouseCursors.resizeLeftRight,
          child: GestureDetector(
            onHorizontalDragUpdate: (details) {
              setState(() {
                if (_rightWidth - details.delta.dx > 0 &&
                    _leftWidth + details.delta.dx > 0) {
                  _leftWidth += details.delta.dx;
                  _rightWidth -= details.delta.dx;
                }
              });
            },
            child: const Icon(Icons.drag_handle),
          ),
        ),
        SizedBox(
          width: _rightWidth,
          child: ConstrainedBox(
            constraints: const BoxConstraints(),
            child: widget.childRight,
          ),
        ),
      ],
    );
  }
}
