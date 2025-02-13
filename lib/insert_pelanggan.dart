import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'beranda/home_page.dart';

class InsertPelangganPage extends StatefulWidget {
  @override
  _InsertPelangganPageState createState() => _InsertPelangganPageState();
}

class _InsertPelangganPageState extends State<InsertPelangganPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _namapelangganController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _notelpController = TextEditingController();

  // Method to insert product data into Supabase
  Future<void> _addPelanggan() async {
    if (_formKey.currentState!.validate()) {
      final namapelanggan = _namapelangganController.text;
      final alamat = _alamatController.text;
      final notelp = _notelpController.text;

      // Validate input
      // if (alamat == null || notelp == null) {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(content: Text('Tidak boleh kosong')),
      //   );
      //   return;
      // }

      // Insert into Supabase
      final response = await Supabase.instance.client.from('pelanggan').insert({
        'Nama Pelanggan': namapelanggan,
        'Alamat': alamat,
        'No Telp': notelp,
      });

      // Check for errors in the response
      if (response != null) {
        // Display the actual error message from Supabase
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${response.error!.message}')),
        );
      } else {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Pelanggan berhasil ditambahkan',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.green,
          ),
        );

        // Clear the form
        _namapelangganController.clear();
        _alamatController.clear();
        _notelpController.clear();

        // Navigate back to the home page
        Navigator.pop(context, true); // Indicate data was successfully added
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Pelanggan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _namapelangganController,
                decoration: InputDecoration(labelText: 'Nama Pelanggan'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan Nama Pelanggan!';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _alamatController,
                decoration: InputDecoration(labelText: 'Alamat'),
                //keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan Alamat!';
                  }
                  // if (double.tryParse(value) == null) {
                  //   return 'Harga harus berupa angka desimal!';
                  // }
                  return null;
                },
              ),
              TextFormField(
                controller: _notelpController,
                decoration: InputDecoration(labelText: 'No Telp'),
                //keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan No Telp!';
                  }
                  // if (int.tryParse(value) == null) {
                  //   return 'Stok harus berupa angka bulat!';
                  // }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Insert the product if the form is valid
                    _addPelanggan();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Warna biru untuk tombol
                  foregroundColor: Colors.white, // Warna teks pada tombol
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        12), // Membuat sudut tombol melengkung
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 12), // Padding tombol
                ),
                child: Text('Tambah Pelanggan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
