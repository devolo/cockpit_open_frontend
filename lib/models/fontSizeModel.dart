/*
Copyright (c) 2021, devolo AG
All rights reserved.

This source code is licensed under the BSD-style license found in the
LICENSE file in the root directory of this source tree.
*/
import 'package:flutter/cupertino.dart';

class FontSize extends ChangeNotifier {
  double _fontSizeFactor;

  double _min = 0.75;
  double _max = 1.75;
  double _step = 0.25;

  FontSize(this._fontSizeFactor);

  double get factor => _fontSizeFactor;
  set factor(double value) {
    if (value < _min) _fontSizeFactor = _min;
    else if (value > _max) _fontSizeFactor = _max;
    else _fontSizeFactor = value;
  }

  double get minFontSizeFactor => _min;
  double get maxFontSizeFactor => _max;
  double get stepForFontSizeFactor => _step;

  void increase() {
    factor = _fontSizeFactor + _step;
    notifyListeners();
  }

  void decrease() {
    factor = _fontSizeFactor - _step;
    notifyListeners();
  }
}