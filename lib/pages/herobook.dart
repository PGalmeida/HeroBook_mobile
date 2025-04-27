import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const HeroApp());
}

class HeroApp extends StatelessWidget {
  const HeroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF121212),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1F1F1F),
          elevation: 2,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Color(0xFF2C2C2C),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
        ),
      ),
      home: const HeroScreen(),
    );
  }
}

class HeroScreen extends StatefulWidget {
  const HeroScreen({super.key});

  @override
  _HeroScreenState createState() => _HeroScreenState();
}

class _HeroScreenState extends State<HeroScreen> {
  List<dynamic> heroList = [];
  List<dynamic> filteredHeroList = [];
  TextEditingController searchController = TextEditingController();
  final String apiKey = '1347897bfc65af5ef04c85933c7557d7';

  @override
  void initState() {
    super.initState();
    fetchHeroes('a');
  }

  Future<void> fetchHeroes(String query) async {
    try {
      final response = await http.get(
        Uri.parse('https://superheroapi.com/api.php/$apiKey/search/$query'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          heroList = data['results'] ?? [];
          filteredHeroList = heroList;
        });
      } else {
        throw Exception('Erro ao carregar heróis');
      }
    } catch (e) {
      print('Erro na requisição: $e');
    }
  }

  void filterHeroes(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredHeroList = heroList;
      });
    } else {
      fetchHeroes(query);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.shield, size: 28, color: Colors.white),
            const SizedBox(width: 8),
            Text(
              'HeroBook',
              style: GoogleFonts.limelight(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: searchController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'Buscar Herói...',
                prefixIcon: Icon(Icons.search, color: Colors.white),
                hintStyle: TextStyle(color: Colors.white54),
              ),
              onChanged: filterHeroes,
            ),
          ),
        ),
      ),
      body: filteredHeroList.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: const EdgeInsets.all(12.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: filteredHeroList.length,
              itemBuilder: (context, index) {
                final hero = filteredHeroList[index];
                final imageUrl = hero['image']['url'];

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HeroDetailScreen(id: hero['id']),
                      ),
                    );
                  },
                  child: Card(
                    color: const Color(0xFF1F1F1F),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(16)),
                            child: Image.network(
                              imageUrl,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.broken_image,
                                      size: 60, color: Colors.white70),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            hero['name'].toUpperCase(),
                            style: GoogleFonts.limelight(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class HeroDetailScreen extends StatelessWidget {
  final String id;
  final String apiKey = '1347897bfc65af5ef04c85933c7557d7';

  HeroDetailScreen({super.key, required this.id});

  Future<Map<String, dynamic>> fetchHeroDetails() async {
    final response = await http.get(
      Uri.parse('https://superheroapi.com/api.php/$apiKey/$id'),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception('Erro ao carregar detalhes do herói');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchHeroDetails(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final heroData = snapshot.data!;
          final imageUrl = heroData['image']['url'];

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    imageUrl,
                    height: 200,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  heroData['name'].toUpperCase(),
                  style: GoogleFonts.limelight(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                buildStat(
                    'Inteligência', heroData['powerstats']['intelligence']),
                buildStat('Força', heroData['powerstats']['strength']),
                buildStat('Velocidade', heroData['powerstats']['speed']),
                buildStat('Durabilidade', heroData['powerstats']['durability']),
                buildStat('Poder', heroData['powerstats']['power']),
                buildStat('Combate', heroData['powerstats']['combat']),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildStat(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text(
        '$label: $value',
        style: const TextStyle(
          fontSize: 18,
          color: Colors.white70,
        ),
      ),
    );
  }
}
