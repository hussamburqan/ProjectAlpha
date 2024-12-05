import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:projectalpha/Controller/authcontroller.dart';

class Settingpage extends StatelessWidget {
  Settingpage({super.key});
  final authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Column(
      children: [
        SizedBox(height: screenSize.height * 0.1),

        _mySectionHeader('عام', screenSize),

        _mySettingRow(screenSize,'إعدادات الحساب','assets/key.svg',
                () {

            }
        ),

        _myDivider(screenSize),

        _mySettingRow(screenSize,'الإشعارات','assets/notification.svg',
                () {

        }
        ),

        SizedBox(height: screenSize.height * 0.02),

        _mySectionHeader('تخصيص', screenSize),

        _mySettingRow(screenSize,'الثيم','assets/layer 2.svg',
                () {
                  Get.dialog(ThemeDialog());
        }
        ),

        _myDivider(screenSize),

        _mySettingRow(screenSize,'اللغة','assets/trans.svg',
                () {
                  Get.dialog(LanguageDialog());
        }
        ),

        SizedBox(height: screenSize.height * 0.02),

        _mySectionHeader('اخرى', screenSize),

        _mySettingRow(screenSize,'حول البرنامج','assets/Help.svg',
                () {

        }
        ),

        _myDivider(screenSize),

        _mySettingRow(screenSize,'تواصل معنا','assets/library.svg',
                () {

        }
        ),
        
        SizedBox(height: screenSize.height * 0.08),

        ElevatedButton(
          onPressed: () {
            authController.logout();

          },
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(
              vertical: screenSize.height * 0.02,
              horizontal: screenSize.width * 0.3,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(
              color: Colors.red,
              width: 2,
            ),
            ),
            backgroundColor: Color(-789517),
            elevation: 5,
          ),
          child: Text(
            'تسجيل الخروج',
            style: TextStyle(
              fontSize: screenSize.height * 0.025,
              color: Colors.red,
            ),
          ),
        ),
      ],
    );
  }

  Widget _mySectionHeader(String title, Size screenSize) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.1),
      child: Align(
        alignment: Alignment.centerRight,
        child: Text(
          title,
          style: TextStyle(fontSize: screenSize.height * 0.02),
        ),
      ),
    );
  }

  Widget _mySettingRow(Size screenSize,String title,String image,var fun) {
    return GestureDetector(
      onTap: fun,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.only(left: screenSize.width * 0.1, right: screenSize.width * 0.02),
            child: const Icon(Icons.arrow_back_ios),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                title,
                style: TextStyle(fontSize: screenSize.height * 0.025),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: screenSize.width * 0.1, left: screenSize.width * 0.02),
            child: SvgPicture.asset(
              image,
            ),
          ),
        ],
      ),
    );
  }

  Widget _myDivider(Size screenSize) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.1),
      child: const Divider(thickness: 1),
    );
  }



}
class ThemeDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'اختر المظهر',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ListTile(
              leading: Icon(Icons.light_mode),
              title: Text('فاتح'),
              onTap: () {
                Get.back();
              },
            ),
            ListTile(
              leading: Icon(Icons.dark_mode),
              title: Text('داكن'),
              onTap: () {
                Get.back();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class LanguageDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'اختر اللغة',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ListTile(
              leading: Text('🇸🇦'),
              title: Text('العربية'),
              onTap: () {
                Get.updateLocale(Locale('ar'));
                Get.back();
              },
            ),
            ListTile(
              leading: Text('🇺🇸'),
              title: Text('English'),
              onTap: () {
                Get.updateLocale(Locale('en'));
                Get.back();
              },
            ),
          ],
        ),
      ),
    );
  }
}