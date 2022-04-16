// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../shared/utils.dart' show CalendarFormat;

class FormatButton extends StatelessWidget {
  final CalendarFormat calendarFormat;
  final ValueChanged<CalendarFormat> onTap;
  final TextStyle textStyle;
  final BoxDecoration decoration;
  final EdgeInsets padding;
  final bool showsNextFormat;
  final Map<CalendarFormat, String> availableCalendarFormats;

  const FormatButton({
    Key? key,
    required this.calendarFormat,
    required this.onTap,
    required this.textStyle,
    required this.decoration,
    required this.padding,
    required this.showsNextFormat,
    required this.availableCalendarFormats,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: decoration,
      height: 30,
      padding: padding,
      child: DropdownButton<CalendarFormat>(
        underline: SizedBox(),
        icon: Container(),
        items: availableCalendarFormats
            .map((description, value) {
              return MapEntry(
                  description,
                  DropdownMenuItem<CalendarFormat>(
                    value: description,
                    child: Text(value),
                  ));
            })
            .values
            .toList(),
        value: calendarFormat,
        onChanged: (format) {
          onTap(format!);
          // if (newValue != null) {
          //   setState(() {
          //     _frequencyValue = newValue;
          //   });
          // }
        },
      ),
    );

    // return DropdownButton<CalendarFormat>(
    //   items: availableCalendarFormats.map((CalendarFormat value) {
    //     return DropdownMenuItem<CalendarFormat>(
    //       value: value,
    //       child: Text(value),
    //     );
    //   }).toList(),
    //   value: calendarFormat.name,
    //   onChanged: (_) {
    //
    //   },
    // );

    final child = Container(
      decoration: decoration,
      padding: padding,
      child: Text(
        _formatButtonText,
        style: textStyle,
      ),
    );

    return !kIsWeb && (Platform.isIOS || Platform.isMacOS)
        ? CupertinoButton(
            onPressed: () => onTap(_nextFormat()),
            padding: EdgeInsets.zero,
            child: child,
          )
        : InkWell(
            borderRadius:
                decoration.borderRadius?.resolve(Directionality.of(context)),
            onTap: () => onTap(_nextFormat()),
            child: child,
          );
  }

  String get _formatButtonText => showsNextFormat
      ? availableCalendarFormats[_nextFormat()]!
      : availableCalendarFormats[calendarFormat]!;

  CalendarFormat _nextFormat() {
    final formats = availableCalendarFormats.keys.toList();
    int id = formats.indexOf(calendarFormat);
    id = (id + 1) % formats.length;

    return formats[id];
  }
}
