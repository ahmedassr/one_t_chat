import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:one_t_chat/modules/login_screen/LoginScreen.dart';
import 'package:one_t_chat/network/local/CashHelper.dart';
import 'package:one_t_chat/shared/components/Components.dart';
import 'package:one_t_chat/shared/style/color.dart';
import 'package:one_t_chat/shared/style/text.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryColor,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 200),
            // Welcome Image
            const Image(
              image: AssetImage('assets/images/welcome.png'),
              fit: BoxFit.fill,
              width: double.infinity,
              height: 250,
            ),
            const SizedBox(height: 20),
            // Welcome Title
            CustomBoldText(
              title: 'Hi_____OneTChat',
              size: 34,
              fontWeight: FontWeight.w900,
              background: Colors.white,
            ),
            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.4),
                  boxShadow: [
                    BoxShadow(
                        color: myBlackColor.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(10, 7))
                  ],
                  borderRadius: const BorderRadius.all(Radius.circular(90)),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomBoldText(
                      title: 'Welcome to OneT Chat',
                      size: 24,
                      fontWeight: FontWeight.bold,
                      background: Colors.white,
                    ),
                    const SizedBox(height: 20),
                    // Welcome Text
                    CustomBoldText(
                      title: welcomeText.isNotEmpty
                          ? welcomeText
                          : 'Enjoy your experience!', // Handle empty welcomeText
                      size: 20,
                      background: Colors.white,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    // Get Started Button

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: defaultButton(
                        width: double.infinity,
                        background: Theme.of(context).primaryColor,
                        // Use theme color
                        radius: 20,
                        onPressed: () {
                          CashHelper.putValue(key: 'isNewUser?', value: false);
                          myNavigator(context, LoginScreen());
                        },
                        child: Text(
                          'Get Started'.toUpperCase(),
                          style: TextStyle(color: primaryColor, fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
