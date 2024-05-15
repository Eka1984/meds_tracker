import 'package:flutter/material.dart';

class UIHelper {
  static void showNotification(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onTertiary,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.tertiary,
      ),
    );
  }

  static bool isValidDateFormat(String date) {
    // Regular expression to match the format dd.mm.yyyy
    final RegExp dateRegExp = RegExp(r'^\d{2}\.\d{2}\.\d{4}$');

    // Check if the input matches the regular expression
    if (!dateRegExp.hasMatch(date)) {
      return false;
    }

    // Further validation to check if the date is a valid calendar date
    List<String> dateParts = date.split('.');
    int day = int.parse(dateParts[0]);
    int month = int.parse(dateParts[1]);
    int year = int.parse(dateParts[2]);

    // Check if month is valid
    if (month < 1 || month > 12) {
      return false;
    }

    // Check if day is valid for the given month
    if (day < 1 || day > _daysInMonth(month, year)) {
      return false;
    }

    return true;
  }

  static int _daysInMonth(int month, int year) {
    // List of days in each month
    List<int> daysInMonth = [
      31, // January
      28, // February
      31, // March
      30, // April
      31, // May
      30, // June
      31, // July
      31, // August
      30, // September
      31, // October
      30, // November
      31 // December
    ];

    // Check for leap year
    if (month == 2 && _isLeapYear(year)) {
      return 29;
    }

    return daysInMonth[month - 1];
  }

  static bool _isLeapYear(int year) {
    // Leap year check
    if (year % 4 == 0) {
      if (year % 100 == 0) {
        if (year % 400 == 0) {
          return true;
        }
        return false;
      }
      return true;
    }
    return false;
  }
}
