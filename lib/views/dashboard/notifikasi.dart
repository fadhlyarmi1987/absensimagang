import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NotifikasiPage extends StatefulWidget {
  const NotifikasiPage({super.key});

  @override
  State<NotifikasiPage> createState() => _NotifikasiPageState();
}

class _NotifikasiPageState extends State<NotifikasiPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(0, -1),
                  stops: [0.3, 0.7],
                  radius: 1.5,
                  colors: [const Color.fromARGB(255, 193, 188, 188), const Color.fromARGB(255, 14, 142, 197)],
                ),
              ),
            ),
            
            Transform.translate(
              offset: Offset(0, 50),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Container(
                          width: double.infinity,
                          height: 150,
                          child: Card(
                            color: Colors.white,
                            child: Center(
                              child: Text('Tugas 3'),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Container(
                          width: double.infinity,
                          height: 150,
                          child: Card(
                            color: Colors.white,
                            child: Center(
                              child: Text('Tugas 2'),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 140),
                        child: Container(
                          width: double.infinity,
                          height: 150,
                          child: Card(
                            color: Colors.white,
                            child: Center(
                              child: Text('Tugas 1'),
                            ),
                          ),
                        ),
                      ),
                      
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        
        )
    ); 
      
    
  }
}