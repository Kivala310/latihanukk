import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_5/beranda/home_page.dart';
import 'package:ukk_5/beranda/produk_page.dart';
import 'package:ukk_5/main.dart';
import 'package:ukk_5/sign.dart';

// void main() {
//   runApp(const MyRoot());
// }

class MyRoot extends StatelessWidget {
  const MyRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyApp(),
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}


class _MyAppState extends State<MyApp> {
   
final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final SupabaseClient supabase = Supabase.instance.client;


  //fungsi login dengan memverifikasi username dan password di supabase
  Future<void> _login() async {
    final username = _usernameController.text;
    final password = _passwordController.text;

    try {
      final response = await supabase
          .from('user')
          .select('username, password')
          .eq('username', username)
          .maybeSingle();

      if (response == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Username tidak ditemukan!',style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
          ),
        );
        return;
      }

      if (response['password'] == password) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login berhasil!',style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.green,
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Password salah!',style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: ${e.toString()}',style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
        ),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      backgroundColor: Color.fromRGBO(120, 179, 206, 1),
      appBar: AppBar(
        title: Text('Fish & Coral Store'),
        backgroundColor: Color.fromRGBO(201, 230, 240, 1),
        titleTextStyle: TextStyle(color: Colors.black),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/logo.png',
            height: 180,
            width: 300,
          ),
          // Text(
          //   'Welcome',
          //   style: TextStyle(
          //       fontSize: 35, color: Colors.white, fontWeight: FontWeight.bold),
          // ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: TextFormField(
                    controller: _usernameController,
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
                    controller: _passwordController,
                    obscureText: true,
                    style: TextStyle(color: Colors.white),
                    keyboardType: TextInputType.visiblePassword,
                    decoration: InputDecoration(
                      //suffixIcon: Icon(Icons.remove_red_eye, color: Colors.white,),
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
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: ElevatedButton(
                    //minWidth: double.infinity,
                    onPressed: _login,
                    child: Text('Login'),
                    //color: Colors.white,
                    //textColor: Colors.black,
                  ),
                ),

                SizedBox(height: 30,),

                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 50),
                //   child: ElevatedButton(
                //     //minWidth: double.infinity,
                //     onPressed: () {
                //       Navigator.push(
                //           context,
                //           MaterialPageRoute(
                //               builder: (context) => const Signup())
                //               );
                //     },
                    //child: Text('Sign Up'),
                    //color: Colors.white,
                    //textColor: Colors.black,
                 ])
                ),
              ],
            ),
          );
    //     ],
    //   ),
    // );
  }
}
