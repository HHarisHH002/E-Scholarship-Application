import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scholarship_flutter_application/models/user.dart';
import 'package:scholarship_flutter_application/provider/user_provider.dart';
import 'package:scholarship_flutter_application/resources/firestore_methods.dart';
import 'package:scholarship_flutter_application/utils/colors.dart';
import 'package:scholarship_flutter_application/widgets/comment_card.dart';
import 'package:provider/provider.dart';

class CommentsScreen extends StatefulWidget {
  final snap;
  const CommentsScreen({Key? key, required this.snap}) : super(key: key);

  @override
  _CommentsScreenState createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final TextEditingController _commentconttroller = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    _commentconttroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final UserDetails user = Provider.of<UserProvider>(context).getuser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        centerTitle: false,
        title: Text('Comments'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .doc(widget.snap['postid'])
            .collection('comments')
            .orderBy('datepublished', descending: true)
            .snapshots(),
        builder: (context, snapshots) {
          if (snapshots.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
              itemCount: (snapshots.data! as dynamic).docs.length,
              itemBuilder: (context, index) => CommentCard(
                  snap: (snapshots.data! as dynamic).docs[index].data()));
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: kToolbarHeight,
          margin:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          padding: EdgeInsets.only(left: 16, right: 8),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(user.photourl),
                radius: 18,
              ),
              Expanded(
                  child: Padding(
                padding: EdgeInsets.only(left: 16, right: 8),
                child: TextField(
                  controller: _commentconttroller,
                  decoration: InputDecoration(
                      hintText: 'Add a comment...', border: InputBorder.none),
                ),
              )),
              InkWell(
                onTap: () async {
                  await FirestoreMethods().postcomment(
                      widget.snap['postid'],
                      _commentconttroller.text,
                      user.uid,
                      user.username,
                      user.photourl);
                  setState(() {
                    _commentconttroller.text = '';
                  });
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: const Text(
                    'Post',
                    style: TextStyle(color: Colors.blueAccent),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
