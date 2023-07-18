import 'package:flutter/material.dart';
import 'package:recursive_tree_flutter/recursive_tree_flutter.dart';

/// This widget displays the whole tree using [SingleChildScrollView]
class ExpandableTreeWidget<T extends AbsNodeType> extends StatefulWidget {
  const ExpandableTreeWidget(this.tree, {super.key});

  final TreeType<T> tree;

  @override
  State<ExpandableTreeWidget<T>> createState() =>
      _ExpandableTreeWidgetState<T>();
}

class _ExpandableTreeWidgetState<T extends AbsNodeType>
    extends State<ExpandableTreeWidget<T>> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: _VTSNodeWidget<T>(
        widget.tree,
        onNodeDataChanged: () => setState(() {}),
      ),
    );
  }
}

//? ____________________________________________________________________________

class _VTSNodeWidget<T extends AbsNodeType> extends StatefulWidget {
  const _VTSNodeWidget(
    this.tree, {
    super.key,
    required this.onNodeDataChanged,
  });

  final TreeType<T> tree;

  /// IMPORTANT: Because this library **DOESN'T** use any state management
  /// library, therefore I need to use call back function like this.
  final VoidCallback onNodeDataChanged;

  @override
  State<_VTSNodeWidget> createState() => _VTSNodeWidgetState<T>();
}

class _VTSNodeWidgetState<T extends AbsNodeType>
    extends State<_VTSNodeWidget<T>> with SingleTickerProviderStateMixin {
  late AnimationController _rotationController;
  final Tween<double> _turnsTween = Tween<double>(begin: -0.25, end: 0.0);

  @override
  initState() {
    super.initState();

    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    if (widget.tree.data.isExpanded) {
      _rotationController.forward();
    }
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.tree.data.isShowedInSearching) return const SizedBox.shrink();

    return Column(
      children: [
        //* Main content of node widget
        InkWell(
          onTap: _toggleExpansion,
          child: Row(
            children: [
              //? Rotation icon
              RotationTransition(
                turns: _turnsTween.animate(_rotationController),
                child: widget.tree.isLeaf
                    ? Container()
                    : IconButton(
                        iconSize: 16,
                        icon: const Icon(Icons.expand_more, size: 16.0),
                        onPressed: _toggleExpansion,
                      ),
              ),
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
                    : BorderSide(
                        color: Theme.of(context).primaryColor, width: 1.0),
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
                        setState(() {
                          updateTreeMultipleChoice(widget.tree, value);
                          widget.onNodeDataChanged();
                        });
                      },
              ),
            ],
          ),
        ),
        //* Generate children nodes widget
        SizeTransition(
          sizeFactor: _rotationController,
          child: Padding(
            padding: const EdgeInsets.only(left: 24),
            child: Column(
                children: _generateChildrenNodesWidget(widget.tree.children)),
          ),
        ),
      ],
    );
  }

  List<_VTSNodeWidget> _generateChildrenNodesWidget(List<TreeType<T>> list) =>
      List.generate(
        list.length,
        (int index) => _VTSNodeWidget(
          list[index],
          onNodeDataChanged: widget.onNodeDataChanged,
        ),
      );

  void _toggleExpansion() => setState(() {
        widget.tree.data.isExpanded = !widget.tree.data.isExpanded;
        widget.tree.data.isExpanded
            ? _rotationController.forward()
            : _rotationController.reverse();
      });
}
