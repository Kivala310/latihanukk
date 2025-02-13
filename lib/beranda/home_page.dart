// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:ukk_5/login.dart';
// import '../insert.dart';

// class ProdukPage extends StatefulWidget {
//   const ProdukPage({super.key});

//   @override
//   State<ProdukPage> createState() => _ProdukPageState();
// }

// class _ProdukPageState extends State<ProdukPage> {
//   List<Map<String, dynamic>> produk = [];
//   // final String username = "Admin";
//   // final String profilePictureUrl =
//   //     "https://via.placeholder.com/150"; // Placeholder profile picture

//   @override
//   void initState() {
//     super.initState();
//     fetchProduk();
//   }

//   Future<void> fetchProduk() async {
//     try {
//       final response = await Supabase.instance.client.from('produk').select();
//       setState(() {
//         produk = List<Map<String, dynamic>>.from(response ?? []);
//       });
//     } catch (e) {
//       print('Error fetching products: $e');
//     }
//   }

//   Future<void> editProduk(Map<String, dynamic> produkData) async {
//     final TextEditingController namaController =
//         TextEditingController(text: produkData['Nama Produk']);
//     final TextEditingController hargaController =
//         TextEditingController(text: produkData['Harga'].toString());
//     final TextEditingController stokController =
//         TextEditingController(text: produkData['Stok'].toString());

//     await showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text('Edit Produk'),
//           content: SingleChildScrollView(
//             child: Column(
//               children: [
//                 TextField(
//                   controller: namaController,
//                   decoration: const InputDecoration(labelText: 'Nama Produk'),
//                 ),
//                 TextField(
//                   controller: hargaController,
//                   decoration: const InputDecoration(labelText: 'Harga'),
//                   keyboardType: TextInputType.number,
//                 ),
//                 TextField(
//                   controller: stokController,
//                   decoration: const InputDecoration(labelText: 'Stok'),
//                   keyboardType: TextInputType.number,
//                 ),
//               ],
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text('Batal'),
//             ),
//             ElevatedButton(
//               onPressed: () async {
//                 try {
//                   final updatedData = {
//                     'Nama Produk': namaController.text,
//                     'Harga': int.parse(hargaController.text),
//                     'Stok': int.parse(stokController.text),
//                   };
//                   await Supabase.instance.client
//                       .from('produk')
//                       .update(updatedData)
//                       .eq('ProdukID', produkData['ProdukID']);
//                   Navigator.pop(context);
//                   fetchProduk();
//                 } catch (e) {
//                   print('Error updating product: $e');
//                 }
//               },
//               child: const Text('Simpan'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 4,
//       child: Scaffold(
//         backgroundColor: const Color.fromRGBO(120, 179, 206, 1),
//         appBar: AppBar(
//           title: const Text('Fish & Coral Store'),
//           centerTitle: true,
//           backgroundColor: const Color.fromRGBO(201, 230, 240, 1),
//           bottom: const TabBar(
//             tabs: [
//               Tab(icon: Icon(Icons.store_mall_directory), text: 'Produk'),
//               Tab(icon: Icon(Icons.person), text: 'Pelanggan'),
//               Tab(icon: Icon(Icons.point_of_sale), text: 'Penjualan'),
//               Tab(icon: Icon(Icons.account_circle), text: 'Akun'),
//             ],
//           ),

//         ),
//         body: TabBarView(
//           children: [
//             produk.isEmpty
//                 ? const Center(child: CircularProgressIndicator())
//                 : Scaffold(
//                   backgroundColor: Color.fromRGBO(120, 179, 206, 1),
//                     body: ListView.builder(
//                       itemCount: produk.length,
//                       itemBuilder: (context, index) {
//                         final prd = produk[index];
//                         return Container(
//                           margin: const EdgeInsets.all(10),
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(15),
//                           ),
//                           child: ListTile(
//                             title: Text(
//                               prd['Nama Produk'] ?? 'Tidak ada produk',
//                               style: const TextStyle(
//                                   fontWeight: FontWeight.bold, fontSize: 18),
//                             ),
//                             subtitle: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   prd['Harga']?.toString() ?? 'Tidak ada Harga',
//                                   style: const TextStyle(
//                                       fontStyle: FontStyle.italic,
//                                       fontSize: 14),
//                                 ),
//                                 Text(
//                                   prd['Stok']?.toString() ?? 'Stok habis',
//                                   style: const TextStyle(
//                                       fontStyle: FontStyle.italic,
//                                       fontSize: 13),
//                                 ),
//                               ],
//                             ),
//                             trailing: Row(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 IconButton(
//                                   icon: const Icon(Icons.edit,
//                                       color: Colors.blue),
//                                   onPressed: () => editProduk(prd),
//                                 ),
//                                 IconButton(
//                                   icon: const Icon(Icons.delete,
//                                       color: Colors.red),
//                                   onPressed: () {
//                                   },
//                                 ),
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                     floatingActionButton: FloatingActionButton(
//                       onPressed: () async {
//                         final result = await Navigator.push(
//                           context,
//                           MaterialPageRoute(builder: (context) => InsertPage()),
//                         );
//                         if (result == true) {
//                           fetchProduk();
//                         }
//                       },
//                       backgroundColor: Colors.blue,
//                       child: const Icon(Icons.add, color: Colors.white),
//                     ),
//                   ),




//             // //Tab Pelanggan
//             // const Center(
//             //   child: Text('Halaman Pelanggan', style: TextStyle(fontSize: 20)),
//             // ),


//             // //Tab Penjualan
//             // const Center(
//             //   child: Text('Halaman Penjualan', style: TextStyle(fontSize: 20)),
//             // ),







//             // //Tab Akun
//             // Scaffold(
//             //   backgroundColor: Color.fromRGBO(120, 179, 206, 1),
//             //   body: Padding(
//             //     padding: const EdgeInsets.all(16.0),
//             //     child: Column(
//             //       crossAxisAlignment: CrossAxisAlignment.center,
//             //       children: [
//             //         Center(
//             //           child: CircleAvatar(
//             //             radius: 50,
//             //             backgroundImage: NetworkImage('https://storage.googleapis.com/fastwork-static/72183c4c-6ad6-4d9e-a614-3be59aab0088.jpg'),
//             //           ),
//             //         ),
//             //         const SizedBox(height: 20),
//             //         Text(
//             //           username,
//             //           style: const TextStyle(
//             //             fontSize: 24,
//             //             fontWeight: FontWeight.bold,
//             //           ),
//             //         ),
//             //         const SizedBox(height: 200),
//             //         ElevatedButton.icon(
//             //           onPressed: () {
//             //             Navigator.push(
//             //               context,
//             //               MaterialPageRoute(builder: (context) => MyRoot()),
//             //             );
//             //           },
//             //           icon: const Icon(Icons.logout, color: Colors.red),
//             //           label: const Text(
//             //             "Keluar",
//             //           style: TextStyle(color: Colors.red),
//             //             ),
//             //         ),
//             //       ],
//             //     ),
//             //   ),
//             // ),
//           ],
//         ),
//       ),
//     );
//   }
// }
