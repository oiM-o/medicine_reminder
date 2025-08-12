import 'package:flutter/material.dart';

Future<void> showSettingsSheet(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) => const _SettingsSheet(),
  );
}

class _SettingsSheet extends StatelessWidget {
  const _SettingsSheet();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          width * 0.06, 12, width * 0.06,
          16 + MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40, height: 4,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Text(
              '設定',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Divider(height: 1),

            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text('通知設定'),
              subtitle: const Text('リマインダーのオン/オフ'),
              trailing: Switch(
                value: true,
                onChanged: (v) {
                  // TODO: 通知の有効/無効を保存
                },
              ),
            ),
            ListTile(
              leading: const Icon(Icons.color_lens),
              title: const Text('テーマ変更'),
              onTap: () {
                // TODO: テーマ選択ダイアログへ
              },
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('アプリ情報'),
              onTap: () {
                // TODO: About画面へ
              },
            ),
          ],
        ),
      ),
    );
  }
}
