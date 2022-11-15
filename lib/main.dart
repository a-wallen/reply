import 'package:flutter/material.dart';
import 'package:reply/models/models.dart';
import 'package:reply/email_widget.dart';
import 'package:reply/search.dart';

import 'models/data.dart' as data;

void main() {
  runApp(const ReplyApp());
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

class _FeedState extends State<Feed> {
  int selectedIndex = 0;
  final ScrollController controller = ScrollController(initialScrollOffset: 7);
  late ColorScheme colorScheme = Theme.of(context).colorScheme;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Color.alphaBlend(
        colorScheme.primary.withOpacity(0.14),
        colorScheme.surface,
      ),
      child: ListDetailView(
        list: ListView(
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
        detail: ListView(
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
    );
  }
}

class ListDetailView extends StatelessWidget {
  const ListDetailView({
    super.key,
    required this.list,
    required this.detail,
  });

  final Widget list;
  final Widget detail;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: list),
        const Padding(padding: EdgeInsets.only(right: 12)),
        Expanded(child: detail),
      ],
    );
  }
}
