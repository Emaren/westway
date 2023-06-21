import 'package:flutter/material.dart';

class TimelineTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget icon;
  final String details;
  final bool completed;
  final int hoursSpent;

  const TimelineTile({
    required Key key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.details,
    this.completed = false,
    this.hoursSpent = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 12, 10, 5),
      child: Column(
        children: [
          Row(
            children: <Widget>[
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
                    child: Center(child: icon),
                  ),
                ],
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
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
                        subtitle,
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
                        '$hoursSpent hours',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
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

class TextTimelineTile extends StatelessWidget {
  final String title;
  @override
  final Key key;

  const TextTimelineTile({required this.key, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(9, 79, 9, 49),
          child: Text(
            title,
            textAlign: TextAlign.center, // align the text to center
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ),
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
    );
  }
}

class TextTimelineTilea extends StatelessWidget {
  @override
  final Key key;
  final RichText titleWidget;

  const TextTimelineTilea({
    required this.key,
    required this.titleWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(9, 25, 9, 10),
      child: Column(
        children: <Widget>[
          Center(child: titleWidget),
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

class TextTimelineTileb extends StatelessWidget {
  @override
  final Key key;
  final RichText titleWidget;

  const TextTimelineTileb({
    required this.key,
    required this.titleWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(9, 25, 9, 10),
      child: Column(
        children: <Widget>[
          Center(child: titleWidget),
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
