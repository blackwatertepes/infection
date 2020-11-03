import 'dart:math' as math;
import 'dart:ui';

import 'package:flame/anchor.dart';
import 'package:flame/gestures.dart';
import 'package:flame/components/component.dart';
import 'package:flame/components/mixins/has_game_ref.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';

void main() {
  final game = MyGame();

  runApp(game.widget);
}

class Palette {
  static const PaletteEntry white = BasicPalette.white;
  static const PaletteEntry red = PaletteEntry(Color(0xFFFF0000));
}

class Wall extends PositionComponent with HasGameRef<MyGame> {
  Paint color = Palette.white.paint;

  @override
  void render(Canvas c) {
    prepareCanvas(c);

    c.drawRect(Rect.fromLTWH(0, 0, width, height), color);
  }
}

class Player extends PositionComponent with HasGameRef<MyGame> {
  static const SPEED = 1.0;
  Paint color = Palette.white.paint;

  @override
  void render(Canvas c) {
    prepareCanvas(c);

    c.drawRect(Rect.fromLTWH(0, 0, width, height), color);
  }

  @override
  void update(double t) {
    super.update(t);
    if (gameRef.go) {
      double distX = (gameRef.destination.dx - x);
      double distY = (gameRef.destination.dy - y);
      double distXY = distX.abs() + distY.abs();
      double newX = x + distX / distXY * SPEED;
      double newY = y + distY / distXY * SPEED;

      bool overlaps = false;
      gameRef.components.forEach((c) {
        if (c is Wall && !overlaps) {
          overlaps = Rect.fromLTWH(newX - width / 2, newY - height / 2, width, height).overlaps(c.toRect());
        }
      });

      if (!overlaps) {
        x = newX;
        y = newY;
      }
    }
  }

  @override
  void onMount() {
    anchor = Anchor.center;
  }
}

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