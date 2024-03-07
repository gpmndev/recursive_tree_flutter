import 'package:flutter/material.dart';
import 'package:recursive_tree_flutter/recursive_tree_flutter.dart';

import '../../models/custom_node_type.dart';
import '../../data/example_vts_department_data.dart';

class ExExpandableTreeScreen extends StatefulWidget {
  const ExExpandableTreeScreen({super.key});

  @override
  State<ExExpandableTreeScreen> createState() => _ExExpandableTreeScreenState();
}

class _ExExpandableTreeScreenState extends State<ExExpandableTreeScreen> {
  late TreeType<CustomNodeType> _tree;
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    _tree = sampleTree();
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(title: const Text("Example Expandable Tree")),
        body: Column(
          children: [
            Expanded(
              flex: 4,
              child: ExpandableTreeWidget(
                _tree,
                maxLines: 2,
              ),
            ),
            Expanded(
              flex: 1,
              child: TextFormField(
                controller: _textController,
                decoration: const InputDecoration(
                  hintText: "PRESS ENTER TO UPDATE",
                ),
                onFieldSubmitted: (value) {
                  updateTreeWithSearchingTitle(_tree, value);
                  setState(() {});
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
