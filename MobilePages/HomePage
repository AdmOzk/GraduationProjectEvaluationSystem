import 'package:evaluation_project/View/Components/BottomNavigationBarComponent.dart';
import 'package:evaluation_project/View/pages/EvaluateList.dart';
import 'package:evaluation_project/View/pages/ResultOfEvaluation.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Anasayfa", style: TextStyle(fontSize: 24)), // Başlık yazı büyüklüğü
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // İlk buton
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EvaluateList()),
                );
              },
              icon: Icon(Icons.add_box_sharp, size: 36), // Simge büyüklüğü
              label: Text("Projeleri Değerlendir", style: TextStyle(fontSize: 20)), // Buton yazısı büyüklüğü
              style: ElevatedButton.styleFrom(
                minimumSize: Size(300, 80), // Buton boyutu
                textStyle: TextStyle(fontSize: 20), // Buton yazı stili
              ),
            ),
            const SizedBox(height: 30), // Butonlar arası boşluk
            // İkinci buton
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ResultOfEvaluation()),
                );
              },
              icon: Icon(Icons.movie, size: 36),
              label: Text("Proje Sonuçlarını Gör", style: TextStyle(fontSize: 20)),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(300, 80),
                textStyle: TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavigationBarComponent(),
    );
  }
}
