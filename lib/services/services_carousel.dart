import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'service.dart';
import 'service_details.dart';

class ServicesCarousel extends StatefulWidget {
  const ServicesCarousel({Key? key}) : super(key: key);

  @override
  State<ServicesCarousel> createState() => _ServicesCarouselState();
}

class _ServicesCarouselState extends State<ServicesCarousel>
    with AutomaticKeepAliveClientMixin {
  final List<Service> services = [
    Service(
        title: 'Booster Tunes',
        description:
            'Boost your cellular signal strength to new heights with our professional Cell Booster Tune Up services. Experience seamless connectivity, faster data speeds, and crystal-clear call quality, ensuring you never miss an important call or suffer from frustrating signal drops again.'),
    Service(
      title: 'Trailer Rentals',
      description:
          'Boost your cellular signal strength to new heights with our tower trailer services. Experience seamless connectivity, faster data speeds, and crystal-clear call quality.',
    ),
    Service(
        title: 'StarLink Rentals',
        description:
            'Stay connected wherever you go with our cutting-edge StarLink Rentals, providing lightning-fast internet speeds and seamless coverage, ensuring you never miss a beat whether you\'re in the city or off the grid.'),
    Service(
        title: 'Intercom Rentals',
        description:
            'Enhance communication and coordination on your next project or event with our state-of-the-art Intercom Rentals, enabling clear and reliable voice transmission for efficient teamwork and flawless execution.'),
    Service(
        title: 'Gas Detectors',
        description:
            "Prioritize safety in any environment with our advanced Gas Detectors, offering precise and real-time monitoring of gas levels to safeguard lives and property, giving you peace of mind in hazardous situations."),
    Service(
        title: 'Video Surveillance',
        description:
            'Protect what matters most with our high-definition Video Surveillance solutions, offering comprehensive monitoring and recording capabilities, ensuring a secure and watchful eye over your home or business.'),
    Service(
        title: 'Rig Packages',
        description:
            'ake your production to the next level with our comprehensive Rig Packages, combining top-of-the-line equipment and accessories to meet all your Oil & Gas Communication needs, delivering exceptional results and unmatched versatility.'),
    Service(
        title: 'Intercoms',
        description:
            "Streamline communication and enhance efficiency with our reliable Intercom systems, providing seamless and crystal-clear voice transmission for instant collaboration, whether it's in large-scale productions or everyday business operations.")
  ];

  @override
  Widget build(BuildContext context) {
    super.build(context); // Don't forget to call super.build(context)
    return Column(
      children: [
        Expanded(
          child: Swiper(
            scrollDirection: Axis.vertical,
            itemCount: services.length,
            itemBuilder: (context, index) {
              return _buildServiceCard(index);
            },
            pagination: const SwiperPagination(),
          ),
        ),
        Expanded(
          child: Swiper(
            scrollDirection: Axis.horizontal,
            itemCount: services.length,
            itemBuilder: (context, index) {
              return _buildServiceCard(index);
            },
            pagination: const SwiperPagination(),
            control: const SwiperControl(),
            index: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildServiceCard(int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ServiceDetails(service: services[index]),
          ),
        );
      },
      child: Card(
        color: Colors.brown[50],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 5.0,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                services[index].title,
                textAlign: TextAlign.center,
                style: GoogleFonts.davidLibre(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                services[index].description,
                textAlign: TextAlign.center,
                style: GoogleFonts.lato(
                  fontSize: 18,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    var emailUri = Uri(
                      scheme: 'mailto',
                      path: 'tony@emaren.ca',
                      query: 'subject=Schedule%20A%20Service',
                    );

                    if (await canLaunchUrl(emailUri)) {
                      await launchUrl(emailUri);
                    } else {
                      throw 'Could not launch $emailUri';
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  ),
                  child: const Text(
                    'Schedule Now',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
