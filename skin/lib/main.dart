import 'package:flutter/material.dart';
import 'dart:convert';

// Enhanced product data model with more fields
const String productData = '''
[
  {
    "name": "Moisturizing Cream",
    "brand": "Brand A",
    "price": 29.99,
    "rating": 4.5,
    "reviews": 128,
    "ingredients": ["Water", "Glycerin", "Aloe Vera", "Vitamin E", "Jojoba Oil"],
    "suitableFor": ["Dry", "Sensitive"],
    "benefits": ["Hydration", "Soothing", "Anti-aging"],
    "description": "A rich, nourishing cream that provides lasting hydration and helps strengthen the skin barrier.",
    "imageUrl": "moisturizer.jpg",
    "size": "50ml"
  },
  {
    "name": "Hydrating Serum",
    "brand": "Brand B",
    "price": 39.99,
    "rating": 4.8,
    "reviews": 256,
    "ingredients": ["Hyaluronic Acid", "Vitamin C", "Niacinamide", "Peptides"],
    "suitableFor": ["Normal", "Oily"],
    "benefits": ["Hydration", "Brightening", "Anti-oxidant"],
    "description": "A lightweight serum that delivers intense hydration and helps brighten skin tone.",
    "imageUrl": "serum.jpg",
    "size": "30ml"
  },
  {
    "name": "Soothing Gel",
    "brand": "Brand C",
    "price": 19.99,
    "rating": 4.3,
    "reviews": 189,
    "ingredients": ["Aloe Vera", "Cucumber Extract", "Green Tea", "Centella Asiatica"],
    "suitableFor": ["Combination", "Sensitive"],
    "benefits": ["Calming", "Cooling", "Oil-control"],
    "description": "A refreshing gel that calms irritated skin and provides oil-free hydration.",
    "imageUrl": "gel.jpg",
    "size": "100ml"
  }
]
''';

void main() {
  runApp(const MyApp());
}

// App theme and styling
class AppTheme {
  static const primaryColor = Color(0xFF6B9080);
  static const accentColor = Color(0xFFA4C3B2);
  static const backgroundColor = Color(0xFFF6FFF8);
  static const textColor = Color(0xFF284B63);

  static ThemeData get theme => ThemeData(
        primaryColor: primaryColor,
        scaffoldBackgroundColor: backgroundColor,
        appBarTheme: const AppBarTheme(
          backgroundColor: primaryColor,
          elevation: 0,
          centerTitle: true,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        cardTheme: CardTheme(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: primaryColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: primaryColor, width: 2),
          ),
        ),
      );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Skincare Advisor',
      theme: AppTheme.theme,
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<String> selectedSkinTypes = [];
  List<String> selectedBenefits = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'Skincare Advisor',
                style: TextStyle(color: Colors.white),
              ),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [AppTheme.primaryColor, AppTheme.accentColor],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SearchBar(controller: _searchController),
                  const SizedBox(height: 24),
                  const Text(
                    'Skin Type',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SkinTypeFilter(
                    selectedTypes: selectedSkinTypes,
                    onChanged: (types) {
                      setState(() => selectedSkinTypes = types);
                    },
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Benefits',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  BenefitsFilter(
                    selectedBenefits: selectedBenefits,
                    onChanged: (benefits) {
                      setState(() => selectedBenefits = benefits);
                    },
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RecommendationScreen(
                              searchQuery: _searchController.text,
                              selectedSkinTypes: selectedSkinTypes,
                              selectedBenefits: selectedBenefits,
                            ),
                          ),
                        );
                      },
                      child: const Text('Find Products'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SearchBar extends StatelessWidget {
  final TextEditingController controller;

  const SearchBar({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: 'Search products...',
        prefixIcon: const Icon(Icons.search, color: AppTheme.primaryColor),
        suffixIcon: IconButton(
          icon: const Icon(Icons.clear, color: AppTheme.primaryColor),
          onPressed: () => controller.clear(),
        ),
      ),
    );
  }
}

class SkinTypeFilter extends StatelessWidget {
  final List<String> selectedTypes;
  final Function(List<String>) onChanged;

