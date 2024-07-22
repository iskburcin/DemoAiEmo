import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class GenderProvider with ChangeNotifier {
  bool _isMale = true;

  bool get isMale => _isMale;

  set isMale(bool value) {
    _isMale = value;
    notifyListeners();
  }

  get color => _isMale ? Colors.blue : Colors.pink;
  get maleColor => _isMale ? Colors.blue : Colors.grey;
  get femaleColor => _isMale ? Colors.grey : Colors.pink;

  Widget genderPicker(BuildContext context) {
    return ChangeNotifierProvider<GenderProvider>(
      create: (context) => GenderProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Consumer<GenderProvider>(
                  builder: (context, genderProvider, _) => Text(
                    'Cinsiyet',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                        color: genderProvider.color),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                Row(
                  children: [
                    // MALE
                    Expanded(
                      child: Consumer<GenderProvider>(
                        builder: (context, genderProvider, _) =>
                            GestureDetector(
                          onTap: () {
                            genderProvider.isMale = true;
                          },
                          child: Container(
                            height: 150,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: genderProvider.maleColor,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/icon_male.png',
                                  height: 80,
                                  color: genderProvider.maleColor,
                                ),
                                Text(
                                  'Erkek',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    color: genderProvider.maleColor,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    // FEMALE
                    Expanded(
                      child: Consumer<GenderProvider>(
                        builder: (context, genderProvider, _) =>
                            GestureDetector(
                              onTap: () {
                                genderProvider.isMale = false;
                              },
                          child: Container(
                            height: 150,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: genderProvider.femaleColor,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/icon_female.png',
                                  height: 80,
                                  color: genderProvider.femaleColor,
                                ),
                                Text(
                                  'Kadın',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    color: genderProvider.femaleColor,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
