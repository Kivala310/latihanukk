import 'package:flutter/material.dart';
import 'package:ukk_5/main.dart';
// import 'beranda.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(120, 179, 206, 1),
      appBar: AppBar(
        title: Text('Sign up Page'),
        backgroundColor: Color.fromRGBO(201, 230, 240, 1),
        titleTextStyle: TextStyle(color: Colors.black),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: Column(
              children: [

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: TextFormField(
                    style: TextStyle(color: Colors.white),
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelStyle: TextStyle(color: Colors.white),
                      labelText: 'Username',
                      hintText: 'Enter Username',
                      prefixIcon: Icon(
                        Icons.person,
                        color: Colors.white,
                      ),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (String value) {},
                    validator: (value) {
                      return value!.isEmpty ? 'Please enter username' : null;
                    },
                  ),
                ),

                SizedBox(height: 30,),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: TextFormField(
                    style: TextStyle(color: Colors.white),
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelStyle: TextStyle(color: Colors.white),
                      labelText: 'Email',
                      hintText: 'Enter email',
                      prefixIcon: Icon(
                        Icons.email,
                        color: Colors.white,
                      ),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (String value) {},
                    validator: (value) {
                      return value!.isEmpty ? 'Please enter email' : null;
                    },
                  ),
                ),

                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: TextFormField(
                    style: TextStyle(color: Colors.white),
                    keyboardType: TextInputType.visiblePassword,
                    decoration: InputDecoration(
                      labelStyle: TextStyle(color: Colors.white),
                      labelText: 'Password',
                      hintText: 'Enter password',
                      prefixIcon: Icon(
                        Icons.password,
                        color: Colors.white,
                      ),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (String value) {},
                    validator: (value) {
                      return value!.isEmpty ? 'Please enter password' : null;
                    },
                  ),
                ),
                SizedBox(
                  height: 30,
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: TextFormField(
                    style: TextStyle(color: Colors.white),
                    keyboardType: TextInputType.visiblePassword,
                    decoration: InputDecoration(
                      labelStyle: TextStyle(color: Colors.white),
                      labelText: 'Confirm Password',
                      hintText: 'Confirm password',
                      prefixIcon: Icon(
                        Icons.password,
                        color: Colors.white,
                      ),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (String value) {},
                    validator: (value) {
                      return value!.isEmpty ? 'Please confirm password' : null;
                    },
                  ),
                ),

                SizedBox(height: 30,),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: ElevatedButton(
                    //minWidth: double.infinity,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MyApp())
                              );
                    },
                    child: Text('Sign In'),
                    //color: Colors.white,
                    //textColor: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
