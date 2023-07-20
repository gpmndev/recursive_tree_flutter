import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:recursive_tree_flutter/recursive_tree_flutter.dart';

import '../../data/custom_node_type.dart';
import '../../data/example_vts_department_data.dart';
import '../helper/empty_page.dart';
import '../helper/error_page.dart';
import 'widgets/dash_line.dart';
import 'widgets/default_widgets.dart';

class ExVTSDeptTreeScreen extends StatefulWidget {
  const ExVTSDeptTreeScreen({super.key});

  @override
  State<ExVTSDeptTreeScreen> createState() => _ExVTSDeptTreeScreenState();
}

class _ExVTSDeptTreeScreenState extends State<ExVTSDeptTreeScreen> {
  Future<TreeType<CustomNodeType>?> funcParseDataToTree = Future.delayed(
    const Duration(seconds: 2),
    () => sampleTree(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Example VTS Department Tree")),
      body: Center(
        child: OutlinedButton(
          onPressed: () => showVTSDepartmentTreeBottomSheet<CustomNodeType>(
            context: context,
            sheetTitle: "BRUH BRUH LMAO LMAO",
            sheetTitleStyle: kDefaultSheetTitleStyle,
            titleLeadingWidget: const DefaultLeadingWidget(),
            titleTrailingWidget: const DefaultTrailingWidget("Add"),
            loadingWidget: const DefaultLoadingWidget(),
            emptyPage: const EmptyPage(),
            errorPage: const ErrorPage(),
            handleBar: const DefaultHandleBar(),
            funcParseDataToTree: funcParseDataToTree,
            funcWhenComplete: funcWhenComplete,
            buildLeadingWidgetNode: _buildLeadingWidgetNode,
          ),
          child: const Text("Press me"),
        ),
      ),
    );
  }

  void funcWhenComplete(TreeType<CustomNodeType> tree) {
    List<TreeType<CustomNodeType>> result = [];
    returnChosenLeaves(tree, result);
    String resultTxt = "WHICH LEAVES ARE CHOSEN?";
    for (var e in result) {
      resultTxt += "\n${e.data.title}";
    }
    if (result.isEmpty) resultTxt += "\nnone";

    resultTxt += "\n\nWHICH LEAVES ARE IN FAVORITE LIST?";
    result.clear();
    returnFavoriteNodes(tree, result);
    for (var e in result) {
      resultTxt += "\n${e.data.title}";
    }
    if (result.isEmpty) resultTxt += "\nnone";

    var snackBar = SnackBar(content: Text(resultTxt));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  //? __________________________________________________________________________

  Widget _buildLeadingWidgetNode(
      TreeType<CustomNodeType> tree, VoidCallback setStateCallback) {
    if (tree.isRoot) {
      return _buildLeadingRoot(tree);
    } else if (tree.isLeaf) {
      return _buildLeadingLeafWithFavoriteIcon(tree, setStateCallback);
    } else {
      return _buildLeadingInnerNode(tree);
    }
  }

  Widget _buildLeadingRoot(TreeType<CustomNodeType> tree) {
    return Row(
      children: [
        const SizedBox(width: 20),
        tree.data.isExpanded
            ? Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AnimatedRotation(
                    turns: tree.data.isExpanded ? 0.25 : 0,
                    duration: const Duration(milliseconds: 300),
                    child:
                        SvgPicture.asset("assets/img/icon_expansion_tile.svg"),
                  ),
                  CustomPaint(
                    painter: BottomDashedLinePainterWhenClicked(),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.025,
                      width: MediaQuery.of(context).size.width * 0.02,
                    ),
                  ),
                ],
              )
            : AnimatedRotation(
                turns: tree.data.isExpanded ? 0.25 : 0,
                duration: const Duration(milliseconds: 300),
                child: SvgPicture.asset("assets/img/icon_expansion_tile.svg"),
              ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildLeadingInnerNode(TreeType<CustomNodeType> tree) {
    if (tree.data.isExpanded) {
      return SizedBox(
        width: 40,
        height: 50,
        child: Row(
          children: [
            CustomPaint(
              painter: TopDashedLinePainterWhenClicked(),
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width * 0.05,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                AnimatedRotation(
                  turns: tree.data.isExpanded ? 0.25 : 0,
                  duration: const Duration(milliseconds: 300),
                  child: SvgPicture.asset("assets/img/icon_expansion_tile.svg"),
                ),
                CustomPaint(
                  painter: BottomDashedLinePainterWhenClicked(),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.025,
                    width: MediaQuery.of(context).size.width * 0.02,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    } else {
      return SizedBox(
        width: 30,
        height: 50,
        child: Row(
          children: [
            CustomPaint(
              painter: tree.data.toString() ==
                      findRightmostOfABranch(tree).data.toString()
                  ? TopDashedLinePainterWhenClicked()
                  : DashedLinePainter(),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.05,
                height: MediaQuery.of(context).size.height * 0.08,
              ),
            ),
            AnimatedRotation(
              turns: tree.data.isExpanded ? 0.25 : 0,
              duration: const Duration(milliseconds: 300),
              child: SvgPicture.asset("assets/img/icon_expansion_tile.svg"),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildLeadingLeafWithFavoriteIcon(
      TreeType<CustomNodeType> tree, VoidCallback setStateCallback) {
    return Row(
      children: [
        SizedBox(
          height: 70.0,
          width: 35.0,
          child: Row(
            children: [
              CustomPaint(
                painter: tree.data.toString() ==
                        findRightmostOfABranch(tree).data.toString()
                    ? TopDashedLinePainterWhenClicked()
                    : DashedLinePainter(),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.04,
                  height: MediaQuery.of(context).size.height * 0.08,
                ),
              ),
              SvgPicture.asset("assets/img/icon_expansion_tile.svg"),
            ],
          ),
        ),
        const SizedBox(width: 8),
        //? no display favorite icon if current tree is a inner node
        InkWell(
          onTap: () {
            tree.data.isFavorite = !tree.data.isFavorite;
            setStateCallback();
          },
          child: SizedBox(
            width: 25,
            height: 25,
            child: tree.data.isFavorite
                ? SvgPicture.asset("assets/img/ic_filled_heart.svg")
                : SvgPicture.asset("assets/img/ic_heart.svg"),
          ),
        ),
      ],
    );
  }
}
