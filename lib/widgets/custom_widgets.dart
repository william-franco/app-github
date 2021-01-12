import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class CustomWidgets {
  static Widget customFooterRefresh(bool isLoadingPage) {
    return CustomFooter(
      height: isLoadingPage ? 55.0 : 0.0,
      builder: (BuildContext context, LoadStatus mode) {
        if (mode == LoadStatus.loading)
          return Container(
            child: CircularProgressIndicator(),
            height: 15,
            width: 15,
          );
        else
          return Container(
            height: 0.0,
          );
      },
    );
  }

  static BoxDecoration decorationCircular() {
    return BoxDecoration(
      color: Colors.grey[200],
      borderRadius: BorderRadius.circular(10.0),
    );
  }

  static Widget getInputLabel(textLabel) {
    return Container(
      margin: EdgeInsets.only(left: 15.0, bottom: 5.0, top: 15.0),
      child: Text(
        textLabel,
        style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
      ),
    );
  }
}
