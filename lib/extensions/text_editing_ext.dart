import 'package:flutter/material.dart';

/// editing text 扩展函数
extension TextEditingControllerExt on TextEditingController {
  /// 输入赋值， 并光标置于末尾
  void input(String data) {
    if (text.isNotEmpty) {
      clear();
    }
    selection = selection;
    String newText;
    TextSelection newSelection;

    if (selection.isValid) {
      final start = selection.start;
      newText = text.replaceRange(start, selection.end, data);
      newSelection = TextSelection.collapsed(offset: start + data.length);
    } else {
      newText = text + data;
      newSelection = TextSelection.collapsed(offset: newText.length);
    }

    value = value.copyWith(
      text: newText,
      selection: newSelection,
    );
  }

  void deleteSelection(TextSelection selection) {
    if (!selection.isValid) return;

    int start, end;
    if (selection.start <= 0) {
      return;
    } else if (selection.isCollapsed) {
      start = selection.end - 1;
      end = selection.end;
    } else if (selection.isNormalized) {
      start = selection.start;
      end = selection.end;
    } else {
      start = selection.end;
      end = selection.start;
    }

    deleteRange(start, end);
  }

  void deleteRange(int start, int end) {
    final newText = text.replaceRange(start, end, '');
    value = newText.isEmpty
        ? TextEditingValue.empty
        : TextEditingValue(
            text: newText,
            selection: TextSelection.collapsed(offset: start),
          );
  }

  void backspace() {
    if (text.isEmpty) return;

    final selection = this.selection;
    if (selection.isValid) {
      deleteSelection(selection);
    } else {
      final start = text.length - 1;
      final end = text.length;
      deleteRange(start, end);
    }
  }
}
