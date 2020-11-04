import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flame/components/mixins/has_game_ref.dart';
import 'package:flutter/material.dart';

import 'package:infection/components/game.dart';
import 'package:infection/components/palette.dart';
import 'package:infection/components/player.dart';

class Task extends PositionComponent with HasGameRef<MyGame> {
  static const double TASK_SPEED = 0.01;
  Paint bgColor = Palette.green_ghost.paint;
  Paint fillColor = Palette.green.paint;
  double completion = 0.1;
  Player assignee;

  @override
  void render(Canvas c) {
    prepareCanvas(c);

    width = 10;
    height = 10;

    c.drawRect(Rect.fromLTWH(0, 0, width, height), bgColor);
    c.drawRect(Rect.fromLTWH(0, height * (1 - completion), width, height * completion), fillColor);
  }

  bool complete() {
    return completion >= 1;
  }

  bool dead() {
    return completion <= 0;
  }

  void work() {
    if (complete()) {
      assignee.task = null;
      assignee = null;
    } else {
      completion += TASK_SPEED;
    }
  }

  void unwork() {
    if (dead()) {
      assignee.task = null;
      assignee = null;
    } else {
      completion -= TASK_SPEED;
    }
  }
}