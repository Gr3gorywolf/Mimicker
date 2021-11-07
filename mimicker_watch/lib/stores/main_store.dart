import 'package:flutter_store/flutter_store.dart';
import 'package:mimicker_watch/main.dart';
import 'dart:async';

import 'package:mimicker_watch/ui/widgets/full_screen_alert.dart';

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
            
              FullScreenAlert.show(bldCtx, "Attention", msg, null, null);
          }
        });
  }
}
