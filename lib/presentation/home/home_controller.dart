import 'dart:math';
import 'package:flutter/material.dart';

class HomeController extends ChangeNotifier {
  final Random _random = Random();

  String _lastRollResult = 'tapToRoll';
  String get lastRollResult => _lastRollResult;

  String _lastLootResult = 'tapGenerate';
  String get lastLootResult => _lastLootResult;

  final List<String> _lootTable = [
    'goldCoins',
    'healingPotion',
    'gem50',
    'swordPlus1',
    'silverRing',
    'treasureMap',
    'magicMissileScroll',
    'rustyKey',
  ];

  void rollDice(int sides) {
    final result = _random.nextInt(sides) + 1;
    _lastRollResult = 'd$sides → $result';
    notifyListeners();
  }

  void generateLoot() {
    _lastLootResult = _lootTable[_random.nextInt(_lootTable.length)];
    notifyListeners();
  }
}
