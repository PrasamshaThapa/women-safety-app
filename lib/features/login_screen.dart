import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/auth/auth_bloc.dart';
import '../bloc/auth/auth_event.dart';
import '../constants/app_constants.dart';
import '../constants/app_spaces.dart';
import '../utils/buttons/expanded_filled_button.dart';
import '../utils/gesture/custom_inkwell.dart';
import '../utils/inputs/custom_input.dart';
import 'home/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? _user;

  @override
  void initState() {
    super.initState();
    _auth.authStateChanges().listen((event) {
      setState(() {
        _user = event;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFC096CC),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 300,
                child: Stack(
                  children: [
                    Container(
                      height: 220,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/login.jpg'),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(50),
                        ),
                      ),
                    ),
                    Transform.translate(
                      offset: const Offset(190, -15),
                      child: Transform.scale(
                        scale: 0.6,
                        child: Image.asset('assets/images/logoo.png'),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(AppConstants.screenPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,

                  spacing: AppSpaces.veryLargeSpace,
                  children: [
                    CustomInput(
                      label: 'Email Address',
                      hint: 'Enter Email Address',
                    ),
                    CustomInput(
                      label: 'Password',
                      hint: 'Enter Password',
                      isPassword: true,
                    ),
                    AppSpaces.small,
                    ExpandedFilledButton(
                      title: "Login",
                      onTap: () {
                        //TODO

                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => HomeScreen()),
                        );
                      },
                    ),
                    Text(
                      'Or sign up with',
                      style: TextStyle(color: Colors.purple.shade700),
                    ),
                    CustomInkWell(
                      onTap: _handleGoogleSignUp,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(color: Colors.black26, blurRadius: 5),
                          ],
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/images/googleicon.png',
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
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
    );
  }

  void _handleGoogleSignUp() async {
    try {
      final GoogleAuthProvider googleAuthProvider = GoogleAuthProvider();
      final UserCredential userCredential = await _auth.signInWithProvider(
        googleAuthProvider,
      );

      // Check if we got a user
      if (userCredential.user != null) {
        final User user = userCredential.user!;
        final String email = user.email!;

        // Reference to Firestore
        final FirebaseFirestore db = FirebaseFirestore.instance;
        final CollectionReference users = db.collection('users');

        // Check if the email exists in the database
        final QuerySnapshot query =
            await users.where('email', isEqualTo: email).limit(1).get();

        // If email doesn't exist, add it to the database
        if (query.docs.isEmpty) {
          // Create user document with the email
          await users.add({
            'email': email,
            'createdAt': FieldValue.serverTimestamp(),
            // Add any other user info you want to store
            'displayName': user.displayName,
            'photoURL': user.photoURL,
          });
          log('User added to database: $email');
        } else {
          log('User already exists in database: $email');
        }

        // Update the auth state and navigate to home screen
        context.read<AuthBloc>().add(AuthUserChanged(user));
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      }
    } catch (e) {
      print("LOGIN ERROR: $e");
    }
  }
}
