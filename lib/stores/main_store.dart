import 'package:flutter_store/flutter_store.dart';
import 'package:mimicker/constants/app.dart';
import 'package:mimicker/main.dart';
import 'package:mimicker/ui/watch_app/full_screen_alert.dart';
import 'dart:async';
import 'package:mimicker/ui/widgets/watch_content.dart';
import 'package:mimicker/utils/helpers.dart';

class MainStore extends Store {
  bool _isLoading = false;
  get isLoading => _isLoading;
  setLoading(bool val) {
    setState(() {
      _isLoading = val;
    });
    Future.delayed(Duration(seconds: 45)).then((value) => () {
          if (_isLoading) {
            setState(() {
              _isLoading = false;
            });
            var msg ="Some process is taking more time as expected. the loading was cancelled";
            if (APP_TARGET == "phone") {
              Helpers.showAlert(bldCtx, "Attention", msg,null,null);
            } else {
              FullScreenAlert.show(bldCtx, "Attention", msg, null, null);
            }
          }
        });
  }
}
