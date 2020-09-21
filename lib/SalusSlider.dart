import 'package:flutter/material.dart';

import 'Theme.dart';

class SalusSlider extends StatefulWidget {
  Function(double) sliderUpdate;
  double min;
  double max;
  int ticks;

  SalusSlider({Key key, Function(double) this.sliderUpdate, this.min, this.max, this.ticks}) : super(key: key);

  @override
  _SalusSliderState createState() => _SalusSliderState();
}

class _SalusSliderState extends State<SalusSlider> {
  double _currentSliderValue = 1;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          SliderTheme(
            data: SliderThemeData(
              thumbColor: Salus.lightGreen,
              activeTrackColor: Salus.sliderTickColor,
              inactiveTrackColor: Salus.sliderTickColor,
              thumbShape: RoundSliderThumbShape(
                enabledThumbRadius: 14.5,
              )
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

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                    child: Text(widget.min.toString(), style: Theme.of(context).textTheme.headline5, textAlign: TextAlign.left)
                ),
                for(int i = 0; i < widget.ticks - 1; ++i) Expanded(
                  child: Container(
                    width: 13,
                    height: 13,
                    decoration: BoxDecoration(
                      color: Salus.lightGreen,
                      shape: BoxShape.circle,
                    )
                  )
                ),
                Expanded(
                  flex: 1,
                    child: Text(widget.max.toString(), style: Theme.of(context).textTheme.headline5, textAlign: TextAlign.right)
                ),
              ]
            ),
          )
        ],
      ),
    );
  }
}

