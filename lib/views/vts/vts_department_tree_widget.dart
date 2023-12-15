import 'package:flutter/material.dart';
import 'package:recursive_tree_flutter/recursive_tree_flutter.dart';

/// This widget displays the whole tree using [SingleChildScrollView]
class VTSDepartmentTreeWidget<T extends AbsNodeType> extends StatefulWidget {
  const VTSDepartmentTreeWidget(
    this.tree, {
    super.key,
    required this.buildLeadingWidget,
  });

  final TreeType<T> tree;
  final FunctionBuildLeadingWidget<T> buildLeadingWidget;

  @override
  State<VTSDepartmentTreeWidget<T>> createState() =>
      _VTSDepartmentTreeWidgetState<T>();
}

class _VTSDepartmentTreeWidgetState<T extends AbsNodeType>
    extends State<VTSDepartmentTreeWidget<T>> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: _VTSNodeWidget<T>(
        widget.tree,
        onNodeDataChanged: () => setState(() {}),
        buildLeadingWidget: widget.buildLeadingWidget,
      ),
    );
  }
}

//? ____________________________________________________________________________

class _VTSNodeWidget<T extends AbsNodeType> extends StatefulWidget {
  const _VTSNodeWidget(
    this.tree, {
    required this.onNodeDataChanged,
    required this.buildLeadingWidget,
  });

  final TreeType<T> tree;

  /// IMPORTANT: Because this library **DOESN'T** use any state management
  /// library, therefore I need to use call back function like this - although
  /// it is more readable if using `Provider`.
  final VoidCallback onNodeDataChanged;

  /// Each node has its own style of leading widget, root or inner node or leaf
  /// may have different UI.
  final FunctionBuildLeadingWidget<T> buildLeadingWidget;

  @override
  State<_VTSNodeWidget<T>> createState() => _VTSNodeWidgetState<T>();
}

class _VTSNodeWidgetState<T extends AbsNodeType>
    extends State<_VTSNodeWidget<T>>
    with SingleTickerProviderStateMixin, ExpandableTreeMixin<T> {
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
    return InkWell(
      onTap: widget.tree.data.isUnavailable ? null : updateStateToggleExpansion,
      child: Row(
        children: [
          widget.buildLeadingWidget(widget.tree, () => setState(() {})),
          //? Title
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6.0),
              child: Text(
                widget.tree.data.title +
                    (widget.tree.isLeaf
                        ? ""
                        : " (${widget.tree.children.length})"),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          //? Check box
          Checkbox(
            tristate: widget.tree.isLeaf ? false : true,
            side: widget.tree.data.isUnavailable
                ? const BorderSide(color: Colors.grey, width: 1.0)
                : BorderSide(color: Theme.of(context).primaryColor, width: 1.0),
            value: widget.tree.data.isUnavailable
                ? false
                : widget.tree.data.isChosen,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(4)),
            ),
            activeColor: widget.tree.data.isUnavailable
                ? Colors.grey
                : Theme.of(context).primaryColor,
            onChanged: widget.tree.data.isUnavailable
                ? null
                : (value) {
                    widget.tree.data.isChosen = value;
                    updateTreeMultipleChoice(widget.tree, value);
                    widget.onNodeDataChanged();
                  },
          ),
        ],
      ),
    );
  }

  //? __________________________________________________________________________

  @override
  List<Widget> generateChildrenNodesWidget(List<TreeType<T>> list) =>
      List.generate(
        list.length,
        (int index) => _VTSNodeWidget<T>(
          list[index],
          onNodeDataChanged: widget.onNodeDataChanged,
          buildLeadingWidget: widget.buildLeadingWidget,
        ),
      );

  @override
  void updateStateToggleExpansion() => setState(() => toggleExpansion());
}
