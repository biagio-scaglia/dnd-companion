import 'dart:math';
import 'package:flutter/material.dart';

class HomeController extends ChangeNotifier {
  final Random _random = Random();

  String _lastRollResult = 'Tocca un dado per lanciare';
  String get lastRollResult => _lastRollResult;

  String _lastLootResult = 'Tocca "Genera" per un bottino';
  String get lastLootResult => _lastLootResult;

  final List<String> _lootTable = [
    '10 Monete d\'Oro',
    'Pozione di Guarigione',
    'Gemma Preziosa (50 mo)',
    'Spada Corta +1',
    'Anello d\'Argento antico',
    'Mappa del Tesoro sgualcita',
    'Pergamena di "Dardo Incantato"',
    'Chiave di Ferro arrugginita',
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
