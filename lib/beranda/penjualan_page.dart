import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PenjualanPage extends StatefulWidget {
  const PenjualanPage({super.key});

  @override
  State<PenjualanPage> createState() => _PenjualanState();
}

class _PenjualanState extends State<PenjualanPage> {
  List<Map<String, dynamic>> produk = [];
  List<Map<String, dynamic>> pelanggan = [];
  Map<String, dynamic>? selectedProduk;
  Map<String, dynamic>? selectedPelanggan;
  final TextEditingController jumlahController = TextEditingController();
  num hargaTotal = 0;

  @override
  void initState() {
    super.initState();
    fetchProduk();
    fetchPelanggan();
  }

  Future<void> fetchProduk() async {
    try {
      final response = await Supabase.instance.client.from('produk').select();
      setState(() {
        produk = List<Map<String, dynamic>>.from(response ?? []);
      });
    } catch (e) {
      print('Error fetching products: $e');
    }
  }

  Future<void> fetchPelanggan() async {
    try {
      final response = await Supabase.instance.client.from('pelanggan').select();
      setState(() {
        pelanggan = List<Map<String, dynamic>>.from(response ?? []);
      });
    } catch (e) {
      print('Error fetching customers: $e');
    }
  }

  // Fungsi untuk memperbarui stok produk setelah transaksi
  Future<void> updateStokProduk(int produkID, int jumlah) async {
    try {
      final response = await Supabase.instance.client
          .from('produk')
          .select('Stok')
          .eq('ProdukID', produkID)
          .single();

      int currentStock = response['Stok'] ?? 0;

      if (currentStock >= jumlah) {
        final newStock = currentStock - jumlah;
        await Supabase.instance.client
            .from('produk')
            .update({'Stok': newStock})
            .eq('ProdukID', produkID);

        print('Stok produk berhasil diperbarui');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Stok produk tidak mencukupi!'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print('Error updating stock: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal memperbarui stok produk'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Fungsi untuk membuat transaksi
  Future<void> buatTransaksi() async {
    if (selectedProduk == null || selectedPelanggan == null || jumlahController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Harap lengkapi semua data'), backgroundColor: Colors.red),
      );
      return;
    }

    try {
      int jumlah = int.tryParse(jumlahController.text) ?? 0;
      hargaTotal = jumlah * (selectedProduk!['Harga'] ?? 0);

      if (jumlah <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Jumlah harus lebih dari 0'), backgroundColor: Colors.red),
        );
        return;
      }

      // Insert transaksi ke tabel penjualan
      final response = await Supabase.instance.client.from('penjualan').insert({
        'PelangganID': selectedPelanggan!['PelangganID'],
        'TanggalPenjualan': DateTime.now().toIso8601String(),
        'TotalHarga': hargaTotal,
      }).select();

      // Ambil PenjualanID dari response
      final penjualanID = response[0]['PenjualanID'];

      print('Penjualan berhasil dibuat dengan PenjualanID: $penjualanID');

      // Perbarui stok produk setelah transaksi
      await updateStokProduk(selectedProduk!['ProdukID'], jumlah);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Transaksi berhasil'), backgroundColor: Colors.green),
      );
      jumlahController.clear();
      setState(() {
        selectedProduk = null;
        selectedPelanggan = null;
        hargaTotal = 0; // Reset total harga
      });
    } catch (e) {
      print('Error creating transaction: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal membuat transaksi'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Penjualan')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dropdown untuk memilih pelanggan
            DropdownButtonFormField<Map<String, dynamic>>(
              decoration: const InputDecoration(labelText: 'Pilih Pelanggan'),
              value: selectedPelanggan,
              items: pelanggan.map((plg) {
                return DropdownMenuItem(
                  value: plg,
                  child: Text(plg['NamaPelanggan'] ?? 'Tanpa Nama'),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedPelanggan = value;
                });
              },
            ),
            const SizedBox(height: 10),

            // Dropdown untuk memilih produk
            DropdownButtonFormField<Map<String, dynamic>>(
              decoration: const InputDecoration(labelText: 'Pilih Produk'),
              value: selectedProduk,
              items: produk.map((prd) {
                return DropdownMenuItem(
                  value: prd,
                  child: Text(prd['NamaProduk'] ?? 'Tanpa Nama'),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedProduk = value;
                  // Update harga total saat produk dipilih
                  hargaTotal = (selectedProduk != null && jumlahController.text.isNotEmpty)
                      ? int.tryParse(jumlahController.text)! * (selectedProduk!['Harga'] ?? 0)
                      : 0;
                });
              },
            ),
            const SizedBox(height: 10),

            // Input untuk jumlah produk yang dibeli
            TextField(
              controller: jumlahController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Jumlah'),
              onChanged: (value) {
                setState(() {
                  // Update harga total saat jumlah diubah
                  int jumlah = int.tryParse(value) ?? 0;
                  hargaTotal = (selectedProduk != null) ? jumlah * (selectedProduk!['Harga'] ?? 0) : 0;
                });
              },
            ),
            const SizedBox(height: 10),

            // Menampilkan total harga
            Text('Total Harga: Rp ${hargaTotal.toStringAsFixed(2)}'),
            const SizedBox(height: 20),

            // Tombol untuk membuat transaksi
            ElevatedButton(
              onPressed: (selectedProduk != null && selectedPelanggan != null && jumlahController.text.isNotEmpty && int.tryParse(jumlahController.text) != null && int.tryParse(jumlahController.text)! > 0)
                  ? buatTransaksi
                  : null, // Tombol hanya aktif jika semua validasi terpenuhi
              child: const Text('Buat Transaksi'),
            ),
          ],
        ),
      ),
    );
  }
}
