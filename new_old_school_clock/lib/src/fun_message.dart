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

/// Helper that gets a fun message based on the time of day. The day is
/// divided up into commonly known time periods and the messages are selected
/// from the time period based on the current time of day.
///
/// The time periods that messages can be delivered for are:
/// - **Wee-Hours** - The period from Midnight until Morning.
/// - **Morning** - The period from Morning until Afternoon.
/// - **Afternoon** - The period from Afternoon until Evening.
/// - **Evening** - The period from Evening until Night.
/// - **Night** - The period from Night until Midnight.
class FunTimeMessage {
  // TODO: Consider making these messages loadable and/or addressing i18n.

  /// Messages for MORNING
  static const _morningMessages = <String>[
    'GOOD MORNING',
    'RISE AND SHINE',
    'BE THE CHANGE',
    "LET'S DO THIS"
  ];

  /// Messages for AFTERNOON
  static const _afternoonMessages = <String>[
    'LOOK AT YOU GO',
    'STAY FOCUSED',
    'GET IT DONE'
  ];

  /// Messages for EVENING
  static const _eveningMessages = <String>[
    'GOOD EVENING',
    'WHAT IS HAPPENING',
    'FEED YOUR BRAIN'
  ];

  /// Messages for NIGHT
  static const _nightMessages = <String>[
    'GOOD NIGHT',
    'TIME TO RELAX',
    'SHEEP COUNTING TIME'
  ];

  /// Messages for WEE-HOURS
  static const _weeHoursMessages = <String>[
    'WHO SAID WHAT NOW',
    'ARE YOU THERE',
    'WHY ARE YOU READING THIS'
  ];

  /// Default hour for the MORNING time period.
  static const defaultMorning = 4; // 4am - Noon

  /// Default hour for the AFTERNOON time period.
  static const defaultAfternoon = 12; // Noon - 5pm

  /// Default hour for the EVENING time period.
  static const defaultEvening = 17; // 5pm - 9pm

  /// Default hour for the NIGHT time period.
  static const defaultNight = 21; // 9pm - Midnight

  /// Hour to use for the MORNING time period.
  final int _morning;

  /// Hour to use for the AFTERNOON time period.
  final int _afternoon;

  /// Hour to use for the EVENING time period.
  final int _evening;

  /// Hour to use for the NIGHT time period.
  final int _night;

  /// The current message to display, but only expose the getter.
  String _currentMessage;

  /// Used to cycle through next messages (in combination with modulus).
  var _nextCounter = 0;

  /// Creates an instance of this helper, optionally with custom hour
  /// boundaries specified.
  FunTimeMessage(
      {morning = defaultMorning,
      afternoon = defaultAfternoon,
      evening = defaultEvening,
      night = defaultNight})
      : this._morning = morning,
        this._afternoon = afternoon,
        this._evening = evening,
        this._night = night;

  /// Get the current message being displayed.
  String get currentMessage => _currentMessage;

  /// Advance to the next message to display based on the time of day.
  String nextMessage(DateTime dateTime) {
    if (dateTime.hour < _morning) {
      // PERIOD == WEE-HOURS
      _currentMessage =
          _weeHoursMessages[_nextCounter++ % _weeHoursMessages.length];
    } else if (dateTime.hour < _afternoon) {
      // PERIOD == MORNING
      _currentMessage =
          _morningMessages[_nextCounter++ % _morningMessages.length];
    } else if (dateTime.hour < _evening) {
      // PERIOD == AFTERNOON
      _currentMessage =
          _afternoonMessages[_nextCounter++ % _afternoonMessages.length];
    } else if (dateTime.hour < _night) {
      // PERIOD == EVENING
      _currentMessage =
          _eveningMessages[_nextCounter++ % _eveningMessages.length];
    } else {
      // PERIOD == NIGHT
      _currentMessage = _nightMessages[_nextCounter++ % _nightMessages.length];
    }
    return _currentMessage;
  }
}
