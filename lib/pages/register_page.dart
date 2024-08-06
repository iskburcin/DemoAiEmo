import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demoaiemo/system/helpers.dart';
import 'package:demoaiemo/util/labeled_radio_button.dart';
import 'package:demoaiemo/util/my_botton.dart';
import 'package:demoaiemo/util/labeled_location_button.dart';
import 'package:demoaiemo/util/my_textfields.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;

  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  int selectedOption = 1;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmController =
      TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController occupationController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  String selectedGender = "Kadın";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text("AIEmo"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _title(),
            Expanded(
                child: ListView(
                    padding: const EdgeInsets.all(25.0),
                    shrinkWrap: true,
                    children: [
                  const SizedBox(
                    height: 25,
                  ),
                  _loginform(),
                  const SizedBox(
                    height: 10,
                  ),
                  MyBotton(
                    text: "Kaydol",
                    onTap: registerUser,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Hesabın var mu?",
                        style: TextStyle(
                            color:
                                Theme.of(context).colorScheme.inversePrimary),
                      ),
                      GestureDetector(
                          onTap: widget.onTap,
                          child: const Text(
                            "Giriş Yap",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ))
                    ],
                  ),
                ]))
          ],
        ),
      ),
    );
  }

  void registerUser() async {
    //loading circlı göster
    showDialog(
        context: context,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));

    //şifrelerin eşleştiğini checkle
    if (passwordConfirmController.text != passwordController.text) {
      Navigator.pop(context); //loading circlı çıkar
      displayMessageToUser("Şifre eşleşmedi!", context); //error ver
    } else {
      //kullanıcı oluştur
      try {
        UserCredential? userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: emailController.text, password: passwordController.text);

        //kullanıcı dosyası oluşturup firestore a ekle
        createUserDocument(userCredential);

        //loading circle çıkar
        if (context.mounted) Navigator.pop(context);
      } on FirebaseAuthException catch (e) {
        //loading circle çıkar
        Navigator.pop(context);
        displayMessageToUser(e.code, context);
      }
    }
  }

  Widget _title() {
    return const SizedBox(
        child: Text(
      "AIEmo",
      style: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
      ),
    ));
  }

  Widget _loginform() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: MyTextfield(
                hintText: "Adınız",
                obscureText: false,
                controller: nameController,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: MyTextfield(
                hintText: "Soyadınız",
                obscureText: false,
                controller: surnameController,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        MyTextfield(
          hintText: "Mail Adresiniz",
          obscureText: false,
          controller: emailController,
        ),
        const SizedBox(
          height: 10,
        ),
        MyTextfield(
          hintText: "Şifreniz",
          obscureText: true,
          controller: passwordController,
        ),
        const SizedBox(
          height: 10,
        ),
        MyTextfield(
          hintText: "Şifreni Doğrula",
          obscureText: true,
          controller: passwordConfirmController,
        ),
        const SizedBox(
          height: 10,
        ),
        LabeledRadio(
          groupValue: selectedGender,
          onChanged: (value) {
            setState(() {
              selectedGender = value;
            });
          },
          controller: genderController,
        ),
        const SizedBox(
          height: 10,
        ),
        MyTextfield(
          hintText: "Yaşınız",
          obscureText: false,
          controller: ageController,
        ),
        const SizedBox(
          height: 10,
        ),
        MyTextfield(
          hintText: "Mesleğiniz",
          obscureText: false,
          controller: occupationController,
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Expanded(
              child: MyTextfield(
                hintText: "Konumunuz:",
                obscureText: false,
                controller: locationController,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: LabeledLocationButton(
                controller: locationController,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> createUserDocument(UserCredential? userCredential) async {
    if (userCredential != null && userCredential.user != null) {
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(userCredential.user!.email)
          .set({
        'Email': userCredential.user!.email,
        'Name': nameController.text,
        'Surname': surnameController.text,
        'Gender': genderController.text,
        'Age': ageController.text,
        'Occupation': occupationController.text,
        'Location': locationController.text,
      });
    }
  }
}
