import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'models/social_post.dart';
import 'theme.dart';
import 'utilities.dart';

class SocialIntro extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return CuliTopImage(
      imageName: "assets/images/social_feature.png",
      contents: [
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Alone together",
              style: Theme.of(context).textTheme.headline2,
              textAlign: TextAlign.center,
            )),
        Container(
          height: 0.3 * size.height,
        ),
        CuliButton(
          "Explore",
          height: 75,
          width: 0.8 * size.width,
          onPressed: () => Utils.changeScreens(
              context: context, nextWidget: () => SocialScreen(), squash: true),
        ),
      ],
    );
  }
}

class SocialScreen extends StatefulWidget {
  @override
  _SocialScreenState createState() => _SocialScreenState();
}

class _SocialScreenState extends State<SocialScreen>
    with AutomaticKeepAliveClientMixin {
  final List<Tab> tabs = <Tab>[
    Tab(text: "Crew"),
    Tab(text: "Explore"),
  ];

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return DefaultTabController(
      length: tabs.length,
      child: Builder(
        builder: (context) {
          final tabController = DefaultTabController.of(context);
          tabController.addListener(() {
            if (!tabController.indexIsChanging) {}
          });
          return Scaffold(
            appBar: AppBar(
              title: Text("Culi Community",
                  style: Theme.of(context).textTheme.headline3),
              centerTitle: true,
              bottom: TabBar(
                tabs: tabs,
                indicatorColor: Culi.coral,
                labelStyle: Theme.of(context)
                    .textTheme
                    .headline3
                    .copyWith(color: Culi.coral),
                labelColor: Culi.coral,
                unselectedLabelStyle: Theme.of(context).textTheme.headline3,
                unselectedLabelColor: Colors.black,
              ),
            ),
            body: TabBarView(
              children: tabs.map((tab) {
                return Center(
                  child: RefreshIndicator(
                    onRefresh: () async {},
                    child: ListView.builder(
                      dragStartBehavior: DragStartBehavior.start,
                      cacheExtent: 5,
                      itemCount: 10,
                      itemBuilder: (context, count) => Post(tab.text == "Crew"
                          ? PostData.defaultPost1
                          : PostData.defaultPost2),
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class Post extends StatelessWidget {
  final PostData data;

  const Post(this.data, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
        width: size.width,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Row(children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Culi.accentCoral),
                  child: Container(
                    height: 24,
                    width: 24,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/images/pan.png'))),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  alignment: Alignment.topCenter,
                  child: Text(data.author.toLowerCase(),
                      style: Theme.of(context)
                          .textTheme
                          .headline4
                          .copyWith(fontWeight: FontWeight.bold)),
                )
              ]),
            ),
            CachedNetworkImage(
              imageUrl: data.imageUrl,
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  Container(
                      height: (4.0 / 3) * size.width,
                      width: size.width,
                      padding: EdgeInsets.symmetric(
                          vertical: (4.0 / 3) * size.width * 0.425,
                          horizontal: size.width * 0.425),
                      child: CircularProgressIndicator(
                          value: downloadProgress.progress)),
              errorWidget: (context, url, error) => Icon(Icons.error),
              fit: BoxFit.fitWidth,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RichText(
                  text: TextSpan(
                      text: data.author.toLowerCase(),
                      style: Theme.of(context).textTheme.headline4.copyWith(
                          color: Culi.black, fontWeight: FontWeight.bold),
                      children: <TextSpan>[
                    TextSpan(
                      text: " ${data.caption}",
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .copyWith(color: Culi.black),
                    )
                  ])),
            )
          ],
        ));
  }
}
