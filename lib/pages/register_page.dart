import 'package:demoaiemo/util/my_botton.dart';
import 'package:demoaiemo/util/my_textfields.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  final void Function()? onTap;

  RegisterPage({super.key, required this.onTap});

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController occupationController = TextEditingController();


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

              const SizedBox(height: 10,),

              MyBotton(text: "Kaydol", onTap: register,),

              const SizedBox(height: 10,),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Hesabın var mu?",
                  style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),),
                  GestureDetector(
                    onTap: onTap,
                    child: Text("Giriş Yap", style: TextStyle(fontWeight: FontWeight.bold),))
                ],
              ),

          ],),
        ),
      ),
    );
  }

  void register(){}

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
          controller: usernameController,
        ),

        const SizedBox(height: 10,),

        MyTextfield(
          hintText: "Şifreniz",
          obscureText: true,
          controller: passwordController,
        ),
        
        const SizedBox(height: 10,),

        MyTextfield(
          hintText: "Şifreni Doğrula",
          obscureText: true,
          controller: passwordConfirmController,
        ),
        
        const SizedBox(height: 10,),

        MyTextfield(
          hintText: "Cinsiyet",
          obscureText: false,
          controller: genderController,
        ),
        
        const SizedBox(height: 10,),

        MyTextfield(
          hintText: "Yaşınız",
          obscureText: false,
          controller: ageController,
        ),
        
        const SizedBox(height: 10,),

        MyTextfield(
          hintText: "Mesleğiniz",
          obscureText: false,
          controller: occupationController,
        ),
        
        const SizedBox(height: 10,),
        ],
    );
  }
}