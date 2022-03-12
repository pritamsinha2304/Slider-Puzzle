import 'lib.dart';

class NSettings extends StatefulWidget {
  const NSettings({Key? key}) : super(key: key);

  @override
  _NSettingsState createState() => _NSettingsState();
}

class _NSettingsState extends State<NSettings> {
  late String mode;

  bool tapped = false;

  Color primaryColor = Color(int.parse(userConfig['primary']));
  Color secondaryColor = Color(int.parse(userConfig['secondary']));
  Color primaryBackgroundColor =
      Color(int.parse(userConfig['primary_background']));
  Color secondaryBackgroundColor =
      Color(int.parse(userConfig['secondary_background']));
  Color tileColor = Color(int.parse(userConfig['tile_color']));
  String curveValue = userConfig['curve'];
  String themeName = userConfig['theme'];
  String backgroundMusicName = userConfig['background_sound_option'];
  String backgroundSound = userConfig['background_sound'];
  String interfaceSound = userConfig['interface_sound'];
  String backgroundSoundVolume =
      userConfig['background_sound_volume'].toString();
  String interfaceSoundVolume = userConfig['interface_sound_volume'].toString();

  Future<bool> _writePrefs(Map userPrefs) async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    final file = File('$path/userprefs.json');
    return file.writeAsString(json.encode(userPrefs)).then((value) {
      return true;
    });
  }

  void _reset() {
    for (String key in userConfig.keys) {
      userConfig[key] = defaultConfig[key];
    }
  }

  void _savePrefs() {
    userConfig['primary'] =
        '0x' + primaryColor.value.toRadixString(16).toString().toUpperCase();

    userConfig['secondary'] =
        '0x' + secondaryColor.value.toRadixString(16).toString().toUpperCase();

    userConfig['primary_background'] = '0x' +
        primaryBackgroundColor.value.toRadixString(16).toString().toUpperCase();

    userConfig['secondary_background'] = '0x' +
        secondaryBackgroundColor.value
            .toRadixString(16)
            .toString()
            .toUpperCase();
    userConfig['tile_color'] =
        '0x' + tileColor.value.toRadixString(16).toString().toUpperCase();
    userConfig['curve'] = curveValue.toString();
    userConfig['theme'] = themeName;
    userConfig['background_sound_option'] = backgroundMusicName;
    userConfig['background_sound'] = backgroundSound;
    userConfig['interface_sound'] = interfaceSound;
    userConfig['background_sound_volume'] = backgroundSoundVolume.toString();
    userConfig['interface_sound_volume'] = interfaceSoundVolume.toString();

    // Write the updated config to file
    if (!kIsWeb) {
      _writePrefs(userConfig).then((value) {
        // if (value) debugPrint('Write updated prefs successful');
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return NeumorphicApp(
      debugShowCheckedModeBanner: false,
      home: Builder(builder: (context) {
        return Scaffold(
          backgroundColor: primaryBackgroundColor,
          appBar: AppBar(
            toolbarHeight: 80.0,
            elevation: 10.0,
            leading: NeumorphicButton(
              onPressed: () {
                if (userConfig['background_sound'] == "off") {
                  audioCacheBackground.fixedPlayer!.stop();
                }
                if (userConfig['interface_sound'] == "on") {
                  audioCacheInterface.play('page-back-chime.wav',
                      volume: double.parse(interfaceSoundVolume));
                }
                Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.rightToLeftWithFade,
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
                color: secondaryBackgroundColor,
              ),
              child: Center(
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 25.0,
                  color: secondaryColor,
                ),
              ),
            ),
            backgroundColor: secondaryBackgroundColor,
            title: Text(
              'Settings',
              textDirection: TextDirection.ltr,
              style: TextStyle(
                fontSize: 30.0,
                color: secondaryColor,
                fontFamily: "BebasNeue",
              ),
            ),
          ),
          body: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              physics: const BouncingScrollPhysics(),
              child: Container(
                margin: const EdgeInsets.only(top: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // ANCHOR Theme Dropdown
                    Neumorphic(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50.0, vertical: 10.0),
                      style: NeumorphicStyle(
                        shape: NeumorphicShape.flat,
                        boxShape: NeumorphicBoxShape.roundRect(
                            const BorderRadius.all(Radius.circular(10.0))),
                        depth: 10.0,
                        intensity: 0.8,
                        surfaceIntensity: 0.8,
                        color: secondaryBackgroundColor,
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Theme Selection',
                            textDirection: TextDirection.ltr,
                            style: TextStyle(
                              color: secondaryColor,
                              fontFamily: "BebasNeue",
                              fontSize: 25.0,
                            ),
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: DropdownButton<String>(
                              isExpanded: true,
                              value: themeName,
                              icon: Icon(
                                Icons.arrow_downward,
                                color: primaryColor,
                              ),
                              elevation: 16,
                              style: TextStyle(
                                color: secondaryColor,
                                fontFamily: "BebasNeue",
                              ),
                              underline: Container(
                                height: 2,
                                color: primaryColor,
                              ),
                              onChanged: (String? newValue) {
                                setState(() {
                                  themeName = newValue!;
                                  tapped = false;
                                  primaryColor = Color(
                                      int.parse(themes[themeName]['primary']));
                                  secondaryColor = Color(int.parse(
                                      themes[themeName]['secondary']));
                                  primaryBackgroundColor = Color(int.parse(
                                      themes[themeName]['primary_background']));
                                  secondaryBackgroundColor = Color(int.parse(
                                      themes[themeName]
                                          ['secondary_background']));
                                  tileColor = Color(int.parse(themes[themeName]
                                      ['secondary_background']));
                                });
                              },
                              items: themes.keys
                                  .toList()
                                  .map<DropdownMenuItem<String>>((value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Container(
                                    margin: const EdgeInsets.only(right: 155.0),
                                    child: Text(
                                      value,
                                      textDirection: TextDirection.ltr,
                                      style: TextStyle(
                                        color: secondaryColor,
                                        fontFamily: "BebasNeue",
                                        fontSize: 25.0,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // ANCHOR Tile Curves
                    Neumorphic(
                      margin: const EdgeInsets.only(
                          top: 20.0, left: 20.0, right: 20.0, bottom: 5.0),
                      padding: const EdgeInsets.all(10.0),
                      style: NeumorphicStyle(
                        shape: NeumorphicShape.flat,
                        boxShape: NeumorphicBoxShape.roundRect(
                            const BorderRadius.all(Radius.circular(10.0))),
                        depth: 10.0,
                        intensity: 0.8,
                        surfaceIntensity: 0.8,
                        color: secondaryBackgroundColor,
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Tile Movement Curve Options',
                            textDirection: TextDirection.ltr,
                            style: TextStyle(
                                fontSize: 25.0,
                                color: secondaryColor,
                                fontFamily: "BebasNeue"),
                          ),
                          DropdownButton<String>(
                            isExpanded: true,
                            value: curveValue,
                            icon: Icon(
                              Icons.arrow_downward,
                              color: primaryColor,
                            ),
                            elevation: 16,
                            style: TextStyle(
                                color: secondaryColor, fontFamily: "BebasNeue"),
                            underline: Container(
                              height: 2,
                              color: primaryColor,
                            ),
                            onChanged: (String? newValue) {
                              setState(() {
                                curveValue = newValue!;
                                tapped = false;
                              });
                            },
                            items: curves.keys
                                .toList()
                                .map<DropdownMenuItem<String>>((value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  textDirection: TextDirection.ltr,
                                  style: TextStyle(
                                    color: secondaryColor,
                                    fontFamily: "BebasNeue",
                                    fontSize: 25.0,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                          Container(
                            margin: const EdgeInsets.all(10.0),
                            padding: const EdgeInsets.all(5.0),
                            child: Stack(
                              children: [
                                AnimatedAlign(
                                  alignment: tapped
                                      ? Alignment.centerRight
                                      : Alignment.centerLeft,
                                  curve: curves[curveValue],
                                  duration: const Duration(milliseconds: 500),
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        tapped = !tapped;
                                      });
                                    },
                                    child: Neumorphic(
                                      style: NeumorphicStyle(
                                        shape: NeumorphicShape.flat,
                                        boxShape: NeumorphicBoxShape.roundRect(
                                            const BorderRadius.all(
                                                Radius.circular(20.0))),
                                        depth: 5.0,
                                        intensity: 0.8,
                                        surfaceIntensity: 0.8,
                                        color: primaryColor,
                                      ),
                                      child: const SizedBox(
                                        width: 100.0,
                                        height: 100.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    // ANCHOR Background Music Switch
                    Neumorphic(
                      margin: const EdgeInsets.only(
                          top: 20.0, left: 20.0, right: 20.0, bottom: 5.0),
                      padding: const EdgeInsets.all(10.0),
                      style: NeumorphicStyle(
                        shape: NeumorphicShape.flat,
                        boxShape: NeumorphicBoxShape.roundRect(
                            const BorderRadius.all(Radius.circular(10.0))),
                        depth: 10.0,
                        intensity: 0.8,
                        surfaceIntensity: 0.8,
                        color: secondaryBackgroundColor,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'BACKGROUND MUSIC',
                            style: TextStyle(
                                fontFamily: "BebasNeue",
                                fontSize: 25.0,
                                color: secondaryColor),
                          ),
                          NeumorphicSwitch(
                            value: backgroundSound == "on" ? true : false,
                            style: NeumorphicSwitchStyle(
                                trackDepth: 7.0,
                                thumbDepth: 7.0,
                                thumbShape: NeumorphicShape.concave,
                                activeThumbColor: secondaryBackgroundColor,
                                inactiveThumbColor: secondaryBackgroundColor,
                                activeTrackColor: primaryColor,
                                inactiveTrackColor: secondaryBackgroundColor),
                            onChanged: (bool result) {
                              setState(() {
                                backgroundSound = result ? "on" : "off";
                              });
                              if (result) {
                                audioCacheBackground.fixedPlayer!
                                    .stop()
                                    .then((value) {
                                  audioCacheBackground.loop(
                                      "$backgroundMusicName.ogg",
                                      volume:
                                          double.parse(backgroundSoundVolume));
                                });
                                // audioCacheBackground.loop(
                                //     "$backgroundMusicName.ogg",
                                //     volume:
                                //         double.parse(backgroundSoundVolume));
                              } else {
                                audioCacheBackground.fixedPlayer!.stop();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    // ANCHOR Background Music
                    if (backgroundSound == "on")
                      Neumorphic(
                        margin: const EdgeInsets.only(
                            top: 20.0, left: 20.0, right: 20.0, bottom: 5.0),
                        padding: const EdgeInsets.all(10.0),
                        style: NeumorphicStyle(
                          shape: NeumorphicShape.flat,
                          boxShape: NeumorphicBoxShape.roundRect(
                              const BorderRadius.all(Radius.circular(10.0))),
                          depth: 10.0,
                          intensity: 0.8,
                          surfaceIntensity: 0.8,
                          color: secondaryBackgroundColor,
                        ),
                        child: Column(
                          children: [
                            Text(
                              'BACKGROUND MUSIC',
                              textDirection: TextDirection.ltr,
                              style: TextStyle(
                                fontFamily: "BebasNeue",
                                fontSize: 25.0,
                                color: secondaryColor,
                              ),
                            ),
                            DropdownButton(
                              isExpanded: true,
                              value: backgroundMusicName,
                              icon: Icon(
                                Icons.arrow_downward,
                                color: primaryColor,
                              ),
                              elevation: 16,
                              style: TextStyle(
                                  color: secondaryColor,
                                  fontFamily: "BebasNeue"),
                              underline: Container(
                                height: 2,
                                color: primaryColor,
                              ),
                              onChanged: (String? musicName) {
                                setState(() {
                                  backgroundMusicName = musicName!;
                                });
                                audioCacheBackground.fixedPlayer!
                                    .stop()
                                    .then((value) {
                                  audioCacheBackground.loop("$musicName.ogg",
                                      volume:
                                          double.parse(backgroundSoundVolume));
                                });
                              },
                              items: [
                                for (String item in audioName)
                                  item.substring(0, item.indexOf('.'))
                              ].map<DropdownMenuItem<String>>((value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    textDirection: TextDirection.ltr,
                                    style: TextStyle(
                                      color: secondaryColor,
                                      fontFamily: "BebasNeue",
                                      fontSize: 25.0,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    // ANCHOR Background Sound volume
                    if (backgroundSound == "on")
                      Neumorphic(
                        margin: const EdgeInsets.only(
                            top: 20.0, left: 20.0, right: 20.0, bottom: 5.0),
                        padding: const EdgeInsets.all(10.0),
                        style: NeumorphicStyle(
                          shape: NeumorphicShape.flat,
                          boxShape: NeumorphicBoxShape.roundRect(
                              const BorderRadius.all(Radius.circular(10.0))),
                          depth: 10.0,
                          intensity: 0.8,
                          surfaceIntensity: 0.8,
                          color: secondaryBackgroundColor,
                        ),
                        child: NeumorphicSlider(
                          min: 0.0,
                          max: 1.0,
                          value: double.parse(backgroundSoundVolume),
                          onChanged: (result) {
                            audioCacheBackground.fixedPlayer!.setVolume(result);
                            setState(() {
                              backgroundSoundVolume = result.toString();
                            });
                          },
                          style: SliderStyle(
                              depth: 5.0,
                              variant: secondaryBackgroundColor,
                              accent: primaryColor),
                        ),
                      ),
                    // ANCHOR Interface Music Switch
                    Neumorphic(
                      margin: const EdgeInsets.only(
                          top: 20.0, left: 20.0, right: 20.0, bottom: 5.0),
                      padding: const EdgeInsets.all(10.0),
                      style: NeumorphicStyle(
                        shape: NeumorphicShape.flat,
                        boxShape: NeumorphicBoxShape.roundRect(
                            const BorderRadius.all(Radius.circular(10.0))),
                        depth: 10.0,
                        intensity: 0.8,
                        surfaceIntensity: 0.8,
                        color: secondaryBackgroundColor,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'INTERFACE MUSIC',
                            style: TextStyle(
                                fontFamily: "BebasNeue",
                                fontSize: 25.0,
                                color: secondaryColor),
                          ),
                          NeumorphicSwitch(
                            value: interfaceSound == "on" ? true : false,
                            style: NeumorphicSwitchStyle(
                                trackDepth: 7.0,
                                thumbDepth: 7.0,
                                thumbShape: NeumorphicShape.concave,
                                activeThumbColor: secondaryBackgroundColor,
                                inactiveThumbColor: secondaryBackgroundColor,
                                activeTrackColor: primaryColor,
                                inactiveTrackColor: secondaryBackgroundColor),
                            onChanged: (bool result) {
                              setState(() {
                                interfaceSound = result ? "on" : "off";
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    // ANCHOR Interface Sound Volume
                    if (interfaceSound == "on")
                      Neumorphic(
                          margin: const EdgeInsets.only(
                              top: 20.0, left: 20.0, right: 20.0, bottom: 5.0),
                          padding: const EdgeInsets.all(10.0),
                          style: NeumorphicStyle(
                            shape: NeumorphicShape.flat,
                            boxShape: NeumorphicBoxShape.roundRect(
                                const BorderRadius.all(Radius.circular(10.0))),
                            depth: 10.0,
                            intensity: 0.8,
                            surfaceIntensity: 0.8,
                            color: secondaryBackgroundColor,
                          ),
                          child: NeumorphicSlider(
                            min: 0.0,
                            max: 1.0,
                            value: double.parse(interfaceSoundVolume),
                            onChanged: (result) {
                              audioCacheInterface.fixedPlayer!
                                  .setVolume(result);
                              setState(() {
                                interfaceSoundVolume = result.toString();
                              });
                            },
                            style: SliderStyle(
                                depth: 5.0,
                                variant: secondaryBackgroundColor,
                                accent: primaryColor),
                          )),
                    // ANCHOR Row of Reset and Save Button
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Row(
                        mainAxisAlignment: kIsWeb
                            ? MainAxisAlignment.center
                            : MainAxisAlignment.spaceAround,
                        children: [
                          NeumorphicButton(
                            onPressed: () {
                              _reset();
                              setState(() {
                                tileColor = Color(
                                    int.parse(defaultConfig['tile_color']));
                                curveValue = defaultConfig['curve'];
                                primaryColor = Color(
                                    int.parse(defaultConfig['primary_color']));
                                secondaryColor = Color(int.parse(
                                    defaultConfig['secondary_color']));
                                primaryBackgroundColor = Color(int.parse(
                                    defaultConfig['primary_background_color']));
                                secondaryBackgroundColor = Color(int.parse(
                                    defaultConfig[
                                        'secondary_background_color']));
                                themeName = defaultConfig['theme'];
                                backgroundMusicName =
                                    defaultConfig['background_sound_option'];
                                backgroundSound =
                                    defaultConfig['background_sound'];
                                interfaceSound =
                                    defaultConfig['interface_sound'];
                                backgroundSoundVolume =
                                    defaultConfig['background_sound_volume'];
                                interfaceSoundVolume =
                                    defaultConfig['interface_sound_volume'];
                              });
                            },
                            style: NeumorphicStyle(
                                shape: NeumorphicShape.flat,
                                boxShape: NeumorphicBoxShape.roundRect(
                                    const BorderRadius.all(
                                        Radius.circular(10.0))),
                                depth: 10.0,
                                intensity: 0.8,
                                surfaceIntensity: 0.8,
                                color: secondaryBackgroundColor),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(
                                  Icons.restart_alt_outlined,
                                  size: 20.0,
                                  color: secondaryColor,
                                ),
                                const SizedBox(
                                  width: 10.0,
                                ),
                                Text(
                                  'Reset To Default',
                                  textDirection: TextDirection.ltr,
                                  style: TextStyle(
                                    color: secondaryColor,
                                    fontSize: 20.0,
                                    fontFamily: "BebasNeue",
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (kIsWeb)
                            const SizedBox(
                              width: 40.0,
                            ),
                          NeumorphicButton(
                            onPressed: () {
                              _savePrefs();
                              final snackBar = SnackBar(
                                content: Text(
                                  'Save Successful',
                                  textDirection: TextDirection.ltr,
                                  style: TextStyle(
                                      color: secondaryColor,
                                      fontSize: 25.0,
                                      fontFamily: "BebasNeue"),
                                ),
                                backgroundColor: secondaryBackgroundColor,
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.0))),
                                behavior: SnackBarBehavior.floating,
                                margin: const EdgeInsets.all(20.0),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            },
                            style: NeumorphicStyle(
                                shape: NeumorphicShape.flat,
                                boxShape: NeumorphicBoxShape.roundRect(
                                    const BorderRadius.all(
                                        Radius.circular(10.0))),
                                depth: 10.0,
                                intensity: 0.8,
                                surfaceIntensity: 0.8,
                                color: secondaryBackgroundColor),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(
                                  Icons.save_rounded,
                                  size: 20.0,
                                  color: secondaryColor,
                                ),
                                const SizedBox(
                                  width: 10.0,
                                ),
                                Text(
                                  'Save Preference',
                                  textDirection: TextDirection.ltr,
                                  style: TextStyle(
                                    color: secondaryColor,
                                    fontSize: 20.0,
                                    fontFamily: "BebasNeue",
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )),
        );
      }),
    );
  }
}
