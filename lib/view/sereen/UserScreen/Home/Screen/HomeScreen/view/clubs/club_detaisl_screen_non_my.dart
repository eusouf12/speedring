import 'package:flutter/material.dart';

class ClubDetaislScreenNonMy extends StatelessWidget {
  const ClubDetaislScreenNonMy({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "CLUB DETAILS",
          style: TextStyle(
            color: Colors.amber,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        leading: const BackButton(color: Colors.amber),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Icon(Icons.more_vert, color: Colors.amber),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// Cover
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                Container(
                  height: 160,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                        "https://images.unsplash.com/photo-1503376780353-7e6692767b70",
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                Positioned(
                  bottom: -35,
                  child: Container(
                    height: 70,
                    width: 70,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      border: Border.all(color: Colors.white24),
                    ),
                    child: const Icon(Icons.shield, color: Colors.white),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 45),

            const Text(
              "PORSCHE GT3 COLLECTIVE",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w900,
                fontStyle: FontStyle.italic,
              ),
            ),

            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                  ),
                  onPressed: () {},
                  child: const Text(
                    "JOIN CLUB",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 25),

            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              color: const Color(0xff1B1B1B),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: const [
                        SizedBox(height: 20),

                        Text(
                          "MEMBERS",
                          style: TextStyle(color: Colors.grey, fontSize: 10),
                        ),

                        SizedBox(height: 5),

                        Text(
                          "1,240",
                          style: TextStyle(
                            color: Colors.amber,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        SizedBox(height: 20),
                      ],
                    ),
                  ),

                  Container(width: 1, height: 80, color: Colors.white12),

                  Expanded(
                    child: Column(
                      children: const [
                        SizedBox(height: 20),

                        Text(
                          "ACCESS",
                          style: TextStyle(color: Colors.grey, fontSize: 10),
                        ),

                        SizedBox(height: 5),

                        Text(
                          "PUBLIC",
                          style: TextStyle(
                            color: Colors.amber,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            Container(
              margin: const EdgeInsets.symmetric(horizontal: 12),
              padding: const EdgeInsets.all(16),
              color: const Color(0xff1B1B1B),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "About",
                    style: TextStyle(
                      color: Colors.amber,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 16),

                  Text(
                    "The Porsche GT3 Collective is an elite alliance dedicated to the pursuit of mechanical perfection. We focus exclusively on the GT3 lineage, prioritizing technical telemetry, precision driving, and structural engineering insights.",
                    style: TextStyle(
                      color: Colors.white70,
                      height: 1.6,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
