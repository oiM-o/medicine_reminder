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
    return FractionallySizedBox(
      heightFactor: 0.94,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            width * 0.06, 12, width * 0.06,
            16 + MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
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
              SizedBox(
                height: 44,
                child: Stack(
                  children: [
                    Center(
                      child:Text(
                        '設定',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      top: 0,
                      bottom: 0,
                      child: IconButton(
                        tooltip: '閉じる',
                        splashRadius: 20,
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                  ],
                ),
              ),
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
                title: const Text('プライバシーポリシー'),
                onTap: () {
                  // TODO: プライバシーポリシー画面へ
                },
              ),
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text('利用規約'),
                onTap: () {
                  // TODO: 利用規約画面へ
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
      ),
    );
  }
}
