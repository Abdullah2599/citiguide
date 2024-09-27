import 'package:CityNavigator/Theme/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Privacypolicy extends StatelessWidget {
  const Privacypolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorTheme.primaryColor,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Get.back();
          },
        ),
        title: const Text(
          'Privacy Policy',
          style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            ExpansionTile(
              textColor: Colors.black,
              collapsedIconColor: ColorTheme.primaryColor,
              title: const Text('1. Introduction'),
              subtitle: Text('Overview of our commitment to privacy.', style: TextStyle(color: Colors.grey)),
              children: <Widget>[
                ListTile(
                  title: Text(
                    'Welcome to City Navigator! We value your privacy and are committed to protecting your personal information. This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use our application.',
                    style: TextStyle(fontSize: 14, color: Colors.black),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            ExpansionTile(
              textColor: Colors.black,
              collapsedIconColor:  ColorTheme.primaryColor,
              title: const Text('2. Information We Collect'),
              subtitle: Text('Types of information collected.', style: TextStyle(color: Colors.grey)),
              children: <Widget>[
                ListTile(
                  title: Text(
                    '- Personal Information: We may collect personal information, such as your name, email address, and location data.\n'
                    '- Usage Data: We collect information about your interactions with the app.',
                    style: TextStyle(fontSize: 14, color: Colors.black),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            ExpansionTile(
              textColor: Colors.black,
              collapsedIconColor:  ColorTheme.primaryColor,
              title: const Text('3. How We Use Your Information'),
              subtitle: Text('Ways we utilize your information.', style: TextStyle(color: Colors.grey)),
              children: <Widget>[
                ListTile(
                  title: Text(
                    'We may use the information we collect for various purposes, including:\n'
                    '- To provide and maintain our app\n'
                    '- To notify you about changes\n'
                    '- To provide customer support\n'
                    '- To gather analysis for improvement',
                    style: TextStyle(fontSize: 14, color: Colors.black),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            ExpansionTile(
              textColor: Colors.black,
              collapsedIconColor:  ColorTheme.primaryColor,
              title: const Text('4. Disclosure of Your Information'),
              subtitle: Text('Conditions under which we may share your information.', style: TextStyle(color: Colors.grey)),
              children: <Widget>[
                ListTile(
                  title: Text(
                    'We may share your information in the following situations:\n'
                    '- With Service Providers: To monitor and analyze the app’s usage.\n'
                    '- For Legal Reasons: If required by law or public authorities.',
                    style: TextStyle(fontSize: 14, color: Colors.black),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            ExpansionTile(
              textColor: Colors.black,
              collapsedIconColor:  ColorTheme.primaryColor,
              title: const Text('5. Security of Your Information'),
              subtitle: Text('Measures we take to protect your data.', style: TextStyle(color: Colors.grey)),
              children: <Widget>[
                ListTile(
                  title: Text(
                    'While we strive to use commercially acceptable means to protect your personal information, we cannot guarantee its absolute security.',
                    style: TextStyle(fontSize: 14, color: Colors.black),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            ExpansionTile(
              textColor: Colors.black,
              collapsedIconColor:  ColorTheme.primaryColor,
              title: const Text('6. Changes to This Privacy Policy'),
              subtitle: Text('How we will notify you of changes.', style: TextStyle(color: Colors.grey)),
              children: <Widget>[
                ListTile(
                  title: Text(
                    'We may update our Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page.',
                    style: TextStyle(fontSize: 14, color: Colors.black),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ExpansionTile(
              textColor: Colors.black,
              collapsedIconColor:  ColorTheme.primaryColor,
              title: const Text('Terms and Conditions'),
              subtitle: Text('Overview of user agreements.', style: TextStyle(color: Colors.grey)),
              children: <Widget>[
                ListTile(
                  title: Text(
                    'By accessing or using the City Navigator application, you agree to be bound by these Terms and Conditions.',
                    style: TextStyle(fontSize: 14, color: Colors.black),
                  ),
                ),
                ListTile(
                  title: Text(
                    'Use of the Application: You may use the application only for lawful purposes.',
                    style: TextStyle(fontSize: 14, color: Colors.black),
                  ),
                ),
                ListTile(
                  title: Text(
                    'Limitation of Liability: In no event shall City Navigator be liable for any indirect, incidental, special, consequential damages.',
                    style: TextStyle(fontSize: 14, color: Colors.black),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
