import 'package:flutter/material.dart';
import 'package:flutter_diploma/models/SearchModel.dart';

class SearchWordController {
  final SearchModel _model;
  final TextEditingController textController = TextEditingController();

  final ValueNotifier<String> wordMeaningNotifier = ValueNotifier('');
  final ValueNotifier<bool> isLoadingNotifier = ValueNotifier(false);
  final ValueNotifier<bool> isSpeakingNotifier = ValueNotifier(false);

  SearchWordController(this._model) {
    _model.addListener(_updateState);
  }

  Future<void> init() async {
    await _model.initSpeech();
    await _model.initTTS();
    _updateState(); // Первинна синхронізація стану
  }

  void handleSearch() => _model.searchWord(textController.text.trim());

  void handleMicPress() {
    if (_model.isListening) {
      _model.stopListening();
    } else {
      _model.startListening();
    }
  }

  void handleSpeak() {
    if (_model.isSpeaking) {
      _model.stopSpeaking();
    } else {
      _model.speak(_model.wordMeaning);
    }
  }

  void _updateState() {
    wordMeaningNotifier.value = _model.wordMeaning;
    isLoadingNotifier.value = _model.isLoading;
    isSpeakingNotifier.value = _model.isSpeaking;
  }

  Future<void> dispose() async {
    await _model.stopSpeaking();
    await _model.stopListening();
    _model.removeListener(_updateState);
    textController.dispose();
  }
}