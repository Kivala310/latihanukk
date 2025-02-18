import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DetailPenjualan extends StatefulWidget {
  final int penjualanID;

  const DetailPenjualan({super.key, required this.penjualanID});

  @override
  State<DetailPenjualan> createState() => _DetailPenjualanState();
}

class _DetailPenjualanState extends State<DetailPenjualan> {
  List<Map<String, dynamic>> detailPenjualan = [];
  Map<String, dynamic>? transaksi;

  @override
  void initState() {
    super.initState();
    fetchDetailPenjualan();
    fetchTransaksi();
  }

  // Mengambil detail transaksi dari tabel 'detail_transaksi'
  Future<void> fetchDetailPenjualan() async {
    try {
      final response = await Supabase.instance.client
          .from('detail_transaksi')
          .select('DetailID, ProdukID, JumlahProduk, Subtotal')
          .eq('PenjualanID', widget.penjualanID)
          .execute();

      if (response.error != null) {
        print('Error fetching detail penjualan: ${response.error?.message}');
      } else {
        setState(() {
          detailPenjualan = List<Map<String, dynamic>>.from(response.data ?? []);
        });
      }
    } catch (e) {
      print('Error fetching detail penjualan: $e');
    }
  }

  // Mengambil informasi transaksi (penjualan) dari tabel 'penjualan'
  Future<void> fetchTransaksi() async {
    try {
      final response = await Supabase.instance.client
          .from('penjualan')
          .select('PenjualanID, PelangganID, TanggalPenjualan, TotalHarga')
          .eq('PenjualanID', widget.penjualanID)
          .single()
          .execute();

      if (response.error != null) {
        print('Error fetching transaksi: ${response.error?.message}');
      } else {
        setState(() {
          transaksi = Map<String, dynamic>.from(response.data ?? {});
        });
      }
    } catch (e) {
      print('Error fetching transaksi: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Penjualan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: transaksi == null
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Menampilkan informasi transaksi
                  Text('Tanggal: ${transaksi!['TanggalPenjualan']}',
                      style: const TextStyle(fontSize: 18)),
                  Text('Total Harga: Rp ${transaksi!['TotalHarga'].toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 20),

                  // Menampilkan detail produk
                  const Text('Detail Produk:', style: TextStyle(fontSize: 20)),
                  Expanded(
                    child: detailPenjualan.isEmpty
                        ? const Center(child: CircularProgressIndicator())
                        : ListView.builder(
                            itemCount: detailPenjualan.length,
                            itemBuilder: (context, index) {
                              final detail = detailPenjualan[index];
                              return FutureBuilder<Map<String, dynamic>>(
                                future: fetchProduk(detail['ProdukID']),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return const Center(child: CircularProgressIndicator());
                                  } else if (snapshot.hasError || !snapshot.hasData) {
                                    return const ListTile(title: Text('Error loading product'));
                                  } else {
                                    final produk = snapshot.data!;
                                    return ListTile(
                                      title: Text(produk['NamaProduk'] ?? 'Unknown Product'),
                                      subtitle: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Jumlah: ${detail['JumlahProduk']}'),
                                          Text('Subtotal: Rp ${detail['Subtotal'].toStringAsFixed(2)}'),
                                        ],
                                      ),
                                    );
                                  }
                                },
                              );
                            },
                          ),
                  ),
                ],
              ),
      ),
    );
  }

  // Mengambil data produk berdasarkan ProdukID
  Future<Map<String, dynamic>?> fetchProduk(int produkID) async {
    try {
      final response = await Supabase.instance.client
          .from('produk')
          .select('NamaProduk')
          .eq('ProdukID', produkID)
          .single()
          .execute();

      if (response.error != null) {
        print('Error fetching product: ${response.error?.message}');
      } else {
        return Map<String, dynamic>.from(response.data ?? {});
      }
    } catch (e) {
      print('Error fetching product: $e');
      return null;
    }
  }
}





// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// class DetailPenjualan extends StatefulWidget {
//   const DetailPenjualan({super.key});

//   @override
//   State<DetailPenjualan> createState() => _DetailPenjualanState();
// }

// class _DetailPenjualanState extends State<DetailPenjualan> {
//   List<Map<String, dynamic>> detailPenjualan = [];

