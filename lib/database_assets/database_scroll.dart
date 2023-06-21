import 'package:flutter/material.dart';

import '../services/second_screen.dart';
import 'assets_display_page.dart';

class DatabaseScroll extends StatelessWidget {
  final List<Asset> Offerings = [
    Asset('Boosters', 'b.png'),
    Asset('Gas Detectors', 'PGD1.png'),
    Asset('Intercom', 'li.png'),
    Asset('Internet & Cell Phone', 'image-20.png'),
    Asset('Radios & Gang Chargers', '2-way-radios.png'),
    Asset('Confer & Blue T', 'image-6.png'),
    Asset('Satellite', 'image-10.png'),
    Asset('Security & Mobile Cell Towers',
        'Mobile-Security-Trailer-2048x1536.jpg'),
    Asset('Monitors', 'laptop-1.png'),
  ];

  DatabaseScroll({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 192, 1, 1),
                Color.fromARGB(255, 88, 0, 0),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        title: const Text('Database Scroll'),
      ),
      body: ListView.builder(
        itemCount: Offerings.length + 2,
        itemBuilder: (context, index) {
          if (index == 0) {
            return const SizedBox(height: 19.0);
          }
          if (index == Offerings.length + 1) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AssetsDisplayPage(),
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.build),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SecondScreen()),
                      );
                    },
                  ),
                ],
              ),
            );
          }
          index -= 1;

          if (index == 3 || index == 5) {
            return Column(
              children: [
                const SizedBox(height: 20.0),
                AppBar(
                  title: Text(index == 0 ? 'Assets' : 'Boosters'),
                  backgroundColor: index == 3
                      ? const Color.fromARGB(255, 3, 0, 193)
                      : Colors.transparent,
                ),
                const SizedBox(height: 20.0),
                buildAssetCard(index, context),
              ],
            );
          }

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 1.0),
            child: buildAssetCard(index, context),
          );
        },
      ),
    );
  }

  Widget buildAssetCard(int index, BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AssetsDisplayPage(),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            children: [
              Flexible(
                flex: 1,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: FadeInImage(
                    placeholder: const AssetImage('assets/h.png'),
                    image: AssetImage('assets/${Offerings[index].imagePath}'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Flexible(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Offerings[index].name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 24,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Total: 11          Working: 7 \n\n In Repair: 2    In Transit: 1',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Asset {
  final String name;
  final String imagePath;

  Asset(this.name, this.imagePath);
}
