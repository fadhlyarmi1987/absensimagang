import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AturLokasiPage extends StatefulWidget {
  @override
  _AturLokasiPageState createState() => _AturLokasiPageState();
}

class _AturLokasiPageState extends State<AturLokasiPage> {
  GoogleMapController? mapController;
  LatLng? selectedLatLng;
  String selectedKantorId =
      ''; // Kosongkan untuk memilih ID kantor secara dinamis
  final CollectionReference kantorRef =
      FirebaseFirestore.instance.collection('kantor');
  LatLng _initialPosition = LatLng(-7.922791, 112.592157);
  Map<String, dynamic>? kantorData;
  bool isEditingName = false;
  TextEditingController _nameController = TextEditingController();
  List<Map<String, dynamic>> kantorList = [];
  bool showAddIcon = false; // Untuk menampilkan icon tambah
  Set<Marker> allMarkers = {};

  @override
  void initState() {
    super.initState();
    _loadKantorList();
    _goToCurrentLocation();
  }

  Future<void> _loadKantorList() async {
    final querySnapshot = await kantorRef.get();
    final kantorDocs = querySnapshot.docs;

    List<Map<String, dynamic>> kantorDataList = [];
    Set<Marker> markers = {};

    for (var doc in kantorDocs) {
      final data = doc.data() as Map<String, dynamic>;
      final geoPoint = data['location'] as GeoPoint;
      final id = doc.id;
      final name = data['name'] ?? 'Tanpa Nama';

      kantorDataList.add({
        'id': id,
        'name': name,
        'location': data['location'],
      });

      markers.add(
        Marker(
          markerId: MarkerId(id),
          position: LatLng(geoPoint.latitude, geoPoint.longitude),
          infoWindow: InfoWindow(
            title: 'Nama Kantor: $id',
          ),
        ),
      );
    }

    setState(() {
      kantorList = kantorDataList;
      allMarkers = markers;

      if (kantorList.isNotEmpty) {
        selectedKantorId = kantorList[0]['id'];
        _loadSelectedKantorLocation();
      }
    });
  }

  Future<void> _loadSelectedKantorLocation() async {
    final doc = await kantorRef.doc(selectedKantorId).get();
    if (doc.exists) {
      final data = doc.data() as Map<String, dynamic>;
      final geoPoint = data['location'] as GeoPoint;

      setState(() {
        kantorData = data;
        selectedLatLng = LatLng(geoPoint.latitude, geoPoint.longitude);
        _initialPosition = selectedLatLng!;
        _nameController.text = data['name'] ?? '';
      });

      mapController?.animateCamera(
        CameraUpdate.newLatLng(selectedLatLng!),
      );
    }
  }

  Future<void> _saveLocation() async {
    if (selectedLatLng != null) {
      await kantorRef.doc(selectedKantorId).update({
        'location': GeoPoint(
          selectedLatLng!.latitude,
          selectedLatLng!.longitude,
        ),
      });

      // Menampilkan splash screen setelah menyimpan lokasi
      _showSplashScreen("Memperbarui Lokasi kantor ");
      //Navigator.pop(context);
      _loadKantorList(); // Refresh dropdown
    }
  }

