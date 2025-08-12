import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medicine_reminder/ui/components/capsule_pill_button.dart';
import 'package:medicine_reminder/ui/dialog/register_dialog.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _showRegisterDialog(BuildContext context) async {
    final choice = await registerDialog(context);
    if (choice == RegisterChoice.camera) {
      debugPrint("カメラを起動する処理");
    } else if (choice == RegisterChoice.manual) {
      debugPrint("手動入力画面へ遷移する処理");
    } else {
      debugPrint("キャンセルされた");
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

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
            onPressed: () {},
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

            // 薬リスト部分
            SizedBox(
              height: screenHeight * 0.4,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: ListView.separated(
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04, vertical: 8),
                        title: Text(
                          '薬 ${index + 1}',
                          style: TextStyle(fontSize: screenWidth * 0.04),
                        ),
                        subtitle: const Text('1日3回'),
                      );
                    },
                    separatorBuilder: (context, index) => Divider(
                      color: Colors.grey.shade300,
                      height: 1,
                    ),
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
