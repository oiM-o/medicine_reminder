import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medicine_reminder/ui/components/capsule_pill_button.dart';
import 'package:medicine_reminder/ui/dialog/register_dialog.dart';
import 'package:medicine_reminder/ui/screen/register_screen.dart';
import 'package:medicine_reminder/ui/screen/setting_sheet.dart';

import '../../data/app_database.dart';
import '../../data/models/medicine.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Medicine>> _futureMeds;

  @override
  void initState() {
    super.initState();
    _futureMeds = AppDatabase.instance.getAllMedicines();
  }

  //TODO: 登録直後に必ず画面リロードが走るようにしたい
  Future<void> _reload() async {
    setState(() {
      _futureMeds = AppDatabase.instance.getAllMedicines();
    });
  }

  Future<void> _showRegisterDialog(BuildContext context) async {
    final choice = await registerDialog(context);
    if (choice == RegisterChoice.camera) {
      debugPrint("カメラを起動する処理");
    } else if (choice == RegisterChoice.manual) {
      final saved = await Navigator.push<bool>(
        context,
        MaterialPageRoute(builder: (_) => const RegisterScreen()),
      );
      if (saved == true) {
        await Future.delayed(Duration(milliseconds: 700));
        _reload();
      }
    } else {
      debugPrint("キャンセルされた");
    }
  }

  String _formatYmd(DateTime dt) {
    return '${dt.year}/${dt.month.toString().padLeft(2, '0')}/${dt.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final blue = Color(0xFF94CBFF);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: SvgPicture.asset(
              'assets/icons/home_question.svg',
              width: screenWidth * 0.07,
              height: screenWidth * 0.07,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: SvgPicture.asset(
              'assets/icons/home_settings.svg',
              width: screenWidth * 0.07,
              height: screenWidth * 0.07,
            ),
            onPressed: () => showSettingsSheet(context),
          ),
          SizedBox(width: screenWidth * 0.04,)
        ],
      ),

      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: screenHeight * 0.25,
              child: Card(
                color: Color(0xFFA3EAD0),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'すべて服薬済み',
                        style: TextStyle(
                          fontSize: screenWidth * 0.08,
                          fontWeight: FontWeight.w900,
                          color: Colors.white
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.04),
                      Image.asset(
                        'assets/images/medicine_red.png',
                        width: screenWidth * 0.30,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(height: screenHeight * 0.02),

            SizedBox(
              height: screenHeight * 0.12,
              child: CapsulePillButton(
                label: 'おくすり登録',
                onTap: () {
                  _showRegisterDialog(context);
                },
              ),
            ),

            SizedBox(height: screenHeight * 0.02),

            SizedBox(
              height: screenHeight * 0.4,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                      color: blue,
                      width: 2,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        color: blue,
                        padding: EdgeInsets.symmetric(
                          vertical: screenHeight * 0.006,
                        ),
                        child: Center(
                          child: Text(
                            '登録済みのおくすり',
                            style: TextStyle(
                              fontSize: screenWidth * 0.04,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    Divider(color: blue, height: 1),
                    Expanded(
                      child: FutureBuilder<List<Medicine>>(
                        future: _futureMeds,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          }
                          if (snapshot.hasError) {
                            return Center(
                              child: Text('読み込みに失敗しました: ${snapshot.error}'),
                            );
                          }
                          final meds = snapshot.data ?? [];
                          if (meds.isEmpty) {
                            return Center(
                              child: Text(
                                '登録されたおくすりはありません',
                                style: TextStyle(
                                  fontSize: screenWidth * 0.04,
                                  color: Colors.black54,
                                ),
                              ),
                            );
                          }

                          return RefreshIndicator(
                            onRefresh: _reload,
                            child: ListView.separated(
                              physics: const AlwaysScrollableScrollPhysics(),
                              itemCount: meds.length,
                              itemBuilder: (context, index) {
                                final m = meds[index];
                                return ListTile(
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: screenWidth * 0.04,
                                    vertical: screenHeight * 0.001,
                                  ),
                                  title: Text(
                                    m.name,
                                    style: TextStyle(fontSize: screenWidth * 0.042),
                                  ),
                                  // humanReadableDose を使うと見やすい
                                  subtitle: Text(
                                    m.humanReadableDose,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  // 例：右端に作成日など
                                  trailing: Text(
                                    _formatYmd(m.createdAt),
                                    style: TextStyle(fontSize: screenWidth * 0.032),
                                  ),
                                  onTap: () {
                                    // TODO: 詳細表示/編集へ遷移したい場合ここに実装
                                  },
                                );
                              },
                              separatorBuilder: (context, index) => Divider(
                                color: Colors.grey.shade300,
                                height: 1,
                              ),
                            ),
                          );
                        },
                      ),

                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


