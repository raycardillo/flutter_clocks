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

import 'dart:async';

import 'package:digital_clock/clock_style.dart';
import 'package:digital_clock/weather_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:intl/intl.dart';

const _bgDateString = '~~~~-~~-~~      ~~~';
const _fgDateFormat = 'yyyy-MM-dd      EEE';

const _bgTimeString = '88:88';
const _fgTime24OnFormat = 'HH:mm';
const _fgTime12OnFormat = 'hh:mm';
const _fgTime24OffFormat = 'HH mm';
const _fgTime12OffFormat = 'hh mm';

const _secondsPart = '. ';
final _bgSecondsString = (_secondsPart * 59).trimRight();

/// A basic digital clock.
///
/// You can do better than this!
class DigitalClock extends StatefulWidget {
  const DigitalClock(this.model);

  final ClockModel model;

  @override
  _DigitalClockState createState() => _DigitalClockState();
}

class _DigitalClockState extends State<DigitalClock> {
  DateTime _dateTime = DateTime.now();
  Timer _timer;

  @override
  void initState() {
    super.initState();
    widget.model.addListener(_updateModel);
    _updateTime();
    _updateModel();
  }

  @override
  void didUpdateWidget(DigitalClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateModel);
      widget.model.addListener(_updateModel);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.model.removeListener(_updateModel);
    widget.model.dispose();
    super.dispose();
  }

  void _updateModel() {
    setState(() {
      // Cause the clock to rebuild when the model changes.
    });
  }

  void _updateTime() {
    setState(() {
      _dateTime = DateTime.now();

      // Update once per minute. If you want to update every second, use the
      // following code.
//      _timer = Timer(
//        Duration(minutes: 1) -
//            Duration(seconds: _dateTime.second) -
//            Duration(milliseconds: _dateTime.millisecond),
//        _updateTime,
//      );

      // Update once per second, but make sure to do it at the beginning of each
      // new second, so that the clock is accurate.
      _timer = Timer(
        Duration(seconds: 1) - Duration(milliseconds: _dateTime.millisecond),
        _updateTime,
      );
    });
  }

  String _timeString() {
    String timeFormat;
    if (_dateTime.second.isOdd) {
      timeFormat =
          widget.model.is24HourFormat ? _fgTime24OnFormat : _fgTime12OnFormat;
    } else {
      timeFormat =
          widget.model.is24HourFormat ? _fgTime24OffFormat : _fgTime12OffFormat;
    }
    return DateFormat(timeFormat).format(_dateTime);
  }

  @override
  Widget build(BuildContext context) {
    final model = widget.model;
    final mediaSize = MediaQuery.of(context).size;

    final clockStyle = Theme.of(context).brightness == Brightness.light
        ? ClockStyle.light(mediaSize)
        : ClockStyle.dark(mediaSize);

    final dateString = DateFormat(_fgDateFormat).format(_dateTime);
    final timeString = _timeString();

    return Container(
      color: clockStyle.backgroundColor,
      child: Center(
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Opacity(
                opacity: 0.20,
                child: Image.asset(
                  'third_party/images/lcd_screen_texture.jpg',
                  fit: BoxFit.cover,
                )),
            Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: Align(
                alignment: Alignment.topCenter,
                child: Stack(
                  children: <Widget>[
                    Text(
                      _bgDateString,
                      style: clockStyle.bgDateTextStyle,
                    ),
                    Text(
                      dateString,
                      style: clockStyle.fgDateTextStyle,
                    ),
                  ],
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Stack(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 0.0, bottom: 12.0),
                      child: Stack(
                        children: <Widget>[
                          Text(
                            _bgTimeString,
                            style: clockStyle.bgTimeTextStyle,
                          ),
                          Text(
                            timeString,
                            style: clockStyle.fgTimeTextStyle,
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 0.0,
                      left: 0.0,
                      right: 0.0,
                      child: Center(
                        child: Stack(
                          children: <Widget>[
                            Text(
                              _bgSecondsString,
                              style: clockStyle.bgDateTextStyle,
                            ),
                            Text(
                              (_secondsPart * _dateTime.second).trimRight(),
                              style: clockStyle.fgDateTextStyle,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: WeatherWidget(clockStyle, model.weatherCondition),
            )
          ],
        ),
      ),
    );
  }
}
