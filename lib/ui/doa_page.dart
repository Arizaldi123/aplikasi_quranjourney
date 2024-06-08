import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quranjourney/cubit/doa_cubit.dart';
import 'package:quranjourney/cubit/doa_state.dart';
import 'package:quranjourney/data/api_services.dart';
import 'package:quranjourney/data/models/doa_model.dart';
import 'package:http/http.dart' as http;

class DoaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DoaCubit(ApiService(client: http.Client()))..fetchDoa(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Doa-Doa'),
        ),
        body: BlocBuilder<DoaCubit, DoaState>(
          builder: (context, state) {
            if (state is DoaLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is DoaLoaded) {
              return ListView.builder(
                itemCount: state.doa.length,
                itemBuilder: (context, index) {
                  final DoaModel doa = state.doa[index];
                  if (doa.judul != null && doa.arab != null && doa.indo != null) {
                    // Menampilkan data dari API 1
                    return _buildDoaCard(
                      index,
                      '${doa.judul}',
                      '${doa.indo}',
                      '${doa.arab}',
                    );
                  } else if (doa.title != null && doa.arabic != null && doa.translation != null && doa.latin != null) {
                    // Menampilkan data dari API 2
                    return _buildDoaCard(
                      index,
                      'Title: ${doa.title}',
                      'Latin: ${doa.latin}\nTranslation: ${doa.translation}',
                      'Arabic: ${doa.arabic}',
                    );
                  } else {
                    // Kasus jika data tidak sesuai dengan kriteria dari kedua API
                    return Card(
                      child: ListTile(
                        title: Text('Unknown data format'),
                      ),
                    );
                  }
                },
              );
            } else if (state is DoaError) {
              return Center(child: Text('Error: ${state.error}'));
            } else {
              return Center(child: Text('Start by fetching data'));
            }
          },
        ),
      ),
    );
  }

  Widget _buildDoaCard(int index, String title, String indo, String arab) {
    return Card(
      color: Colors.blue.shade900,
      child: ListTile(
        leading: Text((index + 1).toString(), style: TextStyle(fontSize: 15, color: Colors.white),), // Menambah nomor untuk doa
        title: Text(
        title,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,), // Mengatur warna teks menjadi putih
      ),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10), 
                  Text(arab, textAlign: TextAlign.right, style: TextStyle(color: Colors.white),), // Letakkan arab di atas indo
                  SizedBox(height: 10), // Spasi antara arab dan indo
                  Text(indo, textAlign: TextAlign.justify, style: TextStyle(color: Colors.white),),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Doa App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: DoaPage(),
    );
  }
}
