import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scholarship_flutter_application/models/user.dart';
import 'package:scholarship_flutter_application/provider/user_provider.dart';
import 'package:scholarship_flutter_application/resources/firestore_methods.dart';
import 'package:scholarship_flutter_application/screens/comments_screen.dart';
import 'package:scholarship_flutter_application/screens/form_screen.dart';
import 'package:scholarship_flutter_application/utils/colors.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:scholarship_flutter_application/utils/utils.dart';
import 'package:scholarship_flutter_application/widgets/like_animation.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PostCard extends StatefulWidget {
  final snap;
  const PostCard({Key? key, required this.snap}) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLikeAnimating = false;
  int commentlen = 0;
  var role;
  @override
  void initState() {
    super.initState();
    getcomment();
    getRole();
  }

  void getRole() async {
    var usersnap = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .get();
    setState(() {
      role = usersnap['role'].toString();
    });
  }

  void getcomment() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.snap['postid'])
          .collection('comments')
          .get();
      setState(() {
        commentlen = snap.docs.length;
      });
    } catch (e) {
      showsnackbar(e.toString(), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final UserDetails user = Provider.of<UserProvider>(context).getuser;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: mobileBackgroundColor),
        color: mobileBackgroundColor,
      ),
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16)
                .copyWith(right: 0),
            child: Row(children: [
              CircleAvatar(
                radius: 16,
                backgroundImage: NetworkImage(widget.snap['profimage']),
              ),
              Expanded(
                  child: Padding(
                padding: EdgeInsets.only(left: 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.snap['username'],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              )),
              (role.toString() == "Sponsor")?(IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) => Dialog(
                              child: ListView(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shrinkWrap: true,
                                children: ['Delete']
                                    .map(
                                      (e) => InkWell(
                                        onTap: () async {
                                          FirestoreMethods().deletepost(
                                              widget.snap['postid']);
                                          Navigator.of(context).pop();
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 12, horizontal: 16),
                                          child: Text(e),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ));
                  },
                  icon: const Icon(Icons.more_vert))):Text(""),
            ]),
          ),
          GestureDetector(
            onDoubleTap: () async {
              await FirestoreMethods().likepost(
                  widget.snap['postid'], user.uid, widget.snap['likes']);

              setState(() {
                isLikeAnimating = true;
              });
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.35,
                  width: double.infinity,
                  child:
                      Image.network(widget.snap['posturl'], fit: BoxFit.cover),
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: isLikeAnimating ? 1 : 0,
                  child: LikeAnimation(
                    child: const Icon(
                      Icons.favorite,
                      size: 120,
                      color: Colors.white,
                    ),
                    isanimating: isLikeAnimating,
                    duration: const Duration(milliseconds: 200),
                    onEnd: () {
                      setState(() {
                        isLikeAnimating = false;
                      });
                    },
                  ),
                )
              ],
            ),
          ),
          Row(
            children: [
              LikeAnimation(
                isanimating: widget.snap['likes'].contains(user.uid),
                smalllike: true,
                child: IconButton(
                    onPressed: () async {
                      await FirestoreMethods().likepost(widget.snap['postid'],
                          user.uid, widget.snap['likes']);
                    },
                    icon: widget.snap['likes'].contains(user.uid)
                        ? const Icon(
                            Icons.favorite,
                            color: Colors.red,
                          )
                        : const Icon(Icons.favorite_outline)),
              ),
              IconButton(
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => CommentsScreen(
                            snap: widget.snap,
                          ))),
                  icon: const Icon(
                    Icons.comment_bank_outlined,
                  )),
              IconButton(onPressed: () {}, icon: const Icon(Icons.send)),
              (role.toString() == "Student")
                  ? Expanded(
                      child: Align(
                          alignment: Alignment.bottomRight,
                          child: ElevatedButton(
                              child: const Text(
                                'Apply',
                                style: TextStyle(fontSize: 13),
                              ),
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.black),
                                  side: MaterialStateProperty.all(BorderSide(
                                      color: Colors.white, width: 0.5))),
                              onPressed: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => FormScreen(),
                                    ),
                                  ))))
                  : Text("")
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DefaultTextStyle(
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2!
                      .copyWith(fontWeight: FontWeight.w800),
                  child: Text(
                    '${widget.snap['likes'].length} likes',
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 8),
                  child: Row(
                    children: [
                      Text('Rate:'),
                      RatingBar.builder(
                        glowRadius: 0.5,
                        itemSize: 20,
                        initialRating: 0,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) {
                          print(rating);
                        },
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 8),
                  child: RichText(
                    text: TextSpan(
                        style: const TextStyle(
                          color: primaryColor,
                        ),
                        children: [
                          TextSpan(
                            text: widget.snap['username'],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: ' ${widget.snap['description']}',
                          ),
                        ]),
                  ),
                ),
                InkWell(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => CommentsScreen(
                            snap: widget.snap,
                          ))),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      'View all $commentlen  comments',
                      style: TextStyle(fontSize: 14, color: secondaryColor),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    DateFormat.yMMMd()
                        .format(widget.snap['datepublished'].toDate()),
                    style: TextStyle(fontSize: 10, color: secondaryColor),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
