/*
 * Clock faces built in Flutter.
 * Copyright (c) 2020 Raymond Cardillo (dba Cardillo's Creations)
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

/// Configuration helper that defines the clock style.
///
/// NOTE:
/// My goal was to create a realistic "old school LCD clock" look, not just a
/// simple color scheme. I researched the typical old school light
/// wavelengths and used a background texture and border to add to the effect.
///
/// ALSO:
/// See the following link for a good discussion of some of the more typical
/// old school green terminal values: https://superuser.com/a/1206781.
class ClockStyle {
  /// Defines the TIME font size based on a fraction of the media width.
  static const _timeTextFontMultiplier = 0.40;

  /// Defines the DATE font size based on a fraction of the TIME font size.
  static const _dateTextFontMultiplier = _timeTextFontMultiplier * 0.40;

  /// Defines the PERIOD font size based on a fraction of the TIME font size.
  static const _periodTextFontMultiplier = _timeTextFontMultiplier * 0.15;

  /// The media size that the style was based upon.
  final Size mediaSize;

  /// The background color of the display.
  final Color backgroundColor;

  /// The background texture image to overlay on top of [backgroundColor].
  final Widget bgImageTexture;

  /// The text background color that simulates LCD segments that are off.
  final Color textBackground;

  /// The text foreground color that simulates LCD segments that are on.
  final Color textForeground;

  /// The background text style for the time display.
  /// Must be a monospace LCD font using the [textBackground] color.
  final TextStyle bgTimeTextStyle;

  /// The foreground text style for the time display.
  /// Must be a monospace LCD font using the [textForeground] color.
  final TextStyle fgTimeTextStyle;

  /// The background text style for the date display.
  /// Must be a monospace LCD font using the [textBackground] color.
  final TextStyle bgDateTextStyle;

  /// The foreground text style for the date display.
  /// Must be a monospace LCD font using the [textForeground] color.
  final TextStyle fgDateTextStyle;

  /// The background text style for the period display.
  /// Must be a monospace LCD font using the [textBackground] color.
  final TextStyle bgPeriodTextStyle;

  /// The foreground text style for the period display.
  /// Must be a monospace LCD font using the [textForeground] color.
  final TextStyle fgPeriodTextStyle;

  /// Time font size that everything else is scaled against.
  final double timeTextFontSize;

  /// Create a new instance for [mediaSize] with specific colors.
  ClockStyle(
      {@required mediaSize,
      @required backgroundColor,
      @required textForegroundColor,
      @required textBackgroundColor})
      : this.mediaSize = mediaSize,
        this.timeTextFontSize = mediaSize.width * _timeTextFontMultiplier,
        this.backgroundColor = backgroundColor,
        this.textForeground = textForegroundColor,
        this.textBackground = textBackgroundColor,
        bgTimeTextStyle = TextStyle(
          color: textBackgroundColor,
          fontFamily: 'DSEG7Modern',
          fontSize: mediaSize.width * _timeTextFontMultiplier,
        ),
        fgTimeTextStyle = TextStyle(
          color: textForegroundColor,
          fontFamily: 'DSEG7Modern',
          fontSize: mediaSize.width * _timeTextFontMultiplier,
        ),
        bgDateTextStyle = TextStyle(
          color: textBackgroundColor,
          fontFamily: 'DSEG14Modern',
          fontSize: mediaSize.width * _dateTextFontMultiplier,
        ),
        fgDateTextStyle = TextStyle(
          color: textForegroundColor,
          fontFamily: 'DSEG14Modern',
          fontSize: mediaSize.width * _dateTextFontMultiplier,
        ),
        bgPeriodTextStyle = TextStyle(
          color: textBackgroundColor,
          fontFamily: 'DSEG14Modern',
          fontSize: mediaSize.width * _periodTextFontMultiplier,
        ),
        fgPeriodTextStyle = TextStyle(
          color: textForegroundColor.withOpacity(0.80),
          fontFamily: 'DSEG14Modern',
          fontSize: mediaSize.width * _periodTextFontMultiplier,
        ),
        bgImageTexture = Stack(children: <Widget>[
          Opacity(
              opacity: 0.25,
              child: Image.asset(
                'third_party/images/border_grunge.png',
                fit: BoxFit.cover,
              )),
          Opacity(
              opacity: 0.45,
              child: Image.asset(
                'third_party/images/lcd_screen_texture.jpg',
                fit: BoxFit.cover,
              ))
        ]);

  /// Singleton instance of the light mode [ClockStyle].
  static var _lightClockStyle;

  /// A light mode clock style.
  /// Optimized for users with various visibility challenges.
  ///
  /// **ACCESSIBILITY CONSIDERATIONS**
  /// - FONT SELECTION: Large fonts that are easy to read.
  /// - CONTRAST RATIO: Approximately **15:1**.
  factory ClockStyle.light(Size mediaSize) {
    if (_lightClockStyle?.mediaSize == mediaSize) {
      return _lightClockStyle;
    }

    return _lightClockStyle = ClockStyle(
      mediaSize: mediaSize,
      backgroundColor: Color(0xFF00FF66),
      textBackgroundColor: Color(0x10000000),
      textForegroundColor: Color(0xFF000000),
    );
  }

  /// Singleton instance of the dark mode [ClockStyle].
  static var _darkClockStyle;

  /// A dark mode clock style.
  /// Optimized for users with various visibility challenges.
  ///
  /// **ACCESSIBILITY CONSIDERATIONS**
  /// - FONT SELECTION: Large fonts that are easy to read.
  /// - CONTRAST RATIO: Approximately **10:1**.
  factory ClockStyle.dark(Size mediaSize) {
    if (_darkClockStyle?.mediaSize == mediaSize) {
      return _darkClockStyle;
    }

    return _darkClockStyle = ClockStyle(
      mediaSize: mediaSize,
      backgroundColor: Color(0xFF282828),
      textBackgroundColor: Color(0x1041FF00),
      textForegroundColor: Color(0xBB41FF00),
    );
  }
}
