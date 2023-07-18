import 'package:flutter/material.dart';
import 'package:recursive_tree_flutter/recursive_tree_flutter.dart';

import '../data/custom_node_type.dart';
import '../data/example_vts_department_data.dart';

class ExExpandableTreeScreen extends StatefulWidget {
  const ExExpandableTreeScreen({super.key});

  @override
  State<ExExpandableTreeScreen> createState() => _ExExpandableTreeScreenState();
}

class _ExExpandableTreeScreenState extends State<ExExpandableTreeScreen> {
  late TreeType<CustomNodeType> _tree;

  @override
  void initState() {
    _tree = sampleTree();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Example Expandable Tree")),
      body: ExpandableTreeWidget(_tree),
    );
  }
}
