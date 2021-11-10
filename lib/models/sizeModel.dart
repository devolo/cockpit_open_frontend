/*
Copyright (c) 2021, devolo AG
All rights reserved.

This source code is licensed under the BSD-style license found in the
LICENSE file in the root directory of this source tree.
*/
import 'package:flutter/cupertino.dart';

class SizeModel extends ChangeNotifier {
  double _fontSizeFactor;
  double _iconSizeFactor;


  double _min_font = 0.75;
  double _max_font = 1.75;
  double _step_font = 0.25;

  double _min_icon = 0.75;
  double _max_icon = 1.75;
  double _step_icon = 0.10;

  SizeModel(this._fontSizeFactor, this._iconSizeFactor);

  double get font_factor => _fontSizeFactor;
  set font_factor(double value) {
    if (value < _min_font) _fontSizeFactor = _min_font;
    else if (value > _max_font) _fontSizeFactor = _max_font;
    else _fontSizeFactor = value;
  }

  double get icon_factor => _iconSizeFactor;
  set icon_factor(double value) {
    if (value < _min_icon) _iconSizeFactor = _min_icon;
    else if (value > _max_icon) _iconSizeFactor = _max_icon;
    else _iconSizeFactor = value;
  }

  double get minFontSizeFactor => _min_font;
  double get maxFontSizeFactor => _max_font;
  double get stepForFontSizeFactor => _step_font;

  double get minIconSizeFactor => _min_icon;
  double get maxIconSizeFactor => _max_icon;
  double get stepForIconSizeFactor => _step_icon;


  // DO we need these Functions?
  void increase() {
    font_factor = _fontSizeFactor + _step_font;
    notifyListeners();
  }

  void decrease() {
    font_factor = _fontSizeFactor - _step_font;
    notifyListeners();
  }

  void increase_icon() {
    icon_factor = _iconSizeFactor + _step_icon;
    notifyListeners();
  }

  void decrease_icon() {
    icon_factor = _iconSizeFactor - _step_icon;
    notifyListeners();
  }
}

// class IconSize extends ChangeNotifier {
//   double _iconSizeFactor;
//
//   double _min_icon = 0.75;
//   double _max_icon = 1.75;
//   double _step_icon = 0.25;
//
//   IconSize(this._iconSizeFactor);
//
//   double get factor => _iconSizeFactor;
//   set factor(double value) {
//     if (value < _min_icon) _iconSizeFactor = _min_icon;
//     else if (value > _max_icon) _iconSizeFactor = _max_icon;
//     else _iconSizeFactor = value;
//   }
//
//   double get minFontSizeFactor => _min_icon;
//   double get maxFontSizeFactor => _max_icon;
//   double get stepForFontSizeFactor => _step_icon;
//
//   void increase_icon() {
//     factor = _iconSizeFactor + _step_icon;
//     notifyListeners();
//   }
//
//   void decrease_icon() {
//     factor = _iconSizeFactor - _step_icon;
//     notifyListeners();
//   }
// }