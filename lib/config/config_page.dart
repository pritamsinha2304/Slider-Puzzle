import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

Map defaultConfig = {
  "primary": "0xFFFEB13E",
  "secondary": "0xFFFF5916",
  "primary_background": "0xFFF8F5DB",
  "secondary_background": "0xFFEAE9E0",
  "tile_background_option": "same_color",
  "tile_color": "0xFFEAE9E0",
  "curve": "Ease",
  "theme": "warm",
  "interface_sound": "on",
  "background_sound": "on",
  "background_sound_option": "Music-Box-Puzzles",
  "interface_sound_volume": "0.3",
  "background_sound_volume": "0.2"
};

Map userConfig = {};

Map curves = {
  'Bounce In': Curves.bounceIn,
  'Bounce In Out': Curves.bounceInOut,
  'Bounce Out': Curves.bounceOut,
  'Decelerate': Curves.decelerate,
  'Ease': Curves.ease,
  'Ease In': Curves.easeIn,
  'Ease In Back': Curves.easeInBack,
  'Ease In Circ': Curves.easeInCirc,
  'Ease In Cubic': Curves.easeInCubic,
  'Ease In Expo': Curves.easeInExpo,
  'Ease In Out': Curves.easeInOut,
  'Ease In Out Back': Curves.easeInOutBack,
  'Ease In Out Circ': Curves.easeInOutCirc,
  'Ease In Out Cubic': Curves.easeInOutCubic,
  'Ease In Out Cubic Emphasized': Curves.easeInOutCubicEmphasized,
  'Ease In Out Expo': Curves.easeInOutExpo,
  'Ease In Out Quad': Curves.easeInOutQuad,
  'Ease In Out Quart': Curves.easeInOutQuart,
  'Ease In Out Quint': Curves.easeInOutQuint,
  'Ease In Out Sine': Curves.easeInOutSine,
  'Ease In Quad': Curves.easeInQuad,
  'Ease In Quart': Curves.easeInQuart,
  'Ease In Quint': Curves.easeInQuint,
  'Ease In Sine': Curves.easeInSine,
  'Ease In To Linear': Curves.easeInToLinear,
  'Ease Out': Curves.easeOut,
  'Ease Out Back': Curves.easeOutBack,
  'Ease Out Circ': Curves.easeOutCirc,
  'Ease Out Cubic': Curves.easeOutCubic,
  'Ease Out Expo': Curves.easeOutExpo,
  'Ease Out Quad': Curves.easeOutQuad,
  'Ease Out Quart': Curves.easeOutQuart,
  'Ease Out Quint': Curves.easeOutQuint,
  'Ease Out Sine': Curves.easeOutSine,
  'Elastic In': Curves.elasticIn,
  'Elastic In Out': Curves.elasticInOut,
  'Elastic Out': Curves.elasticOut,
  'Fast Linear To Slow Ease In': Curves.fastLinearToSlowEaseIn,
  'Fast Out Slow In': Curves.fastOutSlowIn,
  'Linear': Curves.linear,
  'Linear To Ease Out': Curves.linearToEaseOut,
  'Slow Middle': Curves.slowMiddle
};

Map themes = {
  "warm": {
    "primary": "0xFFFEB13E",
    "secondary": "0xFFFF5916",
    "primary_background": "0xFFF8F5DB",
    "secondary_background": "0xFFEAE9E0"
  },
  "cool": {
    "primary": "0xFF86CBE0",
    "secondary": "0xFF205891",
    "primary_background": "0xFFE3F1FE",
    "secondary_background": "0xFFDADFE4"
  },
  "cyberpunk": {
    "primary": "0xFF00CFFF",
    "secondary": "0xFF00CFFF",
    "primary_background": "0xFFFFFA00",
    "secondary_background": "0xFF09080E"
  }
};

// List<String> imageName = [
//   "1.jpg",
//   "2.jpg",
//   "3.jpg",
//   "4.jpg",
//   "5.jpg",
//   "6.jpg",
//   "7.jpg",
//   "8.jpg",
//   "9.jpg",
//   "10.jpg"
// ];

List<String> imageName = [];

List<String> audioName = [];

late AudioPlayer audioPlayerBackground;
late AudioCache audioCacheBackground;
late AudioPlayer audioPlayerInterface;
late AudioCache audioCacheInterface;
