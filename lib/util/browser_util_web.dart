/// SPDX-License-Identifier: AGPL-3.0-or-later
import 'dart:js' as js;

class BrowserUtil {
  bool isBraveBrowser() {
    return js.context.hasProperty('navigator') &&
        js.context['navigator'].hasProperty('brave');
  }

  bool isEdgeBrowser() {
    return js.context.hasProperty('navigator') &&
        js.context['navigator'].hasProperty('userAgent') &&
        js.context['navigator']['userAgent'].toString().contains('Edg/');
  }

  bool isInternetExplorerBrowser() {
    return js.context.hasProperty('navigator') &&
        js.context['navigator'].hasProperty('userAgent') &&
        (js.context['navigator']['userAgent'].toString().contains('MSIE ') ||
            js.context['navigator']['userAgent']
                .toString()
                .contains('Trident/'));
  }
}