  Future<void> _updateKantorName(String newName) async {
    if (selectedKantorId.isNotEmpty && newName.isNotEmpty) {
      final oldDocRef = kantorRef.doc(selectedKantorId);
      final newDocRef = kantorRef.doc(newName);

      final newDocSnapshot = await newDocRef.get();
      if (newDocSnapshot.exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Nama ini sudah digunakan sebagai ID.")),
        );
        return;
      }

      try {
        final oldDocSnapshot = await oldDocRef.get();

        if (oldDocSnapshot.exists) {
          final oldData = oldDocSnapshot.data() as Map<String, dynamic>;

          // Ubah field 'name'
          oldData['name'] = newName;

          // Buat dokumen baru
          await newDocRef.set(oldData);
          await oldDocRef.delete();

          // Set dulu ID baru agar Dropdown tidak error
          setState(() {
            selectedKantorId = newName;
          });

          // Lalu refresh daftar kantor
          await _loadKantorList();

          // Menampilkan splash screen setelah menyimpan nama kantor
          _showSplashScreen("Memperbarui Nama kantor");
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal memperbarui: $e")),
        );
      }
    }
  }

  Future<void> _deleteLocation() async {
    if (selectedKantorId.isNotEmpty) {
      await kantorRef.doc(selectedKantorId).delete();

      setState(() {
        selectedLatLng = null;
      });

      // Menampilkan splash screen setelah menghapus lokasi
      _showSplashScreen("Menghapus titik lokasi.");
    }
  }

  // Fungsi untuk menampilkan splash screen
  void _showSplashScreen(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromARGB(255, 235, 6, 6),
                  Colors.white,
                ],
                stops: [0.1, 0.6],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 10),
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeWidth: 4.0,
                ),
                SizedBox(height: 24),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: const Color.fromARGB(255, 64, 64, 64),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );

    Future.delayed(Duration(seconds: 2), () {
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Atur Lokasi Kantor"),
        backgroundColor: Colors.red.shade700,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Pilih Nama Kantor",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 8,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.location_on_outlined,
                              color: Colors.grey[700]),
                          const SizedBox(width: 12),
                          Expanded(
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                isExpanded: true,
                                value: selectedKantorId.isEmpty
                                    ? null
                                    : selectedKantorId,
                                hint: Text(
                                  "Pilih lokasi",
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                                items: kantorList.map((kantor) {
                                  return DropdownMenuItem<String>(
                                    value: kantor['id'],
                                    child: Text(kantor['name']),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  if (value != null) {
                                    setState(() {
                                      selectedKantorId = value;
                                    });
                                    _loadSelectedKantorLocation();
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: _initialPosition,
                    zoom: 16,
                  ),
                  onMapCreated: (controller) {
                    mapController = controller;
                  },
                  onTap: (LatLng latLng) {
                    setState(() {
                      selectedLatLng = latLng;
                      showAddIcon = true;
                    });
                  },
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  markers: {
                    ...allMarkers,
                    if (selectedLatLng != null)
                      Marker(
                        markerId: MarkerId('kantor_marker'),
                        position: selectedLatLng!,
                        draggable: true,
                        onDragEnd: (newPosition) {
                          setState(() {
                            selectedLatLng = newPosition;
                          });
                        },
                      ),
                  },
                ),
              ),
            ],
          ),
          // Container utama
          Stack(
            children: [
              // FAB Add dan Settings dibungkus dalam Column + Card
              Positioned(
                bottom: 100,
                right: 16,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                  color: Colors.white,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (showAddIcon && selectedLatLng != null)
                        IconButton(
                          icon: Icon(Icons.add, color: Colors.green, size: 28),
                          onPressed: _showquestAddLocationModal,
                        ),
                      IconButton(
                        icon:
                            Icon(Icons.settings, color: Colors.blue, size: 28),
                        onPressed: _showSettingModal,
                      ),
                      IconButton(
                        icon: Icon(Icons.my_location,
                            color: Colors.orange, size: 28),
                        onPressed: _goToCurrentLocation,
                      ),
                    ],
                  ),
                ),
              ),

              // Tombol Simpan Lokasi tetap paling bawah
              Positioned(
                bottom: 16,
                right: 16,
                child: FloatingActionButton.extended(
                  onPressed: _saveLocation,
                  label: Text("Simpan Lokasi"),
                  icon: Icon(Icons.save),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  // Fungsi untuk menampilkan modal pengaturan
  void _showSettingModal() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromARGB(255, 235, 6, 6),
                  Colors.white,
                ],
                stops: [0.06, 0.54],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Text(
                      'Pengaturan Kantor',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white, // judul putih
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Nama Kantor',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.blueAccent),
                      ),
                      prefixIcon: Icon(Icons.business),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.save),
                      label: Text('Update Nama Kantor'),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: Colors.blueAccent,
                      ),
                      onPressed: () {
                        String newName = _nameController.text.trim();
                        if (newName.isNotEmpty) {
                          _updateKantorName(newName);
                          Navigator.pop(context);
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.delete_forever),
                      label: Text('Hapus Lokasi'),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: Colors.redAccent,
                      ),
                      onPressed: () {
                        _deleteLocation();
                        Navigator.pop(context);
                        _loadKantorList();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Fungsi untuk menampilkan modal pertanyaan menambahkan lokasi kantor
  void _showquestAddLocationModal() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromARGB(255, 235, 6, 6),
                  Colors.white,
                ],
                stops: [0.06, 0.54],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Text(
                    'Tambah Lokasi',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.white, // Warna teks judul
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Anda akan menambahkan lokasi kantor baru.',
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      icon: Icon(Icons.close, color: Colors.white),
                      label: Text('Batal'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    SizedBox(width: 16),
                    ElevatedButton.icon(
                      icon: Icon(Icons.add_location_alt, color: Colors.white),
                      label: Text('Tambah Lokasi'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        Future.delayed(Duration(milliseconds: 200), () {
                          _showAddLocationModal();
                        });
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void _showAddLocationModal() {
    TextEditingController _newNameController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 24,
            right: 24,
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // drag handle
              Container(
                width: 40,
                height: 4,
                margin: EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(4),
                ),
              ),

              // title
              Text(
                'Tambah Lokasi Baru',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey[800],
                ),
              ),
              const SizedBox(height: 16),

              // input field
              TextField(
                controller: _newNameController,
                decoration: InputDecoration(
                  labelText: 'Masukkan Nama Lokasi',
                  prefixIcon: Icon(Icons.location_on),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // save button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: Icon(Icons.save),
                  label: Text('Simpan Lokasi'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: Colors.blueAccent,
                  ),
                  onPressed: () async {
                    final name = _newNameController.text.trim();
                    if (name.isNotEmpty && selectedLatLng != null) {
                      await kantorRef.doc(name).set({
                        'name': name,
                        'location': GeoPoint(
                          selectedLatLng!.latitude,
                          selectedLatLng!.longitude,
                        ),
                      });

                      setState(() {
                        showAddIcon = false;
                        _nameController.text = name;
                        selectedKantorId = name;
                      });

                      Navigator.pop(context);
                      _loadKantorList();
                      _showSplashScreen("Lokasi Berhasil Ditambahkan");
                    }
                  },
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  Future<void> _goToCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Layanan lokasi tidak aktif'),
          backgroundColor: const Color.fromARGB(255, 244, 22, 6),
        ),
      );
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Izin lokasi ditolak')),
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Izin lokasi ditolak permanen')),
      );
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    final currentLatLng = LatLng(position.latitude, position.longitude);

    // Arahkan kamera ke lokasi
    mapController?.animateCamera(CameraUpdate.newLatLng(currentLatLng));
  }
}
