import 'package:flutter/material.dart';
import 'package:flutter_diploma/controllers/SearchController.dart';

class SearchScreen extends StatefulWidget {
  final SearchWordController controller;
  const SearchScreen({super.key, required this.controller});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  void initState() {
    super.initState();
    widget.controller.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Словник"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: widget.controller.textController,
              decoration: InputDecoration(
                labelText: "Введіть термін",
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: widget.controller.handleSearch,
                ),
              ),
            ),
            const SizedBox(height: 20),
            ValueListenableBuilder<bool>(
              valueListenable: widget.controller.isLoadingNotifier,
              builder: (_, isLoading, __) {
                return isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ValueListenableBuilder<String>(
                  valueListenable: widget.controller.wordMeaningNotifier,
                  builder: (_, meaning, __) {
                    return Text(
                      meaning,
                      style: const TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton(
                  heroTag: "Mic",
                  backgroundColor: Colors.lightBlue[200],
                  onPressed: widget.controller.handleMicPress,
                  child: const Icon(Icons.mic, color: Colors.black),
                ),
                const SizedBox(width: 20),
                ValueListenableBuilder<bool>(
                  valueListenable: widget.controller.isSpeakingNotifier,
                  builder: (_, isSpeaking, __) {
                    return FloatingActionButton(
                      heroTag: "Speak",
                      backgroundColor: Colors.lightBlue[200],
                      onPressed: widget.controller.handleSpeak,
                      child: Icon(
                        isSpeaking ? Icons.volume_off : Icons.volume_up,
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}