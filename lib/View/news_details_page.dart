import 'package:flutter/material.dart';
import 'package:projectalpha/models/medical_news_model.dart';
import 'package:projectalpha/services/constants.dart';

class NewsDetailsPage extends StatelessWidget {
  final MedicalNews news;

  NewsDetailsPage({required this.news});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(-15441249),
          title: Text('صفحة الخبر',style: TextStyle(color: Colors.white),),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (news.image != null)
              Image.network(
                "${AppConstants.baseURLPhoto}storage/${news.image}",
                height: 300,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Align( alignment: Alignment.centerRight,
                    child: Text(
                      news.title,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                  SizedBox(height: 8),
                  Align( alignment: Alignment.centerRight,
                    child: Text(
                      news.category,
                      style: TextStyle(color: Colors.grey),
                      textAlign: TextAlign.right,
                    ),
                  ),
                  SizedBox(height: 16),
                  Align( alignment: Alignment.centerRight,
                    child: Text(
                      news.content,
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}