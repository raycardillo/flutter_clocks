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

import 'package:digital_clock/clock_style.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_clock_helper/model.dart';

class WeatherWidget extends StatefulWidget {
  const WeatherWidget(this.clockStyle, this.weatherCondition);

  final WeatherCondition weatherCondition;
  final ClockStyle clockStyle;

  @override
  _WeatherWidgetState createState() => _WeatherWidgetState();
}

class _WeatherWidgetState extends State<WeatherWidget> {
  String _stringFromCondition(WeatherCondition condition) {
    switch (condition) {
      case WeatherCondition.cloudy:
        return '9'; // (SUN AND CLOUD)
        break;
      case WeatherCondition.foggy:
        return '2'; // (CLOUD)
        break;
      case WeatherCondition.rainy:
        return '3'; // (RAIN)
        break;
      case WeatherCondition.snowy:
        return '5'; // (SNOW)
        break;
      case WeatherCondition.sunny:
        return '1'; // (SUN)
        break;
      case WeatherCondition.thunderstorm:
        return '7'; // (THUNDER HARD RAIN)
        break;
      case WeatherCondition.windy:
        return '4'; // (HARD RAIN)
        break;
    }
    return ':';
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Text(
          '0',
          style: widget.clockStyle.bgWeatherTextStyle,
        ),
        Text(
          _stringFromCondition(widget.weatherCondition),
          style: widget.clockStyle.fgWeatherTextStyle,
        ),
      ],
    );
  }
}
