import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notesf/constrant/customTextStyle.dart';
import 'package:notesf/model/user_model.dart';
import 'package:notesf/screen/auth_screen/login_screen.dart';
import 'package:notesf/widgets/custom_button.dart';
import 'package:notesf/widgets/custom_text_field.dart';

class RegisterScreen extends StatefulWidget {
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  MediaQueryData? mqData;
  @override
  Widget build(BuildContext context) {
    mqData = MediaQuery.of(context);
    return Scaffold(
      body: SingleChildScrollView(
        // Added SingleChildScrollView for scrolling
        child: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Opacity(
                opacity: 1,
                child: Image.asset(
                  height: mqData!
                      .size.height, // Ensure the image covers full height
                  width: double.infinity,
                  fit: BoxFit.cover,
                  "assets/background not.webp",
                ),
              ),
              Container(
                height: mqData!.size.height,
                width: double.infinity,
                color: Colors.black26,
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),

                    /// -----------------Heading text ----------------------- ///
                    Text(
                      "Create Your Account",
                      style: mTextStyle28(
                          fontColor: Colors.white, fontWeight: FontWeight.bold),
                    ),

                    /// ----------------------Top box---------------------------///
                    ClipPath(
                      clipper: DifferentSidesClipper(),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          width: mqData!.size.width,
                          height: mqData!.size.height * 0.62,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: const Color(0xe7a0bfff),
                          ),
                          child: Center(
                            child: Stack(
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    /// email box
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: CustomTextField(
                                        controller: nameController,
                                        label: "name",
                                        hintText: "Enter name",
                                        sufficeIcon: Icons.verified_user,
                                        prefixIcon: Icons.person,
                                      ),
                                    ),

                                    /// password box
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: CustomTextField(
                                        controller: emailController,
                                        label: "email",
                                        hintText: "Enter email",
                                        sufficeIcon:
                                            Icons.account_circle_outlined,
                                        prefixIcon: Icons.email_outlined,
                                      ),
                                    ),

                                    /// number
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: CustomTextField(
                                        controller: numberController,
                                        label: "number",
                                        hintText: "Enter number",
                                        sufficeIcon: Icons.call,
                                        prefixIcon: Icons.phone_android,
                                      ),
                                    ),

                                    /// gender
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: CustomTextField(
                                        controller: genderController,
                                        label: "gender",
                                        hintText: "Enter gender",
                                        prefixIcon: Icons.man,
                                      ),
                                    ),

                                    /// age
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: CustomTextField(
                                        controller: ageController,
                                        label: "age",
                                        hintText: "Enter age",
                                        prefixIcon: Icons.person,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: CustomTextField(
                                        controller: passwordController,
                                        label: "password",
                                        hintText: "Enter password",
                                        sufficeIcon: Icons.remove_red_eye,
                                        prefixIcon: Icons.lock,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 70,
                                    )
                                  ],
                                ),

                                /// ----Register Button ---------Arrow button------------------///
                                Positioned(
                                  bottom: 10,
                                  right: 10,
                                  child: FloatingActionButton(
                                    onPressed: () async {
                                      var name = nameController.text.trim();
                                      var email = emailController.text.trim();
                                      var number = numberController.text.trim();
                                      var age = int.tryParse(
                                              ageController.text.trim()) ??
                                          0; // Safely parse age
                                      var gender = genderController.text.trim();
                                      var pass = passwordController.text.trim();

                                      var auth = FirebaseAuth.instance;
                                      try {
                                        // Create user with Firebase Authentication
                                        var userCredential = await auth
                                            .createUserWithEmailAndPassword(
                                          email: email,
                                          password: pass,
                                        );

                                        if (userCredential.user != null) {
                                          // User is successfully created
                                          print(
                                              'User created! UID: ${userCredential.user!.uid}');

                                          // Prepare Firestore instance
                                          var fireStore =
                                              FirebaseFirestore.instance;
                                          var collectionRef =
                                              fireStore.collection("users");

                                          // Create UserModel object with user details and initialize notes
                                          var userModel = UserModel(
                                            name: name,
                                            number: number,
                                            email: email,
                                            gender: gender,
                                            age: age,
                                          );

                                          // Store user details in Firestore under 'users' collection
                                          await collectionRef
                                              .doc(userCredential.user!.uid)
                                              .set(userModel.toDoc());

                                          print(
                                              'User details added to Firestore!');

                                          // Navigate to login or home screen
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const LoginScreen()),
                                          );
                                        } else {
                                          print("User creation failed!");
                                        }
                                      } on FirebaseAuthException catch (e) {
                                        // Handle FirebaseAuth errors
                                        print("Error: ${e.message}");
                                      } catch (e) {
                                        print(e);
                                      }
                                    },
                                    backgroundColor: Colors.orangeAccent,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    child: const Icon(
                                      Icons.arrow_forward,
                                      size: 30,
                                      shadows: [
                                        Shadow(
                                            color: Colors.black, blurRadius: 4)
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    ///------------------------bottom-------------box------------------------///
                    ClipPath(
                      clipper: BottomSidesClipper(),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          width: mqData!.size.width,
                          height: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: const Color(0xe7a0bfff),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(height: mqData!.size.height * 0.05),
                                const Text(
                                  'Already have an Account?',
                                  style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                SizedBox(
                                  width: mqData!.size.width * 0.7,
                                  height: mqData!.size.height * 0.05,
                                  child: CustomButton(
                                      text: "Login",
                                      onPress: () {
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const LoginScreen()));
                                      }),
                                ),
                              ],
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
    );
  }
}

// Custom Clipper for different side heights
class DifferentSidesClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    // Define different heights for each side
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(-20, size.height - 100);
    path.close(); // Complete the box
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

// Bottom Clipper for different side heights
class BottomSidesClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(0, -0);
    path.lineTo(size.width, 100);
    path.lineTo(size.width, size.height + 10);
    path.lineTo(0, size.height);
    path.close(); // Complete the box

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
