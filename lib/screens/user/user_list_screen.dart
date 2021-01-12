import 'package:app_github/screens/user/user_filter_screen.dart';
import 'package:app_github/widgets/custom_appbar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:app_github/models/user_model.dart';
import 'package:app_github/services/user_service.dart';
import 'package:app_github/widgets/custom_widgets.dart';

class UserListScreen extends StatefulWidget {
  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> with SingleTickerProviderStateMixin {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  RefreshController _refreshController;

  List<UserModel> users = [];
  UserModel userSearch = new UserModel();
  bool load = false;
  bool hasMore = true;
  bool isLoadingPage = false;
  int page = 0;

  @override
  void initState() {
    super.initState();

    _refreshController = RefreshController(initialRefresh: false);

    _list();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onLoading() async {
    if (users.length > 0 && hasMore) {
      setState(() {
        isLoadingPage = true;
        page++;
      });

      _list();
    } else {
      _refreshController.loadComplete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: appBarWithAction(context, 'Repositórios', actions: _actions()),
      body: SmartRefresher(
        primary: false,
        enablePullDown: false,
        enablePullUp: true,
        header: MaterialClassicHeader(),
        controller: _refreshController,
        onLoading: _onLoading,
        footer: CustomWidgets.customFooterRefresh(isLoadingPage),
        child: CustomScrollView(slivers: <Widget>[
          SliverList(
            delegate: SliverChildListDelegate([
              load
                  ? Container()
                  : Container(
                      margin: EdgeInsets.only(top: 80.0),
                      alignment: Alignment.center,
                      height: 50.0,
                      width: 50.0,
                      child: CircularProgressIndicator()),
              (users.length == 0 && load)
                  ? Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(top: 80.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Image.asset(
                            "assets/logo/octocat-1.png",
                            fit: BoxFit.cover,
                            height: 60,
                            width: 60,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Lista vazia!',
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ))
                  : _createList(context),
              Container(height: 30.0)
            ]),
          )
        ]),
      ),
    );
  }

  void _list() async {
    UserService.getAllUsers().then((value) {
      if (mounted)
        setState(() {
          load = true;
          isLoadingPage = false;

          for (var item in value) {
            if (users.length < 100) {
              users.add(item);
            }
          }

          if (value.length == 0) hasMore = false;
        });
    });
  }

  Widget _createList(context) {
    return ListView.separated(
      shrinkWrap: true,
      primary: false,
      padding: EdgeInsets.all(10.0),
      itemCount: users.length,
      separatorBuilder: (BuildContext context, int index) =>
          Divider(height: 5.0, color: Colors.grey),
      itemBuilder: (BuildContext context, int index) {
        var item = users[index];

        return AnimationConfiguration.staggeredList(
          position: index,
          duration: const Duration(milliseconds: 375),
          child: SlideAnimation(
            horizontalOffset: 50.0,
            child: FadeInAnimation(
              child: Card(
                child: ListTile(
                  contentPadding: EdgeInsets.all(0.0),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(25.0),
                    child: Container(
                      width: 50.0,
                      height: 50.0,
                      child: CachedNetworkImage(
                        fit: BoxFit.fill,
                        imageUrl: item.owner.avatarUrl != null
                            ? item.owner.avatarUrl
                            : Icon(Icons.person),
                      ),
                    ),
                  ),
                  title: item.name != null
                      ? Text(
                          item.owner.login,
                          style: TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.bold),
                        )
                      : Text(""),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      item.name != null
                          ? Text("repositório: " + item.name, style: TextStyle(fontSize: 18.0), overflow: TextOverflow.ellipsis)
                          : Text(""),
                      item.description != null
                          ? Text(
                              item.description,
                              style: TextStyle(fontSize: 18.0), overflow: TextOverflow.ellipsis
                            )
                          : Text(""),
                    ],
                  ),
                  onTap: () {
                    UserService.launchURL(item.htmlUrl);
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  List<Widget> _actions() {
    return [
      IconButton(
        padding: EdgeInsets.only(right: 10.0),
        icon: Icon(Icons.search, size: 40.0),
        onPressed: () async {
          var result = await Navigator.push(context, new MaterialPageRoute(
            builder: (BuildContext context) => new FilterUserPage(userSearch: userSearch),
            fullscreenDialog: true
          ));

          if(result != null){
            setState(() {
              userSearch = result;

              page = 0;
              load = false;
              users = [];
            });

            _list();
          }
        },
      ),
    ];
  }

}
