// ignore_for_file: depend_on_referenced_packages, use_build_context_synchronously

import 'package:bazar_books_design/widgets/texts/texts.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';

class BazUiWidgetbook extends StatelessWidget {
  const BazUiWidgetbook({
    required this.child,
    super.key,
    required this.copyCode,
    this.backgroundColor = Colors.white,
    this.sizeHeight,
    this.sizeWith,
    this.boxShadow,
  });

  final Widget child;
  final String copyCode;
  final Color? backgroundColor;
  final double? sizeHeight;
  final double? sizeWith;
  final List<BoxShadow>? boxShadow;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Scaffold(
        bottomNavigationBar: ExpansionBody(code: copyCode),
        body: Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: backgroundColor,
            boxShadow: boxShadow ??
                [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.shadow,
                    blurRadius: 2,
                    offset: const Offset(1, 1), // Shadow position
                  ),
                ],
            borderRadius: BorderRadius.circular(20),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: sizeHeight,
                  width: sizeWith,
                  child: child,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ExpansionBody extends StatefulWidget {
  const ExpansionBody({
    super.key,
    this.onCopy,
    required this.code,
  });

  final Function(Widget)? onCopy;
  final String code;

  @override
  State<ExpansionBody> createState() => _ExpansionBodyState();
}

class _ExpansionBodyState extends State<ExpansionBody> {
  bool _customTileExpanded = false;
  final ExpansionTileController controller = ExpansionTileController();

  @override
  Widget build(BuildContext context) {
    final copycode = BazUiBodyText1(
      text: widget.code,
    );
    return SingleChildScrollView(
      child: ExpansionTile(
        controller: controller,
        onExpansionChanged: (bool expanded) {
          setState(() {
            _customTileExpanded = expanded;
          });
        },
        trailing: Wrap(
          spacing: 10,
          children: [
            IconButton(
              onPressed: () {
                if (controller.isExpanded) {
                  controller.collapse();
                } else {
                  controller.expand();
                }
              },
              icon: Icon(
                _customTileExpanded ? Icons.expand_more : Icons.expand_less,
              ),
            ),
            IconButton(
              onPressed: () async {
                await FlutterClipboard.copy(copycode.text).then(
                  (value) {
                    return ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Text Copied'),
                      ),
                    );
                  },
                );
              },
              icon: const Icon(
                Icons.content_copy,
              ),
            ),
          ],
        ),
        title: BazUiBodyText1(
          text: '',
          color: Theme.of(context).colorScheme.surface,
        ),
        // subtitle: const Text('Custom expansion arrow icon'),
        children: [
          ListTile(
            title: copycode,
          ),
        ],
      ),
    );
  }
}
