import 'package:flutter/material.dart';
/// 画面半分サイズのエリア
class HalfScreenArea extends StatelessWidget {
  final Widget child;
  const HalfScreenArea({super.key, required this.child});
  @override
  Widget build(BuildContext context) {
    // デバイスの高さを取得して設定
    final double deviceHeight = MediaQuery.of(context).size.height;
    return Expanded(
      flex: 1,
      child: SizedBox(
        height: deviceHeight,
        child: child,
      ),
    );
  }
}