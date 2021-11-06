import 'package:mimicker/models/bridge_action.dart';
import 'package:mimicker/main.dart';

/**
 * Actions that can be executed on phone from python runner
 */
class BridgeActions {
  static call(BridgeAction action) {
    var inst = runner.instances[action.instanceId];
    var res =
        inst.evaluate("var __callback=" + action.action + ";__callback()");
    inst.evaluate("delete __callback");
  }
}
