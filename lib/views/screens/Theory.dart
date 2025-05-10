import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Theory extends StatelessWidget{

  final List<Map<String,String>> materials = [
    {
      'title':'BBC Learning English - Grammar',
      'url':'https://www.bbc.co.uk/learningenglish/english/grammar'
    },
    {
      'title':'DW Deutsch Lernen - A1',
      'url':'https://learngerman.dw.com/en/beginners/s-62078399'
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
      AppBar(title: const Text('Довідкові матеріали'),
        centerTitle: true,),
      body: ListView.builder(
        itemCount: materials.length,
          itemBuilder: (context,index){
          final item = materials[index];
          return ListTile(
            title: Text(item['title']!),
            trailing: const Icon(Icons.open_in_new),
            onTap: () async {
              final url = Uri.parse(item['url']!);
              if (await canLaunchUrl(url)) {
              await launchUrl(url);
              }
            },
          );
          })
    );
  }
}