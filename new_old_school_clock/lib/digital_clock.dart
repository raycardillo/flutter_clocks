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

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:intl/intl.dart';
import 'package:new_old_school_clock/src/clock_style.dart';
import 'package:new_old_school_clock/src/fun_message.dart';
import 'package:new_old_school_clock/src/lcd_marquee.dart';

const oneSecond = const Duration(seconds: 1);

/// A digital clock display.
class DigitalClock extends StatefulWidget {
  const DigitalClock(this.model);

  final ClockModel model;

  @override
  _DigitalClockState createState() => _DigitalClockState();
}

/// [State] for a [DigitalClock] widget.
class _DigitalClockState extends State<DigitalClock> {

  // NOTE: Some of these `static final` variables would need to become more
  // flexible `var` variables to support localization initialization.

  /// The base string for the seconds display line.
  static const _secondsPart = '. ';

  /// The background (LCD off) for the seconds display line.
  static final _bgSecondsString = ' ' + (_secondsPart * 59);

  static const _bgDateString = '~~~~-~~-~~      ~~~';
  static final _fgDateFormat = DateFormat('yyyy-MM-dd      EEE');
  static final _semanticDateFormat = DateFormat.yMMMMEEEEd();

  static const _bgTimeString = '88:88';
  static final _fgTime24OnFormat = DateFormat('HH:mm');
  static final _fgTime24OffFormat = DateFormat('HH mm');
  static final _fgTime12OnFormat = DateFormat('hh:mm');
  static final _fgTime12OffFormat = DateFormat('hh mm');
  static final _semanticTime12Format = DateFormat('hh:mm a');

  static const _bgPeriodString = '~~';
  static final _fgPeriodFormat = DateFormat('a');

  DateTime _dateTime = DateTime.now();
  Timer _timer;

  FunTimeMessage _funTimeMessage = FunTimeMessage();

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

      // this is useful for debugging expected time period behaviors
      //_dateTime = DateTime.parse('2020-11-11 '
      //    '17:59:${_dateTime.second.toString().padLeft(2, '0')}');

      if (_funTimeMessage.currentMessage == null) {
        _funTimeMessage.nextMessage(_dateTime);
      }

      // Update once per second, but make sure to do it at the beginning of each
      // new second, so that the clock is accurate.
      _timer = Timer(
        oneSecond - Duration(milliseconds: _dateTime.millisecond),
        _updateTime,
      );
    });
  }

  String _timeString() {
    DateFormat dateFormat;
    if (_dateTime.second.isOdd) {
      dateFormat =
          widget.model.is24HourFormat ? _fgTime24OnFormat : _fgTime12OnFormat;
    } else {
      dateFormat =
          widget.model.is24HourFormat ? _fgTime24OffFormat : _fgTime12OffFormat;
    }
    return dateFormat.format(_dateTime);
  }

  @override
  Widget build(BuildContext context) {
    final model = widget.model;
    final mediaSize = MediaQuery.of(context).size;

    final clockStyle = Theme.of(context).brightness == Brightness.light
        ? ClockStyle.light(mediaSize)
        : ClockStyle.dark(mediaSize);

    final dateString = _fgDateFormat.format(_dateTime);
    final semanticDateValue = _semanticDateFormat.format(_dateTime);

    final timeString = _timeString();
    final periodString =
        model.is24HourFormat ? '24' : _fgPeriodFormat.format(_dateTime);
    final semanticTimeValue = model.is24HourFormat
        ? timeString
        : _semanticTime12Format.format(_dateTime);

    final temperatureDisplay = model.temperatureString.replaceAll('°', "'");
    final highDisplay = model.highString.replaceAll('°', "'");
    final lowDisplay = model.lowString.replaceAll('°', "'");

    return Container(
      color: clockStyle.backgroundColor,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          FittedBox(fit: BoxFit.fill, child: clockStyle.bgImageTexture),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: clockStyle.timeTextFontSize * 0.05),
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Semantics(
                    readOnly: true,
                    label: 'Date',
                    value: semanticDateValue,
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
              ),
              FittedBox(
                fit: BoxFit.contain,
                alignment: Alignment.center,
                child: Stack(
                  children: <Widget>[
                    Semantics(
                      readOnly: true,
                      label: 'Time',
                      value: semanticTimeValue,
                      child: Container(
                        margin: EdgeInsets.only(
                            bottom: clockStyle.timeTextFontSize * 0.11),
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
                            Positioned(
                              right: 0.2775 * clockStyle.timeTextFontSize,
                              bottom: 0.2345 * clockStyle.timeTextFontSize,
                              child: Stack(
                                children: <Widget>[
                                  Text(
                                    _bgPeriodString,
                                    style: clockStyle.bgPeriodTextStyle,
                                  ),
                                  Text(
                                    periodString,
                                    style: clockStyle.fgPeriodTextStyle,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0.0,
                      left: clockStyle.timeTextFontSize * 0.05,
                      right: clockStyle.timeTextFontSize * 0.05,
                      child: Semantics(
                        readOnly: true,
                        label: 'Seconds',
                        value: _bgSecondsString,
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: Stack(
                            children: <Widget>[
                              Text(
                                _bgSecondsString,
                                style: clockStyle.bgDateTextStyle,
                              ),
                              Text(
                                ' ' + (_secondsPart * _dateTime.second),
                                style: clockStyle.fgDateTextStyle,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: clockStyle.timeTextFontSize * 0.05),
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: LCDMarqueeWidget(clockStyle, 20, <LCDMarqueeEntry>[
                    LCDMarqueeEntry(
                        displayString: 'LOCATION ))',
                        semanticLabel: 'Location',
                        semanticValue: model.location),
                    LCDMarqueeEntry(
                        displayString: model.location,
                        semanticLabel: 'Location',
                        semanticValue: model.location),
                    LCDMarqueeEntry(
                        displayString: 'WEATHER ))',
                        semanticLabel: 'Weather',
                        semanticValue: model.weatherString),
                    LCDMarqueeEntry(
                        displayString: model.weatherString,
                        semanticLabel: 'Weather',
                        semanticValue: model.weatherString),
                    LCDMarqueeEntry(
                        displayString: 'TEMP )) $temperatureDisplay',
                        semanticLabel: 'Temperature',
                        semanticValue: model.temperatureString),
                    LCDMarqueeEntry(
                        displayString: 'HIGH )) $highDisplay',
                        semanticLabel: 'High Temperature',
                        semanticValue: model.highString),
                    LCDMarqueeEntry(
                        displayString: 'LOW )) $lowDisplay',
                        semanticLabel: 'Low Temperature',
                        semanticValue: model.lowString),
                    LCDMarqueeEntry(
                        displayString: _funTimeMessage.currentMessage,
                        semanticLabel: 'Fun Message',
                        semanticValue: _funTimeMessage.currentMessage,
                        onComplete: () {
                          _funTimeMessage.nextMessage(_dateTime);
                        }),
                  ]),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
