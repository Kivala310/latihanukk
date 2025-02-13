import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'beranda/home_page.dart';

class InsertPage extends StatefulWidget {
  @override
  _InsertPageState createState() => _InsertPageState();
}

class _InsertPageState extends State<InsertPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _namaprodukController = TextEditingController();
  final TextEditingController _hargaController = TextEditingController();
  final TextEditingController _stokController = TextEditingController();

  // Method to insert product data into Supabase
  Future<void> _addProduk() async {
    if (_formKey.currentState!.validate()) {
      final namaproduk = _namaprodukController.text;
      final harga = double.tryParse(_hargaController.text);
      final stok = int.tryParse(_stokController.text);

      // Validate input
      if (harga == null || stok == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Harga harus berupa angka desimal, Stok harus berupa angka bulat')),
        );
        return;
      }

      // Insert into Supabase
      final response = await Supabase.instance.client.from('produk').insert({
        'Nama Produk': namaproduk,
        'Harga': harga,
        'Stok': stok,
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
              'Produk berhasil ditambahkan',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.green,
          ),
        );

        // Clear the form
        _namaprodukController.clear();
        _hargaController.clear();
        _stokController.clear();

        // Navigate back to the home page
        Navigator.pop(context, true); // Indicate data was successfully added
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Produk'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _namaprodukController,
                decoration: InputDecoration(labelText: 'Nama Produk'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan Nama Produk!';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _hargaController,
                decoration: InputDecoration(labelText: 'Harga'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan Harga!';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Harga harus berupa angka desimal!';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _stokController,
                decoration: InputDecoration(labelText: 'Stok'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan Stok!';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Stok harus berupa angka bulat!';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Insert the product if the form is valid
                    _addProduk();
                  }
                },
                style: ElevatedButton.styleFrom(
    backgroundColor: Colors.blue, // Warna biru untuk tombol
    foregroundColor: Colors.white, // Warna teks pada tombol
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12), // Membuat sudut tombol melengkung
    ),
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12), // Padding tombol
  ),
                child: Text('Tambah Produk'),
                
              ),
            ],
          ),
        ),
      ),
    );
  }
}
