import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';

import 'Theme.dart';

class HorizontalCardList extends StatefulWidget {
  final List<Widget> children;
  final Color color;
  final Color shadowColor;
  final double height;

  const HorizontalCardList({Key key, @required this.children, this.color = Colors.transparent, this.shadowColor = Colors.transparent, this.height}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HorizontalCardListState();
}

class _HorizontalCardListState extends State<HorizontalCardList> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: widget.height,
          child: PageView.builder(
              itemCount: widget.children.length,
              controller: PageController(viewportFraction: 1.0),
              onPageChanged: (int index) => setState(() => _index = index),
              itemBuilder: (_, i) {
                return Transform.scale(
                  scale: 1,
                  child: Card(
                    shadowColor: widget.shadowColor,
                    color: widget.color,
                    elevation: 0,
                    child: Center(
                      child: widget.children[i]
                    ),
                  ),
                );
            }
          )
        ),
        DotsIndicator(
          dotsCount: widget.children.length,
          position: _index * 1.0,
          // onTap: (position) {
          //   setState(() => _index = position as int);
          // },
          decorator: DotsDecorator(
            color: Culi.lightCoral,
            size: const Size.square(13),
            activeColor: Culi.coral,
            activeSize: const Size.square(16),
          ),
        ),
      ]
    );
  }
}