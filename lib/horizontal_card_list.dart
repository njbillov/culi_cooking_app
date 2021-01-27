import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';

import 'theme.dart';

class HorizontalCardList extends StatefulWidget {
  final List<Widget> children;
  final List<Widget> beforeDots;
  final Color color;
  final Color shadowColor;
  final double height;
  final bool dotsOnTop;

  const HorizontalCardList(
      {Key key,
      @required this.children,
      this.color = Colors.transparent,
      this.shadowColor = Colors.transparent,
      this.height,
      this.dotsOnTop = false,
      this.beforeDots = const <Widget>[]})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _HorizontalCardListState();
}

class _HorizontalCardListState extends State<HorizontalCardList> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      if (widget.dotsOnTop) ...widget.beforeDots,
      if (widget.dotsOnTop)
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
      Container(
          height: widget.height * 0.9,
          child: PageView.builder(
              itemCount: widget.children.length,
              controller: PageController(viewportFraction: 1.0),
              onPageChanged: (index) => setState(() => _index = index),
              itemBuilder: (_, i) {
                return Transform.scale(
                  scale: 1,
                  child: Card(
                    shadowColor: widget.shadowColor,
                    color: widget.color,
                    elevation: 0,
                    child: Center(child: widget.children[i]),
                  ),
                );
              })),
      if (!widget.dotsOnTop) ...widget.beforeDots,
      if (!widget.dotsOnTop)
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
    ]);
  }
}
