import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:living_way/config/paths.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Column(children: [
      Container(
          margin: const EdgeInsets.all(10),
          child: TextField(
              autofocus: true,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(35)),
                  hintText: 'Search',
                  suffixIcon: Hero(
                      tag: 'search',
                      child: IconButton(
                          icon: SvgPicture.asset(AppIcons.search, height: 24),
                          onPressed: () {
                            Navigator.pop(context);
                          })))))
    ])));
  }
}
