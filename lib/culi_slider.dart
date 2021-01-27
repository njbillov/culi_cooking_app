import 'package:flutter/material.dart';

import 'theme.dart';

class CuliSlider extends StatefulWidget {
  final Function(double) sliderUpdate;
  final double min;
  final double max;
  final String leftHint;
  final String rightHint;
  final int initialValue;

  int get ticks => max.round() - min.round();

  int get startingValue => initialValue ?? ticks - 2;

  CuliSlider(
      {Key key,
      this.sliderUpdate,
      @required this.min,
      @required this.max,
      this.leftHint = '',
      this.rightHint = '',
      this.initialValue,
      })
      : super(key: key);

  @override
  _CuliSliderState createState() => _CuliSliderState();
}

class _CuliSliderState extends State<CuliSlider> {
  double _currentSliderValue;

  @override
  void initState() {
    super.initState();
    _currentSliderValue = widget.startingValue.toDouble();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final leftSize = (TextPainter(
          text: TextSpan(
              text: widget.leftHint,
              style: Theme.of(context).textTheme.bodyText1),
          maxLines: 1,
          textScaleFactor: MediaQuery.of(context).textScaleFactor,
          textDirection: TextDirection.ltr,
        )..layout())
            .size
            .width /
        size.width;
    // print(leftSize);

    final rightSize = (TextPainter(
                text: TextSpan(
                    text: widget.rightHint,
                    style: Theme.of(context).textTheme.bodyText1),
                maxLines: 1,
                textScaleFactor: MediaQuery.of(context).textScaleFactor,
                textDirection: TextDirection.ltr)
              ..layout())
            .size
            .width /
        size.width;
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(19.0),
            child: Row(
              children: [
                Expanded(child: Container()),
                Expanded(
                  flex: widget.max.round(),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          height: 25,
                          width: 5,
                          decoration: BoxDecoration(
                              color: Culi.black,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(2))),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          height: 25,
                          width: 5,
                          decoration: BoxDecoration(
                              color: Culi.black,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(2))),
                        ),
                      ),
                      SliderTheme(
                        data: SliderThemeData(
                          thumbColor: Culi.coral,
                          activeTrackColor: Culi.black,
                          inactiveTrackColor: Culi.black,
                          activeTickMarkColor: Culi.black,
                          inactiveTickMarkColor: Culi.black,
                          overlayColor: Culi.black,
                          thumbShape: RoundSliderThumbShape(
                            enabledThumbRadius: 21,
                          ),
                          trackShape: CustomTrackShape(),
                        ),
                        child: Slider(
                          value: _currentSliderValue,
                          min: widget.min,
                          max: widget.max,
                          divisions: widget.ticks,
                          label: _currentSliderValue.round().toString(),
                          onChanged: (value) {
                            setState(() {
                              _currentSliderValue = value;
                              widget.sliderUpdate(value);
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(child: Container()),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(0.0),
            child: Column(
              children: [
                Row(children: <Widget>[
                  Expanded(child: Container()),
                  for (double i = 0; i <= widget.ticks; ++i)
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _currentSliderValue = widget.min + i;
                            widget.sliderUpdate(_currentSliderValue);
                          });
                        },
                        child: Align(
                          alignment: AlignmentGeometry.lerp(
                              Alignment.centerLeft,
                              Alignment.centerRight,
                              i / widget.ticks),
                          child: Container(
                            // alignment: Alignment.center,
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: _currentSliderValue == (widget.min + i)
                                  ? Culi.black
                                  : Colors.white,
                              border: Border.all(
                                  color: _currentSliderValue == (widget.min + i)
                                      ? Culi.black
                                      : Colors.black12),
                              shape: BoxShape.circle,
                            ),
                            child: Text((widget.min + i).round().toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .headline3
                                    .copyWith(
                                        color: _currentSliderValue ==
                                                (widget.min + i)
                                            ? Colors.white
                                            : Culi.black),
                                textAlign: TextAlign.center),
                          ),
                        ),
                      ),
                    ),
                  Expanded(child: Container()),
                ]),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Container(
                    width: size.width,
                    child: Stack(children: [
                      Align(
                          alignment:
                              FractionalOffset(1 / (widget.ticks + 2), 1),
                          child: VerticalDivider(
                            thickness: 1,
                          )),
                      Align(
                          alignment: FractionalOffset(
                              1 / (widget.ticks + 2) - leftSize / 2, 1),
                          child: Text(widget.leftHint,
                              style: Theme.of(context).textTheme.bodyText1)),
                      Align(
                          alignment: FractionalOffset(
                              (widget.ticks + 1) / (widget.ticks + 2) +
                                  rightSize / 2,
                              1),
                          child: Text(widget.rightHint,
                              style: Theme.of(context).textTheme.bodyText1)),
                    ]),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class CustomTrackShape extends RoundedRectSliderTrackShape {
  Rect getPreferredRect({
    @required RenderBox parentBox,
    Offset offset = Offset.zero,
    @required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final trackHeight = sliderTheme.trackHeight;
    final trackLeft = offset.dx;
    final trackTop = offset.dy + (parentBox.size.height - trackHeight) / 2;
    final trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}
