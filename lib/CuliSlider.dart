import 'package:flutter/material.dart';

import 'Theme.dart';

class CuliSlider extends StatefulWidget {
  final Function(double) sliderUpdate;
  final double min;
  final double max;
  int ticks;

  CuliSlider({Key key, this.sliderUpdate, this.min, this.max, this.ticks}) : super(key: key) {
    ticks = max.round() - min.round();
  }

  @override
  _CuliSliderState createState() => _CuliSliderState();
}

class _CuliSliderState extends State<CuliSlider> {
  double _currentSliderValue = 2;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
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
                                color:  Culi.black,
                                borderRadius: BorderRadius.all(Radius.circular(2))
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            height: 25,
                            width: 5,
                            decoration: BoxDecoration(
                                color:  Culi.black,
                                borderRadius: BorderRadius.all(Radius.circular(2))
                            ),
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
                            onChanged: (double value) {
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
            child: Row(
              children: <Widget>[
                Expanded(child: Container()),
                for(double i = 0; i <= widget.ticks; ++i) Expanded(
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _currentSliderValue = widget.min + i;
                      });
                    },
                    child: Container(
                      alignment: AlignmentGeometry.lerp(Alignment.centerLeft, Alignment.centerRight, i / widget.ticks),
                      child: Container(
                        alignment: Alignment.center,
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: _currentSliderValue == (widget.min + i) ? Culi.black : Colors.white,
                          border: Border.all(color: _currentSliderValue == (widget.min + i) ? Culi.black : Colors.black12),
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                            (widget.min + i).round().toString(),
                            style: Theme.of(context).textTheme.headline3.copyWith(color: _currentSliderValue == (widget.min + i) ? Colors.white : Culi.black),
                            textAlign: TextAlign.center),
                      ),
                    ),
                  ),
                ),
                Expanded(child: Container()),
              ]
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
    final double trackHeight = sliderTheme.trackHeight;
    final double trackLeft = offset.dx;
    final double trackTop = offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}