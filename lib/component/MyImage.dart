import 'package:flutter/material.dart';

class MyImage extends StatelessWidget {
  const MyImage({super.key, required this.path});
  final String path;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.asset(path, fit: BoxFit.cover ),
      ),
    );
  }
}

class MyImageNet extends StatelessWidget {
  const MyImageNet({super.key, required this.path,required this.sizeh,});
  final String path;
  final sizeh;


  @override
  Widget build(BuildContext context) {
    return Container(
      height: sizeh * 0.1,
      width: sizeh * 0.1,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.network(path, fit: BoxFit.cover ),
      ),
    );
  }
}