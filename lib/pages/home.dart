import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:doit_calendar_todo/data/app_settings.dart';
import 'package:doit_calendar_todo/layout/adaptive.dart';
import 'package:doit_calendar_todo/layout/rally_tab.dart';
import 'package:doit_calendar_todo/layout/text_scale.dart';
import 'package:doit_calendar_todo/pages/tab_activity.dart';
import 'package:doit_calendar_todo/pages/tab_calender.dart';
import 'package:doit_calendar_todo/pages/tab_friend.dart';
import 'package:doit_calendar_todo/pages/tab_setting.dart';
import 'package:doit_calendar_todo/pages/tab_todo.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

GoogleSignIn _googleSignIn = GoogleSignIn(
  // Optional clientId
  // clientId: '479882132969-9i9aqik3jfjd7qhci1nqf0bm2g71rm1u.apps.googleusercontent.com',
  scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);

// TODO:
// 파이어베이스 AUTH example
// https://firebase.flutter.dev/docs/auth/usage/

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

  GoogleSignInAccount? _currentUser;
  String _contactText = '';

  Future<void> _handleGetContact(GoogleSignInAccount user) async {
    setState(() {
      _contactText = 'Loading contact info...';
    });
    final http.Response response = await http.get(
      Uri.parse('https://people.googleapis.com/v1/people/me/connections'
          '?requestMask.includeField=person.names'),
      headers: await user.authHeaders,
    );
    if (response.statusCode != 200) {
      setState(() {
        _contactText = 'People API gave a ${response.statusCode} '
            'response. Check logs for details.';
      });
      print('People API ${response.statusCode} response: ${response.body}');
      return;
    }
    final Map<String, dynamic> data =
        json.decode(response.body) as Map<String, dynamic>;
    final String? namedContact = _pickFirstNamedContact(data);
    setState(() {
      if (namedContact != null) {
        _contactText = 'I see you know $namedContact!';
      } else {
        _contactText = 'No contacts to display.';
      }
    });
  }

  String? _pickFirstNamedContact(Map<String, dynamic> data) {
    final List<dynamic>? connections = data['connections'] as List<dynamic>?;
    final Map<String, dynamic>? contact = connections?.firstWhere(
      (dynamic contact) => contact['names'] != null,
      orElse: () => null,
    ) as Map<String, dynamic>?;
    if (contact != null) {
      final Map<String, dynamic>? name = contact['names'].firstWhere(
        (dynamic name) => name['displayName'] != null,
        orElse: () => null,
      ) as Map<String, dynamic>?;
      if (name != null) {
        return name['displayName'] as String?;
      }
    }
    return null;
  }

  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
  }

  Future<void> _handleSignOut() => _googleSignIn.disconnect();

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
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      setState(() {
        _currentUser = account;
      });
      if (_currentUser != null) {
        _handleGetContact(_currentUser!);
      }
    });
    _googleSignIn.signInSilently();

    _tabController = TabController(length: tabCount, vsync: this)
      ..addListener(() {
        // Set state to make sure that the [_RallyTab] widgets get updated when changing tabs.
        setState(() {
          if (_tabController.index == 0) {
            _tabController.animateTo(1);
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

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;
    final OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    return await FirebaseAuth.instance.signInWithCredential(credential);
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
                      'assets/logo/logo.png',
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
