import 'lib.dart';

class NMenuPage extends StatefulWidget {
  const NMenuPage({
    Key? key,
  }) : super(key: key);

  @override
  State<NMenuPage> createState() => _NMenuPageState();
}

class _NMenuPageState extends State<NMenuPage> {
  List<String> tileNo = ["2", "3", "4", "5"];
  List<String> mode = ["BASIC", "REFER TIMER", "TIMER"];
  List<String> tileBackgroundMode = ["SAME COLOR", "IMAGE", "RANDOM IMAGE"];
  List<String> tileReferTimerBackgroundMode = ["IMAGE", "RANDOM IMAGE"];

  late AudioCache _audioCacheInterface;

  int selectedIndexTileNo = 0;
  int selectedIndexMode = 0;
  int selectedIndexTileBackgroundMode = 0;
  int selectedIndexTileReferTimerBackgroundMode = 0;
  String selectedName = "SAME COLOR";

  String selectedImage = imageName[0];
  String networkImage = "";

  Future loadEnv() async {
    await dotenv.load(fileName: ".env");
  }

  late UnsplashClient client;

  Future<Uri> randomImages() async {
    final Uri img = ((await client.photos.random(count: 1).goAndGet())
        .first
        .urls
        .raw
        .resizePhoto(width: 1920, height: 1080));
    networkImage = img.toString();
    // print(img);
    // print(networkImage);
    return img;
  }

  @override
  void initState() {
    super.initState();
    loadEnv().then((value) {
      client = UnsplashClient(
        settings: ClientSettings(
            credentials: AppCredentials(
          accessKey: dotenv.get('ACCESS_KEY', fallback: accessKey),
          secretKey: dotenv.get('SECRET_KEY', fallback: secretKey),
        )),
      );
    });

    _audioCacheInterface = audioCacheInterface;
  }

