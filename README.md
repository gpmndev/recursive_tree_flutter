<!-- Author: Nguyen Van Bien -->
<!-- Email: nvbien2000@gmail.com -->

# recursive_tree_flutter

<div align="center">

**Languages:**

[![English](https://img.shields.io/badge/Language-English-blueviolet?style=for-the-badge)](README.md)
[![Vietnamese](https://img.shields.io/badge/Language-Vietnamese-blueviolet?style=for-the-badge)](README-vi.md)
  
</div>

The `recursive_tree_flutter` library helps build a tree data structure and visualizes it as an inheritance tree (stack view or expandable tree view). While most tree-view libraries focus on the interface, `recursive_tree_flutter` prioritizes the tree data structure, allowing it to support various special UI styles - that's the strength of this library. For example, it can update the tree when a node is selected.

## Mục lục

- [recursive\_tree\_flutter](#recursive_tree_flutter)
  - [Mục lục](#mục-lục)
  - [Features](#features)
  - [Contents](#contents)
    - [Tree Data Structure (Dart code)](#tree-data-structure-dart-code)
    - [Helper Functions (Dart code)](#helper-functions-dart-code)
    - [Flutter UI Tree](#flutter-ui-tree)
    - [Explaining the working of the Expandable Tree based on ExpandableTreeMixin](#explaining-the-working-of-the-expandable-tree-based-on-expandabletreemixin)
  - [BSD-3-Clause License](#bsd-3-clause-license)

## Features

Some features provided by this library include:

- Building a tree data structure (Dart code).
- Various functions for tree operations, such as finding nodes, searching with text, updating multiple choice/single choice trees, etc.
- Allows lazy-loading to expand the tree at runtime.
- The tree data structure can be used independently from the Flutter UI.
- Visualizes the tree structure using Flutter.
- Allows customization of the Flutter UI to suit specific requirements.

## Contents

### Tree Data Structure (Dart code)

Inspired by the structure of a directory tree on a computer, there are two types of nodes: directories and files. A directory can contain multiple files and other directories, and a file is the smallest level that cannot contain anything else.

Similarly to the directory tree structure on a computer, `recursive_tree_flutter` will build a tree data structure that includes inner nodes and leaf nodes.

- [AbsNodeType](lib/models/abstract_node_type.dart): An abstract class representing the data type of a node. A node can be either an inner node or a leaf node. This class has the following properties:
	- `id`: _required_, dynamic.
    - `title`: _required_, String.
    - `isInner`:  boolean, default is **true**.
    - `isUnavailable`:  boolean, default is **false**.
    - `isChosen`: nullable boolean, default is **false**.
    - `isExpanded`: boolean, default is **false**.
    - `isFavorite`: boolean, default is **false**.
    - `isShowedInSearching`: boolean, default is **true**. Also known as `isDisplayable`, được sử dụng used when the UI tree has a search function.
    + `clone()`: abstract method, `T extends AbsNodeType`. Allows cloning the object.
- [TreeType<T extends AbsNodeType>](lib/models/tree_type.dart): The tree data structure.
	- `T` is the Implement Class of [AbsNodeType](lib/models/abstract_node_type.dart).
    - `data`: _required_, `T`.
    - `children`: _required_, `List<TreeType<T>>`.
    - `parent`: _required_, `TreeType<T>?`. If `parent == null`, it means we are at the root of the entire tree.
    - `isChildrenLoadedLazily`: boolean, default is **false**. Only used if the current tree is lazy-loading, indicating whether the children have been loaded before or not.
    - `isLeaf`: Is current tree at a leaf node?
    - `isRoot`:  Is current tree at the root node?
    - `clone(tree, parent)`: static method. Allows cloning a tree.

### Helper Functions (Dart code)

- [tree_traversal_functions.dart](lib/functions/tree_traversal_functions.dart): Contains functions related to tree traversal:

    - [EChosenAllValues](lib/functions/tree_traversal_functions.dart#L9): An `enum` type for choosing/deselecting nodes in the tree, including 4 values: `chosenAll`, `unchosenAll`, `chosenSome` & `notChosenable`.
    - [isChosenAll(tree)](lib/functions/tree_traversal_functions.dart#L15): Checks if all the children of the current tree are chosen, unchosen, partially chosen, or not selectable.
    - [findRoot(tree)](lib/functions/tree_traversal_functions.dart#L93).
    - [findTreeWithId(tree, id)](lib/functions/tree_traversal_functions.dart#L98).
    - [searchAllTreesWithTitleDFS(tree, text, result)](lib/functions/tree_traversal_functions.dart#L113): Tìm tất cả các cây nếu title data của root chứa searching text, dùng thuật toán DFS. Kết quả trả về được lưu trong biến `result`.
    - [searchLeavesWithTitleDFS(tree, text, result)](lib/functions/tree_traversal_functions.dart#L125): Searches for all trees whose root title data contains the searching text using the DFS algorithm. The results are stored in the `result` variable.
    - [returnChosenLeaves(tree, result)](lib/functions/tree_traversal_functions.dart#L139): Searches for all leaves whose title data contains the searching text using the DFS algorithm. The results are stored in the `result` variable.
    - [returnChosenNodes(tree, result)](lib/functions/tree_traversal_functions.dart#L153): Returns all chosen leaves. The results are stored in the `result` variable.
    - [returnFavoriteNodes(tree, result)](lib/functions/tree_traversal_functions.dart#L164): Returns all nodes that have been added to the favorite list. The results are stored in the `result` variable.
    - [findRightmostOfABranch(tree)](lib/functions/tree_traversal_functions.dart#L181): (***Not important***) Finds the *rightmost* node of the current tree branch (a tree with a current level minus 1). This function is used in the VTS Department Tree to determine which node is at the bottom of the branch, so its leading widget will be slightly different.
- [tree_update_functions.dart](lib/functions/tree_update_functions.dart): Contains functions related to updating the tree:

    - [updateAllUnavailableNodes(tree)](lib/functions/tree_update_functions.dart#L22): Updates the `isUnavailable` property of all nodes in the current tree. Suppose when parsing data for the first time, some leaves will be unavailable, and we need to update the affected inner nodes. The function returns `true` if the tree is available (chosenable), otherwise `false`.
    - [checkAll(tree)](lib/functions/tree_update_functions.dart#L39): Check all.
    - [uncheckALl(tree)](lib/functions/tree_update_functions.dart#L51): Uncheck all.
    - [updateTreeMultipleChoice(tree, chosenValue, isUpdatingParentRecursion)](lib/functions/tree_update_functions.dart#L68): Updates the multiple choice tree when a node is ticked.
    - [updateTreeSingleChoice(tree, chosenValue)](lib/functions/tree_update_functions.dart#L131): Updates the single choice tree when a leaf is ticked.
    - [updateTreeWithSearchingTitle(tree, searchingText)](lib/functions/tree_update_functions.dart#L160): Updates the `isShowedInSearching` field of the nodes when applying the search function.

### Flutter UI Tree

<!-- ***[TreeViewProperties](lib/utils/tree_view_properties.dart): Common properties used for various types of Flutter UI trees.*** -->

[StackWidget](lib/views/stack_widget.dart): The UI tree is built using the stack approach. Multiple choice, data is parsed only once:

<img src="https://github.com/gpmndev/recursive_tree_flutter/blob/main/readme_files/stack_widget.gif" alt="Demo 1" width="200"/>


[StackWidget](lib/views/lazy_stack_widget.dart): The UI tree is built using the lazy-loading stack approach. Multiple choice, data is parsed at runtime:

<img src="https://github.com/gpmndev/recursive_tree_flutter/blob/main/readme_files/lazy_stack_widget.gif" alt="Demo 2" width="200"/>

[ExpandableTreeWidget](lib/views/expandable_tree_widget.dart): The UI tree is built using the expandable approach, and data is parsed only once:

<img src="https://github.com/gpmndev/recursive_tree_flutter/blob/main/readme_files/expandable_tree_widget.gif" alt="Demo 3" width="200"/>

[VTSDepartmentTreeWidget](lib/views/vts/vts_department_tree_widget.dart): Another UI tree built using the expandable approach, and data is parsed only once:

<img src="https://github.com/gpmndev/recursive_tree_flutter/blob/main/readme_files/vts_department_tree_widget.gif" alt="Demo 4" width="200"/>

[SingleChoiceTreeWidget](example/lib/screens/ex_tree_single_choice.dart): Another UI tree built using the expandable approach, and data is parsed only once, single choice:

<img src="https://github.com/gpmndev/recursive_tree_flutter/blob/main/readme_files/ex_tree_single_choice.gif" alt="Demo 5" width="200"/>

[LazySingleChoiceTreeWidget](example/lib/screens/ex_lazy_tree_single_choice.dart): Another UI tree built using the expandable approach, data is parsed at runtime, single choice:

<img src="https://github.com/gpmndev/recursive_tree_flutter/blob/main/readme_files/ex_lazy_tree_single_choice.gif" alt="Demo 6" width="200"/>

### Explaining the working of the Expandable Tree based on [ExpandableTreeMixin](lib/views/expandable_tree_mixin.dart)

An expandable UI tree has the following structure:

```dart
SingleChildScrollView( // tree is scrollable
  - NodeWidget (root)
    -- NodeWidget
      +++ NodeWidget
      +++ NodeWidget
      +++ NodeWidget
    -- NodeWidget
      +++ NodeWidget
    ...
)
```
We can see that `NodeWidget` is a `StatefulWidget` built recursively and wrapped by `SingleChildScrollView` to provide scrolling capability to the tree. Updating the tree (data) will change the state/UI of the `NodeWidget` - this can be done using setState or Provider for management. `NodeWidget` will inherit [ExpandableTreeMixin](lib/views/expandable_tree_mixin.dart) (as shown in the example [VTSDepartmentTreeWidget](lib/views/vts/vts_department_tree_widget.dart) using `setState`) with some functions like:

  - `initTree()`: Initializes the tree (data) (called in `initState()`).
  - `initRotationController()`: Initializes the `rotationController` variable used to create an animation effect when expanding the UI tree (called in `initState()`).
  - `disposeRotationController()`.
  - `buildView()`: Builds the UI of the tree (already written).
  - `buildNode()`: Builds the UI of a node (must be implemented). This function allows developers to freely customize the UI in unlimited ways.
  - `buildChildrenNodes()`: Builds the child nodes with animation for expansion (already written).
  - `generateChildrenNodesWidget()`: Returns `List<NodeWidget>,` must be implemented (an example is provided in the function documentation).
  - `toggleExpansion()`: Determines whether to collapse/expand the child nodes.
  - `updateStateToggleExpansion()`: Updates the state after performing the collapse/expand action.

## BSD-3-Clause License
```
Copyright (c) 2023, Viettel Solutions

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution.

3. Neither the name of the copyright holder nor the names of its
   contributors may be used to endorse or promote products derived from
   this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
```
