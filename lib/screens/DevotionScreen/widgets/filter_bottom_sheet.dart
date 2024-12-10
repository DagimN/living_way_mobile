import 'package:flutter/material.dart';
import 'package:living_way/constants/content.dart';
import 'package:living_way/controllers/content_controller.dart';
import 'package:living_way/themes/light_theme.dart';
import 'package:provider/provider.dart';

class FilterBottomSheet extends StatefulWidget {
  final ActivityFilter activityFilter;
  final CategoryFilter categoryFilter;
  final List<String> booksSelected;
  const FilterBottomSheet(
      {super.key,
      required this.activityFilter,
      required this.categoryFilter,
      required this.booksSelected});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet>
    with TickerProviderStateMixin {
  ActivityFilter activityFilter = ActivityFilter.latest;
  CategoryFilter categoryFilter = CategoryFilter.all;
  List<String> booksSelected = [];

  @override
  void initState() {
    super.initState();
    activityFilter = widget.activityFilter;
    categoryFilter = widget.categoryFilter;
    booksSelected = widget.booksSelected;
  }

  @override
  Widget build(BuildContext context) {
    final contentController = Provider.of<ContentController>(context);
    List<String> totalBooks = [...(books['ot'] ?? []), ...(books['nt'] ?? [])];
    List<String> filteredBooks = books[categoryFilter.name] ?? [];
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    Orientation orientation = MediaQuery.of(context).orientation;
    const Radius radius = Radius.circular(20);

    return Container(
        width: screenWidth,
        height: orientation == Orientation.portrait
            ? screenHeight * .5
            : screenHeight * .65,
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topLeft: radius, topRight: radius)),
        child: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text('Filter',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 24)),
            Row(children: [
              TextButton(
                  child: const Text('Reset',
                      style: TextStyle(color: lightPrimaryColor)),
                  onPressed: () {
                    contentController.setActivityFilter = ActivityFilter.latest;
                    contentController.categoryFilter = CategoryFilter.all;
                    contentController.setBooksFilter = [];

                    contentController.fetchTopics(isRefreshing: true);
                    Navigator.pop(context);
                  }),
              TextButton(
                  child: const Text('Apply',
                      style: TextStyle(color: lightPrimaryColor)),
                  onPressed: () {
                    contentController.setActivityFilter = activityFilter;
                    contentController.setCategoryFilter = categoryFilter;
                    contentController.setBooksFilter = booksSelected;

                    contentController.fetchTopics(isRefreshing: true);
                    Navigator.pop(context);
                  })
            ])
          ]),
          Divider(color: Colors.grey[200]),
          SizedBox(
              height: screenHeight * .38,
              child: SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    SizedBox(
                        width: screenWidth,
                        height: 100,
                        child: GridView(
                            shrinkWrap: true,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2, childAspectRatio: 3.5),
                            children: [
                              Container(
                                  width: screenWidth * .45,
                                  height: 50,
                                  padding: const EdgeInsets.all(3),
                                  child: OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                          foregroundColor: activityFilter ==
                                                  ActivityFilter.latest
                                              ? Colors.white
                                              : null,
                                          backgroundColor: activityFilter ==
                                                  ActivityFilter.latest
                                              ? lightPrimaryColor
                                              : Colors.white),
                                      onPressed: () => setState(() {
                                            activityFilter =
                                                ActivityFilter.latest;
                                          }),
                                      child: const Text('Latest',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 10)))),
                              Padding(
                                  padding: const EdgeInsets.all(3),
                                  child: OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                          foregroundColor: activityFilter ==
                                                  ActivityFilter.mostActive
                                              ? Colors.white
                                              : null,
                                          backgroundColor: activityFilter ==
                                                  ActivityFilter.mostActive
                                              ? lightPrimaryColor
                                              : Colors.white),
                                      onPressed: () => setState(() {
                                            activityFilter =
                                                ActivityFilter.mostActive;
                                          }),
                                      child: const Text('Most Active',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 10)))),
                              Padding(
                                  padding: const EdgeInsets.all(3),
                                  child: OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                          foregroundColor: activityFilter ==
                                                  ActivityFilter.mostLiked
                                              ? Colors.white
                                              : null,
                                          backgroundColor: activityFilter ==
                                                  ActivityFilter.mostLiked
                                              ? lightPrimaryColor
                                              : Colors.white),
                                      onPressed: () => setState(() {
                                            activityFilter =
                                                ActivityFilter.mostLiked;
                                          }),
                                      child: const Text('Most Liked',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 10)))),
                              Padding(
                                  padding: const EdgeInsets.all(3),
                                  child: OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                          foregroundColor: activityFilter ==
                                                  ActivityFilter.mostViewed
                                              ? Colors.white
                                              : null,
                                          backgroundColor: activityFilter ==
                                                  ActivityFilter.mostViewed
                                              ? lightPrimaryColor
                                              : Colors.white),
                                      onPressed: () => setState(() {
                                            activityFilter =
                                                ActivityFilter.mostViewed;
                                          }),
                                      child: const Text('Most Viewed',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 10))))
                            ])),
                    const SizedBox(height: 16),
                    Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
                        child: const Text('Category',
                            style: TextStyle(
                                color: lightPrimaryColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w400))),
                    SizedBox(
                        width: screenWidth * .8,
                        child: Row(mainAxisSize: MainAxisSize.min, children: [
                          Container(
                              height: 35,
                              margin: const EdgeInsets.all(5),
                              child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                      foregroundColor:
                                          categoryFilter == CategoryFilter.all
                                              ? Colors.white
                                              : null,
                                      backgroundColor:
                                          categoryFilter == CategoryFilter.all
                                              ? lightPrimaryColor
                                              : Colors.white),
                                  onPressed: () => setState(() {
                                        categoryFilter = CategoryFilter.all;
                                      }),
                                  child: const Text('All',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 10)))),
                          Container(
                              height: 35,
                              margin: const EdgeInsets.all(5),
                              child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                      foregroundColor:
                                          categoryFilter == CategoryFilter.ot
                                              ? Colors.white
                                              : null,
                                      backgroundColor:
                                          categoryFilter == CategoryFilter.ot
                                              ? lightPrimaryColor
                                              : Colors.white),
                                  onPressed: () => setState(() {
                                        categoryFilter = CategoryFilter.ot;
                                        booksSelected.removeWhere((book) =>
                                            (books['nt'] ?? []).contains(book));
                                      }),
                                  child: const Text('OT',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 10)))),
                          Container(
                              height: 35,
                              margin: const EdgeInsets.all(5),
                              child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                      foregroundColor:
                                          categoryFilter == CategoryFilter.nt
                                              ? Colors.white
                                              : null,
                                      backgroundColor:
                                          categoryFilter == CategoryFilter.nt
                                              ? lightPrimaryColor
                                              : Colors.white),
                                  onPressed: () => setState(() {
                                        categoryFilter = CategoryFilter.nt;
                                        booksSelected.removeWhere((book) =>
                                            (books['ot'] ?? []).contains(book));
                                      }),
                                  child: const Text('NT',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 10))))
                        ])),
                    const SizedBox(height: 16),
                    Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
                        child: Row(children: [
                          const Text('Books',
                              style: TextStyle(
                                  color: lightPrimaryColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400)),
                          if (booksSelected.isNotEmpty)
                            Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 3),
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    color: lightPrimaryColor.withOpacity(0.4),
                                    shape: BoxShape.circle),
                                child: Text(booksSelected.length.toString(),
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400)))
                        ])),
                    Wrap(
                        children: (categoryFilter == CategoryFilter.all
                                ? totalBooks
                                : filteredBooks)
                            .map((book) => Opacity(
                                opacity: 1,
                                child: Container(
                                    height: 35,
                                    margin: const EdgeInsets.all(5),
                                    child: OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                            foregroundColor:
                                                booksSelected.contains(book)
                                                    ? Colors.white
                                                    : null,
                                            backgroundColor:
                                                booksSelected.contains(book)
                                                    ? lightPrimaryColor
                                                    : Colors.white),
                                        onPressed: () => setState(() {
                                              if (!booksSelected
                                                  .contains(book)) {
                                                booksSelected.add(book);
                                              } else {
                                                booksSelected.remove(book);
                                              }
                                            }),
                                        child: Text(book,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                                fontSize: 10))))))
                            .toList())
                  ])))
        ]));
  }
}