  @override
  Widget build(BuildContext context) {
    return NeumorphicApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          appBar: AppBar(
            toolbarHeight: 80.0,
            elevation: 15.0,
            backgroundColor:
                Color(int.parse(userConfig['secondary_background'])),
            actions: [
              NeumorphicButton(
                  margin: const EdgeInsets.only(right: 10.0),
                  onPressed: () {
                    if (userConfig['interface_sound'] == 'on') {
                      _audioCacheInterface.play('page-back-chime.wav',
                          volume: double.parse(
                              userConfig['interface_sound_volume']),
                          mode: PlayerMode.MEDIA_PLAYER);
                    }
                    Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.rightToLeftWithFade,
                        child: const NSettings(),
                      ),
                    );
                  },
                  style: NeumorphicStyle(
                      shape: NeumorphicShape.flat,
                      boxShape: const NeumorphicBoxShape.circle(),
                      depth: 0.0,
                      intensity: 0.8,
                      surfaceIntensity: 0.8,
                      color:
                          Color(int.parse(userConfig['secondary_background']))),
                  child: Center(
                    child: Icon(
                      Icons.settings,
                      size: 30.0,
                      color: Color(
                        int.parse(userConfig['secondary']),
                      ),
                    ),
                  )),
            ],
            title: Row(
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
                              color: Color(int.parse(userConfig['primary']))),
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
                              color: Color(int.parse(userConfig['secondary']))),
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
                      fontSize: 35.0,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 30.0),
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
            centerTitle: false,
          ),
          backgroundColor: Color(int.parse(userConfig['primary_background'])),
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            physics: const BouncingScrollPhysics(),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Dummy SizedBox
                  const SizedBox(
                    width: double.infinity,
                    height: 50.0,
                  ),
                  // ANCHOR Tile No
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      NeumorphicButton(
                        onPressed: selectedIndexTileNo - 1 < 0
                            ? null
                            : () {
                                if (userConfig['interface_sound'] == 'on') {
                                  _audioCacheInterface.play('click-tone-1.wav',
                                      volume: double.parse(
                                          userConfig['interface_sound_volume']),
                                      mode: PlayerMode.MEDIA_PLAYER);
                                }
                                setState(() {
                                  selectedIndexTileNo =
                                      selectedIndexTileNo - 1 < 0
                                          ? 0
                                          : selectedIndexTileNo - 1;
                                });
                              },
                        style: NeumorphicStyle(
                          color: Color(
                              int.parse(userConfig['secondary_background'])),
                          shape: NeumorphicShape.flat,
                          boxShape: const NeumorphicBoxShape.circle(),
                          depth: 5.0,
                          intensity: 0.8,
                          surfaceIntensity: 0.8,
                        ),
                        child: Icon(
                          Icons.arrow_back_ios_rounded,
                          size: 30.0,
                          color: Color(int.parse(userConfig['primary'])),
                        ),
                      ),
                      Neumorphic(
                        padding: const EdgeInsets.all(20.0),
                        style: NeumorphicStyle(
                          color: Color(
                              int.parse(userConfig['secondary_background'])),
                          shape: NeumorphicShape.flat,
                          boxShape: NeumorphicBoxShape.roundRect(
                              const BorderRadius.all(Radius.circular(10.0))),
                          depth: 10.0,
                          intensity: 0.8,
                          surfaceIntensity: 0.8,
                        ),
                        child: SizedBox(
                          width: 150.0,
                          height: 100.0,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    'assets/icons/${tileNo[selectedIndexTileNo].toString()}X${tileNo[selectedIndexTileNo].toString()}.svg',
                                    color: Color(
                                        int.parse(userConfig['secondary'])),
                                    width: 35.0,
                                    height: 35.0,
                                    allowDrawingOutsideViewBox: true,
                                  ),
                                  const SizedBox(
                                    width: 10.0,
                                  ),
                                  Text(
                                    "${tileNo[selectedIndexTileNo].toString()}X${tileNo[selectedIndexTileNo].toString()}",
                                    textDirection: TextDirection.ltr,
                                    style: TextStyle(
                                        color: Color(
                                            int.parse(userConfig['secondary'])),
                                        fontFamily: "BebasNeue",
                                        fontWeight: FontWeight.w500,
                                        fontSize: 35.0),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10.0,
                              ),
                              Text(
                                  "A grid of ${tileNo[selectedIndexTileNo].toString()}X${tileNo[selectedIndexTileNo].toString()} with total of ${((int.parse(tileNo[selectedIndexTileNo]) * int.parse(tileNo[selectedIndexTileNo])) - 1).toString()} tiles",
                                  style: TextStyle(
                                    fontFamily: "BebasNeue",
                                    fontSize: 17.0,
                                    color: Color(
                                        int.parse(userConfig['secondary'])),
                                  )),
                            ],
                          ),
                        ),
                      ),
                      NeumorphicButton(
                        onPressed: selectedIndexTileNo + 1 > (tileNo.length - 1)
                            ? null
                            : () {
                                if (userConfig['interface_sound'] == "on") {
                                  _audioCacheInterface.play('click-tone-1.wav',
                                      volume: double.parse(
                                          userConfig['interface_sound_volume']),
                                      mode: PlayerMode.MEDIA_PLAYER);
                                }

                                setState(() {
                                  selectedIndexTileNo =
                                      selectedIndexTileNo + 1 >
                                              (tileNo.length - 1)
                                          ? (tileNo.length - 1)
                                          : selectedIndexTileNo + 1;
                                });
                              },
                        style: NeumorphicStyle(
                          color: Color(
                              int.parse(userConfig['secondary_background'])),
                          shape: NeumorphicShape.flat,
                          boxShape: const NeumorphicBoxShape.circle(),
                          depth: 5.0,
                          intensity: 0.8,
                          surfaceIntensity: 0.8,
                        ),
                        child: Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 30.0,
                          color: Color(int.parse(userConfig['primary'])),
                        ),
                      ),
                    ],
                  ),
                  // Dummy SizedBox
                  Container(
                    width: 2.0,
                    height: 50.0,
                    color: Color(int.parse(userConfig['secondary'])),
                  ),
                  // ANCHOR Tile Mode
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      NeumorphicButton(
                        onPressed: selectedIndexMode - 1 < 0
                            ? null
                            : () {
                                if (userConfig['interface_sound'] == "on") {
                                  _audioCacheInterface.play('click-tone-1.wav',
                                      volume: double.parse(
                                          userConfig['interface_sound_volume']),
                                      mode: PlayerMode.MEDIA_PLAYER);
                                }

                                setState(() {
                                  selectedIndexMode = selectedIndexMode - 1;
                                  selectedName = (mode[selectedIndexMode] ==
                                              'BASIC' ||
                                          mode[selectedIndexMode] == 'TIMER')
                                      ? tileBackgroundMode[0]
                                      : tileReferTimerBackgroundMode[0];
                                  if (mode[selectedIndexMode] == 'BASIC' ||
                                      mode[selectedIndexMode] == 'TIMER') {
                                    selectedIndexTileBackgroundMode = 0;
                                  } else {
                                    selectedIndexTileReferTimerBackgroundMode =
                                        0;
                                  }
                                });
                              },
                        style: NeumorphicStyle(
                          color: Color(
                              int.parse(userConfig['secondary_background'])),
                          shape: NeumorphicShape.flat,
                          boxShape: const NeumorphicBoxShape.circle(),
                          depth: 5.0,
                          intensity: 0.8,
                          surfaceIntensity: 0.8,
                        ),
                        child: Icon(
                          Icons.arrow_back_ios_rounded,
                          size: 30.0,
                          color: Color(int.parse(userConfig['primary'])),
                        ),
                      ),
                      Neumorphic(
                        padding: const EdgeInsets.all(20.0),
                        style: NeumorphicStyle(
                          color: Color(
                              int.parse(userConfig['secondary_background'])),
                          shape: NeumorphicShape.flat,
                          boxShape: NeumorphicBoxShape.roundRect(
                              const BorderRadius.all(Radius.circular(10.0))),
                          depth: 10.0,
                          intensity: 0.8,
                          surfaceIntensity: 0.8,
                        ),
                        child: SizedBox(
                          width: 150.0,
                          height: 100.0,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    'assets/icons/${mode[selectedIndexMode].toLowerCase()}.svg',
                                    color: Color(
                                        int.parse(userConfig['secondary'])),
                                    width: 35.0,
                                    height: 35.0,
                                    allowDrawingOutsideViewBox: true,
                                  ),
                                  const SizedBox(
                                    width: 10.0,
                                  ),
                                  Text(
                                    mode[selectedIndexMode],
                                    textDirection: TextDirection.ltr,
                                    style: TextStyle(
                                        color: Color(
                                            int.parse(userConfig['secondary'])),
                                        fontFamily: "BebasNeue",
                                        fontWeight: FontWeight.w500,
                                        fontSize: 25.0),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10.0,
                              ),
                              Text(
                                  mode[selectedIndexMode] == "BASIC"
                                      ? "Solve the puzzle freely"
                                      : mode[selectedIndexMode] == "REFER TIMER"
                                          ? "Memorize the image and solve the puzzle"
                                          : "Solve the puzzle within a time limit.",
                                  style: TextStyle(
                                    fontFamily: "BebasNeue",
                                    fontSize: 17.0,
                                    color: Color(
                                        int.parse(userConfig['secondary'])),
                                  )),
                            ],
                          ),
                        ),
                      ),
                      NeumorphicButton(
                        onPressed: selectedIndexMode + 1 > (mode.length - 1)
                            ? null
                            : () {
                                if (userConfig['interface_sound'] == "on") {
                                  _audioCacheInterface.play('click-tone-1.wav',
                                      volume: double.parse(
                                          userConfig['interface_sound_volume']),
                                      mode: PlayerMode.MEDIA_PLAYER);
                                }
                                setState(() {
                                  selectedIndexMode = selectedIndexMode + 1;
                                  selectedName = (mode[selectedIndexMode] ==
                                              'BASIC' ||
                                          mode[selectedIndexMode] == 'TIMER')
                                      ? tileBackgroundMode[0]
                                      : tileReferTimerBackgroundMode[0];
                                  if (mode[selectedIndexMode] == 'BASIC' ||
                                      mode[selectedIndexMode] == 'TIMER') {
                                    selectedIndexTileBackgroundMode = 0;
                                  } else {
                                    selectedIndexTileReferTimerBackgroundMode =
                                        0;
                                  }
                                });
                              },
                        style: NeumorphicStyle(
                          color: Color(
                              int.parse(userConfig['secondary_background'])),
                          shape: NeumorphicShape.flat,
                          boxShape: const NeumorphicBoxShape.circle(),
                          depth: 5.0,
                          intensity: 0.8,
                          surfaceIntensity: 0.8,
                        ),
                        child: Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 30.0,
                          color: Color(int.parse(userConfig['primary'])),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 2.0,
                    height: 50.0,
                    color: Color(int.parse(userConfig['secondary'])),
                  ),
                  if (mode[selectedIndexMode] == 'BASIC' ||
                      mode[selectedIndexMode] == 'TIMER')
                    // ANCHOR TIle background Options
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        NeumorphicButton(
                          onPressed: selectedIndexTileBackgroundMode - 1 < 0
                              ? null
                              : () {
                                  if (userConfig['interface_sound'] == "on") {
                                    _audioCacheInterface.play(
                                        'click-tone-1.wav',
                                        volume: double.parse(userConfig[
                                            'interface_sound_volume']),
                                        mode: PlayerMode.MEDIA_PLAYER);
                                  }
                                  setState(() {
                                    selectedIndexTileBackgroundMode =
                                        selectedIndexTileBackgroundMode - 1;
                                    selectedName = tileBackgroundMode[
                                        selectedIndexTileBackgroundMode];
                                  });
                                },
                          style: NeumorphicStyle(
                            color: Color(
                                int.parse(userConfig['secondary_background'])),
                            shape: NeumorphicShape.flat,
                            boxShape: const NeumorphicBoxShape.circle(),
                            depth: 5.0,
                            intensity: 0.8,
                            surfaceIntensity: 0.8,
                          ),
                          child: Icon(
                            Icons.arrow_back_ios_rounded,
                            size: 30.0,
                            color: Color(int.parse(userConfig['primary'])),
                          ),
                        ),
                        Neumorphic(
                          padding: const EdgeInsets.all(20.0),
                          style: NeumorphicStyle(
                            color: Color(
                                int.parse(userConfig['secondary_background'])),
                            shape: NeumorphicShape.flat,
                            boxShape: NeumorphicBoxShape.roundRect(
                                const BorderRadius.all(Radius.circular(10.0))),
                            depth: 10.0,
                            intensity: 0.8,
                            surfaceIntensity: 0.8,
                          ),
                          child: SizedBox(
                            width: 150.0,
                            height: 100.0,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      tileBackgroundMode[
                                                  selectedIndexTileBackgroundMode] ==
                                              "SAME COLOR"
                                          ? Icons.rectangle_rounded
                                          : tileBackgroundMode[
                                                      selectedIndexTileBackgroundMode] ==
                                                  "IMAGE"
                                              ? Icons.image
                                              : Icons.image_search,
                                      size: 30.0,
                                      color: Color(
                                          int.parse(userConfig['secondary'])),
                                    ),
                                    const SizedBox(
                                      width: 10.0,
                                    ),
                                    Text(
                                      tileBackgroundMode[
                                          selectedIndexTileBackgroundMode],
                                      textDirection: TextDirection.ltr,
                                      style: TextStyle(
                                          color: Color(int.parse(
                                              userConfig['secondary'])),
                                          fontFamily: "BebasNeue",
                                          fontWeight: FontWeight.w500,
                                          fontSize: 20.0),
                                    ),
                                  ],
                                ),
                                Text(
                                    tileBackgroundMode[
                                                selectedIndexTileBackgroundMode] ==
                                            "SAME COLOR"
                                        ? "All the tiles are of same color with ID's on it"
                                        : tileBackgroundMode[
                                                    selectedIndexTileBackgroundMode] ==
                                                "IMAGE"
                                            ? "All the tiles will be pieces of local image"
                                            : "All the tiles will be a pieces of a random image from unsplash",
                                    style: TextStyle(
                                      fontFamily: "BebasNeue",
                                      fontSize: 17.0,
                                      color: Color(
                                          int.parse(userConfig['secondary'])),
                                    )),
                              ],
                            ),
                          ),
                        ),
                        NeumorphicButton(
                          onPressed: selectedIndexTileBackgroundMode + 1 >
                                  (tileBackgroundMode.length - 1)
                              ? null
                              : () {
                                  if (userConfig['interface_sound'] == "on") {
                                    _audioCacheInterface.play(
                                        'click-tone-1.wav',
                                        volume: double.parse(userConfig[
                                            'interface_sound_volume']),
                                        mode: PlayerMode.MEDIA_PLAYER);
                                  }
                                  setState(() {
                                    selectedIndexTileBackgroundMode =
                                        selectedIndexTileBackgroundMode + 1;
                                    selectedName = tileBackgroundMode[
                                        selectedIndexTileBackgroundMode];
                                  });
                                },
                          style: NeumorphicStyle(
                            color: Color(
                                int.parse(userConfig['secondary_background'])),
                            shape: NeumorphicShape.flat,
                            boxShape: const NeumorphicBoxShape.circle(),
                            depth: 5.0,
                            intensity: 0.8,
                            surfaceIntensity: 0.8,
                          ),
                          child: Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 30.0,
                            color: Color(int.parse(userConfig['primary'])),
                          ),
                        ),
                      ],
                    ),
                  if (mode[selectedIndexMode] == 'REFER TIMER')
                    // ANCHOR Tile background Options
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        NeumorphicButton(
                          onPressed:
                              selectedIndexTileReferTimerBackgroundMode - 1 < 0
                                  ? null
                                  : () {
                                      if (userConfig['interface_sound'] ==
                                          "on") {
                                        _audioCacheInterface.play(
                                            'click-tone-1.wav',
                                            volume: double.parse(userConfig[
                                                'interface_sound_volume']),
                                            mode: PlayerMode.MEDIA_PLAYER);
                                      }
                                      setState(() {
                                        selectedIndexTileReferTimerBackgroundMode =
                                            selectedIndexTileReferTimerBackgroundMode -
                                                1;
                                        selectedName = tileReferTimerBackgroundMode[
                                            selectedIndexTileReferTimerBackgroundMode];
                                      });
                                    },
                          style: NeumorphicStyle(
                            color: Color(
                                int.parse(userConfig['secondary_background'])),
                            shape: NeumorphicShape.flat,
                            boxShape: const NeumorphicBoxShape.circle(),
                            depth: 5.0,
                            intensity: 0.8,
                            surfaceIntensity: 0.8,
                          ),
                          child: Icon(
                            Icons.arrow_back_ios_rounded,
                            size: 30.0,
                            color: Color(int.parse(userConfig['primary'])),
                          ),
                        ),
                        Neumorphic(
                          padding: const EdgeInsets.all(20.0),
                          style: NeumorphicStyle(
                            color: Color(
                                int.parse(userConfig['secondary_background'])),
                            shape: NeumorphicShape.flat,
                            boxShape: NeumorphicBoxShape.roundRect(
                                const BorderRadius.all(Radius.circular(10.0))),
                            depth: 10.0,
                            intensity: 0.8,
                            surfaceIntensity: 0.8,
                          ),
                          child: SizedBox(
                            width: 150.0,
                            height: 100.0,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      tileReferTimerBackgroundMode[
                                                  selectedIndexTileReferTimerBackgroundMode] ==
                                              "IMAGE"
                                          ? Icons.image
                                          : Icons.image_search_rounded,
                                      size: 30.0,
                                      color: Color(
                                          int.parse(userConfig['secondary'])),
                                    ),
                                    const SizedBox(
                                      width: 10.0,
                                    ),
                                    Text(
                                      tileReferTimerBackgroundMode[
                                          selectedIndexTileReferTimerBackgroundMode],
                                      textDirection: TextDirection.ltr,
                                      style: TextStyle(
                                          color: Color(int.parse(
                                              userConfig['secondary'])),
                                          fontFamily: "BebasNeue",
                                          fontWeight: FontWeight.w500,
                                          fontSize: 20.0),
                                    ),
                                  ],
                                ),
                                Text(
                                    tileReferTimerBackgroundMode[
                                                selectedIndexTileReferTimerBackgroundMode] ==
                                            "IMAGE"
                                        ? "All the tiles will be pieces of local image"
                                        : "All the tiles will be a pieces of a random image from unsplash",
                                    style: TextStyle(
                                      fontFamily: "BebasNeue",
                                      fontSize: 15.0,
                                      color: Color(
                                          int.parse(userConfig['secondary'])),
                                    )),
                              ],
                            ),
                          ),
                        ),
                        NeumorphicButton(
                          onPressed: selectedIndexTileReferTimerBackgroundMode +
                                      1 >
                                  (tileReferTimerBackgroundMode.length - 1)
                              ? null
                              : () {
                                  if (userConfig['interface_sound'] == "on") {
                                    _audioCacheInterface.play(
                                        'click-tone-1.wav',
                                        volume: double.parse(userConfig[
                                            'interface_sound_volume']),
                                        mode: PlayerMode.MEDIA_PLAYER);
                                  }
                                  setState(() {
                                    selectedIndexTileReferTimerBackgroundMode =
                                        selectedIndexTileReferTimerBackgroundMode +
                                            1;
                                    selectedName = tileReferTimerBackgroundMode[
                                        selectedIndexTileReferTimerBackgroundMode];
                                  });
                                },
                          style: NeumorphicStyle(
                            color: Color(
                                int.parse(userConfig['secondary_background'])),
                            shape: NeumorphicShape.flat,
                            boxShape: const NeumorphicBoxShape.circle(),
                            depth: 5.0,
                            intensity: 0.8,
                            surfaceIntensity: 0.8,
                          ),
                          child: Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 30.0,
                            color: Color(int.parse(userConfig['primary'])),
                          ),
                        ),
                      ],
                    ),
                  if (selectedName == 'IMAGE')
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 10.0),
                      margin: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            width: 280.0,
                            child: CarouselSlider(
                              options: CarouselOptions(
                                height: 400.0,
                                scrollDirection: Axis.vertical,
                                enableInfiniteScroll: false,
                                viewportFraction: 0.5,
                                reverse: true,
                                scrollPhysics: const BouncingScrollPhysics(),
                                enlargeCenterPage: true,
                                autoPlay: true,
                                autoPlayInterval: const Duration(seconds: 2),
                              ),
                              items: imageName.map((imageName) {
                                return Builder(
                                  builder: (BuildContext context) {
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          selectedImage = imageName;
                                        });
                                      },
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        child: Image.asset(
                                          'assets/images/$imageName',
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }).toList(),
                            ),
                          ),
                          Neumorphic(
                            style: NeumorphicStyle(
                              shape: NeumorphicShape.flat,
                              boxShape: NeumorphicBoxShape.roundRect(
                                  const BorderRadius.all(
                                      Radius.circular(10.0))),
                              depth: 10.0,
                              intensity: 0.8,
                              surfaceIntensity: 0.8,
                              color: Color(int.parse(
                                  userConfig['secondary_background'])),
                            ),
                            child: ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10.0)),
                              child: Image.asset(
                                'assets/images/$selectedImage',
                                width: kIsWeb ? 120.0 : 100.0,
                                height: kIsWeb ? 120.0 : 100.0,
                                fit: BoxFit.fill,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  if (selectedName == 'RANDOM IMAGE')
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 10.0),
                      margin: const EdgeInsets.symmetric(vertical: 10.0),
                      child: FutureBuilder(
                          future: randomImages(),
                          builder: ((context, AsyncSnapshot<Uri> snapshot) {
                            if (snapshot.connectionState ==
                                    ConnectionState.done &&
                                snapshot.hasData) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10.0)),
                                    child: Image.network(
                                      "${snapshot.data!}",
                                      fit: BoxFit.fill,
                                      width: 290,
                                    ),
                                  ),
                                  NeumorphicButton(
                                    style: NeumorphicStyle(
                                        shape: NeumorphicShape.flat,
                                        boxShape:
                                            const NeumorphicBoxShape.circle(),
                                        depth: 5.0,
                                        intensity: 0.8,
                                        surfaceIntensity: 0.8,
                                        color: Color(int.parse(userConfig[
                                            'secondary_background']))),
                                    child: Icon(
                                      Icons.refresh_rounded,
                                      size: 30.0,
                                      color: Color(
                                          int.parse(userConfig['primary'])),
                                    ),
                                    onPressed: () {
                                      setState(() {});
                                    },
                                  )
                                ],
                              );
                            }
                            if (snapshot.connectionState ==
                                    ConnectionState.waiting &&
                                !snapshot.hasData) {
                              return SpinKitChasingDots(
                                color:
                                    Color(int.parse(userConfig['secondary'])),
                                size: 100.0,
                              );
                            }
                            if (snapshot.connectionState ==
                                    ConnectionState.waiting &&
                                snapshot.hasData) {
                              return SpinKitChasingDots(
                                color:
                                    Color(int.parse(userConfig['secondary'])),
                                size: 100.0,
                              );
                            } else {
                              return const SizedBox();
                            }
                          })),
                    ),
                  Container(
                    width: 2.0,
                    height: 50.0,
                    color: Color(int.parse(userConfig['secondary'])),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 30.0,
                        color: Color(int.parse(userConfig['primary'])),
                      ),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 30.0,
                        color: Color(int.parse(userConfig['primary'])),
                      ),
                      NeumorphicButton(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0),
                        onPressed: () {
                          if (mode[selectedIndexMode] == 'BASIC') {
                            if (userConfig['interface_sound'] == "on") {
                              _audioCacheInterface.play('page-back-chime.wav',
                                  volume: double.parse(
                                      userConfig['interface_sound_volume']),
                                  mode: PlayerMode.MEDIA_PLAYER);
                            }
                            Navigator.push(
                              context,
                              PageTransition(
                                  child: NBasicPage(
                                    tileNo:
                                        int.parse(tileNo[selectedIndexTileNo]),
                                    tileBackgroundOption: selectedName,
                                    localImageName: selectedName == "IMAGE"
                                        ? selectedImage
                                        : "",
                                    networkImageUrl:
                                        selectedName == "RANDOM IMAGE"
                                            ? networkImage
                                            : "",
                                  ),
                                  type: PageTransitionType.rightToLeftWithFade),
                            );
                          }
                          if (mode[selectedIndexMode] == 'REFER TIMER') {
                            if (userConfig['interface_sound'] == "on") {
                              _audioCacheInterface
                                  .play('page-back-chime.wav',
                                      volume: double.parse(
                                          userConfig['interface_sound_volume']),
                                      mode: PlayerMode.MEDIA_PLAYER)
                                  .then((value) {
                                Navigator.push(
                                  context,
                                  PageTransition(
                                      child: NReferTimerPage(
                                        tileNo: int.parse(
                                            tileNo[selectedIndexTileNo]),
                                        tileBackgroundOption: selectedName,
                                        localImageName: selectedName == "IMAGE"
                                            ? selectedImage
                                            : "",
                                        networkImageUrl:
                                            selectedName == "RANDOM IMAGE"
                                                ? networkImage
                                                : "",
                                      ),
                                      type: PageTransitionType
                                          .rightToLeftWithFade),
                                );
                              });
                            } else {
                              Navigator.push(
                                context,
                                PageTransition(
                                    child: NReferTimerPage(
                                      tileNo: int.parse(
                                          tileNo[selectedIndexTileNo]),
                                      tileBackgroundOption: selectedName,
                                      localImageName: selectedName == "IMAGE"
                                          ? selectedImage
                                          : "",
                                      networkImageUrl:
                                          selectedName == "RANDOM IMAGE"
                                              ? networkImage
                                              : "",
                                    ),
                                    type:
                                        PageTransitionType.rightToLeftWithFade),
                              );
                            }
                          }
                          if (mode[selectedIndexMode] == 'TIMER') {
                            if (userConfig['interface_sound'] == "on") {
                              _audioCacheInterface
                                  .play(
                                'page-back-chime.wav',
                                volume: double.parse(
                                    userConfig['interface_sound_volume']),
                              )
                                  .then((value) {
                                Navigator.push(
                                  context,
                                  PageTransition(
                                      child: NTimerPage(
                                        tileNo: int.parse(
                                            tileNo[selectedIndexTileNo]),
                                        tileBackgroundOption: selectedName,
                                        localImageName: selectedName == "IMAGE"
                                            ? selectedImage
                                            : "",
                                        networkImageUrl:
                                            selectedName == "RANDOM IMAGE"
                                                ? networkImage
                                                : "",
                                      ),
                                      type: PageTransitionType
                                          .rightToLeftWithFade),
                                );
                              });
                            } else {
                              Navigator.push(
                                context,
                                PageTransition(
                                    child: NTimerPage(
                                      tileNo: int.parse(
                                          tileNo[selectedIndexTileNo]),
                                      tileBackgroundOption: selectedName,
                                      localImageName: selectedName == "IMAGE"
                                          ? selectedImage
                                          : "",
                                      networkImageUrl:
                                          selectedName == "RANDOM IMAGE"
                                              ? networkImage
                                              : "",
                                    ),
                                    type:
                                        PageTransitionType.rightToLeftWithFade),
                              );
                            }
                          }
                        },
                        style: NeumorphicStyle(
                            shape: NeumorphicShape.flat,
                            boxShape: NeumorphicBoxShape.roundRect(
                                const BorderRadius.all(Radius.circular(10.0))),
                            depth: 0.0,
                            intensity: 0.8,
                            surfaceIntensity: 0.8,
                            border: NeumorphicBorder(
                                width: 2.0,
                                color:
                                    Color(int.parse(userConfig['secondary']))),
                            color: Color(
                                int.parse(userConfig['primary_background']))),
                        child: Text(
                          'GO',
                          textDirection: TextDirection.ltr,
                          style: TextStyle(
                            color: Color(int.parse(userConfig['secondary'])),
                            fontFamily: "BebasNeue",
                            fontSize: 40.0,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.arrow_back_ios_rounded,
                        size: 30.0,
                        color: Color(int.parse(userConfig['primary'])),
                      ),
                      Icon(
                        Icons.arrow_back_ios_rounded,
                        size: 30.0,
                        color: Color(int.parse(userConfig['primary'])),
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 2.0,
                    height: 50.0,
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
