import 'package:flutter/material.dart';
import 'package:flutter_store/provider.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:mimicker_watch/stores/stores_manager.dart';

class WatchContent extends StatelessWidget {
  final List<Widget> children;
  final Widget title;
  final List<Widget> actions;
  final bool isLoading;
  WatchContent({this.children, this.title, this.actions, this.isLoading});
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size; 
    return Provider(
      store: StoresManager.mainStore,
      child: Builder(builder: (BuildContext ctx) {
          final _mainStore = StoresManager.useMainStore(ctx);
        return Scaffold(
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerTop,
            floatingActionButton: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: actions,
            ),
            body: LoadingOverlay(
              isLoading: _mainStore.isLoading,
              child: Container(
                height: screenSize.height,
                width: screenSize.width,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(30, 50, 30, 0),
                    child: SingleChildScrollView(
                        child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        title,
                        ...children,
                        Container(
                          margin: EdgeInsets.only(bottom: 30),
                        )
                      ],
                    )),
                  ),
                ),
              ),
            ));
      }),
    );
  }
}
