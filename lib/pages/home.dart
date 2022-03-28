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

  static const String baseRoute = '/home';
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin, RestorationMixin {
  late TabController _tabController;
  RestorableInt tabIndex = RestorableInt(1);
  final int tabCount = 6;
  final int turnsToRotateRight = 1;
  final int turnsToRotateLeft = 3;
  final double tabOffset = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
          if (_tabController.index == 0) {
            _tabController.index = 1;
          }
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

  // TODO:
  // 탭 왼쪽으로 갔을 시,
  // 메뉴 위젯으로 넘어가는 것 해결할것
  List<Widget> _buildTabs(
      {required BuildContext context,
      required ThemeData theme,
      bool isVertical = false}) {
    return [
      IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => _scaffoldKey.currentState?.openDrawer()),
      RallyTab(
        theme: theme,
        iconData: Icons.calendar_month,
        // title: GalleryLocalizations.of(context).rallyTitleOverview,
        title: "캘린더",
        tabIndex: 1,
        tabCount: tabCount,
        tabController: _tabController,
        isVertical: isVertical,
        tabOffset: tabOffset,
      ),
      RallyTab(
        theme: theme,
        iconData: Icons.check_box_outlined,
        // title: GalleryLocalizations.of(context).rallyTitleAccounts,
        title: "할일",
        tabIndex: 2,
        tabCount: tabCount,
        tabController: _tabController,
        isVertical: isVertical,
        tabOffset: tabOffset,
      ),
      RallyTab(
        theme: theme,
        iconData: Icons.favorite,
        // title: GalleryLocalizations.of(context).rallyTitleBills,
        title: "활동",
        tabIndex: 3,
        tabCount: tabCount,
        tabController: _tabController,
        isVertical: isVertical,
        tabOffset: tabOffset,
      ),
      RallyTab(
        theme: theme,
        iconData: Icons.group,
        // title: GalleryLocalizations.of(context).rallyTitleBudgets,
        title: "그룹",
        tabIndex: 4,
        tabCount: tabCount,
        tabController: _tabController,
        isVertical: isVertical,
        tabOffset: tabOffset,
      ),
      RallyTab(
        theme: theme,
        iconData: Icons.settings,
        // title: GalleryLocalizations.of(context).rallyTitleSettings,
        title: "설정",
        tabIndex: 5,
        tabCount: tabCount,
        tabController: _tabController,
        isVertical: isVertical,
        tabOffset: tabOffset,
      ),
    ];
  }

  List<Widget> _buildTabViews() {
    return const [
      Text("Menu"),
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
          Padding(
            padding: EdgeInsets.only(left: tabOffset),
            child: RallyTabBar(
              tabs: _buildTabs(context: context, theme: theme),
              tabController: _tabController,
            ),
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

    return ApplyTextOptions(
      child: Scaffold(
          key: _scaffoldKey,
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
                ),
              ),
              child: FocusTraversalGroup(
                policy: OrderedTraversalPolicy(),
                child: tabBarView,
              ),
            ),
          ),
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                const DrawerHeader(
                  decoration: BoxDecoration(
                    color: Color(0x24888888),
                  ),
                  child: Text(
                    'Doit 캘린더',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                ListTile(
                  title: const Text('Doit 일정'),
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 0.0, horizontal: 16.0),
                  dense: true,
                  onTap: () => Navigator.pop(context),
                  onLongPress: () => Navigator.pop(context),
                ),
                ListTile(
                  title: const Text('동기화된 일정'),
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 0.0, horizontal: 16.0),
                  dense: true,
                  onTap: () => Navigator.pop(context),
                  onLongPress: () => Navigator.pop(context),
                ),
              ],
            ),
          )),
    );
  }
}
