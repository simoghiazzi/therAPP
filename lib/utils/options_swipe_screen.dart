import 'package:flutter/material.dart';
import 'package:therAPP/views/Utils/custom_sizer.dart';

class TinderCard extends StatefulWidget {
  final Map<String, dynamic> option;
  final Function(String) onSwipe;
  final Function() onReset;

  const TinderCard({
    Key? key,
    required this.option,
    required this.onSwipe,
    required this.onReset,
  }) : super(key: key);

  @override
  _TinderCardState createState() => _TinderCardState();
}

class _TinderCardState extends State<TinderCard> {
  Offset _offset = Offset.zero;

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      _offset += details.delta;
    });
  }

  void _onPanEnd(DragEndDetails details) {
    if (_offset.dx > 100) {
      // Swiped right
      widget.onSwipe(widget.option['slides'][0]);
    } else if (_offset.dx < -100) {
      // Swiped left
      widget.onSwipe(widget.option['slides'][1]);
    }
    setState(() {
      _offset = Offset.zero;
    });
  }

  void _resetCard() {
    widget.onReset();
    setState(() {}); // Trigger a rebuild to update the card's color immediately
  }

  @override
  Widget build(BuildContext context) {
    String value = widget.option['value'];
    Color cardColor = value == widget.option['slides'][0]
        ? Colors.green.shade100
        : value == widget.option['slides'][1]
            ? Colors.red.shade100
            : Colors.white;
    Color borderColor = value == widget.option['slides'][0]
        ? Colors.green[800]!
        : value == widget.option['slides'][1]
            ? Colors.red[800]!
            : Colors.black;

    return Column(children: [
      GestureDetector(
        onPanUpdate: _onPanUpdate,
        onPanEnd: _onPanEnd,
        onLongPress: _resetCard, // Call the _resetCard function on long press
        child: Transform.translate(
          offset: _offset,
          child: Container(
            height: 150,
            width: 250,
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: borderColor, width: 2),
            ),
            child: Center(
              child: Text(
                widget.option['name'],
                style: TextStyle(fontSize: 10.sp, color: Colors.black),
                textAlign: TextAlign.center, // Center the text horizontally
              ),
            ),
          ),
        ),
      ),
      SizedBox(
        height: (MediaQuery.of(context).orientation == Orientation.portrait)
            ? 5.h
            : 4.h,
      )
    ]);
  }
}

class OptionsSwipeScreen extends StatelessWidget {
  final List<Map<String, dynamic>> options;

  const OptionsSwipeScreen({Key? key, required this.options}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: options
          .map(
            (option) => TinderCard(
              option: option,
              onSwipe: (value) {
                // Implement your logic to update the value here
                option['value'] = value;
              },
              onReset: () {
                option['value'] = "";
              },
            ),
          )
          .toList(),
    );
  }
}