//   @override
//   void initState() {
//     super.initState();
//     fetchDetailPenjualan();
//   }

//   Future<void> fetchDetailPenjualan() async {
//     try {
//       // Fetch data dari tabel detailpenjualan
//       final detailPenjualanResponse = await Supabase.instance.client
//           .from('detailpenjualan')
//           .select()
//           .execute();
      
//       // Cek apakah ada error pada response
//       if (detailPenjualanResponse.error != null) {
//         print('Error fetching detail penjualan: ${detailPenjualanResponse.error?.message}');
//         return;
//       }

//       // Fetch data dari tabel produk
//       final produkResponse = await Supabase.instance.client
//           .from('produk')
//           .select()
//           .execute();

//       if (produkResponse.error != null) {
//         print('Error fetching produk: ${produkResponse.error?.message}');
//         return;
//       }

//       // Fetch data dari tabel penjualan
//       final penjualanResponse = await Supabase.instance.client
//           .from('penjualan')
//           .select()
//           .execute();

//       if (penjualanResponse.error != null) {
//         print('Error fetching penjualan: ${penjualanResponse.error?.message}');
//         return;
//       }

//       // Fetch data dari tabel pelanggan
//       final pelangganResponse = await Supabase.instance.client
//           .from('pelanggan')
//           .select()
//           .execute();

//       if (pelangganResponse.error != null) {
//         print('Error fetching pelanggan: ${pelangganResponse.error?.message}');
//         return;
//       }

//       // Gabungkan data sesuai dengan kebutuhan
//       List<Map<String, dynamic>> dataGabungan = [];

//       // Gabungkan data detailPenjualan dengan produk, penjualan, dan pelanggan
//       for (var transaksi in detailPenjualanResponse.data) {
//         final produk = produkResponse.data.firstWhere(
//             (item) => item['ProdukID'] == transaksi['ProdukID'],
//             orElse: () => {});
//         final penjualan = penjualanResponse.data.firstWhere(
//             (item) => item['PenjualanID'] == transaksi['PenjualanID'],
//             orElse: () => {});
//         final pelanggan = pelangganResponse.data.firstWhere(
//             (item) => item['PelangganID'] == penjualan['PelangganID'],
//             orElse: () => {});

//         // Gabungkan data dari setiap tabel
//         dataGabungan.add({
//           ...transaksi,
//           'NamaProduk': produk['NamaProduk'] ?? 'Produk Tidak Ditemukan',
//           'NamaPelanggan': pelanggan['NamaPelanggan'] ?? 'Pelanggan Tidak Ditemukan',
//           'TanggalPenjualan': penjualan['TanggalPenjualan'] ?? 'Tanggal Tidak Ditemukan',
//           'TotalHarga': penjualan['TotalHarga'] ?? 0.0,
//         });
//       }

//       setState(() {
//         detailPenjualan = dataGabungan;
//       });

//     } catch (e) {
//       print('Error fetching detail penjualan: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Detail Penjualan'),
//         centerTitle: true,
//         backgroundColor: Colors.green,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: detailPenjualan.isEmpty
//             ? const Center(child: CircularProgressIndicator())
//             : ListView.builder(
//                 itemCount: detailPenjualan.length,
//                 itemBuilder: (context, index) {
//                   final transaksi = detailPenjualan[index];
//                   return Card(
//                     margin: const EdgeInsets.symmetric(vertical: 8.0),
//                     child: ListTile(
//                       title: Text(
//                           'Penjualan ID: ${transaksi['PenjualanID']} - ${transaksi['NamaPelanggan']}'),
//                       subtitle: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text('Produk: ${transaksi['NamaProduk']}'),
//                           Text('Jumlah Produk: ${transaksi['JumlahProduk']}'),
//                           Text(
//                               'Subtotal: Rp ${transaksi['Harga']?.toStringAsFixed(2)}'),
//                           Text('Tanggal Penjualan: ${transaksi['TanggalPenjualan']}'),
//                           Text(
//                               'Total Harga: Rp ${transaksi['TotalHarga']?.toStringAsFixed(2)}'),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//       ),
//     );
//   }
// }
