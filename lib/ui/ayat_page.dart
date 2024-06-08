import 'package:flutter/material.dart';
import 'package:quranjourney/bloc/ayat_bloc.dart';
import 'package:quranjourney/data/models/surat_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart'; // Import just_audio package
import '../common/contants.dart';

class AyatPage extends StatefulWidget {
  const AyatPage({
    Key? key,
    required this.surat,
  }) : super(key: key);
  final SuratModel surat;

  @override
  State<AyatPage> createState() => _AyatPageState();
}

class _AyatPageState extends State<AyatPage> {
  late AudioPlayer _audioPlayer; // Declare the audio player
  bool isPlaying = false; // Add a state variable to track audio status

  @override
  void initState() {
    super.initState();
    context.read<AyatBloc>().add(AyatGetEvent(noSurat: widget.surat.nomor));
    _audioPlayer = AudioPlayer(); // Initialize the audio player
  }

  @override
  void dispose() {
    _audioPlayer.dispose(); // Dispose the audio player
    super.dispose();
  }

  Future<void> playAudioFromUrl(String url) async {
    try {
      await _audioPlayer.setUrl(url);
      _audioPlayer.play();
      setState(() {
        isPlaying = true; // Update the state to indicate audio is playing
      });
    } catch (e) {
      print('Error playing audio: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to play audio: $e')),
      );
    }
  }

  void stopAudio() {
    _audioPlayer.stop();
    setState(() {
      isPlaying = false; // Update the state to indicate audio is stopped
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.surat.namaLatin,
        ),
      ),
      body: Column(
        children: [
          Center(
            child: ElevatedButton.icon(
              onPressed: () {
                if (isPlaying) {
                  stopAudio();
                } else {
                  final url = 'https://equran.nos.wjv-1.neo.id/audio-full/Misyari-Rasyid-Al-Afasi/${widget.surat.nomor.toString().padLeft(3, '0')}.mp3';
                  playAudioFromUrl(url);
                }
              },
              icon: Icon(isPlaying ? Icons.stop : Icons.play_arrow),
              label: Text(isPlaying ? 'Stop Audio Surah' : 'Play Audio Surah'),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: BlocBuilder<AyatBloc, AyatState>(
              builder: (context, state) {
                if (state is AyatLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (state is AyatLoaded) {
                  return ListView.builder(
                    itemBuilder: (context, index) {
                      final ayat = state.detail.ayat![index];
                      return Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: AppColors.primary,
                            child: Text(
                              '${ayat.nomor}',
                              style: const TextStyle(
                                color: AppColors.white,
                              ),
                            ),
                          ),
                          title: Text(
                            '${ayat.ar}',
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text('${ayat.idn}'),
                        ),
                      );
                    },
                    itemCount: state.detail.ayat!.length,
                  );
                }
                if (state is AyatError) {
                  return Center(
                    child: Text(state.message),
                  );
                }

                return const Center(
                  child: Text('no data'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
