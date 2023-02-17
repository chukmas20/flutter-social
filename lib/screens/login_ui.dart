import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gram_app/resources/auth_methods.dart';
import 'package:gram_app/responsive/mobile_screen.dart';
import 'package:gram_app/responsive/responsive_layout_screen.dart';
import 'package:gram_app/responsive/webscreen_layout.dart';
import 'package:gram_app/screens/home_screen.dart';
import 'package:gram_app/screens/sign_up.dart';
import 'package:gram_app/utils/colors.dart';
import 'package:gram_app/utils/utils.dart';
import 'package:gram_app/widgets/text_input_fields.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
   void dispose(){
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }
  void loginUser()async{
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().loginUser(
        email: _emailController.text,
        password: _passwordController.text
    );
    if(res == "success"){
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>
      const ResponsiveLayout(
          webScreenLayout: WebScreenLayout(),
          mobileScreenLayout: MobileScreenLayout())));
    }else{
      showSnackBar(context, res);
    }
    setState(() {
      _isLoading = false;
    });
  }

  void navigateToSignUp(){
    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> SignUpScreen(),));
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
               Flexible(child: Container(), flex: 2,),
               Image.asset("assets/oprah.png", color: primaryColor,height: 64),
               const SizedBox(height: 64),
              TextFieldInput(
                  textEditingController: _emailController,
                  hintText: "Enter your email",
                  textInputType: TextInputType.emailAddress,
              ),
              SizedBox(height: 24),
              TextFieldInput(
                textEditingController: _passwordController,
                hintText: "Enter your password",
                textInputType: TextInputType.text,
                isPass: true,
              ),
              SizedBox(height: 24),
              InkWell(
                onTap: loginUser,
                child: Container(
                  child: _isLoading ? Center(
                     child: CircularProgressIndicator(color: primaryColor,),
                  ):
                  const Text("Log in", style: TextStyle(fontWeight: FontWeight.bold),),
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: 12),
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
              const SizedBox(height: 12),
              Flexible(child: Container(), flex: 2,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Container(
                     child: const Text("Dont have an account?", style: TextStyle(fontWeight: FontWeight.bold),),
                     padding: const EdgeInsets.symmetric(vertical: 8),
                   ),
                   SizedBox(width: 5,),
                  GestureDetector(
                    onTap: navigateToSignUp,
                    child: Container(
                      child: const Text("Sign Up", style: TextStyle(fontWeight: FontWeight.bold),),
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
