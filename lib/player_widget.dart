import 'package:flutter/widgets.dart';

import 'player/player.dart';

Future<Player> createPlayer() async {
  return Player();
}

class PlayerWidget extends InheritedWidget {
  final Player player;

  PlayerWidget({Key key, @required Widget child, @required this.player})
      : super(key: key, child: child);

  static Player of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<PlayerWidget>()).player;
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return false;
  }
}
