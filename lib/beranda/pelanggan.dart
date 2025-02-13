import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_5/insert_pelanggan.dart';
import 'package:ukk_5/login.dart';
import '../insert.dart';

class PelangganPage extends StatefulWidget {
  const PelangganPage({super.key});

  @override
  State<PelangganPage> createState() => _PelangganPageState();
}

class _PelangganPageState extends State<PelangganPage> {
  List<Map<String, dynamic>> pelanggan = [];
  // final String username = "Admin";
  // final String profilePictureUrl =
  //     "https://via.placeholder.com/150"; // Placeholder profile picture

  @override
  void initState() {
    super.initState();
    fetchPelanggan();
  }

  Future<void> fetchPelanggan() async {
    try {
      final response = await Supabase.instance.client.from('pelanggan').select();
      setState(() {
        pelanggan = List<Map<String, dynamic>>.from(response ?? []);
      });
    } catch (e) {
      print('Error fetching pelanggan: $e');
    }
  }

  Future<void> editPelanggan(Map<String, dynamic> pelangganData) async {
    final TextEditingController namaController =
        TextEditingController(text: pelangganData['Nama Pelanggan']);
    final TextEditingController alamatController =
        TextEditingController(text: pelangganData['Alamat'].toString());
    final TextEditingController notelpController =
        TextEditingController(text: pelangganData['No Telp'].toString());

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Pelanggan'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: namaController,
                  decoration: const InputDecoration(labelText: 'Nama Pelanggan'),
                ),
                TextField(
                  controller: alamatController,
                  decoration: const InputDecoration(labelText: 'Alamat'),
                  //keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: notelpController,
                  decoration: const InputDecoration(labelText: 'No Telp'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  final updatedData = {
                    'Nama Pelanggan': namaController.text,
                    'Alamat': alamatController.text,
                    'No Telp': notelpController.text,
                  };
                  await Supabase.instance.client
                      .from('pelanggan')
                      .update(updatedData)
                      .eq('PelangganID', pelangganData['PelangganID']);
                  Navigator.pop(context);
                  fetchPelanggan();
                } catch (e) {
                  print('Error updating pelanggan: $e');
                }
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(120, 179, 206, 1),
        //appBar: AppBar(
          // title: const Text('Fish & Coral Store'),
          // centerTitle: true,
          // backgroundColor: const Color.fromRGBO(201, 230, 240, 1),
          // bottom: const TabBar(
          //   tabs: [
          //     Tab(icon: Icon(Icons.store_mall_directory), text: 'Produk'),
          //     Tab(icon: Icon(Icons.person), text: 'Pelanggan'),
          //     Tab(icon: Icon(Icons.point_of_sale), text: 'Penjualan'),
          //     Tab(icon: Icon(Icons.account_circle), text: 'Akun'),
          //   ],
          // ),

        //),
        body: TabBarView(
          children: [
            pelanggan.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : Scaffold(
                  backgroundColor: Color.fromRGBO(120, 179, 206, 1),
                    body: ListView.builder(
                      itemCount: pelanggan.length,
                      itemBuilder: (context, index) {
                        final plg = pelanggan[index];
                        return Container(
                          margin: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: ListTile(
                            title: Text(
                              plg['Nama Pelanggan'] ?? 'Tidak ada pelanggan',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  plg['Alamat']?.toString() ?? 'Tidak ada Alamat',
                                  style: const TextStyle(
                                      fontStyle: FontStyle.italic,
                                      fontSize: 14),
                                ),
                                Text(
                                  plg['No Telp']?.toString() ?? 'Tidak ada No Telp',
                                  style: const TextStyle(
                                      fontStyle: FontStyle.italic,
                                      fontSize: 13),
                                ),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit,
                                      color: Colors.blue),
                                  onPressed: () => (plg),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () {
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    floatingActionButton: FloatingActionButton(
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => InsertPelangganPage()),
                        );
                        if (result == true) {
                          fetchPelanggan();
                        }
                      },
                      backgroundColor: Colors.blue,
                      child: const Icon(Icons.add, color: Colors.white),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
