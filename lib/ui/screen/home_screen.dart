import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medicine_reminder/ui/components/capsule_pill_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
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
                color: Colors.green.shade100,
                child: Center(
                  child: Text(
                    '現在、すべての薬を服薬済',
                    style: TextStyle(fontSize: screenWidth * 0.05),
                  ),
                ),
              ),
            ),

            SizedBox(height: screenHeight * 0.02),

            SizedBox(
              height: screenHeight * 0.08,
              child: CapsulePillButton(
                label: 'おくすり登録',
                onTap: () {
                  // TODO: 登録画面へ遷移
                },
              ),
            ),

            SizedBox(height: screenHeight * 0.02),

            Expanded(
              child: ListView.builder(
                itemCount: 5, // 仮のデータ件数
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text(
                        '薬 ${index + 1}',
                        style: TextStyle(fontSize: screenWidth * 0.04),
                      ),
                      subtitle: const Text('1日3回'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
