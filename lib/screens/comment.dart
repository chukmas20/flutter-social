import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gram_app/models/user_model.dart';
import 'package:gram_app/providers/user_provider.dart';
import 'package:gram_app/resources/firestore_methods.dart';
import 'package:gram_app/utils/colors.dart';
import 'package:gram_app/widgets/comment_card.dart';
import 'package:provider/provider.dart';

class Comments extends StatefulWidget {
   final snap;
  const Comments({Key? key, required this.snap}) : super(key: key);

  @override
  _CommentsState createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  final TextEditingController _commentController = TextEditingController();
  @override
  void dispose(){
     super.dispose();
    _commentController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: const Text("Comments"),
        centerTitle: false,
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('posts')
              .doc(widget.snap['postId'])
               .collection('comments')
               .orderBy('datePublished', descending: true)
               .snapshots(),
         builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot){
            if(snapshot.connectionState == ConnectionState.waiting){
              return const Center(
                 child: CircularProgressIndicator(
                 ),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) =>
                CommentCard(
                  snap:snapshot.data!.docs[index].data(),
                ),
            );
         },
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: kToolbarHeight,
          margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            padding:EdgeInsets.only(left: 16, right: 8),
           child: Row(
             children: [
               CircleAvatar(
                 backgroundImage: NetworkImage(
                   user.photoUrl
                 ),
                   radius:18,
               ),
               Expanded(
                 child: Padding(
                   padding: const EdgeInsets.only(left: 16, right: 8.0),
                   child: TextField(
                     controller: _commentController,
                     decoration: InputDecoration(
                       hintText: "Comment as ${user.username}",
                       border: InputBorder.none,

                     ),
                   ),
                 ),
               ),
               InkWell(
                 onTap: () async{
                   await FirestoreMethod().postComment(
                       widget.snap['postId'],
                       _commentController.text,
                       user.uid,
                       user.username,
                       user.photoUrl
                   );
                   setState(() {
                     _commentController.text = "";
                   });
                 },
                 child: Container(
                   padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                   child: Text(
                        "Post",
                     style: TextStyle(
                         color: Colors.blueAccent
                     ),
                   ),
                 ),
               ),
             ],
           ),
        ),
      ),
    );
  }
}
