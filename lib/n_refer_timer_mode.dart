import 'dart:async';
import 'package:page_transition/page_transition.dart';
import 'package:slide_puzzle/n_menu_page.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'config/config_page.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:image/image.dart' as imglib;
import 'dart:typed_data';
import 'package:http/http.dart' as http;

class NReferTimerPage extends StatefulWidget {
  final int tileNo;
  final String tileBackgroundOption;
  final String localImageName;
  final String networkImageUrl;
  const NReferTimerPage(
      {Key? key,
      required this.tileNo,
      required this.tileBackgroundOption,
      required this.localImageName,
      required this.networkImageUrl})
      : super(key: key);

  @override
  _NReferTimerPageState createState() => _NReferTimerPageState();
}

class _NReferTimerPageState extends State<NReferTimerPage> {
  late Future<List<Image>> _splittedImage;

  late int tileNo;
  late final String tileBackgroundOption;
  late final String localImageName;
  late final String networkImageUrl;

  double mainContainerSize = 400;

  List coord() {
    double step = 2.0 / (tileNo.toDouble() - 1.0);
    List a = [for (int i = 0; i < tileNo; i++) -1.0 + (step * i.toDouble())];
    print(a);
    return a;
  }

  bool checkMapEquals(Map position, Map originalPosition) {
    bool allCheck = false;
    for (int i = 0; i < position.length - 1; i++) {
      if (position[i.toString()] != originalPosition[i.toString()]) {
        allCheck = false;
        break;
      } else {
        allCheck = true;
      }
    }
    return allCheck;
  }

  Map originalPosition = {};
  Map position = {};
  Map possiblePaths = {};
  Alignment currentEmptySpot = Alignment.bottomRight;

  void mapOriginalPositionAndPositionAndPossiblePaths() {
    Map dummyOriginalPosition = {};
    Map dummyPossiblePaths = {};
    List spaces = coord();
    int count = 0;
    double step = 2.0 / (tileNo.toDouble() - 1.0);
    for (double y in spaces) {
      for (double x in spaces) {
        List listOfTempAlignment = [];
        dummyOriginalPosition[count.toString()] = Alignment(x, y);

        if (x - step >= -1.0) {
          listOfTempAlignment.add(Alignment(x - step, y));
        }
        if (x + step <= 1.0) {
          listOfTempAlignment.add(Alignment(x + step, y));
        }
        if (y - step >= -1.0) {
          listOfTempAlignment.add(Alignment(x, y - step));
        }
        if (y + step <= 1.0) {
          listOfTempAlignment.add(Alignment(x, y + step));
        }

        dummyPossiblePaths[Alignment(x, y)] = listOfTempAlignment;

        ++count;
      }
    }
    originalPosition.addAll(dummyOriginalPosition);
    position.addAll(dummyOriginalPosition);
    possiblePaths.addAll(dummyPossiblePaths);
    print(dummyOriginalPosition);
    print(dummyPossiblePaths);
    print(count);
  }

  // Shuffled position is required for reset
  Map shuffledPosition = {};
  Alignment shuffledCurrentEmptySpot = Alignment.bottomRight;

  void shufflePosition() {
    // Shuffleposition and position will have the same length
    position = Map.from(originalPosition);
    List listOfShuffledPosition = position.values.toList();
    setState(() {
      listOfShuffledPosition.shuffle();
      for (int i = 0; i < position.length; i++) {
        position[i.toString()] = listOfShuffledPosition[i];
        shuffledPosition[i.toString()] = listOfShuffledPosition[i];
      }

      currentEmptySpot =
          listOfShuffledPosition[listOfShuffledPosition.length - 1];
      shuffledCurrentEmptySpot =
          listOfShuffledPosition[listOfShuffledPosition.length - 1];
    });
  }

  // List<Image> splittedImage = [];
  Future<List<Image>> splitImage(path) async {
    ByteData bytes = await rootBundle.load(path);
    // convert image to image from image package
    imglib.Image image = imglib.decodeImage(bytes.buffer.asUint8List())!;

    int x = 0, y = 0;
    int width = (image.width / tileNo).round();
    int height = (image.height / tileNo).round();

    // split image to parts
    List<imglib.Image> parts = [];
    for (int i = 0; i < tileNo; i++) {
      for (int j = 0; j < tileNo; j++) {
        parts.add(imglib.copyCrop(image, x, y, width, height));
        x += width;
      }
      x = 0;
      y += height;
    }

    // convert image from image package to Image Widget to display
    List<Image> output = [];
    for (var img in parts) {
      output.add(Image.memory(Uint8List.fromList(imglib.encodeJpg(img))));
    }
    print(output);
    return output;
  }

