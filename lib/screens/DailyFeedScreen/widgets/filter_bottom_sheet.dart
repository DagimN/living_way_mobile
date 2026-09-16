import 'package:flutter/material.dart';
import 'package:living_way/controllers/controllers.dart';
import 'package:living_way/core/core.dart';
import 'package:provider/provider.dart';

class FilterBottomSheet extends StatefulWidget {
  final SortOptions sortOption;
  final CategoryFilter categoryFilter;
  final List<String> booksSelected;
  const FilterBottomSheet(
      {super.key,
      required this.sortOption,
      required this.categoryFilter,
      required this.booksSelected});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet>
    with TickerProviderStateMixin {
  SortOptions activityFilter = SortOptions.latest;
  CategoryFilter categoryFilter = CategoryFilter.all;
  List<String> booksSelected = [];

  @override
  void initState() {
    super.initState();
    activityFilter = widget.sortOption;
    categoryFilter = widget.categoryFilter;
    booksSelected = widget.booksSelected;
  }

  @override
  Widget build(BuildContext context) {
    final devotionController = Provider.of<DevotionController>(context);
    final themeController = Provider.of<ThemeController>(context);
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
        decoration: BoxDecoration(
            color: AppTheme(themeController.brightness).backgroundColor,
            borderRadius:
                const BorderRadius.only(topLeft: radius, topRight: radius)),
        child: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(Tr.t('filter'),
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 24,
                    color: AppTheme(themeController.brightness).accentColor)),
            Row(children: [
              TextButton(
                  child: Text(Tr.t('reset'),
                      style: TextStyle(
                          color: AppTheme(themeController.brightness)
                              .primaryColor)),
                  onPressed: () {
                    devotionController.setSortOption = SortOptions.latest;
                    devotionController.categoryFilter = CategoryFilter.all;
                    devotionController.setBooksFilter = [];

                    devotionController.fetchTopics(isRefreshing: true);
                    Navigator.pop(context);
                  }),
              TextButton(
                  child: Text(Tr.t('apply'),
                      style: TextStyle(
                          color: AppTheme(themeController.brightness)
                              .primaryColor)),
                  onPressed: () {
                    devotionController.setSortOption = activityFilter;
                    devotionController.setCategoryFilter = categoryFilter;
                    devotionController.setBooksFilter = booksSelected;

                    devotionController.fetchTopics(isRefreshing: true);
                    Navigator.pop(context);
                  })
            ])
          ]),
          Divider(color: AppTheme(themeController.brightness).dividerColor),
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
                                                  SortOptions.latest
                                              ? Colors.white
                                              : AppTheme(themeController
                                                      .brightness)
                                                  .inactiveChipColor,
                                          backgroundColor: activityFilter ==
                                                  SortOptions.latest
                                              ? AppTheme(themeController
                                                      .brightness)
                                                  .primaryColor
                                              : AppTheme(themeController
                                                      .brightness)
                                                  .chipColor),
                                      onPressed: () => setState(() {
                                            activityFilter = SortOptions.latest;
                                          }),
                                      child: Text(Tr.t('sortLatest'),
                                          textAlign: TextAlign.center,
                                          style:
                                              const TextStyle(fontSize: 10)))),
                              Padding(
                                  padding: const EdgeInsets.all(3),
                                  child: OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                          foregroundColor: activityFilter ==
                                                  SortOptions.mostActive
                                              ? Colors.white
                                              : AppTheme(themeController
                                                      .brightness)
                                                  .inactiveChipColor,
                                          backgroundColor: activityFilter ==
                                                  SortOptions.mostActive
                                              ? AppTheme(themeController
                                                      .brightness)
                                                  .primaryColor
                                              : AppTheme(themeController
                                                      .brightness)
                                                  .chipColor),
                                      onPressed: () => setState(() {
                                            activityFilter =
                                                SortOptions.mostActive;
                                          }),
                                      child: Text(Tr.t('sortMostActive'),
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(fontSize: 10)))),
                              Padding(
                                  padding: const EdgeInsets.all(3),
                                  child: OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                          foregroundColor: activityFilter ==
                                                  SortOptions.mostLiked
                                              ? Colors.white
                                              : AppTheme(themeController
                                                      .brightness)
                                                  .inactiveChipColor,
                                          backgroundColor: activityFilter ==
                                                  SortOptions.mostLiked
                                              ? AppTheme(themeController
                                                      .brightness)
                                                  .primaryColor
                                              : AppTheme(themeController
                                                      .brightness)
                                                  .chipColor),
                                      onPressed: () => setState(() {
                                            activityFilter =
                                                SortOptions.mostLiked;
                                          }),
                                      child: Text(Tr.t('sortMostLiked'),
                                          textAlign: TextAlign.center,
                                          style:
                                              const TextStyle(fontSize: 10)))),
                              Padding(
                                  padding: const EdgeInsets.all(3),
                                  child: OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                          foregroundColor: activityFilter ==
                                                  SortOptions.mostViewed
                                              ? Colors.white
                                              : AppTheme(themeController
                                                      .brightness)
                                                  .inactiveChipColor,
                                          backgroundColor: activityFilter ==
                                                  SortOptions.mostViewed
                                              ? AppTheme(themeController
                                                      .brightness)
                                                  .primaryColor
                                              : AppTheme(themeController
                                                      .brightness)
                                                  .chipColor),
                                      onPressed: () => setState(() {
                                            activityFilter =
                                                SortOptions.mostViewed;
                                          }),
                                      child: Text(Tr.t('sortMostViewed'),
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(fontSize: 10))))
                            ])),
                    const SizedBox(height: 16),
                    Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
                        child: Text(Tr.t('category'),
                            style: TextStyle(
                                color: AppTheme(themeController.brightness)
                                    .subHeadingColor,
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
                                      foregroundColor: categoryFilter ==
                                              CategoryFilter.all
                                          ? Colors.white
                                          : AppTheme(themeController.brightness)
                                              .inactiveChipColor,
                                      backgroundColor: categoryFilter ==
                                              CategoryFilter.all
                                          ? AppTheme(themeController.brightness)
                                              .primaryColor
                                          : AppTheme(themeController.brightness)
                                              .chipColor),
                                  onPressed: () => setState(() {
                                        categoryFilter = CategoryFilter.all;
                                      }),
                                  child: Text(Tr.t('categoryAll'),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(fontSize: 10)))),
                          Container(
                              height: 35,
                              margin: const EdgeInsets.all(5),
                              child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                      foregroundColor: categoryFilter ==
                                              CategoryFilter.ot
                                          ? Colors.white
                                          : AppTheme(themeController.brightness)
                                              .inactiveChipColor,
                                      backgroundColor: categoryFilter ==
                                              CategoryFilter.ot
                                          ? AppTheme(themeController.brightness)
                                              .primaryColor
                                          : AppTheme(themeController.brightness)
                                              .chipColor),
                                  onPressed: () => setState(() {
                                        categoryFilter = CategoryFilter.ot;
                                        booksSelected.removeWhere((book) =>
                                            (books['nt'] ?? []).contains(book));
                                      }),
                                  child: Text(Tr.t('categoryOT'),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(fontSize: 10)))),
                          Container(
                              height: 35,
                              margin: const EdgeInsets.all(5),
                              child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                      foregroundColor: categoryFilter ==
                                              CategoryFilter.nt
                                          ? Colors.white
                                          : AppTheme(themeController.brightness)
                                              .inactiveChipColor,
                                      backgroundColor: categoryFilter ==
                                              CategoryFilter.nt
                                          ? AppTheme(themeController.brightness)
                                              .primaryColor
                                          : AppTheme(themeController.brightness)
                                              .chipColor),
                                  onPressed: () => setState(() {
                                        categoryFilter = CategoryFilter.nt;
                                        booksSelected.removeWhere((book) =>
                                            (books['ot'] ?? []).contains(book));
                                      }),
                                  child: Text(Tr.t('categoryNT'),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(fontSize: 10))))
                        ])),
                    const SizedBox(height: 16),
                    Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
                        child: Row(children: [
                          Text(Tr.t('books'),
                              style: TextStyle(
                                  color: AppTheme(themeController.brightness)
                                      .subHeadingColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400)),
                          if (booksSelected.isNotEmpty)
                            Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 3),
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    color: AppTheme(themeController.brightness)
                                        .primaryColor
                                        .withAlpha(102),
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
                                                    : AppTheme(themeController
                                                            .brightness)
                                                        .inactiveChipColor,
                                            backgroundColor: booksSelected
                                                    .contains(book)
                                                ? AppTheme(themeController.brightness)
                                                    .primaryColor
                                                : AppTheme(themeController.brightness)
                                                    .chipColor),
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
