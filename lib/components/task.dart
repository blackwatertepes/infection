import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flame/components/mixins/has_game_ref.dart';
import 'package:flutter/material.dart';

import 'package:infection/components/game.dart';
import 'package:infection/components/palette.dart';

class Task extends PositionComponent with HasGameRef<MyGame> {
  Paint color = Palette.green.paint;

  @override
  void render(Canvas c) {
    prepareCanvas(c);

    width = 10;
    height = 10;

    c.drawRect(Rect.fromLTWH(0, 0, width, height), color);
  }
}