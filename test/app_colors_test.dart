/*
Copyright © 2021, devolo AG
All rights reserved.

This source code is licensed under the BSD-style license found in the
LICENSE file in the root directory of this source tree.
*/

import 'package:cockpit_devolo/shared/app_colors.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {

  group('void setTheme(String theme_name)', () {

    test('Given_When_callSetTheme_Then_setTheme', () {

      setTheme("High Contrast");

      expect(mainColor, theme_highContrast["mainColor"]);
      expect(backgroundColor, theme_highContrast["backgroundColor"]);
      expect(secondColor, theme_highContrast["secondColor"]);
      expect(accentColor, theme_highContrast["accentColor"]);
      expect(drawingColor, theme_highContrast["drawingColor"]);
      expect(fontColorOnMain, theme_highContrast["fontColorOnMain"]);
      expect(fontColorOnBackground, theme_highContrast["fontColorOnBackground"]);
      expect(fontColorOnSecond, theme_highContrast["fontColorOnSecond"]);
    });

    test('Given_When_callSetThemeWithNoExistingTheme_Then_keepCurrentTheme', () {

      setTheme("Light Theme");

      setTheme("non existing theme");

      expect(mainColor, theme_light["mainColor"]);
      expect(backgroundColor, theme_light["backgroundColor"]);
      expect(secondColor, theme_light["secondColor"]);
      expect(accentColor, theme_light["accentColor"]);
      expect(drawingColor, theme_light["drawingColor"]);
      expect(fontColorOnMain, theme_light["fontColorOnMain"]);
      expect(fontColorOnBackground, theme_light["fontColorOnBackground"]);
      expect(fontColorOnSecond, theme_light["fontColorOnSecond"]);
    });

  });

}