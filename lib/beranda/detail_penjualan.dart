Future<void> fetchDetailPenjualan() async {
  try {
    final response = await Supabase.instance.client
        .from('detail_transaksi')
        .select('DetailID, ProdukID, JumlahProduk, Subtotal')
        .eq('PenjualanID', widget.penjualanID)
        .execute();

    if (response.error != null) {
      // Menampilkan error jika terjadi
      print('Error fetching detail penjualan: ${response.error!.message}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengambil detail penjualan: ${response.error!.message}')),
      );
    } else {
      setState(() {
        detailPenjualan = List<Map<String, dynamic>>.from(response.data ?? []);
      });
    }
  } catch (e) {
    print('Error fetching detail penjualan: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Terjadi kesalahan saat mengambil data')),
    );
  }
}

Future<void> fetchTransaksi() async {
  try {
    final response = await Supabase.instance.client
        .from('penjualan')
        .select('PenjualanID, PelangganID, TanggalPenjualan, TotalHarga')
        .eq('PenjualanID', widget.penjualanID)
        .single()
        .execute();

    if (response.error != null) {
      // Menampilkan error jika terjadi
      print('Error fetching transaksi: ${response.error!.message}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengambil transaksi: ${response.error!.message}')),
      );
    } else {
      setState(() {
        transaksi = Map<String, dynamic>.from(response.data ?? {});
      });
    }
  } catch (e) {
    print('Error fetching transaksi: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Terjadi kesalahan saat mengambil data transaksi')),
    );
  }
}
