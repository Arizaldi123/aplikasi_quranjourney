import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:quranjourney/globals.dart';
import 'package:quranjourney/ui/surat_page.dart';
import 'package:quranjourney/ui/asmaulhusna_page.dart';
import 'package:quranjourney/ui/doa_page.dart';
import 'package:quranjourney/ui/profil_page.dart';
import 'package:quranjourney/data/models/profil_model.dart';

class HomePage extends StatelessWidget {
  // Tambahkan GlobalKey
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, // Assign GlobalKey to Scaffold
      appBar: AppBar(
        backgroundColor: background,
        centerTitle: true,
        title: const Text(
          'Qur\'anJourney',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            // Gunakan GlobalKey untuk membuka drawer
            _scaffoldKey.currentState!.openDrawer();
          },
          icon: Icon(Icons.menu),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.search),
          ),
        ],
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        actionsIconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFF121931),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Profil Kelompok',
                    style: TextStyle(
                      fontSize: 21,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              title: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage('assets/profil_arizaldi.jpeg'),
                    radius: 30, // Ubah ukuran menjadi lebih besar
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Profil Arizaldi',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyProfilePage(profileData: arizaldiProfile)),
                );
              },
            ),
            ListTile(
              title: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage('assets/profil_salsa.jpeg'),
                    radius: 30, // Ubah ukuran menjadi lebih besar
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Profil Salsabila',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyProfilePage(profileData: salsaProfile)),
                );
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Assalamu\'alaikum',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: text,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Sobat Qur\'anJourney',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            CarouselSlider(
              items: [
                _buildCarouselItem(
                  'Selamat Datang di Aplikasi Qur\'anJourney',
                  AssetImage('assets/logo_quran.png'),
                ),
                _buildCarouselItem(
                  'Stay motivated!',
                  null,
                ),
              ],
              options: CarouselOptions(
                height: 200,
                enableInfiniteScroll: false,
                enlargeCenterPage: true,
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 3),
                onPageChanged: (index, reason) {},
              ),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [0, 1].map((index) {
                return Container(
                  width: 8.0,
                  height: 8.0,
                  margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: index == 0 ? Colors.white : Colors.grey,
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            _buildMenuButton('quran.png', 'Al Qur\'an', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SuratPage()),
              );
            }),
            SizedBox(height: 20),
            _buildMenuButton('doa.png', 'Doa-Doa', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DoaPage()),
              );
            }),
            SizedBox(height: 20),
            _buildMenuButton('asma_allah.png', '    Asmaul Husna', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AsmaulHusnaPage()),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildCarouselItem(String text, AssetImage? image) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFF121931),
        ),
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            if (image != null) ...[
              SizedBox(width: 20),
              Image(image: image, fit: BoxFit.contain, height: 100),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMenuButton(String imagePath, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity, // Lebar sesuai dengan parent
        height: 120, // Tinggi tetap 120
        decoration: BoxDecoration(
          color: Color(0xFF121931),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Ubah alignment menjadi spaceBetween
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 120),
              child: Image.asset(imagePath, height: 60),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 120),
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
