import 'package:flutter/material.dart';
import 'package:recursive_tree_flutter/recursive_tree_flutter.dart';

import '../../data/example_vn_regions_data.dart';
import '../../models/vn_region_node.dart';

class ExVNRegionsTree extends StatefulWidget {
  const ExVNRegionsTree({super.key});

  @override
  State<ExVNRegionsTree> createState() => _ExVNRegionsTreeState();
}

class _ExVNRegionsTreeState extends State<ExVNRegionsTree> {
  late TreeType<VNRegionNode> _tree;

  @override
  void initState() {
    _tree = sampleVNRegionNode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Vietnam regions tree")),
      body: SingleChildScrollView(
        child: _NodeWidget(
          _tree,
          onNodeDataChanged: () => setState(() {}),
        ),
      ),
    );
  }
}

//? ____________________________________________________________________________

class _NodeWidget extends StatefulWidget {
  const _NodeWidget(
    this.tree, {
    required this.onNodeDataChanged,
  });

  final TreeType<VNRegionNode> tree;

  /// IMPORTANT: Because this library **DOESN'T** use any state management
  /// library, therefore I need to use call back function like this - although
  /// it is more readable if using `Provider`.
  final VoidCallback onNodeDataChanged;

  @override
  State<_NodeWidget> createState() => _NodeWidgetState();
}

class _NodeWidgetState<T extends AbsNodeType> extends State<_NodeWidget>
    with SingleTickerProviderStateMixin, ExpandableTreeMixin<VNRegionNode> {
  final Tween<double> _turnsTween = Tween<double>(begin: -0.25, end: 0.0);

  @override
  initState() {
    super.initState();
    initTree();
    initRotationController();
    if (tree.data.isExpanded) {
      rotationController.forward();
    }
  }

  @override
  void initTree() {
    tree = widget.tree;
  }

  @override
  void initRotationController() {
    rotationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    super.disposeRotationController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => buildView();

  @override
  Widget buildNode() {
    if (!widget.tree.data.isShowedInSearching) return const SizedBox.shrink();

    Color colorByLevel;
    switch (widget.tree.data.level) {
      case VN_LEVEL:
        colorByLevel = Colors.red;
        break;
      case PROVINCE_LEVEL:
        colorByLevel = Colors.blue;
        break;
      case DISTRICT_LEVEL:
        colorByLevel = Colors.green;
        break;
      default:
        colorByLevel = Colors.pink;
    }

    return InkWell(
      onTap: updateStateToggleExpansion,
      child: Container(
        color: colorByLevel,
        child: Row(
          children: [
            buildRotationIcon(),
            Expanded(child: buildTitle()),
            buildTrailing(),
          ],
        ),
      ),
    );
  }

  //* __________________________________________________________________________

  Widget buildRotationIcon() {
    return RotationTransition(
      turns: _turnsTween.animate(rotationController),
      child: tree.isLeaf
          ? Container()
          : IconButton(
              iconSize: 16,
              icon: const Icon(Icons.expand_more, size: 16.0),
              onPressed: updateStateToggleExpansion,
            ),
    );
  }

  Widget buildTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0),
      child: Text(
        tree.data.title + (tree.isLeaf ? "" : " (${tree.children.length})"),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget buildTrailing() {
    if (tree.data.isUnavailable) {
      return const Icon(Icons.close_rounded, color: Colors.red);
    }

    if (tree.isLeaf) {
      return Checkbox(
        value: tree.data.isChosen!, // leaves always is true or false
        onChanged: (value) {
          updateTreeSingleChoice(tree, !tree.data.isChosen!);
          widget.onNodeDataChanged();
        },
      );
    }

    return const SizedBox.shrink();
  }

  //* __________________________________________________________________________

  @override
  List<Widget> generateChildrenNodesWidget(List<TreeType<VNRegionNode>> list) =>
      List.generate(
        list.length,
        (int index) => _NodeWidget(
          list[index],
          onNodeDataChanged: widget.onNodeDataChanged,
        ),
      );

  @override
  void updateStateToggleExpansion() => setState(() => toggleExpansion());
}
