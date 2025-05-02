import 'package:flutter/material.dart';
import 'package:flutter_diploma/controllers/TopicController.dart';
import 'package:flutter_diploma/themes/theme.dart';

class TopicListScreen extends StatelessWidget {
  final String language;
  final TopicController controller;

  TopicListScreen({
    super.key,
    required this.language,
  }) : controller = TopicController(language: language);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: buildAppTheme(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(language),
          centerTitle: true,
        ),
        body: _buildTopicList(),
      ),
    );
  }

  Widget _buildTopicList() {
    return ListView.builder(
      itemCount: controller.topics.length,
      itemBuilder: (context, index) {
        final topic = controller.topics[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: GestureDetector(
            onTap: () => controller.handleTopicTap(context, topic.id),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.lightBlue[200],
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    topic.title,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "${topic.questions} питань",
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}