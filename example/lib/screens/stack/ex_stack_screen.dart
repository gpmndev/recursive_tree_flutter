import 'package:flutter/material.dart';
import 'package:recursive_tree_flutter/recursive_tree_flutter.dart';

import '../../models/custom_node_type.dart';
import '../../data/example_stack_data.dart';

/// data was parsed 1 time
class ExStackScreen extends StatefulWidget {
  const ExStackScreen({super.key});

  @override
  State<ExStackScreen> createState() => _ExStackScreenState();
}

class _ExStackScreenState extends State<ExStackScreen> {
  List<TreeType<CustomNodeType>> listTrees = [];
  final String searchingText = "3";

  @override
  void initState() {
    listTrees = sampleTree();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Stack Tree (multiple choice)")),
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
            child: StackWidget(
              properties: TreeViewProperties<CustomNodeType>(
                title: "THIS IS TITLE",
              ),
              listTrees: listTrees,
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
              returnChosenLeaves(root, result);
              String resultTxt = "";
              for (var e in result) {
                resultTxt += "${e.data.title}\n";
              }
              if (resultTxt.isEmpty) resultTxt = "none";

              var snackBar = SnackBar(content: Text(resultTxt));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            },
            child: const Text("Which leaves were chosen?"),
          ),
          OutlinedButton(
            onPressed: () {
              List<TreeType<CustomNodeType>> result = [];
              var root = listTrees[0].parent!;
              searchAllTreesWithTitleDFS(root, searchingText, result);
              String resultTxt = "";
              for (var e in result) {
                resultTxt += "${e.data.title}\n";
              }
              if (resultTxt.isEmpty) resultTxt = "none";

              var snackBar = SnackBar(content: Text(resultTxt));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            },
            child: Text("Which nodes contain text='$searchingText'?"),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
