import 'lib.dart';
import 'package:path/path.dart' as path;

void main() {
  runApp(const MainPage());
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late Future<Map> _configuration;

  final AudioPlayer _audioPlayerBackground = AudioPlayer();
  late AudioCache _audioCacheBackground;

  final AudioPlayer _audioPlayerInterface = AudioPlayer();
  late AudioCache _audioCacheInterface;

  late Future<List<Uri>> _audioCacheBackgroundFuture;
  late Future<List<Uri>> _audioCacheInterfaceFuture;

  late Future _allFutures;

  Future<bool> _checkFileExists(String path) async {
    return File('$path/userprefs.json').exists();
  }

  Future<String> _readValues(File filePath) async {
    final file = filePath;

    // Read the file
    final contents = await file.readAsString();
    return contents;
  }

  Future<bool> _createConfigFile(String path) async {
    return File('$path/userprefs.json').create(recursive: true).then((value) {
      return true;
    });
  }

  Future<bool> _writeValues(path, String values) async {
    File file = File('$path/userprefs.json');
    return file.writeAsString(values).then((value) {
      return true;
    });
  }

  Future<Map> parseJsonFromAssets(String assetsPath) async {
    return rootBundle
        .loadString(assetsPath)
        .then((jsonStr) => jsonDecode(jsonStr));
  }

  bool _checkKeys(Map a, Map b) {
    bool res = false;
    for (var key in a.keys) {
      if (!b.containsKey(key)) {
        res = true;
        break;
      }
    }
    return res;
  }

  Future<Map> _checkCfgExists() async {
    Map configSettings = {}; // configSettings is used for snapshot part
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    return _checkFileExists(path).then((bool value) {
      // Config file found in user file system
      if (value) {
        // Read json from File system
        return _readValues(File('$path/userprefs.json')).then((String value) {
          Map jsonObject = json.decode(value);
          configSettings.addAll(jsonObject);

          // Checking if the default config is not of same length, then the read from file and update the value with default and write again.
          // Changing the default will change the file automatically.
          parseJsonFromAssets('assets/config/config_default.json')
              .then((Map defaultValue) {
            List toRemove = [];
            if ((defaultValue.keys.length != jsonObject.keys.length) ||
                _checkKeys(defaultValue, jsonObject) ||
                _checkKeys(jsonObject, defaultValue)) {
              for (var key in defaultValue.keys) {
                // if (defaultValue[key] != jsonObject[key]) {
                //   jsonObject[key] = defaultValue[key];
                // }
                if (jsonObject[key] == '') {
                  jsonObject[key] = defaultValue[key];
                }
                // key is missing in jsonObject
                if (!jsonObject.containsKey(key)) {
                  jsonObject[key] = defaultValue[key];
                }
              }
              for (var key in jsonObject.keys) {
                if (!defaultValue.containsKey(key)) {
                  toRemove.add(key);
                }
              }
              jsonObject.removeWhere((k, v) => toRemove.contains(k));
              // Assign the values to config page
              userConfig.addAll(jsonObject);
              // print(userConfig);
              // debugPrint(
              //    'Fetched data from file system and updated userconfig');
              _writeValues(path, json.encode(jsonObject)).then((value) {
                // debugPrint(
                //    'Write successful to file bcoz 2 file are different');
              });
            } else {
              // Assign the values to config page
              userConfig.addAll(jsonObject);
              // print(userConfig);
              // debugPrint('Updated Config page');
            }
          });

          return configSettings;
        });
      }
      // No file found in user file system.
      else {
        // Create file
        return _createConfigFile(path).then((bool response) {
          // debugPrint('File created successfully');
          // File created successfully
          // Read default data from assets folder
          return parseJsonFromAssets('assets/config/config_default.json')
              .then((Map values) {
            // Assign value to configSettings
            configSettings.addAll(values);

            // Write these values to file
            _writeValues(path, json.encode(values)).then((value) {
              // debugPrint('Write successful to file');
            });
            // Also we need to apply the values to config page, since
            userConfig.addAll(values);
            // debugPrint('Write successful to config page');

            return configSettings;
          });
        });
      }
    });
  }

  Future<List<String>> _getAudioFilesName(String folderName) async {
    List<String> audioName = [];
    final manifestJson =
        await DefaultAssetBundle.of(context).loadString('AssetManifest.json');
    final audios = json
        .decode(manifestJson)
        .keys
        .where((String key) => key.startsWith('assets/audios/$folderName'));
    for (var audioPath in audios.toList()) {
      String fileName = path.basename(File(audioPath).path);
      audioName.add(fileName);
    }
    // print(audioName);
    return audioName;
  }

  Future<List<String>> _getImageFilesName() async {
    List<String> imageName = [];
    final manifestJson =
        await DefaultAssetBundle.of(context).loadString('AssetManifest.json');
    final images = json
        .decode(manifestJson)
        .keys
        .where((String key) => key.startsWith('assets/images'));
    for (var imagePath in images.toList()) {
      String fileName = path.basename(File(imagePath).path);
      imageName.add(fileName);
    }
    // print(imageName);
    return imageName;
  }

  @override
  void initState() {
    super.initState();

    if (!kIsWeb) {
      _configuration =
          Future.delayed(const Duration(seconds: 10)).then((_) async {
        return await _checkCfgExists();
      });
    } else {
      userConfig = Map.from(defaultConfig);
    }

    _audioCacheBackground = AudioCache(
        prefix: 'assets/audios/background/',
        fixedPlayer: _audioPlayerBackground);
    _audioCacheBackgroundFuture =
        _getAudioFilesName('background').then((value) async {
      audioName = value;
      return await _audioCacheBackground.loadAll(value);
    });

    _audioCacheInterface = AudioCache(
        prefix: 'assets/audios/interface/', fixedPlayer: _audioPlayerInterface);
    _audioCacheInterfaceFuture =
        _getAudioFilesName('interface').then((value) async {
      return await _audioCacheInterface.loadAll(value);
    });

    _getImageFilesName().then((value) async {
      imageName = value;
    });

    if (!kIsWeb) {
      _allFutures = Future.wait([
        _configuration,
        _audioCacheBackgroundFuture,
        _audioCacheInterfaceFuture,
      ]);
    } else {
      _allFutures = Future.wait([
        _audioCacheBackgroundFuture,
        _audioCacheInterfaceFuture,
      ]);
    }

    _allFutures.then((value) async {
      audioPlayerBackground = _audioPlayerBackground;
      audioCacheBackground = _audioCacheBackground;
      audioPlayerInterface = _audioPlayerInterface;
      audioCacheInterface = _audioCacheInterface;
    });
  }

  @override
  Widget build(BuildContext context) {
    // ANCHOR Android
    if (!kIsWeb) {
      return MediaQuery(
        data: const MediaQueryData(),
        child: FutureBuilder(
          future: _allFutures,
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              if (snapshot.data[0]!['background_sound'] == "on") {
                _audioCacheBackground.loop(
                  "${snapshot.data[0]!['background_sound_option']}.ogg",
                  volume: double.parse(
                      snapshot.data[0]!['background_sound_volume']),
                );
              }
              return NeumorphicApp(
                debugShowCheckedModeBanner: false,
                home: Scaffold(
                  backgroundColor:
                      Color(int.parse(snapshot.data[0]!['primary_background'])),
                  body: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 20.0),
                          width: 270.0,
                          height: 270.0,
                          child: Stack(children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: SizedBox(
                                width: 200.0,
                                height: 200.0,
                                child: Neumorphic(
                                  style: NeumorphicStyle(
                                    shape: NeumorphicShape.flat,
                                    boxShape: const NeumorphicBoxShape.circle(),
                                    depth: 5.0,
                                    intensity: 0.8,
                                    surfaceIntensity: 0.8,
                                    color: Color(int.parse(
                                        snapshot.data[0]!['primary'])),
                                  ),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: SizedBox(
                                width: 200.0,
                                height: 200.0,
                                child: Neumorphic(
                                  style: NeumorphicStyle(
                                    shape: NeumorphicShape.flat,
                                    boxShape: const NeumorphicBoxShape.circle(),
                                    depth: 5.0,
                                    intensity: 0.8,
                                    surfaceIntensity: 0.8,
                                    color: Color(int.parse(
                                        snapshot.data[0]!['secondary'])),
                                  ),
                                ),
                              ),
                            ),
                          ]),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 50.0),
                          padding: const EdgeInsets.symmetric(horizontal: 14.0),
                          height: 200.0,
                          width: 300.0,
                          child: Stack(
                            children: [
                              Align(
                                alignment: Alignment.center,
                                child: Text(
                                  'SLIDER',
                                  textDirection: TextDirection.ltr,
                                  style: TextStyle(
                                    fontFamily: "BebasNeue",
                                    fontSize: 130.0,
                                    color: Color(int.parse(
                                        snapshot.data[0]!['primary'])),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Text(
                                  'PUZZLE',
                                  textDirection: TextDirection.ltr,
                                  style: TextStyle(
                                    fontFamily: "BebasNeue",
                                    fontSize: 50.0,
                                    color: Color(int.parse(
                                        snapshot.data[0]!['secondary'])),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 50.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 30.0,
                                color: Color(
                                    int.parse(snapshot.data[0]!['primary'])),
                              ),
                              Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 30.0,
                                color: Color(
                                    int.parse(snapshot.data[0]!['primary'])),
                              ),
                              Builder(builder: (context) {
                                return NeumorphicButton(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 20.0),
                                  onPressed: () {
                                    if (snapshot.data[0]!['interface_sound'] ==
                                        'on') {
                                      _audioCacheInterface.play(
                                          'page-back-chime.wav',
                                          volume: double.parse(snapshot.data[
                                              0]!['interface_sound_volume']),
                                          mode: PlayerMode.MEDIA_PLAYER);
                                    }
                                    Navigator.push(
                                      context,
                                      PageTransition(
                                          child: const NMenuPage(),
                                          type: PageTransitionType
                                              .rightToLeftWithFade),
                                    );
                                  },
                                  style: NeumorphicStyle(
                                      shape: NeumorphicShape.flat,
                                      boxShape: NeumorphicBoxShape.roundRect(
                                          const BorderRadius.all(
                                              Radius.circular(10.0))),
                                      depth: 0.0,
                                      intensity: 0.8,
                                      surfaceIntensity: 0.8,
                                      color: Color(int.parse(snapshot
                                          .data[0]!['primary_background']))),
                                  child: Text(
                                    'START',
                                    textDirection: TextDirection.ltr,
                                    style: TextStyle(
                                      color: Color(int.parse(
                                          snapshot.data[0]!['secondary'])),
                                      fontFamily: "BebasNeue",
                                      fontSize: 40.0,
                                    ),
                                  ),
                                );
                              }),
                              Icon(
                                Icons.arrow_back_ios_rounded,
                                size: 30.0,
                                color: Color(
                                    int.parse(snapshot.data[0]!['primary'])),
                              ),
                              Icon(
                                Icons.arrow_back_ios_rounded,
                                size: 30.0,
                                color: Color(
                                    int.parse(snapshot.data[0]!['primary'])),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            } else if (snapshot.connectionState == ConnectionState.waiting &&
                !snapshot.hasData) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                home: Scaffold(
                  backgroundColor: Colors.grey[50],
                  body: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SpinKitChasingDots(
                        color: Colors.indigo[800],
                        size: 250.0,
                      ),
                      Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.only(top: 20.0),
                        child: DefaultTextStyle(
                          style: TextStyle(
                              fontSize: 30.0,
                              color: Colors.indigo[900],
                              fontFamily: "BebasNeue"),
                          child: AnimatedTextKit(
                              repeatForever: true,
                              animatedTexts: [
                                TypewriterAnimatedText(
                                  'Fetching the code...',
                                  speed: const Duration(milliseconds: 50),
                                ),
                                TypewriterAnimatedText('Fetching the config...',
                                    speed: const Duration(milliseconds: 50)),
                                TypewriterAnimatedText('Fetching the logic...',
                                    speed: const Duration(milliseconds: 50)),
                                TypewriterAnimatedText('Fetching the files...',
                                    speed: const Duration(milliseconds: 50)),
                                TypewriterAnimatedText('Fetching the game...',
                                    speed: const Duration(milliseconds: 50)),
                                TypewriterAnimatedText('Fetching the world...',
                                    speed: const Duration(milliseconds: 50)),
                                TypewriterAnimatedText('Fetching the levels...',
                                    speed: const Duration(milliseconds: 50)),
                                TypewriterAnimatedText('Fetching the theme...',
                                    speed: const Duration(milliseconds: 50)),
                                TypewriterAnimatedText('Fetching the assets...',
                                    speed: const Duration(milliseconds: 50)),
                                TypewriterAnimatedText('Fetching the tiles...',
                                    speed: const Duration(milliseconds: 50)),
                                TypewriterAnimatedText('Fetching the APIs...',
                                    speed: const Duration(milliseconds: 50)),
                                TypewriterAnimatedText('Fetching the design...',
                                    speed: const Duration(milliseconds: 50)),
                                TypewriterAnimatedText('Fetching...',
                                    speed: const Duration(milliseconds: 50)),
                              ],
                              pause: const Duration(
                                milliseconds: 0,
                              )),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                  child: Text(
                snapshot.error.toString(),
                textDirection: TextDirection.ltr,
                style: const TextStyle(fontSize: 50.0, color: Colors.red),
              ));
            } else {
              return const SizedBox();
            }
          },
        ),
      );
    }
    // ANCHOR Web
    else {
      return MediaQuery(
        data: const MediaQueryData(),
        child: FutureBuilder(
          future: _allFutures,
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              return NeumorphicApp(
                debugShowCheckedModeBanner: false,
                home: Scaffold(
                  backgroundColor:
                      Color(int.parse(userConfig['primary_background'])),
                  body: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 20.0),
                          width: 270.0,
                          height: 270.0,
                          child: Stack(children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: SizedBox(
                                width: 200.0,
                                height: 200.0,
                                child: Neumorphic(
                                  style: NeumorphicStyle(
                                    shape: NeumorphicShape.flat,
                                    boxShape: const NeumorphicBoxShape.circle(),
                                    depth: 5.0,
                                    intensity: 0.8,
                                    surfaceIntensity: 0.8,
                                    color:
                                        Color(int.parse(userConfig['primary'])),
                                  ),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: SizedBox(
                                width: 200.0,
                                height: 200.0,
                                child: Neumorphic(
                                  style: NeumorphicStyle(
                                    shape: NeumorphicShape.flat,
                                    boxShape: const NeumorphicBoxShape.circle(),
                                    depth: 5.0,
                                    intensity: 0.8,
                                    surfaceIntensity: 0.8,
                                    color: Color(
                                        int.parse(userConfig['secondary'])),
                                  ),
                                ),
                              ),
                            ),
                          ]),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 50.0),
                          padding: const EdgeInsets.symmetric(horizontal: 14.0),
                          height: 200.0,
                          width: 300.0,
                          child: Stack(
                            children: [
                              Align(
                                alignment: Alignment.center,
                                child: Text(
                                  'SLIDER',
                                  textDirection: TextDirection.ltr,
                                  style: TextStyle(
                                    fontFamily: "BebasNeue",
                                    fontSize: 130.0,
                                    color:
                                        Color(int.parse(userConfig['primary'])),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Text(
                                  'PUZZLE',
                                  textDirection: TextDirection.ltr,
                                  style: TextStyle(
                                    fontFamily: "BebasNeue",
                                    fontSize: 50.0,
                                    color: Color(
                                        int.parse(userConfig['secondary'])),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 50.0),
                          child: Row(
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
                              Builder(builder: (context) {
                                return NeumorphicButton(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 20.0),
                                  onPressed: () {
                                    if (userConfig['background_sound'] ==
                                        "on") {
                                      _audioCacheBackground.fixedPlayer!
                                          .stop()
                                          .then((value) {
                                        _audioCacheBackground.loop(
                                          "${userConfig['background_sound_option']}.ogg",
                                          volume: double.parse(userConfig[
                                              'background_sound_volume']),
                                        );
                                      });
                                    }
                                    if (userConfig['interface_sound'] == 'on') {
                                      _audioCacheInterface.play(
                                          'page-back-chime.wav',
                                          volume: double.parse(userConfig[
                                              'interface_sound_volume']),
                                          mode: PlayerMode.MEDIA_PLAYER);
                                    }
                                    Navigator.push(
                                      context,
                                      PageTransition(
                                          child: const NMenuPage(),
                                          type: PageTransitionType
                                              .rightToLeftWithFade),
                                    );
                                  },
                                  style: NeumorphicStyle(
                                      shape: NeumorphicShape.flat,
                                      boxShape: NeumorphicBoxShape.roundRect(
                                          const BorderRadius.all(
                                              Radius.circular(10.0))),
                                      depth: 0.0,
                                      intensity: 0.8,
                                      surfaceIntensity: 0.8,
                                      color: Color(int.parse(
                                          userConfig['primary_background']))),
                                  child: Text(
                                    'START',
                                    textDirection: TextDirection.ltr,
                                    style: TextStyle(
                                      color: Color(
                                          int.parse(userConfig['secondary'])),
                                      fontFamily: "BebasNeue",
                                      fontSize: 40.0,
                                    ),
                                  ),
                                );
                              }),
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
                        )
                      ],
                    ),
                  ),
                ),
              );
            } else if (snapshot.connectionState == ConnectionState.waiting &&
                !snapshot.hasData) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                home: Scaffold(
                  backgroundColor: Colors.grey[50],
                  body: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SpinKitChasingDots(
                        color: Colors.indigo[800],
                        size: 250.0,
                      ),
                      Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.only(top: 20.0),
                        child: DefaultTextStyle(
                          style: TextStyle(
                              fontSize: 30.0,
                              color: Colors.indigo[900],
                              fontFamily: "BebasNeue"),
                          child: AnimatedTextKit(
                              repeatForever: true,
                              animatedTexts: [
                                TypewriterAnimatedText(
                                  'Fetching the code...',
                                  speed: const Duration(milliseconds: 50),
                                ),
                                TypewriterAnimatedText('Fetching the config...',
                                    speed: const Duration(milliseconds: 50)),
                                TypewriterAnimatedText('Fetching the logic...',
                                    speed: const Duration(milliseconds: 50)),
                                TypewriterAnimatedText('Fetching the files...',
                                    speed: const Duration(milliseconds: 50)),
                                TypewriterAnimatedText('Fetching the game...',
                                    speed: const Duration(milliseconds: 50)),
                                TypewriterAnimatedText('Fetching the world...',
                                    speed: const Duration(milliseconds: 50)),
                                TypewriterAnimatedText('Fetching the levels...',
                                    speed: const Duration(milliseconds: 50)),
                                TypewriterAnimatedText('Fetching the theme...',
                                    speed: const Duration(milliseconds: 50)),
                                TypewriterAnimatedText('Fetching the assets...',
                                    speed: const Duration(milliseconds: 50)),
                                TypewriterAnimatedText('Fetching the tiles...',
                                    speed: const Duration(milliseconds: 50)),
                                TypewriterAnimatedText('Fetching the APIs...',
                                    speed: const Duration(milliseconds: 50)),
                                TypewriterAnimatedText('Fetching the design...',
                                    speed: const Duration(milliseconds: 50)),
                                TypewriterAnimatedText('Fetching...',
                                    speed: const Duration(milliseconds: 50)),
                              ],
                              pause: const Duration(
                                milliseconds: 0,
                              )),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                  child: Text(
                snapshot.error.toString(),
                textDirection: TextDirection.ltr,
                style: const TextStyle(fontSize: 50.0, color: Colors.red),
              ));
            } else {
              return const SizedBox();
            }
          },
        ),
      );
    }
  }
}
