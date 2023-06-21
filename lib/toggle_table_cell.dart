import 'package:flutter/material.dart';

class ToggleTableCell extends StatefulWidget {
  const ToggleTableCell({super.key});

  @override
  _ToggleTableCellState createState() => _ToggleTableCellState();
}

class _ToggleTableCellState extends State<ToggleTableCell> {
  bool _isIn = true;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isIn = !_isIn;
        });
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(1, 10, 1, 1),
        child: Center(
          child: Text(
            _isIn ? 'In' : 'Out',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: _isIn
                  ? Colors.black
                  : const Color.fromARGB(
                      255, 15, 6, 188), // Set the color based on _isIn value
            ),
          ),
        ),
      ),
    );
  }
}
