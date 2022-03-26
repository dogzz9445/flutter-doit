import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_doit/data/app_settings.dart';
import 'package:flutter_doit/layout/adaptive.dart';
import 'package:flutter_doit/layout/rally_tab.dart';
import 'package:flutter_doit/layout/text_scale.dart';
import 'package:flutter_doit/pages/tab_activity.dart';
import 'package:flutter_doit/pages/tab_calender.dart';
import 'package:flutter_doit/pages/tab_friend.dart';
import 'package:flutter_doit/pages/tab_setting.dart';
import 'package:flutter_doit/pages/tab_todo.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, this.title = "Home Page"}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  static const String baseRoute = '/';
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin, RestorationMixin {
  late TabController _tabController;
  RestorableInt tabIndex = RestorableInt(0);
  final int tabCount = 5;
  final int turnsToRotateRight = 1;
  final int turnsToRotateLeft = 3;

  @override
  String get restorationId => 'home_page';

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(tabIndex, 'tab_index');
    _tabController.index = tabIndex.value;
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabCount, vsync: this)
      ..addListener(() {
        // Set state to make sure that the [_RallyTab] widgets get updated when changing tabs.
        setState(() {
          tabIndex.value = _tabController.index;
        });
      });
  }

  @override
  void dispose() {
    _tabController.dispose();
    tabIndex.dispose();
    super.dispose();
  }

  List<Widget> _buildTabs(
      {required BuildContext context,
      required ThemeData theme,
      bool isVertical = false}) {
    return [
      RallyTab(
        theme: theme,
        iconData: Icons.pie_chart,
        // title: GalleryLocalizations.of(context).rallyTitleOverview,
        title: "캘린더",
        tabIndex: 0,
        tabCount: tabCount,
        tabController: _tabController,
        isVertical: isVertical,
      ),
      RallyTab(
        theme: theme,
        iconData: Icons.attach_money,
        // title: GalleryLocalizations.of(context).rallyTitleAccounts,
        title: "투두",
        tabIndex: 1,
        tabCount: tabCount,
        tabController: _tabController,
        isVertical: isVertical,
      ),
      RallyTab(
        theme: theme,
        iconData: Icons.money_off,
        // title: GalleryLocalizations.of(context).rallyTitleBills,
        title: "활동",
        tabIndex: 2,
        tabCount: tabCount,
        tabController: _tabController,
        isVertical: isVertical,
      ),
      RallyTab(
        theme: theme,
        iconData: Icons.table_chart,
        // title: GalleryLocalizations.of(context).rallyTitleBudgets,
        title: "그룹",
        tabIndex: 3,
        tabCount: tabCount,
        tabController: _tabController,
        isVertical: isVertical,
      ),
      RallyTab(
        theme: theme,
        iconData: Icons.settings,
        // title: GalleryLocalizations.of(context).rallyTitleSettings,
        title: "설정",
        tabIndex: 4,
        tabCount: tabCount,
        tabController: _tabController,
        isVertical: isVertical,
      ),
    ];
  }

  List<Widget> _buildTabViews() {
    return const [
      CalenderView(),
      TodoView(),
      ActivityView(),
      FriendView(),
      SettingView()
    ];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDesktop = isDisplayDesktop(context);

    Widget tabBarView;
    if (isDesktop) {
      final isTextDirectionRtl =
          AppSettings.of(context).resolvedTextDirection() == TextDirection.rtl;
      final verticalRotation =
          isTextDirectionRtl ? turnsToRotateLeft : turnsToRotateRight;
      final revertVerticalRotation =
          isTextDirectionRtl ? turnsToRotateRight : turnsToRotateLeft;
      tabBarView = Row(
        children: [
          Container(
            width: 150 + 50 * (cappedTextScale(context) - 1),
            alignment: Alignment.topCenter,
            padding: const EdgeInsets.symmetric(vertical: 32),
            child: Column(
              children: [
                const SizedBox(height: 24),
                ExcludeSemantics(
                  child: SizedBox(
                    height: 80,
                    child: Image.asset(
                      'logo.png',
                      package: 'rally_assets',
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Rotate the tab bar, so the animation is vertical for desktops.
                RotatedBox(
                  quarterTurns: verticalRotation,
                  child: RallyTabBar(
                    tabs: _buildTabs(
                            context: context, theme: theme, isVertical: true)
                        .map(
                      (widget) {
                        // Revert the rotation on the tabs.
                        return RotatedBox(
                          quarterTurns: revertVerticalRotation,
                          child: widget,
                        );
                      },
                    ).toList(),
                    tabController: _tabController,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            // Rotate the tab views so we can swipe up and down.
            child: RotatedBox(
              quarterTurns: verticalRotation,
              child: TabBarView(
                controller: _tabController,
                children: _buildTabViews().map(
                  (widget) {
                    // Revert the rotation on the tab views.
                    return RotatedBox(
                      quarterTurns: revertVerticalRotation,
                      child: widget,
                    );
                  },
                ).toList(),
              ),
            ),
          ),
        ],
      );
    } else {
      tabBarView = Column(
        children: [
          RallyTabBar(
            tabs: _buildTabs(context: context, theme: theme),
            tabController: _tabController,
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: _buildTabViews(),
            ),
          ),
        ],
      );
    }

    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    // return Scaffold(
    //   appBar: AppBar(
    //     // Here we take the value from the MyHomePage object that was created by
    //     // the App.build method, and use it to set our appbar title.
    //     title: Text(widget.title),
    //   ),
    //   body: Center(
    //     // Center is a layout widget. It takes a single child and positions it
    //     // in the middle of the parent.
    //     child: Column(
    //       // Column is also a layout widget. It takes a list of children and
    //       // arranges them vertically. By default, it sizes itself to fit its
    //       // children horizontally, and tries to be as tall as its parent.
    //       //
    //       // Invoke "debug painting" (press "p" in the console, choose the
    //       // "Toggle Debug Paint" action from the Flutter Inspector in Android
    //       // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
    //       // to see the wireframe for each widget.
    //       //
    //       // Column has various properties to control how it sizes itself and
    //       // how it positions its children. Here we use mainAxisAlignment to
    //       // center the children vertically; the main axis here is the vertical
    //       // axis because Columns are vertical (the cross axis would be
    //       // horizontal).
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: <Widget>[
    //         const Text(
    //           'You have pushed the button this many times:',
    //         ),
    //         Text(
    //           '00',
    //           style: Theme.of(context).textTheme.headline4,
    //         ),
    //         CalendarDatePicker(
    //             initialDate: DateTime.now(),
    //             firstDate: DateTime(2017),
    //             lastDate: DateTime(2030),
    //             onDateChanged: (pick) {
    //               log("pick cal");
    //             })
    //       ],
    //     ),
    //   ),
    // );

    return ApplyTextOptions(
      child: Scaffold(
        body: SafeArea(
          // For desktop layout we do not want to have SafeArea at the top and
          // bottom to display 100% height content on the accounts view.
          top: !isDesktop,
          bottom: !isDesktop,
          child: Theme(
            // This theme effectively removes the default visual touch
            // feedback for tapping a tab, which is replaced with a custom
            // animation.
            data: theme.copyWith(
                inputDecorationTheme: const InputDecorationTheme(
                  labelStyle: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                  filled: true,
                  fillColor: Colors.black,
                  focusedBorder: InputBorder.none,
                ),
                primaryColor: Colors.black,
                // splashColor: Colors.transparent,
                // highlightColor: Colors.transparent,
                appBarTheme: const AppBarTheme(
                  systemOverlayStyle: SystemUiOverlayStyle.light,
                  // backgroundColor: RallyColors.primaryBackground,
                  backgroundColor: Colors.black,
                  elevation: 0,
                )),
            child: FocusTraversalGroup(
              policy: OrderedTraversalPolicy(),
              child: tabBarView,
            ),
          ),
        ),
      ),
    );
  }
}
