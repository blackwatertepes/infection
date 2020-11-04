import 'dart:ui';

import 'package:flame/anchor.dart';
import 'package:flame/components/component.dart';
import 'package:flame/components/mixins/has_game_ref.dart';
import 'package:flutter/material.dart';

import 'package:infection/components/game.dart';
import 'package:infection/components/palette.dart';
import 'package:infection/components/wall.dart';

class Player extends PositionComponent with HasGameRef<MyGame> {
  static const SPEED = 1.0;
  Paint color = Palette.white.paint;

  @override
  void render(Canvas c) {
    prepareCanvas(c);

    width = 8;
    height = 8;

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