  Future<List<Image>> networkSplitImage(url) async {
    http.Response response = await http.get(url);

    // convert image to image from image package
    imglib.Image image =
        imglib.decodeImage(response.bodyBytes.buffer.asUint8List())!;

    int x = 0, y = 0;
    int width = (image.width / tileNo).round();
    int height = (image.height / tileNo).round();

    // split image to parts
    List<imglib.Image> parts = [];
    for (int i = 0; i < tileNo; i++) {
      for (int j = 0; j < tileNo; j++) {
        parts.add(imglib.copyCrop(image, x, y, width, height));
        x += width;
      }
      x = 0;
      y += height;
    }

    // convert image from image package to Image Widget to display
    List<Image> output = [];
    for (var img in parts) {
      output.add(Image.memory(Uint8List.fromList(imglib.encodeJpg(img))));
    }
    print(output);
    return output;
  }

  @override
  void initState() {
    super.initState();
    tileNo = widget.tileNo;
    tileBackgroundOption = widget.tileBackgroundOption;
    localImageName = widget.localImageName;
    networkImageUrl = widget.networkImageUrl;

    mapOriginalPositionAndPositionAndPossiblePaths();
    if (tileBackgroundOption == 'IMAGE') {
      _splittedImage =
          Future.delayed(const Duration(seconds: 0)).then((_) async {
        print('initstate splitted image run first');
        return await splitImage('assets/images/$localImageName');
      });
    }
    if (tileBackgroundOption == 'RANDOM IMAGE') {
      _splittedImage =
          Future.delayed(const Duration(seconds: 0)).then((_) async {
        print('initstate splitted image run first');
        return await networkSplitImage(Uri.parse(networkImageUrl));
      });
    }

    tileSize = (mainContainerSize / tileNo).floor().toDouble() - 10.0;
  }

