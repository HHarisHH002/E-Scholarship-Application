import 'package:flutter/material.dart';
import 'package:scholarship_flutter_application/screens/feed_screen.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({Key? key}) : super(key: key);

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
        child: Form(
          key: _formkey,
          child: Column(children: [
            const SizedBox(height: 20),
            const Text(
              'Application Form',
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            TextFormField(
              onTap: () {},
              showCursor: true,
              cursorColor: Colors.grey,
              decoration: const InputDecoration(
                labelText: 'Name',
                labelStyle: TextStyle(color: Colors.grey),
                fillColor: Colors.black12,
                filled: true,
                border: UnderlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
              validator: (val) {
                if (val == null || val.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              onTap: () {},
              showCursor: true,
              cursorColor: Colors.grey,
              decoration: const InputDecoration(
                labelText: 'Email Address',
                labelStyle: TextStyle(color: Colors.grey),
                fillColor: Colors.black12,
                filled: true,
                border: UnderlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
              validator: (val) {
                if (val == null || val.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              onTap: () {},
              showCursor: true,
              cursorColor: Colors.grey,
              decoration: const InputDecoration(
                labelText: 'College Name',
                labelStyle: TextStyle(color: Colors.grey),
                fillColor: Colors.black12,
                filled: true,
                border: UnderlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
              validator: (val) {
                if (val == null || val.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              onTap: () {},
              showCursor: true,
              cursorColor: Colors.grey,
              decoration: const InputDecoration(
                labelText: 'Cumulitive GPA',
                labelStyle: TextStyle(color: Colors.grey),
                fillColor: Colors.black12,
                filled: true,
                border: UnderlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
              validator: (val) {
                if (val == null || val.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              onTap: () {},
              showCursor: true,
              cursorColor: Colors.grey,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'City/State',
                labelStyle: TextStyle(color: Colors.grey),
                fillColor: Colors.black12,
                filled: true,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
              validator: (val) {
                if (val == null || val.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
              child: const Text(
                'Apply',
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.w700),
              ),
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Colors.grey.shade100),
                  side: MaterialStateProperty.all(
                      const BorderSide(color: Colors.white, width: 0.5))),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ]),
        ),
      )),
    );
  }
}
