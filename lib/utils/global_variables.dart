import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gram_app/screens/profile_screen.dart';
import 'package:gram_app/screens/search_screen.dart';
import 'package:gram_app/screens/add_post.dart';
import 'package:gram_app/screens/feed_screen.dart';


const webScreenSize = 600;

// const homeScreenItems = [
//    FeedScreen(),
//    SearchScreen(),
//    AddPostScreen(),
//   Text("notif"),
//    ProfileScreen(uid: FirebaseAuth.instance.currentUser!.uid,),
// ];

List<Widget> homeScreenItems = [
  const FeedScreen(),
  const SearchScreen(),
  const AddPostScreen(),
  const Text('notifications'),
  ProfileScreen(
    uid: FirebaseAuth.instance.currentUser!.uid,
  ),
];