import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:scholarship_flutter_application/resources/auth_methods.dart';
import 'package:scholarship_flutter_application/screens/feed_screen.dart';
import 'package:select_form_field/select_form_field.dart';
import 'package:scholarship_flutter_application/screens/login_screen.dart';
import 'package:scholarship_flutter_application/utils/colors.dart';
import 'package:scholarship_flutter_application/utils/utils.dart';
import 'package:scholarship_flutter_application/widgets/text_feild_input.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

class Signupscreen extends StatefulWidget {
  const Signupscreen({Key? key}) : super(key: key);

  @override
  _SignupscreenState createState() => _SignupscreenState();
}

class _SignupscreenState extends State<Signupscreen> {
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();
  final TextEditingController _biocontroller = TextEditingController();
  final TextEditingController _usernamecontroller = TextEditingController();
  final TextEditingController _rolecontroller = TextEditingController();
  Uint8List? _image;
  bool _isloading = false;
  String role = '';
  final _items = ['Student', 'Sponsor'];

  @override
  void dispose() {
    super.dispose();
    _emailcontroller.dispose();
    _passwordcontroller.dispose();
    _biocontroller.dispose();
    _usernamecontroller.dispose();
    _rolecontroller.dispose();
  }

  void signupuser() async {
    setState(() {
      _isloading = true;
    });
    String res = await auth_methods().signup(
        email: _emailcontroller.text,
        password: _passwordcontroller.text,
        username: _usernamecontroller.text,
        bio: "bio",
        role: _rolecontroller.text,
        file: _image!);
    setState(() {
      _isloading = false;
    });
    if (res != 'Success') {
      showsnackbar(res, context);
    } else {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => FeedScreen()));
    }
  }

  void navigatetologin() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const Loginscreen()));
  }

  void selectImage() async {
    Uint8List? im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Expanded(
          flex: 1,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 1,
                  child: const SizedBox(
                    height: 20,
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Stack(
                    children: [
                      _image != null
                          ? CircleAvatar(
                              radius: 64,
                              backgroundImage: MemoryImage(_image!),
                              backgroundColor: Colors.red,
                            )
                          : const CircleAvatar(
                              radius: 64,
                              backgroundImage:
                                  AssetImage('assests/profile.jpeg'),
                              backgroundColor: Colors.red,
                            ),
                      Positioned(
                        bottom: 100,
                        left: 80,
                        child: IconButton(
                          onPressed: selectImage,
                          icon: const Icon(Icons.add_a_photo),
                        ),
                      )
                    ],
                  ),
                ),
                textfeildinput(
                    textEditingController: _usernamecontroller,
                    hinttext: 'Enter your Username',
                    textInputType: TextInputType.text),
                const SizedBox(
                  height: 24,
                ),
                textfeildinput(
                    textEditingController: _emailcontroller,
                    hinttext: 'Enter your Email',
                    textInputType: TextInputType.emailAddress),
                const SizedBox(
                  height: 24,
                ),
                textfeildinput(
                  textEditingController: _passwordcontroller,
                  hinttext: 'Enter your Password',
                  textInputType: TextInputType.text,
                  ispass: true,
                ),
                const SizedBox(
                  height: 24,
                ),
                TextField(
                  controller: _rolecontroller,
                  decoration: InputDecoration(
                    hintText: 'Enter your role',
                    suffixIcon: PopupMenuButton<String>(
                      icon: const Icon(Icons.arrow_drop_down),
                      onSelected: (String value) {
                        _rolecontroller.text = value;
                      },
                      itemBuilder: (BuildContext context) {
                        return _items
                            .map<PopupMenuItem<String>>((String value) {
                          return new PopupMenuItem(
                              child: new Text(value), value: value);
                        }).toList();
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                InkWell(
                  child: Container(
                    child: !_isloading
                        ? const Text(
                            'Sign up',
                          )
                        : const CircularProgressIndicator(
                            color: Colors.grey,
                          ),
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
                  onTap: signupuser,
                ),
                const SizedBox(
                  height: 12,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: const Text(
                        'Already have an account?',
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const Loginscreen(),
                        ),
                      ),
                      child: Container(
                        child: const Text(
                          ' Login.',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
