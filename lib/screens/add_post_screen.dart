import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:scholarship_flutter_application/models/user.dart';
import 'package:scholarship_flutter_application/provider/user_provider.dart';
import 'package:scholarship_flutter_application/resources/firestore_methods.dart';
import 'package:scholarship_flutter_application/utils/colors.dart';
import 'package:scholarship_flutter_application/utils/utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  Uint8List? _file;
  final TextEditingController _descriptioncontroller = TextEditingController();
  bool _isloading = false;

  void postimage(
    String uid,
    String username,
    String profimage,
  ) async {
    setState(() {
      _isloading = true;
    });
    try {
      String res = await FirestoreMethods().uploadPost(
          _descriptioncontroller.text, _file!, uid, username, profimage);
      if (res == 'success') {
        setState(() {
          _isloading = false;
        });
        showsnackbar('Posted!', context);
        clearimage();
      } else {
        setState(() {
          _isloading = false;
        });
        showsnackbar(res, context);
      }
    } catch (e) {
      showsnackbar(e.toString(), context);
    }
  }

  _selectimage(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text('Create a post'),
            children: [
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Take a photo'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(ImageSource.camera);
                  setState(() {
                    _file = file;
                  });
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Choose from gallery'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(ImageSource.gallery);
                  setState(() {
                    _file = file;
                  });
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Cancel'),
                onPressed: () async {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  void clearimage() {
    setState(() {
      _file = null;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _descriptioncontroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final UserDetails user = Provider.of<UserProvider>(context).getuser;
    return _file == null
        ? Scaffold(
            body: Center(
            child: IconButton(
              icon: const Icon(Icons.upload),
              onPressed: () => _selectimage(context),
            ),
          ))
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              leading: IconButton(
                  onPressed: () {
                    clearimage();
                  },
                  icon: const Icon(Icons.arrow_back)),
              title: const Text('Post to'),
              centerTitle: false,
              actions: [
                TextButton(
                    onPressed: () =>
                        postimage(user.uid, user.username, user.photourl),
                    child: const Text(
                      'post',
                      style: TextStyle(
                        color: Colors.blueAccent,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ))
              ],
            ),
            body: Column(
              children: [
                _isloading
                    ? const LinearProgressIndicator()
                    : const Padding(padding: EdgeInsets.only(top: 0)),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                        user.photourl,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: TextField(
                        controller: _descriptioncontroller,
                        decoration: const InputDecoration(
                          hintText: 'Write a caption...',
                          border: InputBorder.none,
                        ),
                        maxLines: 8,
                      ),
                    ),
                    SizedBox(
                        height: 45,
                        width: 45,
                        child: AspectRatio(
                            aspectRatio: 487 / 451,
                            child: Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                image: MemoryImage(_file!),
                                fit: BoxFit.fill,
                                alignment: FractionalOffset.topCenter,
                              )),
                            ))),
                    const Divider(),
                  ],
                )
              ],
            ),
          );
  }
}
