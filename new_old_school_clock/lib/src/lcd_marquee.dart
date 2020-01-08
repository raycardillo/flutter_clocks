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

import 'dart:collection';

import 'package:flutter/widgets.dart';
import 'package:new_old_school_clock/src/clock_style.dart';

/// Character '!'.
const int $exclamation = 0x21;

/// Character '-'.
const int $minus = 0x2D;

/// Defines an entry to be displayed on the marquee.
///
/// This includes basic semantics information for each entry as well, so the
/// display can use this to add [Semantics] and support accessibility features.
class LCDMarqueeEntry {
  /// The string to display.
  final String displayString;

  /// The semantic label for the entry.
  final String semanticLabel;

  /// The semantic value for the entry (e.g., for screen readers).
  final String semanticValue;

  /// A function to call when the marquee display is complete for this entry.
  final VoidCallback onComplete;

  /// Create a marquee entry with an optional [onComplete] callback.
  LCDMarqueeEntry(
      {@required this.displayString,
      @required this.semanticLabel,
      @required this.semanticValue,
      this.onComplete});
}

/// An LCD marquee display widget that makes display string entries appear to
/// slide across the marquee display LCD display segments.
class LCDMarqueeWidget extends StatefulWidget {
  /// The style to use for colors and fonts (LCD font is required).
  final ClockStyle _clockStyle;

  /// The number of LCD segment character slots to display.
  final int _numChars;

  /// The display entries to cycle through on the LCD display.
  final List<LCDMarqueeEntry> _marqueeEntries;

  /// Create an LCD marquee widget with [_numChars] LCD segments, a specific
  /// [_clockStyle], and a list of [_marqueeEntries].
  LCDMarqueeWidget(this._clockStyle, this._numChars, this._marqueeEntries);

  @override
  _LCDMarqueeWidgetState createState() => _LCDMarqueeWidgetState();
}

/// [State] for a [LCDMarqueeWidget] widget.
class _LCDMarqueeWidgetState extends State<LCDMarqueeWidget> {
  /// Cycle time between updates in milliseconds.
  static const _cycleMilliseconds = 350;

  /// How many cycles to delay between entries.
  static const _nextEntryDelay = 5;

  /// Whitespace [RegExp] to convert whitespace to LCD placeholder characters.
  static final _whiteSpace = RegExp(r'\s+');

  /// The background LCD segments that simulates LCD segments that are off.
  String _bgDisplaySegments;

  /// A queue of characters that represents the current display segments.
  Queue<int> _marqueeDisplay;

  /// The index of the marquee entry being displayed.
  int _currentEntryIndex = 0;

  /// The current delay countdown between marquee entries.
  int _currentDelay = 0;

  /// The queue of characters pending display on the marquee.
  Queue<int> _pendingChars;

  /// A stream of strings that are emitted periodically to update the marquee.
  Stream<String> _marqueeStringStream;

  @override
  void initState() {
    super.initState();

    final numChars = widget._numChars;
    _bgDisplaySegments = '~.' * numChars;
    _marqueeDisplay = Queue<int>.from(('!' * numChars).codeUnits);

    _currentEntryIndex = 0;
    _addEntryToDisplay(widget._marqueeEntries[_currentEntryIndex]);

    _marqueeStringStream = Stream<String>.periodic(
        Duration(milliseconds: _cycleMilliseconds), _marqueeString);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _marqueeStringStream,
      builder: _buildMarquee,
    );
  }

  /// Compute function for [_marqueeStringStream] that determines what the
  /// current marquee string should be to achieve the intended effect.
  String _marqueeString(int computationCount) {
    if (_currentDelay > 0) {
      _currentDelay--;
    } else {
      if (_pendingChars.isNotEmpty) {
        _marqueeDisplay.removeFirst();
        _marqueeDisplay.addLast(_pendingChars.removeFirst());
      } else {
        final currentEntry = widget._marqueeEntries[_currentEntryIndex];
        if (currentEntry.onComplete != null) {
          currentEntry.onComplete();
        }

        _currentDelay = _nextEntryDelay;

        if (++_currentEntryIndex >= widget._marqueeEntries.length) {
          _currentEntryIndex = 0;
        }

        final nextEntry = widget._marqueeEntries[_currentEntryIndex];
        _addEntryToDisplay(nextEntry);
      }
    }

    return String.fromCharCodes(_marqueeDisplay);
  }

  /// Add an entry to display on the marquee.
  void _addEntryToDisplay(LCDMarqueeEntry marqueeEntry) {
    final displayString = marqueeEntry.displayString;
    _pendingChars = Queue<int>.from(displayString.codeUnits);
    _pendingChars.addFirst($exclamation);
    _pendingChars.addFirst($exclamation);
    _pendingChars.addFirst($exclamation);
    var rightPadding = widget._numChars - displayString.length;
    while (rightPadding-- > 0) {
      _pendingChars.addLast($exclamation);
    }
  }

  /// Build the marquee as the [_marqueeStringStream] provides new strings.
  Widget _buildMarquee(BuildContext context, AsyncSnapshot<String> snapshot) {
    final clockStyle = widget._clockStyle;

    String displayString;
    if (snapshot.hasError || !snapshot.hasData) {
      displayString = '';
    } else {
      displayString = snapshot.data.replaceAll(_whiteSpace, '!');
    }

    final marqueeEntry = widget._marqueeEntries[_currentEntryIndex];
    return Semantics(
      readOnly: true,
      label: marqueeEntry.semanticLabel,
      value: marqueeEntry.semanticValue,
      child: Stack(
        children: <Widget>[
          Text(
            _bgDisplaySegments,
            style: clockStyle.bgDateTextStyle,
          ),
          Text(
            displayString,
            style: clockStyle.fgDateTextStyle,
          ),
        ],
      ),
    );
  }
}
