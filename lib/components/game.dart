import 'dart:math' as math;
import 'dart:ui';

import 'package:flame/gestures.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'package:infection/components/palette.dart';
import 'package:infection/components/player.dart';
import 'package:infection/components/task.dart';
import 'package:infection/components/wall.dart';

class MyGame extends BaseGame with DoubleTapDetector, TapDetector, PanDetector {
  bool running = true;
  Offset destination;
  bool go = false;

  MyGame() {
    // Construct the board...
    add(Wall()
      ..x = 0
      ..y = 0
      ..width = 500
      ..height = 200);

    add(Wall()
      ..x = 0
      ..y = 500
      ..width = 500
      ..height = 200);

    // Top
    add(Task()
      ..x = 200
      ..y = 250);

    // Top Left
    add(Task()
      ..x = 130
      ..y = 280);

    // Left
    add(Task()
      ..x = 100
      ..y = 350);

    // Bottom Left
    add(Task()
      ..x = 130
      ..y = 420);

    // Bottom
    add(Task()
      ..x = 200
      ..y = 450);

    // Bottom Right
    add(Task()
      ..x = 270
      ..y = 420);

    // Right
    add(Task()
      ..x = 300
      ..y = 350);

    // Top Right
    add(Task()
      ..x = 270
      ..y = 280);

    // Top
    add(Player()
      ..x = 200
      ..y = 340
      ..color = Palette.red.paint);

    // Left
    add(Player()
      ..x = 190
      ..y = 350
      ..color = Palette.blue.paint);

    // Bottom
    add(Player()
      ..x = 200
      ..y = 360
      ..color = Palette.yellow.paint);

    // Right
    add(Player()
      ..x = 210
      ..y = 350
      ..color = Palette.purple.paint);
  }

  @override
  void update(double t) {
    super.update(t);

    // Make sure everyone has a task
    List<Task> availableTasks = List();
    components.forEach((task) {
      if (task is Task && task.assignee == null) {
        availableTasks.add(task);
      }
    });

    components.forEach((player) {
      if (player is Player && player.task == null) {
        Task task = availableTasks.removeAt(math.Random().nextInt(availableTasks.length));
        player.task = task;
        task.assignee = player;
      }
    });
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