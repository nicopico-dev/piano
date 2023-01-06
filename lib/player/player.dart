export 'src/player_main.dart'
    if (dart.library.js) 'src/player_web.dart'
    if (dart.library.io) 'src/player_mobile.dart';
