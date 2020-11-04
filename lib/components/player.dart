import 'dart:math' as math;
import 'dart:ui';

import 'package:flame/anchor.dart';
import 'package:flame/components/component.dart';
import 'package:flame/components/mixins/has_game_ref.dart';
import 'package:flutter/material.dart';

import 'package:infection/components/game.dart';
import 'package:infection/components/palette.dart';
import 'package:infection/components/task.dart';
import 'package:infection/components/wall.dart';

class Player extends PositionComponent with HasGameRef<MyGame> {
  static const SPEED = 1.0;
  static const DIST_TO_TASK = 20;
  Paint color = Palette.white.paint;
  Task task;
  bool saboteur = false;
  bool ai = true; // The Player will play itself

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

    // Movement...
    Offset destination;

    if (ai && task != null) {
      destination = Offset(task.x, task.y);
    }

    if (gameRef.go) {
      destination = gameRef.destination;
    }

    if (destination != null) {
      double distX = destination.dx - x;
      double distY = destination.dy - y;
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

    // Working...
    if (ai && task != null) {
      double distX = task.x - x;
      double distY = task.y - y;
      double distXY = math.sqrt(math.pow(distX.abs(), 2) + math.pow(distY.abs(), 2));

      if (distXY < DIST_TO_TASK) {
        if (saboteur) {
          task.unwork();
        } else {
          task.work();
        }
      }
    }
  }

  @override
  void onMount() {
    anchor = Anchor.center;
  }
}