  const SkinTypeFilter({
    Key? key,
    required this.selectedTypes,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final skinTypes = ['Combination', 'Dry', 'Normal', 'Oily', 'Sensitive'];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: skinTypes.map((type) {
        final isSelected = selectedTypes.contains(type);
        return FilterChip(
          label: Text(type),
          selected: isSelected,
          onSelected: (selected) {
            final newTypes = List<String>.from(selectedTypes);
            if (selected) {
              newTypes.add(type);
            } else {
              newTypes.remove(type);
            }
            onChanged(newTypes);
          },
          selectedColor: AppTheme.accentColor,
          checkmarkColor: AppTheme.primaryColor,
        );
      }).toList(),
    );
  }
}

class BenefitsFilter extends StatelessWidget {
  final List<String> selectedBenefits;
  final Function(List<String>) onChanged;

  const BenefitsFilter({
    Key? key,
    required this.selectedBenefits,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final benefits = [
      'Hydration',
      'Anti-aging',
      'Brightening',
      'Calming',
      'Oil-control'
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: benefits.map((benefit) {
        final isSelected = selectedBenefits.contains(benefit);
        return FilterChip(
          label: Text(benefit),
          selected: isSelected,
          onSelected: (selected) {
            final newBenefits = List<String>.from(selectedBenefits);
            if (selected) {
              newBenefits.add(benefit);
            } else {
              newBenefits.remove(benefit);
            }
            onChanged(newBenefits);
          },
          selectedColor: AppTheme.accentColor,
          checkmarkColor: AppTheme.primaryColor,
        );
      }).toList(),
    );
  }
}

class RecommendationScreen extends StatelessWidget {
  final String searchQuery;
  final List<String> selectedSkinTypes;
  final List<String> selectedBenefits;

  const RecommendationScreen({
    Key? key,
    required this.searchQuery,
    required this.selectedSkinTypes,
    required this.selectedBenefits,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<dynamic> products = json.decode(productData);
    final filteredProducts = products.where((product) {
      final matchesSearch = searchQuery.isEmpty ||
          product['name']
              .toString()
              .toLowerCase()
              .contains(searchQuery.toLowerCase());
      final matchesSkinType = selectedSkinTypes.isEmpty ||
          selectedSkinTypes
              .any((type) => product['suitableFor'].contains(type));
      final matchesBenefits = selectedBenefits.isEmpty ||
          selectedBenefits.any((benefit) => product['benefits'].contains(benefit));
      return matchesSearch && matchesSkinType && matchesBenefits;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recommended Products'),
      ),
      body: filteredProducts.isEmpty
          ? const Center(
              child: Text(
                'No products found matching your criteria',
                style: TextStyle(fontSize: 16, color: AppTheme.textColor),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                return ProductCard(product: filteredProducts[index]);
              },
            ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final dynamic product;

  const ProductCard({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductDetailsScreen(product: product),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product['name'],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          product['brand'],
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '\$${product['price'].toString()}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.star,
                    size: 20,
                    color: Colors.amber[700],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    product['rating'].toString(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '(${product['reviews']} reviews)',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: (product['benefits'] as List)
                    .map((benefit) => Chip(
                          label: Text(
                            benefit,
                            style: const TextStyle(fontSize: 12),
                          ),
                          backgroundColor: AppTheme.accentColor.withOpacity(0.2),
                        ))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProductDetailsScreen extends StatelessWidget {
  final dynamic product;

  const ProductDetailsScreen({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product['name']),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    offset: Offset(0, 2),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product['brand'],
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product['name'],
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Text(
                        '\$${product['price']}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        product['size'],
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product['description'],
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Benefits',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: (product['benefits'] as List)
                        .map((benefit) => Chip(
                              label: Text(benefit),
                              backgroundColor: AppTheme.accentColor.withOpacity(0.2),
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Suitable For',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: (product['suitableFor'] as List)
                        .map((type) => Chip(
                              label: Text(type),
                              backgroundColor: AppTheme.accentColor.withOpacity(0.2),
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Ingredients',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    (product['ingredients'] as List).join(', '),
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Added to cart'),
                            backgroundColor: AppTheme.primaryColor,
                          ),
                        );
                      },
                      child: const Text('Add to Cart'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}



