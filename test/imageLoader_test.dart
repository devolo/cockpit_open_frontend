/*
Copyright © 2021, devolo AG
All rights reserved.

This source code is licensed under the BSD-style license found in the
LICENSE file in the root directory of this source tree.
*/

import 'dart:typed_data';

import 'package:cockpit_devolo/models/deviceModel.dart';
import 'package:cockpit_devolo/shared/helpers.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cockpit_devolo/shared/imageLoader.dart';
import 'dart:ui' as ui;

void main (){

  TestWidgetsFlutterBinding.ensureInitialized(); // needed to use rootBundle (in loadAllDeviceIcons())

  group('List<Image> loadOptimizeImages()', () {

    test('Given__When_callLoadOptimizeImages_Then_returnIconList', () {

      var optimizeImageList = loadOptimizeImages();

      expect(optimizeImageList.length,4);
      expect(optimizeImageList[0].toString(),'Image(image: AssetImage(bundle: null, name: "assets/optimisationImages/dLAN200AVmini2_A.png"), frameBuilder: null, loadingBuilder: null, alignment: Alignment.center, this.excludeFromSemantics: false, filterQuality: low)');
      expect(optimizeImageList[1].toString(),'Image(image: AssetImage(bundle: null, name: "assets/optimisationImages/dLAN200AVmini2_B.png"), frameBuilder: null, loadingBuilder: null, alignment: Alignment.center, this.excludeFromSemantics: false, filterQuality: low)');
      expect(optimizeImageList[2].toString(),'Image(image: AssetImage(bundle: null, name: "assets/optimisationImages/dLAN200AVmini2_C.png"), frameBuilder: null, loadingBuilder: null, alignment: Alignment.center, this.excludeFromSemantics: false, filterQuality: low)');
      expect(optimizeImageList[3].toString(),'Image(image: AssetImage(bundle: null, name: "assets/optimisationImages/dLAN200AVplus_A.png"), frameBuilder: null, loadingBuilder: null, alignment: Alignment.center, this.excludeFromSemantics: false, filterQuality: low)');
    });
  });
}