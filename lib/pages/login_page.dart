import 'package:demoaiemo/util/my_botton.dart';
import 'package:demoaiemo/util/my_textfields.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;

  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text("AIEmo"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _title(),
              const SizedBox(height: 25,),
              _loginform(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text("Forget Password",style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary
                  ),
                  ),
                ],
              ),
              const SizedBox(height: 10,),
              MyBotton(text: "Login", onTap: login,),
              const SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Hesabın yok mu?",
                  style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),),
                  GestureDetector(
                    onTap: widget.onTap ,
                    child: Text("Kaydol", style: TextStyle(fontWeight: FontWeight.bold),))
                ],
              ),

          ],),
        ),
      ),
    );
  }

  void login(){}

  Widget _title(){
    return const SizedBox(
      child: Text("AIEmo",
      style: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        ),
      )
    );
  }

  Widget _loginform(){
    return Column(children: [
        MyTextfield(
          hintText: "Mail Adresiniz",
          obscureText: false,
          controller: emailController,
        ),

        const SizedBox(height: 10,),

        MyTextfield(
          hintText: "Şifreniz",
          obscureText: true,
          controller: passwordController,
        ),
        
        const SizedBox(height: 10,),
        ],
    );
  }
}