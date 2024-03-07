import 'package:flutter/material.dart';
import 'package:recursive_tree_flutter/recursive_tree_flutter.dart';

import '../../data/example_vts_dms4_data.dart';
import '../../models/dms4_node_type.dart';

class ExVTSDms4TreeScreen extends StatefulWidget {
  const ExVTSDms4TreeScreen({super.key});

  @override
  State<ExVTSDms4TreeScreen> createState() => _ExVTSDms4TreeScreenState();
}

class _ExVTSDms4TreeScreenState extends State<ExVTSDms4TreeScreen> {
  late TreeType<Dms4NodeType> _tree;
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    _tree = sampleTreeDms4();
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
        appBar: AppBar(title: const Text("Example VTS DMS.4 Tree")),
        body: Column(
          children: [
            Expanded(
              flex: 4,
              child: SingleChildScrollView(
                child: _VTSNodeWidget(
                  _tree,
                  onNodeDataChanged: () => setState(() {}),
                ),
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

//? ____________________________________________________________________________

class _VTSNodeWidget extends StatefulWidget {
  const _VTSNodeWidget(
    this.tree, {
    required this.onNodeDataChanged,
  });

  final TreeType<Dms4NodeType> tree;

  /// IMPORTANT: Because this library **DOESN'T** use any state management
  /// library, therefore I need to use call back function like this - although
  /// it is more readable if using `Provider`.
  final VoidCallback onNodeDataChanged;

  @override
  State<_VTSNodeWidget> createState() => _VTSNodeWidgetState();
}

class _VTSNodeWidgetState<T extends AbsNodeType> extends State<_VTSNodeWidget>
    with SingleTickerProviderStateMixin, ExpandableTreeMixin<Dms4NodeType> {
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
    if (widget.tree.isRoot) return const SizedBox.shrink();

    return GestureDetector(
      onTap: () {
        updateTreeSingleChoiceDms4(tree, !tree.data.isChosen!);
        widget.onNodeDataChanged();
      },
      child: Row(
        children: [
          Expanded(child: buildTitle()),
          buildRotationIcon(),
        ],
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
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(5)),
        color: tree.data.isChosen == true
            ? Colors.pink.shade100
            : Colors.transparent,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            tree.data.title + (tree.isLeaf ? "" : " (${tree.children.length})"),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          buildCheckMark(),
        ],
      ),
    );
  }

  Widget buildCheckMark() {
    if (tree.data.isChosen == true) {
      return const Icon(Icons.check, color: Colors.green);
    } else {
      return const SizedBox.shrink();
    }
  }

  //* __________________________________________________________________________

  @override
  List<Widget> generateChildrenNodesWidget(List<TreeType<Dms4NodeType>> list) =>
      List.generate(
        list.length,
        (int index) => _VTSNodeWidget(
          list[index],
          onNodeDataChanged: widget.onNodeDataChanged,
        ),
      );

  @override
  void updateStateToggleExpansion() => setState(() => toggleExpansion());
}
