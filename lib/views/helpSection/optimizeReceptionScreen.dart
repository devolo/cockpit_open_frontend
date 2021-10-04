/*
Copyright © 2021, devolo AG
All rights reserved.

This source code is licensed under the BSD-style license found in the
LICENSE file in the root directory of this source tree.
*/

/* OLD CODE FROM helpScreen.dart

  void _optimiseAlert(context) {
    double _animatedHeight = 0.0;
    String? selected;

    Map<String, dynamic> contents = Map();
    optimizeImages.asMap().forEach((i, value) {
      contents["Optimierungstitel $i"] = optimizeImages[i];
    });

    showDialog<void>(
        context: context,
        barrierDismissible: true, // user doesn't need to tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Column(
              children: [
                getCloseButton(context),
                Center(
                    child: Text(
                      S
                          .of(context)
                          .optimizationHelp,
                      style: TextStyle(color: fontColorOnBackground),
                    )),
              ],
            ),
            titlePadding: EdgeInsets.all(2),
            backgroundColor: backgroundColor.withOpacity(0.9),
            insetPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 50),
            content: StatefulBuilder( // You need this, notice the parameters below:
                builder: (BuildContext context, StateSetter setState) {
                  return Center(
                    child: Column(
                      children: [
                        for (dynamic con in contents.entries)
                          Flex(
                            direction: Axis.vertical,
                            children: [
                              new GestureDetector(
                                onTap: () {
                                  setState(() {
                                    logger.w(con);
                                    selected = con.key;
                                    _animatedHeight != 0.0 ? _animatedHeight = 0.0 : _animatedHeight = 250.0;
                                  });
                                  //AppBuilder.of(context).rebuild();
                                },
                                child: new Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      new Text(
                                        " " + con.key,
                                        style: TextStyle(color: fontColorOnSecond),
                                      ),
                                      Spacer(),
                                      // ToDo CircleAvatar doesn't change
                                      // new CircleAvatar(
                                      //   backgroundColor: con.value.selectedColor, //_tempShadeColor,
                                      //   radius: 15.0,
                                      // ),
                                      new Icon(
                                        DevoloIcons.ic_arrow_drop_down_24px,
                                        color: fontColorOnSecond,
                                      ),
                                    ],
                                  ),
                                  color: secondColor, //Colors.grey[800].withOpacity(0.9),
                                  height: 50.0,
                                  width: 900.0,
                                ),
                              ),
                              new AnimatedContainer(
                                duration: const Duration(milliseconds: 120),
                                child: Column(
                                  children: [
                                    Expanded(child: con.value),
                                  ],
                                ),
                                height: selected == con.key ? _animatedHeight : 0.0,
                                color: secondColor.withOpacity(0.8),
                                //Colors.grey[800].withOpacity(0.6),
                                width: 900.0,
                              ),
                            ],
                          ),
                      ],
                    ),
                  );
                }),
          );
        });
  }
*/
