import 'package:flutter/material.dart';

import '../../widgets/custom_outlined_btn.dart';
import 'ex_vts_department_tree_screen.dart';
import 'ex_vts_dms4_tree_screen.dart';

class VTSScreen extends StatefulWidget {
  const VTSScreen({super.key});

  @override
  State<VTSScreen> createState() => _VTSScreenState();
}

class _VTSScreenState extends State<VTSScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("VTS Department Tree")),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomOutlinedButton(
              screen: ExVTSDeptTreeScreen(),
              title: "VTS Department Tree",
            ),
            SizedBox(height: 20),
            CustomOutlinedButton(
              screen: ExVTSDms4TreeScreen(),
              title: "VTS DMS.4 Tree",
            ),
          ],
        ),
      ),
    );
  }
}
