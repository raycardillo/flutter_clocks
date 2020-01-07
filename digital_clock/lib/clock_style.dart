/*
 * A clock face UI for the Lenovo Smart Clock.
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

const _timeTextFontMultiplier = 0.26;
const _dateTextFontMultiplier = _timeTextFontMultiplier * 0.28;
const _weatherTextFontMultiplier = _timeTextFontMultiplier * 0.56;

class ClockStyle {
  final Size mediaSize;

  final Color backgroundColor;
  final Color textBackground;
  final Color textForeground;

  final TextStyle bgTimeTextStyle;
  final TextStyle fgTimeTextStyle;

  final TextStyle bgDateTextStyle;
  final TextStyle fgDateTextStyle;

  final TextStyle bgWeatherTextStyle;
  final TextStyle fgWeatherTextStyle;

  ClockStyle(
      {@required mediaSize,
      @required backgroundColor,
      @required textForegroundColor,
      @required textBackgroundColor})
      : this.mediaSize = mediaSize,
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
        bgWeatherTextStyle = TextStyle(
          color: textBackgroundColor,
          fontFamily: 'DSEGWeather',
          fontSize: mediaSize.width * _weatherTextFontMultiplier,
        ),
        fgWeatherTextStyle = TextStyle(
          color: textForegroundColor,
          fontFamily: 'DSEGWeather',
          fontSize: mediaSize.width * _weatherTextFontMultiplier,
        );

  static var _lightClockStyle;

  factory ClockStyle.light(Size mediaSize) {
    return _lightClockStyle ??= ClockStyle(
      mediaSize: mediaSize,
      backgroundColor: Color(0xFF00FF66),
      textBackgroundColor: Color(0x10000000),
      textForegroundColor: Color(0xFF000000),
    );
  }

  static var _darkClockStyle;

  factory ClockStyle.dark(Size mediaSize) {
    return _darkClockStyle ??= ClockStyle(
      mediaSize: mediaSize,
      backgroundColor: Color(0xFF282828),
      textBackgroundColor: Color(0x1041FF00),
      textForegroundColor: Color(0xBB41FF00),
    );
  }
}
