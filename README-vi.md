<!-- Author: Nguyen Van Bien -->
<!-- Email: nvbien2000@gmail.com -->

# recursive_tree_flutter

<div align="center">

**Languages:**

[![English](https://img.shields.io/badge/Language-English-blueviolet?style=for-the-badge)](README.md)
[![Vietnamese](https://img.shields.io/badge/Language-Vietnamese-blueviolet?style=for-the-badge)](README-vi.md)
  
</div>

Thư viện `recursive_tree_flutter` giúp xây dựng một cấu trúc dữ liệu kiểu cây và trực quan hoá chúng dưới dạng cây kế thừa (stack view hoặc expandable tree view). Đa số các thư viện tree-view tập trung vào giao diện, nhưng `recursive_tree_flutter` sẽ tập trung vào cấu trúc dữ liệu cây nên sẽ có thể đáp ứng được nhiều kiểu UI đặc biệt hơn - đó chính là điểm mạnh của thư viện này. Chẳng hạn như khả năng update cây khi một node được chọn, trả về danh sách những node/lá được chọn, trả về danh sách những node được đánh dấu favorite...

## Mục lục

- [recursive\_tree\_flutter](#recursive_tree_flutter)
  - [Mục lục](#mục-lục)
  - [Ví dụ](#ví-dụ)
  - [Tính năng](#tính-năng)
  - [Nội dung](#nội-dung)
    - [Cấu trúc dữ liệu cây (Dart code)](#cấu-trúc-dữ-liệu-cây-dart-code)
    - [Hàm phụ trợ (Dart code)](#hàm-phụ-trợ-dart-code)
    - [Cây giao diện Flutter](#cây-giao-diện-flutter)
    - [Giải thích cách hoạt động của expandable tree bất kỳ dựa trên ExpandableTreeMixin](#giải-thích-cách-hoạt-động-của-expandable-tree-bất-kỳ-dựa-trên-expandabletreemixin)
  - [BSD-3-Clause License](#bsd-3-clause-license)

## Ví dụ
Tham khảo mục [Giải thích cách hoạt động của expandable tree bất kỳ dựa trên ExpandableTreeMixin](#giải-thích-cách-hoạt-động-của-expandable-tree-bất-kỳ-dựa-trên-expandabletreemixin).

```dart
import 'package:flutter/material.dart';
import 'package:recursive_tree_flutter/recursive_tree_flutter.dart';

import '../data/custom_node_type.dart';
import '../data/example_vts_department_data.dart';

class ExTreeSingleChoice extends StatefulWidget {
  const ExTreeSingleChoice({super.key});

  @override
  State<ExTreeSingleChoice> createState() => _ExTreeSingleChoiceState();
}

class _ExTreeSingleChoiceState extends State<ExTreeSingleChoice> {
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
        appBar: AppBar(
          title: const Text("Example Single Choice Expandable Tree"),
        ),
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

  final TreeType<CustomNodeType> tree;

  /// IMPORTANT: Because this library **DOESN'T** use any state management
  /// library, therefore I need to use call back function like this - although
  /// it is more readable if using `Provider`.
  final VoidCallback onNodeDataChanged;

  @override
  State<_VTSNodeWidget> createState() => _VTSNodeWidgetState();
}

class _VTSNodeWidgetState<T extends AbsNodeType> extends State<_VTSNodeWidget>
    with SingleTickerProviderStateMixin, ExpandableTreeMixin<CustomNodeType> {
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
    disposeRotationController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => buildView();

  @override
  Widget buildNode() {
    if (!widget.tree.data.isShowedInSearching) return const SizedBox.shrink();

    return InkWell(
      onTap: updateStateToggleExpansion,
      child: Row(
        children: [
          buildRotationIcon(),
          Expanded(child: buildTitle()),
          buildTrailing(),
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
  List<Widget> generateChildrenNodesWidget(
          List<TreeType<CustomNodeType>> list) =>
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
```

Kết quả: 

<img src="https://github.com/gpmndev/recursive_tree_flutter/raw/main/readme_files/ex_tree_single_choice.gif" alt="Demo 5" width="200"/>

## Tính năng

Một số tính năng mà thư viện này cung cấp:

- Tạo một cấu trúc dữ liệu kiểu cây (Dart code).
- Nhiều function thao tác trên cây, ví dụ như find node, search with text, update cây multiple choice/single choice...
- Cho phép mở rộng cây trong run-time (lazy-loading).
- Có thể sử dụng riêng cấu trúc dữ liệu cây tách biệt hoàn toàn với Flutter UI.
- Trực quan hoá cấu trúc cây bằng Flutter.
- Cho phép tuỳ chỉnh giao diện Flutter để phù hợp với nhu cầu sử dụng.

## Nội dung

### Cấu trúc dữ liệu cây (Dart code)

Được lấy ý tưởng từ cấu trúc của một cây thư mục trong máy tính, ta sẽ có 2 loại: thư mục và tệp. Một thư mục có thể chứa nhiều tệp và thư mục khác, và tệp là cấp độ bé nhất không thể chứa thêm gì nữa.

Tương tự cấu trúc cây thư mục trong máy tính, `recursive_tree_flutter` sẽ xây dựng một cấu trúc dữ liệu cây bao gồm inner node và leaf node.

- [AbsNodeType](lib/models/abstract_node_type.dart): Class trừu tượng cho kiểu dữ liệu của một node. Một node có thể là inner node và leaf node. Class này có các thuộc tính sau:
	- `id`: _required_, dynamic.
    - `title`: _required_, String.
    - `isInner`:  boolean, mặc định là **true**.
    - `isUnavailable`:  boolean, mặc định là **false**.
    - `isChosen`: nullable boolean, mặc định là **false**.
    - `isExpanded`: boolean, mặc định là **false**.
    - `isFavorite`: boolean, mặc định là **false**.
    - `isShowedInSearching`: boolean, mặc định là **true**. Còn được gọi là `isDisplayable`, được sử dụng nếu cây giao diện có chức năng search.
    + `clone()`: abstract method, `T extends AbsNodeType`. Cho phép clone object.
- [TreeType<T extends AbsNodeType>](lib/models/tree_type.dart): Cấu trúc dữ liệu cây.
	- `T` là Implement Class của [AbsNodeType](lib/models/abstract_node_type.dart).
    - `data`: _required_, `T`.
    - `children`: _required_, `List<TreeType<T>>`.
    - `parent`: _required_, `TreeType<T>?`. Nếu `parent == null`, tức là ta đang ở root của toàn bộ cây.
    - `isChildrenLoadedLazily`: boolean, mặc định là **false**. Chỉ được sử dụng nếu cây hiện tại là lazy-loading, cho biết liệu children đã được load lần nào hay chưa.
    - `isLeaf`: Cây hiện tại đang ở node lá?
    - `isRoot`: Cây hiện tại đang ở node root?
    - `clone(tree, parent)`: static method. Cho phép clone một cây.

### Hàm phụ trợ (Dart code)

- [tree_traversal_functions.dart](lib/functions/tree_traversal_functions.dart): Chứa các hàm liên quan đến duyệt cây:

    - [EChosenAllValues](lib/functions/tree_traversal_functions.dart#L9): Là kiểu `enum`, phục vụ cho các thao tác chọn/huỷ chọn trên cây, bao gồm 4 giá trị: `chosenAll`, `unchosenAll`, `chosenSome` & `notChosenable`.
    - [isChosenAll(tree)](lib/functions/tree_traversal_functions.dart#L15): Kiểm tra xem liệu các con của cây hiện tại có chọn hết, hoặc là không chọn cái nào cả, hoặc là chỉ một số được chọn, hoặc là không khả dụng.
    - [findRoot(tree)](lib/functions/tree_traversal_functions.dart#L93): Tìm gốc.
    - [findTreeWithId(tree, id)](lib/functions/tree_traversal_functions.dart#L98): Tìm cây với id dược cho.
    - [searchAllTreesWithTitleDFS(tree, text, result)](lib/functions/tree_traversal_functions.dart#L113): Tìm tất cả các cây nếu title data của root chứa searching text, dùng thuật toán DFS. Kết quả trả về được lưu trong biến `result`.
    - [searchLeavesWithTitleDFS(tree, text, result)](lib/functions/tree_traversal_functions.dart#L125): Tìm tất cả các lá nếu title data của lá chứa searching text, dùng thuật toán DFS. Kết quả trả về được lưu trong biến `result`.
    - [returnChosenLeaves(tree, result)](lib/functions/tree_traversal_functions.dart#L139): Tìm tất cả các lá được chọn. Kết quả trả về được lưu trong biến `result`.
    - [returnChosenNodes(tree, result)](lib/functions/tree_traversal_functions.dart#L153): Tìm tất cả các node được chọn. Kết quả trả về được lưu trong biến `result`.
    - [returnFavoriteNodes(tree, result)](lib/functions/tree_traversal_functions.dart#L164): Tìm tất cả các node được đưa vào danh sách yêu thích. Kết quả trả về được lưu trong biến `result`.
    - [findRightmostOfABranch(tree)](lib/functions/tree_traversal_functions.dart#L181): (***NOT important***) Tìm node **rightmost** của nhánh cây hiện tại (cây có level hiện tại trừ 1). Hàm này được sử dụng trong VTS Department Tree, dùng để xác định xem node nào nằm ở dưới cùng trong nhánh, thì leading widget của nó sẽ hơi khác biết.

- [tree_update_functions.dart](lib/functions/tree_update_functions.dart): Chứa các hàm liên quan đến cập nhập cây:

    - [updateAllUnavailableNodes(tree)](lib/functions/tree_update_functions.dart#L22): Cập nhập các giá trị `isUnavailable` của các node trong cây hiện tại. Giả sử khi ta parse data lần đầu tiên, một số lá sẽ unavailable và ta sẽ cần phải cập nhập luôn các inner node bị ảnh hưởng. Hàm trả về `true` nếu cây khả dụng (choosenable), ngược lại `false`.
    - [checkAll(tree)](lib/functions/tree_update_functions.dart#L39): Check all.
    - [uncheckALl(tree)](lib/functions/tree_update_functions.dart#L51): Uncheck all.
    - [updateTreeMultipleChoice(tree, chosenValue, isUpdatingParentRecursion)](lib/functions/tree_update_functions.dart#L68): Cập nhập cây (multiple choice) khi một node nào đó được tick.
    - [updateTreeSingleChoice(tree, chosenValue)](lib/functions/tree_update_functions.dart#L131): Cập nhập cây (single choice) khi một lá nào đó được tick.
    - [updateTreeWithSearchingTitle(tree, searchingText, willBlurParent, willAllExpanded)](lib/functions/tree_update_functions.dart#L160): Update trường `isShowedInSearching` của các node khi áp dụng chức năng search.

### Cây giao diện Flutter

<!-- ***[TreeViewProperties](lib/utils/tree_view_properties.dart): Các thuộc tính được dùng chung cho các kiểu cây giao diện.*** -->

[StackWidget](lib/views/stack_widget.dart): Cây giao diện được xây dựng theo kiểu stack. Multiple choice, data được parse 1 lần duy nhất:

<img src="https://github.com/gpmndev/recursive_tree_flutter/raw/main/readme_files/stack_widget.gif" alt="Demo 1" width="200"/>


[StackWidget](lib/views/lazy_stack_widget.dart): Cây giao diện được xây dựng theo kiểu stack lazy-loading. Multiple choice, data được parse run-time:

<img src="https://github.com/gpmndev/recursive_tree_flutter/raw/main/readme_files/lazy_stack_widget.gif" alt="Demo 2" width="200"/>

[ExpandableTreeWidget](lib/views/expandable_tree_widget.dart): Cây giao diện được xây dựng theo kiểu expandable, data được parse 1 lần duy nhất:

<img src="https://github.com/gpmndev/recursive_tree_flutter/raw/main/readme_files/expandable_tree_widget.gif" alt="Demo 3" width="200"/>

[VTSDepartmentTreeWidget](lib/views/vts/vts_department_tree_widget.dart): Một cây giao diện khác được xây dựng theo kiểu expandable, data được parse 1 lần duy nhất:

<img src="https://github.com/gpmndev/recursive_tree_flutter/raw/main/readme_files/vts_department_tree_widget.gif" alt="Demo 4" width="200"/>

[SingleChoiceTreeWidget](example/lib/screens/expandable_single_choice/ex_tree_single_choice.dart): Một cây giao diện khác được xây dựng theo kiểu expandable, data được parse 1 lần duy nhất, single choice:

<img src="https://github.com/gpmndev/recursive_tree_flutter/raw/main/readme_files/ex_tree_single_choice.gif" alt="Demo 5" width="200"/>

[LazySingleChoiceTreeWidget](example/lib/screens/expandable_single_choice/ex_lazy_tree_single_choice.dart): Một cây giao diện khác được xây dựng theo kiểu expandable, data được parse run-time, single choice:

<img src="https://github.com/gpmndev/recursive_tree_flutter/raw/main/readme_files/ex_lazy_tree_single_choice.gif" alt="Demo 6" width="200"/>

[ExVNRegions](example/lib/screens/expandable_single_choice/ex_vietnam_regions.dart): Cây khu vực Việt Nam (tỉnh, huyện, xã):

<img src="https://github.com/gpmndev/recursive_tree_flutter/raw/main/readme_files/vn_regions_tree.gif" alt="Demo 7" width="200"/>

[ExVTSDms4TreeScreen](example/lib/screens/vts/ex_vts_dms4_tree_screen.dart): Cây đơn vị của Viettel VTS miền Nam DMS.4:

<img src="https://github.com/gpmndev/recursive_tree_flutter/raw/main/readme_files/vts_dm4_tree.gif" alt="Demo 8" width="200"/>

### Giải thích cách hoạt động của expandable tree bất kỳ dựa trên [ExpandableTreeMixin](lib/views/expandable_tree_mixin.dart)

Một cây giao diện expandable sẽ có cấu trúc như sau:
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
Ta có thể thấy, `NodeWidget` là `StatefulWidget` được xây dựng theo kiểu đệ quy và được bọc ngoài bởi `SingleChildScrollView` cung cấp cho cây khả năng scroll. Việc cập nhập cây (data) sẽ dẫn tới thay đổi trạng thái/UI của `NodeWidget` - có thể sử dụng `setState` hoặc `Provider` để quản lý. `NodeWidget` sẽ kế thừa [ExpandableTreeMixin](lib/views/expandable_tree_mixin.dart) (xem ví dụ ở [VTSDepartmentTreeWidget](lib/views/vts/vts_department_tree_widget.dart) dùng `setState`) với một số hàm như:
  - `initTree()`: Khởi tạo cây (data) (gọi trong `initState()`).
  - `initRotationController()`: Khởi tạo biến `rotationController` dùng để tạo hiệu ứng khi mở rộng cây UI (gọi trong `initState()`).
  - `disposeRotationController()`.
  - `buildView()`: Build giao diện của cây (đã được viết sẵn).
  - `buildNode()`: Build giao diện của một node (phải implement). Hàm này sẽ cho phép developer thoải mái custom giao diện một cách "KHÔNG THỂ TIN NỔI", trải nghiệm "KHÔNG GIỚI HẠN", nói chung là "CHẤT" :))))
  - `buildChildrenNodes()`: Build những node con với hiệu ứng animation mở rộng (đã được viết sẵn).
  - `generateChildrenNodesWidget()`: Trả về `List<NodeWidget>`, phải implement (ví dụ được ghi sẵn ở function doc).
  - `toggleExpansion()`: Xác định việc thu vào/thả ra của những node con.
  - `updateStateToggleExpansion()`: Update state sau khi thực hiện hành động thu vào/thả ra.

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

> **_NOTE:_**  Hoàng Sa, Trường Sa là của Việt Nam.
