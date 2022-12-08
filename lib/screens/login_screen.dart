import 'package:flutter/material.dart';
import 'package:scholarship_flutter_application/resources/auth_methods.dart';
import 'package:scholarship_flutter_application/screens/feed_screen.dart';

import 'package:scholarship_flutter_application/screens/signup_screen.dart';
import 'package:scholarship_flutter_application/utils/colors.dart';

import 'package:scholarship_flutter_application/utils/utils.dart';
import 'package:scholarship_flutter_application/widgets/text_feild_input.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Loginscreen extends StatefulWidget {
  const Loginscreen({Key? key}) : super(key: key);

  @override
  _LoginscreenState createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {
  final TextEditingController _emailconroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();
  bool _isloading = false;

  @override
  void dispose() {
    super.dispose();
    _emailconroller.dispose();
    _passwordcontroller.dispose();
  }

  void navigatetosignup() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const Signupscreen()));
  }

  void loginuser() async {
    setState(() {
      _isloading = true;
    });
    String res = await auth_methods().loginuser(
        email: _emailconroller.text, password: _passwordcontroller.text);
    if (res == 'Success') {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => FeedScreen()));
    } else {
      showsnackbar(res, context);
    }
    setState(() {
      _isloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              child: Container(),
              flex: 1,
            ),
            Expanded(
              flex: 3,
              child: Image.asset(
                'assests/logos.png',
                fit: BoxFit.cover,
                height: 200,
                width: 200,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            textfeildinput(
              hinttext: 'Emailaddress',
              textInputType: TextInputType.emailAddress,
              textEditingController: _emailconroller,
            ),
            const SizedBox(
              height: 24,
            ),
            textfeildinput(
              hinttext: 'Password',
              textInputType: TextInputType.text,
              textEditingController: _passwordcontroller,
              ispass: true,
            ),
            const SizedBox(
              height: 24,
            ),
            InkWell(
              onTap: loginuser,
              child: Container(
                child: _isloading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: primaryColor,
                        ),
                      )
                    : const Text('Log in'),
                width: double.infinity,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: const ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                  ),
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Flexible(
              child: Container(),
              flex: 1,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: const Text("Don't have an account?"),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                ),
                GestureDetector(
                  onTap: navigatetosignup,
                  child: Container(
                      child: const Text("  Sign up",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          )),
                      padding: const EdgeInsets.symmetric(vertical: 8.0)),
                )
              ],
            )
          ],
        ),
      )),
    );
  }
}
