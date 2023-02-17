import 'package:flutter/material.dart';
import 'package:gram_app/resources/auth_methods.dart';
import 'package:gram_app/responsive/mobile_screen.dart';
import 'package:gram_app/responsive/responsive_layout_screen.dart';
import 'package:gram_app/responsive/webscreen_layout.dart';
import 'package:gram_app/screens/login_ui.dart';
import 'package:gram_app/utils/utils.dart';
import 'package:image_picker/image_picker.dart';
import '../utils/colors.dart';
import '../widgets/text_input_fields.dart';
import 'dart:typed_data';




class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;


  @override
  void dispose(){
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    _usernameController.dispose();
  }

  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    // set state because we need to display the image we selected on the circle avatar
    setState(() {
      _image = im;
    });
  }
 void navigateToLogin(){
    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> const LoginScreen()));
 }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 35),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(child: Container(), flex: 2,),
                  Image.asset("assets/oprah.png", color: primaryColor,height: 50),
                  const SizedBox(height: 34),
                  Stack(
                    children: [
                      _image != null
                          ? CircleAvatar(
                        radius: 64,
                        backgroundImage: MemoryImage(_image!),
                        backgroundColor: Colors.red,
                      )
                          : const CircleAvatar(
                        radius: 64,
                        backgroundImage: NetworkImage(
                            'https://i.stack.imgur.com/l60Hf.png'),
                        backgroundColor: Colors.red,
                      ),
                      Positioned(
                         bottom: -10,
                          left: 80,
                          child:IconButton(
                              onPressed: selectImage,
                              icon: const Icon(Icons.add_a_photo),
                          ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFieldInput(
                    textEditingController: _usernameController,
                    hintText: "Enter your user name",
                    textInputType: TextInputType.text,
                  ),
                  SizedBox(height: 5),
                  TextFieldInput(
                    textEditingController: _emailController,
                    hintText: "Enter your email",
                    textInputType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 5),
                     TextFieldInput(
                      textEditingController: _passwordController,
                      hintText: "Enter your password",
                      textInputType: TextInputType.text,
                      isPass: true,
                    ),
                  SizedBox(height: 5),

                     TextFieldInput(
                      textEditingController: _bioController,
                      hintText: "Enter your Bio",
                      textInputType: TextInputType.text,
                    ),
                  SizedBox(height: 5),
                  InkWell(
                    onTap: ()async{
                      setState(() {
                        _isLoading = true;
                      });
                       String res = await AuthMethods().signUpUser(
                           email: _emailController.text,
                           password: _passwordController.text,
                           username: _usernameController.text,
                           bio: _bioController.text,
                           file: _image!
                       );
                      setState(() {
                        _isLoading = false;
                      });
                       if(res != 'success'){
                         showSnackBar(context, res);
                       }else{
                         Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>
                         const ResponsiveLayout(
                             webScreenLayout: WebScreenLayout(),
                             mobileScreenLayout: MobileScreenLayout())));
                       }
                    },
                    child: Container(
                      child:_isLoading ?
                       const Center(
                         child:  CircularProgressIndicator(color: primaryColor),
                       ):
                       const Text("Sign Up", style: TextStyle(fontWeight: FontWeight.bold),),
                      width: double.infinity,
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(vertical: 10),
                      decoration: const ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                              Radius.circular(4)
                          ),
                        ),
                        color: Colors.pinkAccent,
                      ),
                    ),
                  ),
                  //const SizedBox(height: 12),
                  Flexible(child: Container(), flex: 1,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: const Text("Dont have an account?", style: TextStyle(fontWeight: FontWeight.bold),),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                      // SizedBox(width: 5,),
                      GestureDetector(
                        onTap: navigateToLogin,
                        child: Container(
                          child: const Text("Login", style: TextStyle(fontWeight: FontWeight.bold),),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
        )
    );
  }
}
