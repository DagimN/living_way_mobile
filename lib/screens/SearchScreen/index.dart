import 'package:flutter/material.dart' hide SearchController;
import 'package:flutter_svg/svg.dart';
import 'package:living_way/controllers/controllers.dart';
import 'package:living_way/core/core.dart';
import 'package:living_way/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'widgets/bible_result_tile.dart';
import 'widgets/search_section.dart';
import 'widgets/youtube_result_tile.dart';

class _NoResultsState extends StatelessWidget {
  const _NoResultsState();

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);
    final theme = AppTheme(themeController.brightness);

    return Center(
      child: Text(
        Tr.t('messages.noResultsFound'),
        style: TextStyle(color: theme.accentColor.withAlpha(153)),
      ),
    );
  }
}

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    final ThemeController themeController =
        Provider.of<ThemeController>(context);
    final SearchController searchController =
        Provider.of<SearchController>(context);
    final LayoutController layoutController =
        Provider.of<LayoutController>(context);
    final BibleController bibleController =
        Provider.of<BibleController>(context);
    final textController = searchController.textFieldController;

    final nothingYet = !searchController.isSearchingActivities &&
        !searchController.isSearchingMedia &&
        !searchController.isSearchingBible &&
        searchController.results.isEmpty;

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final theme = AppTheme(themeController.brightness);

    return Scaffold(
        backgroundColor: AppTheme(themeController.brightness).backgroundColor,
        body: SafeArea(
            child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(children: [
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      searchController.clear();
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back, color: theme.primaryColor)),
                Container(
                    margin: const EdgeInsets.all(10),
                    width: screenWidth * .8,
                    child: TextField(
                        controller: searchController.textFieldController,
                        autofocus: true,
                        onChanged: (value) =>
                            searchController.onQueryChanged(value),
                        textInputAction: TextInputAction.search,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(35)),
                            hintText: Tr.t('common.search'),
                            suffixIcon: Hero(
                                tag: 'search',
                                child: IconButton(
                                    icon: SvgPicture.asset(AppIcons.search,
                                        height: 24),
                                    onPressed: () {
                                      searchController
                                          .search(textController.text);
                                    }))))),
              ],
            ),
            (nothingYet)
                ? const _NoResultsState()
                : DefaultTabController(
                    length: 4,
                    child: Column(
                      spacing: 4,
                      children: [
                        TabBar(
                          onTap: (index) async {
                            AnalyticsService.logEvent('about_tab_selected',
                                parameters: {'index': index.toString()});
                          },
                          tabs: [
                            Tab(
                                child: Text(
                                    '${Tr.t("bottomSheet.categoryAll")} (${searchController.results.length})',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 10))),
                            Tab(
                                child: Text(
                                    '${Tr.t("navigation.media")} (${searchController.youtubeResults.length})',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 10))),
                            Tab(
                                child: Text(
                                    '${Tr.t("navigation.activities")} (${searchController.activityResults.length})',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 10))),
                            Tab(
                                child: Text(
                                    '${Tr.t("navigation.bible")} (${searchController.bibleResults.length})',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 10))),
                          ],
                          unselectedLabelColor: theme.accentColor,
                        ),
                        SizedBox(
                          height: screenHeight * 0.8,
                          child: TabBarView(children: [
                            SingleChildScrollView(
                              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                              child: Column(
                                children: [
                                  SearchSection<YoutubeSearchResult>(
                                    title: Tr.t('navigation.media'),
                                    icon: Icons.play_circle_fill_rounded,
                                    items: searchController.youtubeResults,
                                    isLoading:
                                        searchController.isSearchingMedia,
                                    height: screenHeight * 0.15,
                                    scrollDirection: Axis.horizontal,
                                    scrollController: searchController
                                        .mediaSearchHorizontalScrollController,
                                    errorText: searchController
                                        .sourceErrors[SearchResultType.youtube],
                                    itemBuilder: (context, item) =>
                                        YoutubeResultTile(
                                            result: item,
                                            scrollDirection: Axis.horizontal,
                                            onTap: () {
                                              AnalyticsService.logEvent(
                                                  'topic_video_launched');
                                              launchUrl(Uri.parse(
                                                  "https://www.youtube.com/watch?v=${item.videoId}"));
                                            }),
                                  ),
                                  SearchSection<ActivitySearchResult>(
                                    title: Tr.t('navigation.activities'),
                                    icon: Icons.event_note_rounded,
                                    items: searchController.activityResults,
                                    isLoading:
                                        searchController.isSearchingActivities,
                                    errorText: searchController.sourceErrors[
                                        SearchResultType.activity],
                                    height: screenHeight * 0.25,
                                    scrollDirection: Axis.vertical,
                                    scrollController: searchController
                                        .activitiesSearchMiniScrollController,
                                    itemBuilder: (context, item) =>
                                        TimelineContainer(
                                            activity: item.activity,
                                            isLast: true,
                                            margin: EdgeInsets.zero),
                                  ),
                                  SearchSection<BibleSearchResult>(
                                    title: Tr.t('navigation.bible'),
                                    icon: Icons.menu_book_rounded,
                                    items: searchController.bibleResults,
                                    isLoading:
                                        searchController.isSearchingBible,
                                    scrollDirection: Axis.vertical,
                                    height: screenHeight * 0.4,
                                    errorText: searchController
                                        .sourceErrors[SearchResultType.bible],
                                    itemBuilder: (context, item) =>
                                        BibleResultTile(
                                            result: item,
                                            onTap: () {
                                              Navigator.pop(context);
                                              layoutController
                                                      .setSelectedHomePageNavigation =
                                                  HomePageNavigation.bible;
                                              bibleController.setPassage =
                                                  item.passage;
                                              AnalyticsService.logEvent(
                                                  'searched_verse_navigated');

                                              Future.delayed(
                                                  const Duration(seconds: 2),
                                                  () => layoutController
                                                      .scrollToVerse(
                                                          layoutController
                                                                  .verseKeys[
                                                              item.passage
                                                                  .verse]));
                                            }),
                                  ),
                                ],
                              ),
                            ),
                            SingleChildScrollView(
                              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                              child: SearchSection<YoutubeSearchResult>(
                                title: Tr.t('navigation.media'),
                                icon: Icons.play_circle_fill_rounded,
                                items: searchController.youtubeResults,
                                isLoading: searchController.isSearchingMedia,
                                height: screenHeight * .8,
                                scrollDirection: Axis.vertical,
                                scrollController: searchController
                                    .mediaSearchVerticalScrollController,
                                showLabel: false,
                                errorText: searchController
                                    .sourceErrors[SearchResultType.youtube],
                                itemBuilder: (context, item) =>
                                    YoutubeResultTile(
                                        result: item,
                                        scrollDirection: Axis.vertical,
                                        onTap: () {
                                          AnalyticsService.logEvent(
                                              'topic_video_launched');
                                          launchUrl(Uri.parse(
                                              "https://www.youtube.com/watch?v=${item.videoId}"));
                                        }),
                              ),
                            ),
                            SingleChildScrollView(
                              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                              child: SearchSection<ActivitySearchResult>(
                                title: Tr.t('navigation.activities'),
                                icon: Icons.event_note_rounded,
                                items: searchController.activityResults,
                                isLoading:
                                    searchController.isSearchingActivities,
                                errorText: searchController
                                    .sourceErrors[SearchResultType.activity],
                                showLabel: false,
                                height: screenHeight * .8,
                                scrollDirection: Axis.vertical,
                                scrollController: searchController
                                    .activitiesSearchScrollController,
                                itemBuilder: (context, item) =>
                                    TimelineContainer(
                                        activity: item.activity,
                                        isLast: true,
                                        margin: EdgeInsets.zero),
                              ),
                            ),
                            SingleChildScrollView(
                              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                              child: SearchSection<BibleSearchResult>(
                                title: Tr.t('navigation.bible'),
                                icon: Icons.menu_book_rounded,
                                items: searchController.bibleResults,
                                isLoading: searchController.isSearchingBible,
                                scrollDirection: Axis.vertical,
                                height: screenHeight * .8,
                                errorText: searchController
                                    .sourceErrors[SearchResultType.bible],
                                showLabel: false,
                                itemBuilder: (context, item) => BibleResultTile(
                                    result: item,
                                    onTap: () {
                                      Navigator.pop(context);
                                      layoutController
                                              .setSelectedHomePageNavigation =
                                          HomePageNavigation.bible;
                                      bibleController.setPassage = item.passage;
                                      AnalyticsService.logEvent(
                                          'searched_verse_navigated');

                                      Future.delayed(
                                          const Duration(seconds: 2),
                                          () => layoutController.scrollToVerse(
                                              layoutController.verseKeys[
                                                  item.passage.verse]));
                                    }),
                              ),
                            ),
                          ]),
                        ),
                      ],
                    ),
                  )
          ]),
        )));
  }
}
