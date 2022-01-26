import 'package:mimicker/main.dart';
import 'package:mimicker_core/models/bridge_action.dart';

/**
 * Actions that can be executed on phone from js runner
 */
class BridgeActions {
  static call(BridgeAction action) {
    var inst = runner.instances[action.instanceId];
    var res =
        inst?.evaluate("var __callback=" + action.action + ";__callback()");
    inst?.evaluate("delete __callback");
  }
}
