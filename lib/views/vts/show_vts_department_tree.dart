import 'package:flutter/material.dart';
import 'package:recursive_tree_flutter/recursive_tree_flutter.dart';

void showVTSDepartmentTreeBottomSheet<T extends AbsNodeType>({
  required BuildContext context,
  double? height,
  double sheetBorderRadius = 24,

  /// Space from main view (department tree) to the top of bottom sheet
  double spaceTopPositionedMainView = 24,
  Widget? titleLeadingWidget,
  Widget? titleTrailingWidget,
  required String sheetTitle,
  TextStyle? sheetTitleStyle,
  required Widget loadingWidget,
  required Widget emptyPage,
  required Widget errorPage,
  Widget handleBar = const SizedBox.shrink(),

  /// if future returns null -> no data exist
  required Future<TreeType<T>?> funcParseDataToTree,
  Function(TreeType<T> tree)? funcWhenComplete,
  required FunctionBuildLeadingWidget<T> buildLeadingWidgetNode,
}) {
  double screenHeight = MediaQuery.sizeOf(context).height;
  double statusBarHeight = MediaQuery.paddingOf(context).top;
  late TreeType<T> tree;

  showModalBottomSheet(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(sheetBorderRadius),
        topLeft: Radius.circular(sheetBorderRadius),
      ),
    ),

    //? builder ________________________________________________________________
    builder: (ctx) => SizedBox(
      height: height ?? (screenHeight - statusBarHeight),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //* Handle Bar
          handleBar,
          //* main view ________________________________________________________
          Expanded(
            child: Column(
              children: [
                //? title ______________________________________________________
                ListTile(
                  leading: titleLeadingWidget,
                  trailing: titleTrailingWidget,
                  title: Text(
                    sheetTitle,
                    textAlign: TextAlign.center,
                    style: sheetTitleStyle,
                  ),
                ),
                const SizedBox(height: 10),
                //? tree view __________________________________________________
                Expanded(
                  child: FutureBuilder<TreeType<T>?>(
                    future: funcParseDataToTree,
                    builder: (_, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return loadingWidget;
                      } else if (snapshot.hasError) {
                        return errorPage;
                      } else {
                        // Data has been fetched successfully
                        if (snapshot.data == null) {
                          return emptyPage;
                        } else {
                          tree = snapshot.data!;
                          return VTSDepartmentTreeWidget(
                            tree,
                            buildLeadingWidget: buildLeadingWidgetNode,
                          );
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  ).whenComplete(() {
    if (funcWhenComplete != null) funcWhenComplete(tree);
  });
}
