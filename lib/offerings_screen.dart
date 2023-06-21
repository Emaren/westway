import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';

import 'products/first_screen.dart';
import 'services/second_screen.dart';

class OfferingsScreen extends StatelessWidget {
  final List<Recipe> Offerings = [
    Recipe('Data Hubs', 'a.png'),
    Recipe('Boosters', 'b.png'),
    Recipe('Antennas', 'c.png'),
    Recipe('Extenders', 'd.png'),
    Recipe('Links', 'e.png'),
    // Add more Offerings...
  ];

  OfferingsScreen({super.key});

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
        title: const Text('RigSat\'s Offerings'),
      ),
      body: ListView.builder(
        itemCount: Offerings.length +
            2, // Add 2 for the extra SizedBox and the bottom icons row

        itemBuilder: (context, index) {
          if (index == 0) {
            // Add space after the AppBar
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
                            builder: (context) => const FirstScreen()),
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
          index -= 1; // Subtract 1 so the index aligns with Offerings

          if (index == 3 || index == 6) {
            return Column(
              children: [
                const SizedBox(height: 20.0), // Add space before the AppBar
                AppBar(
                  title: Text(index == 0
                      ? 'RigSat\'s Offerings'
                      : 'Quintel\'s Offerings'),
                  backgroundColor: Color.fromARGB(
                      225, index == 3 ? 25 : 192, 0, index == 3 ? 163 : 1),
                ),
                const SizedBox(height: 20.0), // Add space after the AppBar
                buildRecipeCard(index),
              ],
            );
          }

          return Padding(
            padding: const EdgeInsets.symmetric(
                vertical: 1.0), // Add vertical padding around each recipe card
            child: buildRecipeCard(index),
          );
        },
      ),
      floatingActionButton: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 75, 18, 100),
              Color.fromARGB(255, 13, 0, 152),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          shape: BoxShape.circle,
        ),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const FirstScreen(),
              ),
            );
          },
          backgroundColor: Colors.transparent,
          child: const Icon(Icons.menu),
        ),
      ),
    );
  }

  Widget buildRecipeCard(int index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          children: [
            // This Flexible makes the image take up 50% of the card
            Flexible(
              flex: 1,
              child: FadeInImage(
                placeholder: const AssetImage('assets/h.png'),
                image: AssetImage('assets/${Offerings[index].imagePath}'),
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            // This Flexible makes the text take up the remaining 50% of the card
            Flexible(
              flex: 1,
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
                    InkWell(
                      child: const Text(
                        'Contact Tony for more information.',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                      onTap: () async {
                        var emailUri = Uri(
                          scheme: 'mailto',
                          path: 'tony@emaren.ca',
                          query: 'subject=More%20Information%20Required',
                        );

                        if (await canLaunchUrl(emailUri)) {
                          await launchUrl(emailUri);
                        } else {
                          throw 'Could not launch $emailUri';
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Recipe {
  final String name;
  final String imagePath;

  Recipe(this.name, this.imagePath);
}
