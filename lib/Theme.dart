import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Salus {
  static const Color green = Color.fromARGB(255, 108, 158, 79);
  static const Color lightGreen = Color.fromARGB(255, 189, 242, 113);
  static const Color widgetActiveColor = Color.fromARGB(255, 8, 92, 108);
  static const Color widgetInactiveColor = Color.fromRGBO(29, 91, 106, 0.58);
  static const Color sliderTickColor = Color.fromRGBO(29, 91, 106, 1);
  static const Color bodyTextGrey = Color.fromARGB(255, 72, 72, 72);
  static const Color headerTextBlue = Color.fromARGB(255, 47, 72, 88);
  static const Color buttonBackground = Color.fromARGB(255, 204, 221, 221);
  static const Color backgroundWhite = Color.fromRGBO(229, 229, 229, 0.43);

  static const double letterSpacing = -0.3;

  static TextTheme textTheme = TextTheme(
      headline1: GoogleFonts.poppins(fontSize: 18.0, fontWeight: FontWeight.bold, color: Salus.headerTextBlue, letterSpacing: letterSpacing),
      headline2: GoogleFonts.poppins(fontSize: 24.0, fontWeight: FontWeight.bold, color: Salus.green, letterSpacing: letterSpacing),
      headline3: GoogleFonts.poppins(fontSize: 20.0, fontWeight: FontWeight.normal, color: Salus.headerTextBlue, letterSpacing: letterSpacing),
      headline4: GoogleFonts.poppins(fontSize: 20.0, fontWeight: FontWeight.bold, color: Salus.widgetActiveColor, letterSpacing: letterSpacing),
      headline5: GoogleFonts.comfortaa(fontSize: 36.0, fontWeight: FontWeight.normal, color: Salus.sliderTickColor, letterSpacing: letterSpacing),
      headline6: GoogleFonts.poppins(fontSize: 18.0, fontWeight: FontWeight.normal, color: Colors.black, letterSpacing: letterSpacing),
      bodyText1: GoogleFonts.poppins(fontSize: 14.0, color: Salus.bodyTextGrey, letterSpacing: letterSpacing),
  );


}

// class SalusSlider extends StatefulWidget {
//   final num min;
//   final num max;
//   final int ticks;
//
//   SalusSlider({Key key, this.min, this.max, this.ticks}) : super(key: key);
//
//   @override
//   _SalusSliderState createState() => _SalusSliderState().._value = min;
// }
//
// class _SalusSliderState extends State<SalusSlider> {
//   double _value = 0.0;
//   @override
//   Widget build(BuildContext context) {
//     return Slider(
//       value: _value,
//       min: widget.min,
//       max: widget.max,
//       divisions: widget.ticks,
//       label: _value.round().toString(),
//       onChanged: (double value) {
//         setState(() {
//           _value = value;
//         });
//       }
//     );
//   }
// }

