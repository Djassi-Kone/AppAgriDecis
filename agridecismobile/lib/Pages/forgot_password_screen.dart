// lib/screens/forgot_password_screen.dart

import 'package:flutter/material.dart';
import 'login_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {

  final TextEditingController emailController = TextEditingController();

  void showPopup() {

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),

          child: Padding(
            padding: const EdgeInsets.all(20),

            child: Stack(
              children: [

                /// BOUTON FERMER (CERCLE ROUGE)
                Positioned(
                  right: 0,
                  top: 0,
                  child: GestureDetector(
                    onTap: () {

                      Navigator.pop(context);

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );

                    },
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(6),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ),

                /// CONTENU
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    const SizedBox(height: 20),

                    const Text(
                      "Réinitialisation",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 20),

                    Text(
                      "Vous allez recevoir le lien de réinitialisation sur cet email :\n\n${emailController.text}\n\nLe lien sera expiré dans 2 min",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: Container(
        width: double.infinity,
        height: double.infinity,

        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.cover,
          ),
        ),

        child: SafeArea(
          child: SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Center(   /// 🔥 CENTRAGE VERTICAL
                child: Padding(
                  padding: const EdgeInsets.all(24),

                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      /// CARD TRANSPARENT
                      Container(
                        padding: const EdgeInsets.all(25),

                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.25),
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                          ),
                        ),

                        child: Column(
                          children: [

                            /// LOGO + NOM
                            Column(
                              children: [

                                Image.asset(
                                  'assets/images/logo.png',
                                  height: 100,
                                  width: 100,
                                ),

                                const SizedBox(height: 10),
                                const Text(
                                  "AGRIDECIS",
                                  style: TextStyle(
                                    letterSpacing: 2,
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 25),

                            /// TITRE
                            const Text(
                              "Tapez votre email",
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),

                            const SizedBox(height: 25),

                            /// EMAIL
                            TextField(
                              controller: emailController,
                              style: const TextStyle(color: Colors.black),

                              decoration: InputDecoration(
                                hintText: "Email",
                                hintStyle: const TextStyle(color: Colors.black54),

                                prefixIcon: const Icon(
                                  Icons.email_outlined,
                                  color: Colors.black,
                                ),

                                filled: true,
                                fillColor: Colors.white.withOpacity(0.3),

                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),

                            const SizedBox(height: 25),

                            /// BOUTON ENVOYER
                            GestureDetector(
                              onTap: showPopup,

                              child: Container(
                                width: double.infinity,
                                height: 50,

                                decoration: BoxDecoration(
                                  color: const Color(0xFF2E7D32),
                                  borderRadius: BorderRadius.circular(25),

                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF2E7D32).withOpacity(0.4),
                                      blurRadius: 8,
                                      offset: const Offset(0,4),
                                    )
                                  ],
                                ),

                                child: const Center(
                                  child: Text(
                                    "Envoyer",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}