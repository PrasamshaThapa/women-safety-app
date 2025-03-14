import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../bloc/auth/auth_bloc.dart';
import '../bloc/auth/auth_event.dart';
import '../constants/app_spaces.dart';
import '../utils/buttons/custom_filled_button.dart';
import 'home/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final PageController _pageController = PageController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isLoading = false;

  User? _user;

  @override
  void initState() {
    super.initState();
    _checkUserAndRedirect();
    _auth.authStateChanges().listen((event) {
      setState(() {
        _user = event;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _checkUserAndRedirect() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userUid = prefs.getString('user');

      if (userUid != null) {
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.read<AuthBloc>().add(AuthUserChanged(user));
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          });
        }
      }
    } catch (e) {
      print("Error in _checkUserAndRedirect: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An error occurred: ${e.toString()}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/splashscreen.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: PageView(
            controller: _pageController,

            onPageChanged: (int index) {
              if (index == 1) {
                log("message");
              }
            },
            children: [buildSplashPage(), buildProceedToLoginPage()],
          ),
        ),
      ),
    );
  }

  Widget buildSplashPage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Transform.translate(
          offset: const Offset(0, 20),
          child: Transform.scale(
            scale: 1.1,
            child: Image.asset('assets/images/logo3.png'),
          ),
        ),
        const SizedBox(height: 25),
        Text(
          'Welcome',
          style: GoogleFonts.lobster(
            textStyle: const TextStyle(fontSize: 45, color: Colors.black),
          ),
        ),
        const SizedBox(height: 150),
        buildDotsIndicator(),
      ],
    );
  }

  Widget buildDotsIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(2, (index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 5),
          height: 10,
          width: 10,
          decoration: BoxDecoration(
            color: index == 0 ? Colors.black : Colors.grey,
            shape: BoxShape.circle,
          ),
        );
      }),
    );
  }

  Widget buildProceedToLoginPage() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Transform.translate(
            offset: const Offset(0, 20),
            child: Transform.scale(
              scale: 1.1,
              child: Image.asset('assets/images/logo3.png'),
            ),
          ),
          Text(
            'Aashraya is all about women safety. This app is designed to ensure your safety, at all times. Stay positive  with us.',
            style: GoogleFonts.poppins(
              textStyle: const TextStyle(fontSize: 18, color: Colors.black),
            ),
            textAlign: TextAlign.center,
          ),
          AppSpaces.veryLarge,
          CustomFilledButton(
            // onTap: () {
            //   // Navigator.pushReplacement(
            //   //   context,
            //   //   MaterialPageRoute(builder: (context) => const LoginScreen()),
            //   // );
            // },
            onTap: _handleGoogleSignUp,
            title: "Login with Google",
            padding: EdgeInsets.symmetric(horizontal: 100),
            isLoading: _isLoading,
          ),
        ],
      ),
    );
  }

  void _handleGoogleSignUp() async {
    setState(() {
      _isLoading = true;
    });
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

        // Check if the user document exists
        final DocumentSnapshot userDoc = await users.doc(user.uid).get();

        // If user doesn't exist, create a new document
        if (!userDoc.exists) {
          // Create user document with the user's UID as the document ID
          await users.doc(user.uid).set({
            'email': email,
            'displayName': user.displayName,
            'photoURL': user.photoURL,
            'createdAt': FieldValue.serverTimestamp(),
            'lastLogin': FieldValue.serverTimestamp(),
          });
          log('User added to database: $email');
        } else {
          // Update last login time
          await users.doc(user.uid).update({
            'lastLogin': FieldValue.serverTimestamp(),
          });
          log('User already exists in database: $email');
        }

        // Update the auth state and navigate to home screen
        context.read<AuthBloc>().add(AuthUserChanged(user));
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      }
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print("LOGIN ERROR: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Login failed: ${e.toString()}")));
    }
  }
}
