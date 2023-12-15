import 'package:flutter/material.dart';
import 'package:recursive_tree_flutter/recursive_tree_flutter.dart';

import '../../models/custom_node_type.dart';
import '../../data/example_lazy_stack_data.dart';

/// data was parsed in run-time
class ExLazyStackScreen extends StatefulWidget {
  const ExLazyStackScreen({super.key});

  @override
  State<ExLazyStackScreen> createState() => _ExLazyStackScreenState();
}

class _ExLazyStackScreenState extends State<ExLazyStackScreen> {
  List<TreeType<CustomNodeType>> listTrees = [];
  final String searchingText = "3";

  @override
  void initState() {
    listTrees = [createRoot()];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Lazy Stack Tree (multiple choice)")),
      body: Column(
        children: [
          const SizedBox(height: 30),
          const Text(
            "Stack tree widget was built for fun :)",
            style: TextStyle(color: Colors.red),
          ),
          const Divider(
            thickness: 2,
            height: 60,
          ),
          Expanded(
            child: LazyStackWidget(
              properties: TreeViewProperties<CustomNodeType>(
                title: "THIS IS TITLE",
              ),
              listTrees: listTrees,
              getNewAddedTreeChildren: getNewAddedTreeChildren,
            ),
          ),
          const Divider(
            thickness: 2,
            height: 60,
          ),
          OutlinedButton(
            onPressed: () {
              List<TreeType<CustomNodeType>> result = [];
              var root = findRoot(listTrees[0]);
              returnChosenNodes(root, result);
              String resultTxt = "";
              for (var e in result) {
                resultTxt += "\n${e.data.title}";
              }
              if (resultTxt.isEmpty) resultTxt = "\nnone";

              var snackBar = SnackBar(content: Text(resultTxt));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            },
            child: const Text("Which nodes were chosen? (not full data)"),
          ),
          OutlinedButton(
            onPressed: () {
              List<TreeType<CustomNodeType>> result = [];
              var root = findRoot(listTrees[0]);
              searchAllTreesWithTitleDFS(root, searchingText, result);
              String resultTxt = "";
              for (var e in result) {
                resultTxt += "${e.data.title}\n";
              }
              if (resultTxt.isEmpty) resultTxt = "none";

              var snackBar = SnackBar(content: Text(resultTxt));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            },
            child: Text(
                "Which nodes contain text='$searchingText'? (not full data)"),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  List<TreeType<CustomNodeType>> getNewAddedTreeChildren(
      TreeType<CustomNodeType> parent) {
    List<TreeType<CustomNodeType>> newChildren;
    String parentTitle = parent.data.title;

    if (parentTitle.contains("0")) {
      newChildren = createChildrenOfRoot();
    } else if (parentTitle.contains("1.1")) {
      newChildren = createChildrenOfLv1_1();
    } else if (parentTitle.contains("2.1")) {
      newChildren = createChildrenOfLv2_1();
    } else if (parentTitle.contains("2.2")) {
      newChildren = createChildrenOfLv2_2();
    } else {
      newChildren = [];
    }

    for (var newChild in newChildren) {
      newChild.parent = parent;
    }

    return newChildren;
  }
}
