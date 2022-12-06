import 'package:flutter/material.dart';
import 'package:reply/models/models.dart';
import 'package:reply/widgets/animated_fab.dart';
import 'package:reply/widgets/email_widget.dart';
import 'package:reply/widgets/search.dart';
import 'package:reply/transitions/constants.dart';
import 'package:reply/transitions/list_detail_transition.dart';

import 'models/data.dart' as data;
import 'transitions/bar_transition.dart';
import 'transitions/rail_transition.dart';

void main() {
  runApp(const ReplyApp());
}

class _Destination {
  const _Destination(this.icon,  this.label);
  final IconData icon;
  final String label;
}

class ReplyApp extends StatelessWidget {
  const ReplyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(useMaterial3: true),
      home: Scaffold(
        body: Feed(currentUser: data.user_0),
      ),
    );
  }
}

class Feed extends StatefulWidget {
  const Feed({
    super.key,
    required this.currentUser,
  });

  final User currentUser;

  @override
  State<Feed> createState() => _FeedState();
}

class _FeedState extends State<Feed> with SingleTickerProviderStateMixin {
  late ColorScheme colorScheme = Theme.of(context).colorScheme;
  late final AnimationController controller;
  late final CurvedAnimation railAnimation;
  late final CurvedAnimation railFabAnimation;
  late final ReverseAnimation barAnimation;
  int selectedIndex = 0;
  bool controllerInitialized = false;

  @override initState() {
    super.initState();

    controller = AnimationController(
      reverseDuration: MaterialDuration.max.value,
      duration: MaterialDuration.extraLong4.value,
      value: 0,
      vsync: this,
    );

    barAnimation = ReverseAnimation(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0, 1 / 5),
        reverseCurve: const Interval(1 / 5, 4 / 5)
      ),
    );

    railAnimation = CurvedAnimation(
      parent: controller,
      curve: const Interval(0 / 5, 4 / 5),
      reverseCurve: const Interval(3 / 5, 1),
    );

    railFabAnimation = CurvedAnimation(
      parent: railAnimation,
      curve: const Interval(3 / 5, 1),
      reverseCurve: const Interval(0, 1), // the FAB shouldn't disappear
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final double width = MediaQuery.of(context).size.width;
    final AnimationStatus status = controller.status;
    if (width > 600) {
      if (status != AnimationStatus.forward && status != AnimationStatus.completed) {
        controller.forward();
      }
    } else {
      if (status != AnimationStatus.reverse && status != AnimationStatus.dismissed) {
        controller.reverse();
      }
    }
    if (!controllerInitialized) {
      controllerInitialized = true;
      controller.value = width > 600 ? 1 : 0;
    }
}

  final List<_Destination> destinations = const <_Destination>[
    _Destination(Icons.inbox_rounded, 'Inbox'),
    _Destination(Icons.article_outlined, 'Articles'),
    _Destination(Icons.messenger_outline_rounded, 'Messages'),
    _Destination(Icons.group_outlined, 'Groups'),
  ];

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Color backgroundColor = Color.alphaBlend(
      colorScheme.primary.withOpacity(0.14),
      colorScheme.surface,
    );


    return AnimatedBuilder(
      animation: controller,
      builder: (BuildContext context, Widget? child) {
        return Scaffold(
          body: Row(
            children: <Widget>[
              RailTransition(
                animation: railAnimation,
                backgroundColor: backgroundColor,
                child: NavigationRail(
                  selectedIndex: selectedIndex,
                  backgroundColor: backgroundColor,
                  onDestinationSelected: (int index) {
                    setState(() {
                      selectedIndex = index;
                    });
                  },
                  leading: Column(
                    children: <Widget>[
                      IconButton(
                        onPressed: () { },
                        icon: const Icon(Icons.menu),
                      ),
                      const SizedBox(height: 8),
                      AnimatedFloatingActionButton(
                        animation: railFabAnimation,
                        elevation: 0,
                        onPressed: () { },
                        child: const Icon(Icons.add),
                      ),
                    ],
                  ),
                  groupAlignment: -0.85,
                  destinations: destinations.map<NavigationRailDestination>((_Destination d) {
                    return NavigationRailDestination(
                      icon: Icon(d.icon),
                      label: Text(d.label),
                    );
                  }).toList(),
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                  color: backgroundColor,
                  child: OneTwoTransition(
                    animation: railAnimation,
                    one: ListView(
                      children: [
                        SearchBar(currentUser: widget.currentUser),
                        const Padding(padding: EdgeInsets.only(bottom: 8.0)),
                        ...List.generate(data.emails.length, (int index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: EmailWidget(
                              email: data.emails[index],
                              onSelected: () {
                                setState(() {
                                  selectedIndex = index;
                                });
                              },
                              selected: selectedIndex == index,
                            ),
                          );
                        }),
                      ],
                    ),
                    two: ListView(
                      children:  List.generate(data.replies.length, (int index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: EmailWidget(
                            email: data.replies[index],
                            isPreview: false,
                            isThreaded: true,
                            showHeadline: index == 0,
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ),
            ],
          ),
          floatingActionButton: AnimatedFloatingActionButton(
            animation: barAnimation,
            onPressed: () { },
            child: const Icon(Icons.add),
          ),
          bottomNavigationBar: BarTransition(
            animation: barAnimation,
            backgroundColor: Colors.white,
            child: NavigationBar(
              elevation: 0,
              backgroundColor: Colors.white,
              destinations: destinations.map<NavigationDestination>((_Destination d) {
                return NavigationDestination(
                  icon: Icon(d.icon),
                  label: d.label,
                );
              }).toList(),
              selectedIndex: selectedIndex,
              onDestinationSelected: (int index) {
                setState(() {
                  selectedIndex = index;
                });
              },
            ),
          ),
        );
      }
    );
  }
}
