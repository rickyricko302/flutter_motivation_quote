class Quotes {
  String? q;
  String? nama;
  String? keterangan;
  String? sumber;

  Quotes({this.q, this.nama, this.keterangan, this.sumber});

  Quotes.fromJson(Map<String, dynamic> json) {
    q = json['q'];
    nama = json['nama'];
    keterangan =
        json['keterangan'].toString().isEmpty ? "-" : json['keterangan'];
    sumber = json['sumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['q'] = q;
    data['nama'] = nama;
    data['keterangan'] = keterangan;
    data['sumber'] = sumber;
    return data;
  }
}
