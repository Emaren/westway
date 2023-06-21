import 'package:flutter/material.dart';

import 'timeline_tile.dart';

class ReversedTimelineTile extends StatelessWidget {
  final TimelineTile timelineTile;

  const ReversedTimelineTile({super.key, required this.timelineTile});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: Column(
        children: [
          Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      timelineTile.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 7),
                    ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [
                          Color.fromARGB(255, 65, 65, 65),
                          Color.fromARGB(255, 0, 2, 129),
                          Color.fromARGB(255, 65, 65, 65),
                        ],
                        tileMode: TileMode.mirror,
                      ).createShader(bounds),
                      child: Text(
                        timelineTile.subtitle,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [
                          Color.fromARGB(255, 0, 0, 0),
                          Color.fromARGB(255, 0, 0, 0),
                        ],
                        tileMode: TileMode.mirror,
                      ).createShader(bounds),
                      child: Text(
                        '${timelineTile.hoursSpent} hours',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              Stack(
                children: <Widget>[
                  Container(
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color.fromARGB(255, 0, 150, 8),
                          Color.fromARGB(255, 1, 51, 0),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: Center(child: timelineTile.icon),
                  ),
                  if (timelineTile.completed)
                    const Positioned(
                      bottom: 0,
                      right: 0,
                      child: Icon(Icons.check_circle, color: Colors.green),
                    ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 88, 0, 0),
                  Color.fromARGB(255, 192, 1, 1),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            width: 2.0,
            height: 40.0,
          ),
        ],
      ),
    );
  }
}