  void _countdown() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timerValue == 0) {
        timer.cancel();
        shufflePosition();
        setState(() {
          showTimer = false;
          onTapActivated = true;
          reset = true;
          start = false;
          originalPositionReset = true;
          solved = false;
          tapCount = 0;
          logTapTrail = "";
          showLogTapTrail = true;
          // showGallery = false;
        });
      } else {
        setState(() {
          timerValue--;
        });
      }
    });
  }

  _showSolvedAlert() async {
    await Alert(
      context: context,
      type: AlertType.success,
      title: "Solved Successfully",
      desc: "You have successfully solved the puzzle. Now pat on your back.",
      style: AlertStyle(
        animationType: AnimationType.fromBottom,
        backgroundColor: Color(int.parse(userConfig['primary_background'])),
        alertElevation: 20.0,
        isButtonVisible: false,
        isCloseButton: false,
        titleStyle: TextStyle(
          color: Color(int.parse(userConfig['primary'])),
          fontFamily: "BebasNeue",
          fontSize: 35.0,
        ),
        descStyle: TextStyle(
          color: Color(int.parse(userConfig['secondary'])),
          fontFamily: "BebasNeue",
          fontSize: 25.0,
        ),
      ),
    ).show();
  }

  bool onTapActivated = false;
  bool start = true;
  bool reset = false;
  int noOfShuffle = 10;
  bool solved = false;
  bool originalPositionReset = false;
  int tapCount = 0;
  String logTapTrail = "";
  bool showLogTapTrail = false;
  // bool showGallery = true;
  int timerValue = 30;
  bool showTimer = false;
  late double tileSize;
  double tileBorderRadius = 10.0;

  @override
  Widget build(BuildContext context) {
    return NeumorphicApp(
      debugShowCheckedModeBanner: false,
      home: Builder(builder: (context) {
        return Scaffold(
          backgroundColor: Color(int.parse(userConfig['primary_background'])),
          appBar: AppBar(
            toolbarHeight: 80.0,
            elevation: 10.0,
            centerTitle: true,
            backgroundColor:
                Color(int.parse(userConfig['secondary_background'])),
            leading: NeumorphicButton(
              onPressed: () {
                if (userConfig['interface_sound'] == "on") {
                  audioCacheInterface.play('page-back-chime.wav',
                      volume:
                          double.parse(userConfig['interface_sound_volume']));
                }
                Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.leftToRightWithFade,
                    child: const NMenuPage(),
                  ),
                );
              },
              style: NeumorphicStyle(
                shape: NeumorphicShape.flat,
                boxShape: const NeumorphicBoxShape.circle(),
                depth: 0.0,
                intensity: 0.8,
                surfaceIntensity: 0.8,
                color: Color(int.parse(userConfig['secondary_background'])),
              ),
              child: Center(
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 25.0,
                  color: Color(
                    int.parse(userConfig['secondary']),
                  ),
                ),
              ),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 100.0,
                      height: 60.0,
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Neumorphic(
                              style: NeumorphicStyle(
                                  shape: NeumorphicShape.flat,
                                  boxShape: const NeumorphicBoxShape.circle(),
                                  depth: 5.0,
                                  intensity: 0.8,
                                  surfaceIntensity: 0.8,
                                  color:
                                      Color(int.parse(userConfig['primary']))),
                              child: const SizedBox(
                                width: 50.0,
                                height: 50.0,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Neumorphic(
                              style: NeumorphicStyle(
                                  shape: NeumorphicShape.flat,
                                  boxShape: const NeumorphicBoxShape.circle(),
                                  depth: 5.0,
                                  intensity: 0.8,
                                  surfaceIntensity: 0.8,
                                  color: Color(
                                      int.parse(userConfig['secondary']))),
                              child: const SizedBox(
                                width: 50.0,
                                height: 50.0,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Column(children: [
                      Text(
                        'SLIDER',
                        textDirection: TextDirection.ltr,
                        style: TextStyle(
                          color: Color(int.parse(userConfig['primary'])),
                          fontFamily: "BebasNeue",
                          fontSize: 30.0,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 40.0),
                        child: Text(
                          'PUZZLE',
                          textDirection: TextDirection.ltr,
                          style: TextStyle(
                            color: Color(int.parse(userConfig['secondary'])),
                            fontFamily: "BebasNeue",
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                    ]),
                  ],
                ),
                Column(children: [
                  Container(
                    margin: const EdgeInsets.only(left: 50.0),
                    child: Text(
                      "${tileNo}X$tileNo",
                      textDirection: TextDirection.ltr,
                      style: TextStyle(
                        color: Color(int.parse(userConfig['primary'])),
                        fontFamily: "BebasNeue",
                        fontSize: 30.0,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 30.0),
                    child: Text(
                      "REFER TIMER",
                      textDirection: TextDirection.ltr,
                      style: TextStyle(
                        color: Color(int.parse(userConfig['secondary'])),
                        fontFamily: "BebasNeue",
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                ]),
              ],
            ),
          ),
          body: Center(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  //ANCHOR Show Log Tap Trail
                  if (showLogTapTrail)
                    Neumorphic(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 20.0),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 5.0),
                      style: NeumorphicStyle(
                        shape: NeumorphicShape.flat,
                        depth: -5.0,
                        intensity: 0.8,
                        boxShape: const NeumorphicBoxShape.stadium(),
                        color: Color(
                            int.parse(userConfig['secondary_background'])),
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Text(
                            logTapTrail,
                            textDirection: TextDirection.ltr,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 25.0,
                              color: Color(int.parse(userConfig['secondary'])),
                              fontFamily: "BebasNeue",
                            ),
                          ),
                        ),
                      ),
                    ),
                  // ANCHOR Container for tap count
                  Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // ANCHOR Row of tap count text and number
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // ANCHOR Tap count Text
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0, vertical: 5.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: Color(int.parse(
                                      userConfig['primary_background'])),
                                ),
                                child: Text(
                                  'Moves',
                                  textDirection: TextDirection.ltr,
                                  style: TextStyle(
                                      fontSize: 30.0,
                                      fontFamily: "BebasNeue",
                                      color: Color(
                                          int.parse(userConfig['secondary']))),
                                ),
                              ),
                              // ANCHOR Tap Count Number
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0, vertical: 5.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: Color(int.parse(
                                      userConfig['primary_background'])),
                                ),
                                child: Text(
                                  '$tapCount',
                                  textDirection: TextDirection.ltr,
                                  style: TextStyle(
                                      fontSize: 30.0,
                                      fontFamily: "BebasNeue",
                                      color: Color(
                                          int.parse(userConfig['secondary']))),
                                ),
                              ),
                            ],
                          ),
                        ],
                      )),

                  // ANCHOR Main Holding Container for tiles
                  Neumorphic(
                      style: NeumorphicStyle(
                        shape: NeumorphicShape.flat,
                        boxShape: NeumorphicBoxShape.roundRect(
                            const BorderRadius.all(Radius.circular(10.0))),
                        depth: -10.0,
                        intensity: 0.8,
                        surfaceIntensity: 0.8,
                        color: Color(int.parse(userConfig['primary'])),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(10.0),
                        decoration: const BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                            color: Colors.transparent),
                        width: mainContainerSize,
                        height: mainContainerSize,
                        child: FutureBuilder(
                            future: _splittedImage,
                            builder:
                                (context, AsyncSnapshot<List<Image>> snapshot) {
                              if (snapshot.connectionState ==
                                      ConnectionState.done &&
                                  snapshot.hasData) {
                                return Stack(children: [
                                  for (int i = 0; i < position.length - 1; i++)
                                    AnimatedAlign(
                                      alignment: position[i.toString()],
                                      curve: curves[userConfig['curve']],
                                      duration:
                                          const Duration(milliseconds: 500),
                                      child: GestureDetector(
                                          onTap: onTapActivated
                                              ? () {
                                                  debugPrint('${i + 1}');
                                                  debugPrint(
                                                      '${position[i.toString()]}');
                                                  List listPath = possiblePaths[
                                                      position[i.toString()]];
                                                  setState(() {
                                                    // Checking if it is goable
                                                    if (listPath.contains(
                                                        currentEmptySpot)) {
                                                      if (userConfig[
                                                              'interface_sound'] ==
                                                          "on") {
                                                        audioCacheInterface.play(
                                                            'click-tone-1.wav',
                                                            volume: double.parse(
                                                                userConfig[
                                                                    'interface_sound_volume']));
                                                      }
                                                      Alignment temp = position[
                                                          i.toString()];

                                                      position[i.toString()] =
                                                          currentEmptySpot;

                                                      currentEmptySpot = temp;
                                                      logTapTrail =
                                                          logTapTrail +
                                                              "${i + 1}" +
                                                              " " +
                                                              ">" +
                                                              " ";
                                                      // increment tap count by 1
                                                      ++tapCount;
                                                    }
                                                    // Check if position equals original position
                                                    if (checkMapEquals(position,
                                                        originalPosition)) {
                                                      solved = true;
                                                      showTimer = false;
                                                      timerValue = 30;
                                                      onTapActivated = false;
                                                      reset = false;
                                                      originalPositionReset =
                                                          false;
                                                      start = true;
                                                      logTapTrail =
                                                          logTapTrail + "End";

                                                      if (userConfig[
                                                              'interface_sound'] ==
                                                          "on") {
                                                        audioCacheInterface.play(
                                                            'select-click.wav',
                                                            volume: double.parse(
                                                                userConfig[
                                                                    'interface_sound_volume']));
                                                      }
                                                      _showSolvedAlert();
                                                    }
                                                  });
                                                }
                                              : null,
                                          child: Neumorphic(
                                            style: NeumorphicStyle(
                                              shape: NeumorphicShape.flat,
                                              boxShape: NeumorphicBoxShape
                                                  .roundRect(BorderRadius.all(
                                                      Radius.circular(
                                                          tileBorderRadius))),
                                              depth: 10.0,
                                              intensity: 0.8,
                                              surfaceIntensity: 0.8,
                                              shadowLightColor:
                                                  Colors.transparent,
                                              color: Color(int.parse(
                                                  userConfig['tile_color'])),
                                            ),
                                            child: SizedBox(
                                                width: tileSize,
                                                height: tileSize,
                                                child: FittedBox(
                                                  fit: BoxFit.fill,
                                                  child: snapshot.data![i],
                                                )),
                                          )),
                                    ),
                                ]);
                              }
                              if (snapshot.connectionState ==
                                      ConnectionState.waiting &&
                                  !snapshot.hasData) {
                                return Center(
                                  child: SizedBox(
                                    width: 100.0,
                                    height: 100.0,
                                    child: Neumorphic(
                                      style: NeumorphicStyle(
                                        shape: NeumorphicShape.flat,
                                        boxShape:
                                            const NeumorphicBoxShape.circle(),
                                        depth: 10.0,
                                        intensity: 0.8,
                                        surfaceIntensity: 0.8,
                                        color: Color(int.parse(userConfig[
                                            'secondary_background'])),
                                      ),
                                      child: CircularProgressIndicator(
                                        value: 0.6,
                                        strokeWidth: 10.0,
                                        color: Color(
                                            int.parse(userConfig['secondary'])),
                                      ),
                                    ),
                                  ),
                                );
                              }
                              if (snapshot.connectionState ==
                                      ConnectionState.waiting &&
                                  snapshot.hasData) {
                                return Center(
                                  child: SizedBox(
                                    width: 100.0,
                                    height: 100.0,
                                    child: Neumorphic(
                                      style: NeumorphicStyle(
                                        shape: NeumorphicShape.flat,
                                        boxShape:
                                            const NeumorphicBoxShape.circle(),
                                        depth: 10.0,
                                        intensity: 0.8,
                                        surfaceIntensity: 0.8,
                                        color: Color(int.parse(userConfig[
                                            'secondary_background'])),
                                      ),
                                      child: CircularProgressIndicator(
                                        value: 0.6,
                                        strokeWidth: 5.0,
                                        color: Color(
                                            int.parse(userConfig['secondary'])),
                                      ),
                                    ),
                                  ),
                                );
                              } else if (snapshot.hasError) {
                                return Center(
                                    child: Text(
                                  snapshot.error.toString(),
                                  textDirection: TextDirection.ltr,
                                  style: const TextStyle(
                                      fontSize: 50.0, color: Colors.red),
                                ));
                              } else {
                                return const SizedBox();
                              }
                            }),
                      )),
                  // ANCHOR Tile Size Slider
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 10.0),
                        width: (mainContainerSize / 2).floor().toDouble(),
                        child: NeumorphicSlider(
                          min:
                              ((mainContainerSize / tileNo).floor().toDouble() -
                                      10.0) -
                                  20.0,
                          max: (mainContainerSize / tileNo).floor().toDouble() -
                              10.0,
                          value: tileSize,
                          onChanged: (value) {
                            setState(() {
                              tileSize = value.toDouble();
                            });
                          },
                          style: SliderStyle(
                            depth: 5.0,
                            variant: Color(
                                int.parse(userConfig['secondary_background'])),
                            accent: Color(int.parse(userConfig['primary'])),
                          ),
                        ),
                      ),
                      // ANCHOR Tile Border Radius Slider
                      Container(
                        margin: const EdgeInsets.only(top: 10.0),
                        width: (mainContainerSize / 2).floor().toDouble(),
                        child: NeumorphicSlider(
                          min: 0.0,
                          max: (tileSize / 2).floor().toDouble(),
                          value: tileBorderRadius,
                          onChanged: (value) {
                            setState(() {
                              tileBorderRadius = value.toDouble();
                            });
                          },
                          style: SliderStyle(
                            depth: 5.0,
                            variant: Color(
                                int.parse(userConfig['secondary_background'])),
                            accent: Color(int.parse(userConfig['primary'])),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // ANCHOR Container for row of start and reset
                  Container(
                    margin: const EdgeInsets.only(bottom: 20.0, top: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        if (start)
                          NeumorphicButton(
                            style: NeumorphicStyle(
                                shape: NeumorphicShape.flat,
                                boxShape: const NeumorphicBoxShape.stadium(),
                                depth: 5.0,
                                intensity: 0.8,
                                surfaceIntensity: 0.8,
                                color: Color(int.parse(
                                    userConfig['secondary_background']))),
                            onPressed: start
                                ? () {
                                    if (userConfig['interface_sound'] == "on") {
                                      audioCacheInterface.play('start.wav',
                                          volume: double.parse(userConfig[
                                              'interface_sound_volume']));
                                    }
                                    setState(() {
                                      showTimer = true;
                                      position = Map.from(originalPosition);
                                      solved = false;
                                    });
                                    _countdown();
                                  }
                                : null,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  'Start',
                                  textDirection: TextDirection.ltr,
                                  style: TextStyle(
                                      fontSize: 30.0,
                                      fontFamily: "BebasNeue",
                                      color: start
                                          ? Color(int.parse(
                                              userConfig['secondary']))
                                          : Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        // ANCHOR Reset
                        if (reset)
                          NeumorphicButton(
                            style: NeumorphicStyle(
                                shape: NeumorphicShape.flat,
                                boxShape: const NeumorphicBoxShape.stadium(),
                                depth: 5.0,
                                intensity: 0.8,
                                surfaceIntensity: 0.8,
                                color: Color(int.parse(
                                    userConfig['secondary_background']))),
                            onPressed: reset
                                ? () {
                                    if (userConfig['interface_sound'] == "on") {
                                      audioCacheInterface.play('start.wav',
                                          volume: double.parse(userConfig[
                                              'interface_sound_volume']));
                                    }
                                    setState(() {
                                      position = Map.from(shuffledPosition);
                                      currentEmptySpot =
                                          shuffledCurrentEmptySpot;
                                      logTapTrail = "";
                                      tapCount = 0;
                                    });
                                  }
                                : null,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  'Reset',
                                  textDirection: TextDirection.ltr,
                                  style: TextStyle(
                                      fontSize: 30.0,
                                      fontFamily: "BebasNeue",
                                      color: reset
                                          ? Color(int.parse(
                                              userConfig['secondary']))
                                          : Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        // ANCHOR Restart
                        if (!start)
                          NeumorphicButton(
                            style: NeumorphicStyle(
                                shape: NeumorphicShape.flat,
                                boxShape: const NeumorphicBoxShape.stadium(),
                                depth: 5.0,
                                intensity: 0.8,
                                surfaceIntensity: 0.8,
                                color: Color(int.parse(
                                    userConfig['secondary_background']))),
                            onPressed: originalPositionReset
                                ? () {
                                    if (userConfig['interface_sound'] == "on") {
                                      audioCacheInterface.play('start.wav',
                                          volume: double.parse(userConfig[
                                              'interface_sound_volume']));
                                    }
                                    setState(() {
                                      position = Map.from(originalPosition);
                                      onTapActivated = false;
                                      start = true;
                                      originalPositionReset = false;
                                      shuffledPosition.clear();
                                      reset = false;
                                      tapCount = 0;
                                      logTapTrail = "";
                                      showLogTapTrail = false;
                                      // showGallery = true;
                                      showTimer = false;
                                      timerValue = 30;
                                    });
                                  }
                                : null,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  'Restart',
                                  textDirection: TextDirection.ltr,
                                  style: TextStyle(
                                      fontSize: 30.0,
                                      fontFamily: "BebasNeue",
                                      color: originalPositionReset
                                          ? Color(int.parse(
                                              userConfig['secondary']))
                                          : Colors.grey),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                  // ANCHOR Refer Image
                  if (showTimer)
                    Column(
                      children: [
                        Text(
                          timerValue.toString(),
                          textDirection: TextDirection.ltr,
                          style: TextStyle(
                              fontSize: 30.0,
                              fontFamily: "BebasNeue",
                              color: Color(int.parse(userConfig['secondary']))),
                        ),
                        Neumorphic(
                          margin:
                              const EdgeInsets.only(top: 20.0, bottom: 20.0),
                          style: NeumorphicStyle(
                              shape: NeumorphicShape.flat,
                              depth: 10.0,
                              intensity: 0.8,
                              surfaceIntensity: 0.8,
                              color: Color(int.parse(
                                  userConfig['secondary_background']))),
                          child: SizedBox(
                            width: 350.0,
                            height: 250.0,
                            child: tileBackgroundOption == 'IMAGE'
                                ? Image.asset(
                                    'assets/images/$localImageName',
                                    width: 350.0,
                                    height: 250.0,
                                    fit: BoxFit.fill,
                                    isAntiAlias: false,
                                  )
                                : Image.network(
                                    networkImageUrl.toString(),
                                    width: 350.0,
                                    height: 250.0,
                                    fit: BoxFit.fill,
                                    isAntiAlias: false,
                                  ),
                          ),
                        ),
                      ],
                    )
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
