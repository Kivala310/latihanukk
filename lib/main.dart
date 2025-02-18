import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_5/beranda/akun_page.dart';
import 'package:ukk_5/beranda/detail_penjualan.dart';
import 'package:ukk_5/beranda/home_page.dart';
import 'package:ukk_5/beranda/pelanggan.dart';
import 'package:ukk_5/beranda/penjualan_page.dart';
import 'package:ukk_5/beranda/produk_page.dart';
import 'package:ukk_5/login.dart';
//import 'package:ukk_5/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
      url: 'https://zwntqpxkxjqrxmjhuagd.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inp3bnRxcHhreGpxcnhtamh1YWdkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzc0Mjk0NTksImV4cCI6MjA1MzAwNTQ1OX0.mlI3GSWQ7TjQUkK7hNDTUOvwr_1ymqMU4l9s0xQOfy8');
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Fish & Coral Store',
      home: MyRoot(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Fish & Coral Store'),
          centerTitle: true,
          backgroundColor: const Color.fromRGBO(201, 230, 240, 1),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.store), text: 'Produk'),
              Tab(icon: Icon(Icons.point_of_sale), text: 'Penjualan'),
              Tab(icon: Icon(Icons.people), text: 'Pelanggan'),
              Tab(icon: Icon(Icons.account_circle), text: 'Akun'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            Produk(),
            PenjualanPage(),
            DetailPenjualan(),
            Pelanggan(),
            AkunPage(),
          ],
        ),
      ),
    );
  }
}
