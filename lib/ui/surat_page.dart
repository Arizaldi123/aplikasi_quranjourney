import 'package:flutter/material.dart';
import 'package:quranjourney/common/contants.dart';
import 'package:quranjourney/cubit/surat_cubit.dart';
import 'package:quranjourney/ui/ayat_page.dart';
import 'package:quranjourney/ui/keterangansurat_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SuratPage extends StatefulWidget {
  const SuratPage({super.key});

  @override
  State<SuratPage> createState() => _SuratPageState();
}

class _SuratPageState extends State<SuratPage> {
  @override
  void initState() {
    context.read<SuratCubit>().getAllSurat();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Semua Surat')),
      body: BlocBuilder<SuratCubit, SuratState>(
        builder: (context, state) {
          if (state is SuratLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is SuratLoaded) {
            return ListView.builder(
              itemBuilder: (context, index) {
                final surat = state.listSurat[index];
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppColors.primary,
                      child: Text(
                        '${surat.nomor}',
                        style: const TextStyle(
                          color: AppColors.white,
                        ),
                      ),
                    ),
                    title: Text('${surat.namaLatin}, ${surat.nama}'),
                    subtitle: Text('${surat.arti}, ${surat.jumlahAyat} Ayat.'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return AyatPage(surat: surat);
                            }));
                          },
                          child: const Text('Baca'),
                        ),
                        const SizedBox(width: 8.0),
                        IconButton(
                          icon: const Icon(Icons.info),
                          color: Colors.blueAccent,
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              // Navigate to KeteranganSuratPage
                              return KeteranganSuratPage(surat: surat);
                            }));
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
              itemCount: state.listSurat.length,
            );
          }

          if (state is SuratError) {
            return Center(
              child: Text(state.message),
            );
          }

          return const Center(
            child: Text('no data'),
          );
        },
      ),
    );
  }
}
