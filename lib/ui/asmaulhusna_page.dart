import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quranjourney/cubit/asmaulhusna_cubit.dart';
import 'package:quranjourney/cubit/asmaulhusna_state.dart';
import 'package:quranjourney/data/api_services.dart';
import 'package:http/http.dart' as http;

class AsmaulHusnaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AsmaulHusnaCubit(ApiService(client: http.Client()))..fetchAsmaulHusna(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Asmaul Husna'),
        ),
        body: BlocBuilder<AsmaulHusnaCubit, AsmaulHusnaState>(
          builder: (context, state) {
            if (state is AsmaulHusnaLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is AsmaulHusnaLoaded) {
              return ListView.builder(
                itemCount: state.asmaulHusna.length,
                itemBuilder: (context, index) {
                  final item = state.asmaulHusna[index];
                  return Container(
                    padding: EdgeInsets.all(8.0),
                    child: Card(
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(8.0),
                        child: ListTile(
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${item.indo}',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 4), // Jarak antara teks Indo dan Latin
                              Text(
                                '${item.latin}',
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),
                            ],
                          ),
                          trailing: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '${item.arab}',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          leading: Stack(
                            alignment: Alignment.center,
                            children: [
                              Icon(Icons.brightness_5, size: 52),
                              Positioned(
                                top: 10,
                                child: Text(
                                  '${index + 1}',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            } else if (state is AsmaulHusnaError) {
              return Center(child: Text('Error: ${state.error}'));
            } else {
              return Center(child: Text('Start by fetching data'));
            }
          },
        ),
      ),
    );
  }
}
