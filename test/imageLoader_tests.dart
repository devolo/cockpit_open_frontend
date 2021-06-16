/*
Copyright (c) 2021, devolo AG
All rights reserved.

This source code is licensed under the BSD-style license found in the
LICENSE file in the root directory of this source tree.
*/

import 'dart:typed_data';

import 'package:cockpit_devolo/models/deviceModel.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cockpit_devolo/shared/imageLoader.dart';
import 'dart:ui' as ui;

void main (){

  TestWidgetsFlutterBinding.ensureInitialized(); // needed to use rootBundle (in loadAllDeviceIcons())

  group('Future<void> loadAllDeviceIcons()', () {

    test('Given__When_callLoadAllDeviceIcons_Then_fillDeviceIconList', () async{

      await loadAllDeviceIcons();

      expect(areDeviceIconsLoaded,true);
      expect(deviceIconList.length,6);
      expect(deviceIconList[0].toString(),"[35×79]");
      expect(deviceIconList[1].toString(),"[35×79]");
      expect(deviceIconList[2].toString(),"[36×64]");
      expect(deviceIconList[3].toString(),"[36×37]");
      expect(deviceIconList[4].toString(),"[76×69]");
      expect(deviceIconList[5].toString(),"[352×334]");
    });
  });

  group('Future<ui.Image> loadImage(var img)', () {

    test('Given_ByteData_When_callLoadImage_Then_returnImage', () async{

      ByteData data = await rootBundle.load('assets/network.png');

      ui.Image image = await loadImage(new Uint8List.view(data.buffer));

      expect(image.toString(),"[352×334]");
    });
  });

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

  group('ui.Image? getIconForDeviceType(DeviceType? dt)', () {

    test('Given__When_callGetIconForDeviceType_Then_returnImage', () async{

      await loadAllDeviceIcons();

      var imageWiFiPlus = getIconForDeviceType(DeviceType.dtWiFiPlus);
      var imageLanPlus = getIconForDeviceType(DeviceType.dtLanPlus);
      var imageWiFiOnly = getIconForDeviceType(DeviceType.dtWiFiOnly);
      var imageWiFiMini = getIconForDeviceType(DeviceType.dtWiFiMini);
      var imageLanMini = getIconForDeviceType(DeviceType.dtLanMini);
      var imageDINrail = getIconForDeviceType(DeviceType.dtDINrail);
      var imageUnknown = getIconForDeviceType(DeviceType.dtUnknown);

      expect(areDeviceIconsLoaded,true);
      expect(imageWiFiPlus.toString(),"[35×79]");
      expect(imageLanPlus.toString(),"[35×79]");
      expect(imageWiFiOnly.toString(),"[36×64]");
      expect(imageWiFiMini.toString(),"[36×64]");
      expect(imageLanMini.toString(),"[36×37]");
      expect(imageUnknown.toString(),"[36×37]");
      expect(imageDINrail.toString(),"[76×69]");
    });
  });


}