import 'package:flutter/widgets.dart';
import 'package:flutter_store/flutter_store.dart';
import 'package:mimicker_watch/stores/main_store.dart';

class StoresManager {
  static final mainStore = MainStore();
  static MainStore useMainStore(BuildContext ctx) {
    return Provider.of<MainStore>(ctx);
  }
}
