import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gram_app/models/user_model.dart' as model;
import 'dart:typed_data';

import 'package:gram_app/resources/storage_methods.dart';

class AuthMethods{
   final FirebaseAuth _auth = FirebaseAuth.instance;
   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

   Future<model.User> getUserDetails() async{
     User currentUser = _auth.currentUser!;

     DocumentSnapshot snap = await _firestore.collection('users').doc(currentUser.uid).get();

     return model.User.fromSnap(snap);
   }

  // signup user
   Future <String> signUpUser({
     required String email,
     required String password,
     required String username,
     required String bio,
     required Uint8List file,

   }) async {
     String res = "Some error Occurred";
     try{
       if(email.isNotEmpty || password.isNotEmpty || username.isNotEmpty || bio.isNotEmpty || file != null){
         // register user
        UserCredential cred =  await  _auth.createUserWithEmailAndPassword(email: email, password: password);
        
        print(cred.user!.uid);
        
        String photoUrl = await StorageMethods().uploadImageToStorage('profilePics', file, false);

        //add user to database.

        model.User user = model.User(
            username:username,
            uid: cred.user!.uid,
            email:email,
            bio: bio,
             followers:[],
             following:[],
            photoUrl:photoUrl
         );
        await _firestore.collection('users').doc(cred.user!.uid).set(user.toJson());
        res = "success";
       }

     }on FirebaseAuthException catch(err){
       if(err.code == "Invalid Email"){
          res = "The email format is invalid";
       }
     }
     catch(err){
       res = err.toString();
     }
     return res;
   }
   // Login user
   Future<String> loginUser({
     required String email,
     required String password,
   })async{
     String res = "Some error Occurred";

     try{
       if(email.isNotEmpty || password.isNotEmpty){
         await _auth.signInWithEmailAndPassword(email: email, password: password);
         res = "success";
       }else{
         res="All fields must be filled";
       }
     }catch(err){
       res = err.toString();
     }
     return res;
   }

   Future<void> signOut() async{
      await _auth.signOut();
   }
}
