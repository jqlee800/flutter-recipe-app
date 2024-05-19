import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Bloc
import 'package:flutter_recipe_app/bloc/recipe_bloc.dart';

// Models
import 'package:flutter_recipe_app/models/constants.dart';

// Screens
import 'package:flutter_recipe_app/screens/home.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ---------- APP LOGO -----------
            const Icon(
              Icons.food_bank_rounded,
              color: Colors.white,
              size: 100,
            ),
            const Text(
              'DishDash',
              style: TextStyle(
                fontSize: 50,
                fontStyle: FontStyle.italic,
                color: Colors.white,
              ),
            ),

            // ---------- GET STARTED BUTTON -----------
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: ElevatedButton(
                child: const Text('Get Started'),
                onPressed: () {
                  // Navigate to home screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BlocProvider(
                        create: (BuildContext context) => RecipeBloc(),
                        child: const HomeScreen(),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
