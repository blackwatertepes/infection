import 'dart:ui';

import 'package:flame/gestures.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'package:infection/components/palette.dart';
import 'package:infection/components/player.dart';
import 'package:infection/components/wall.dart';

class MyGame extends BaseGame with DoubleTapDetector, TapDetector, PanDetector {
  bool running = true;
  Offset destination;
  bool go = false;

  MyGame() {
    // Construct the board...
    add(Wall()
      ..x = 200
      ..y = 200
      ..width = 64
      ..height = 64);

    add(Wall()
      ..x = 200
      ..y = 500
      ..width = 64
      ..height = 64);
    
    // Add the player...
    add(Player()
      ..x = 200
      ..y = 350
      ..width = 16
      ..height = 16
      ..color = Palette.red.paint);
  }

  @override
  void onTapDown(details) {
    destination = details.localPosition;
    go = true;
  }

  @override
  void onTapUp(details) {
    go = false;
  }

  @override
  void onPanEnd(details) {
    go = false;
  }

  @override
  void onPanUpdate(details) {
    destination = details.localPosition;
  }

  @override
  void onDoubleTap() {
    if (running) {
      pauseEngine();
    } else {
      resumeEngine();
    }

    running = !running;
  }
}