import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:seekhelp/strings.dart';
import 'dart:async';

import 'package:url_launcher/url_launcher.dart';

void main() => runApp(new LinksAmbassade());

List<String> lists = [
  Strings.portfolioSiteLinkUrl
];

class LinksAmbassade extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.appName),
      ),
      body: links1(),
    );
  }

  Widget links1() {
    return new ListView.separated(
        separatorBuilder: (context, index) => Divider(
              height: 10,
              color: Colors.transparent,
            ),
        shrinkWrap: true,
        itemCount: lists.length,
        padding: EdgeInsets.all(10.0),
        itemBuilder: (BuildContext context, int index) {
          return Column(children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                decoration: BoxDecoration(color: Colors.white),
                child: ListTile(
                  title: Linkify(
                      text: Text(lists[index]).data,
                      linkStyle: TextStyle(color: Colors.red, fontSize: 18),
                      onOpen: _onOpen),
                ),
              ),
            ),
          ]);
        });
  }

  Future<void> _onOpen(LinkableElement link) async {
    print('received: $link');
    if (await canLaunch(link.url)) {
      await launch(link.url);
    } else {
      throw 'Could not launch $link';
    }
  }
}
