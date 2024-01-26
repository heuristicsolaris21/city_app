import 'package:city_app/nearbylocationmaps/bus.dart';
import 'package:city_app/nearbylocationmaps/hospital.dart';
import 'package:city_app/nearbylocationmaps/petrolbunk.dart';
import 'package:city_app/nearbylocationmaps/policestation.dart';
import 'package:city_app/nearbylocationmaps/railway.dart';
import 'package:flutter/material.dart';

class nearbymap extends StatefulWidget {
  const nearbymap({super.key});

  @override
  State<nearbymap> createState() => _nearbymapState();
}

class _nearbymapState extends State<nearbymap> with SingleTickerProviderStateMixin {
  late TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 5, vsync: this, initialIndex: 1);
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 70,
          backgroundColor: const Color.fromARGB(255, 11, 51, 83),
          title: Row(
            children: [
              Image.asset(
                'assets/cityapplogo.png',
                width: 100,
                height: 100,
              ),
            ],
          ),
          bottom: TabBar(
            controller: _controller,
            indicatorColor: Colors.white,
            tabs: const [
              Tab(
                icon: Icon(Icons.emoji_transportation),
              ),
              Tab(
                icon: Icon(Icons.directions_railway),
              ),
              Tab(
                icon: Icon(Icons.local_hospital_rounded),

              ),
              Tab(
                icon: Icon(Icons.local_police_outlined),

              ),
              Tab(
                icon: Icon(Icons.local_gas_station),
              )
            ],
          ),
        ),
        body: TabBarView(
          controller: _controller,
          children: [
            bus(),
            railway(),
            hospital(),
            policestation(),
            petrolbunk(),
          ],
        ),
      ),
    );
  }
}