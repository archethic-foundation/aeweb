/// SPDX-License-Identifier: AGPL-3.0-or-later
class AddressUtil {
  static String reduceAddress(String input) {
    if (input.length <= 14) {
      return input;
    }

    final start = input.substring(0, 9);
    final end = input.substring(input.length - 5);

    return '$start...$end';
  }
}
