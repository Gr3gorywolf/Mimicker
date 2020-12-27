import 'package:mimicker/models/bridge_action.dart';
import 'package:mimicker/main.dart';

/**
 * Actions that can be executed on phone from python runner
 */
class BridgeActions {
  static call(BridgeAction action) {
    runner.instances
        .where((element) => element.starId == action.context)
        .first
        .call(action.function, action.args);
  }
}
