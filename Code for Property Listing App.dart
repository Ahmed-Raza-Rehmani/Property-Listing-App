import 'package:flutter/material.dart';
import 'package:flutter_weather_app/weather_app.dart';
import 'package:flutter/rendering.dart';

void  main() { 
  
  runApp(Myapp());
debugPaintSizeEnabled = false;
}
class Myapp extends StatelessWidget{
  const Myapp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ScreenListing(),
      
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: 
        false,
        primarySwatch: Colors.grey,
        appBarTheme: const AppBarTheme(
          backgroundColor:  Colors.grey,
        ),
      ),
    );
    
  }
}
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';

class ScreenListing extends StatefulWidget {
  const ScreenListing({super.key});

  @override
  ScreenListingState createState() => ScreenListingState();
}

class ScreenListingState extends State<ScreenListing> {
  List<dynamic> listings = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchListing();
  }

  Future<void> fetchListing() async {
    final url = Uri.parse('https://testing.hikalcrm.com/api/listings');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          listings = data['data']['data'];
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return   Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        backgroundColor:  Colors.grey,
        title: const Text(
          'Property Listing',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : listings.isEmpty
              ? const Center(child: Text('No listings found'))
              : ListView.builder(
                  itemCount: listings.length,
                  itemBuilder: (context, index) {
                    final listing = listings[index];
                    return Card(
                       color: AppColors.pastelGrey,

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 8,
                      margin: const EdgeInsets.all(8),
                      child: Column(
                        children: [
                          Stack(
                            alignment: Alignment.bottomLeft,
                            children: [
                              CachedNetworkImage(
                                imageUrl: listing['banner_img'] ?? '',
                                placeholder: (context, url) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                },
                                errorWidget: (context, url, error) {
                                  return const Icon(Icons.error);
                                },
                                fit: BoxFit.cover,
                                height: 200,
                                width: double.infinity,
                              ),
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.black.withOpacity(0.5),
                                      Colors.transparent
                                    ],
                                    begin: Alignment.bottomLeft,
                                    end: Alignment.topRight,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  listing['listing_title'] ?? 'No title available',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Price: ${listing['price'] ?? 'N/A'} ${listing['currency'] ?? ''}',
                                  style: const TextStyle(
                                      fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                ElevatedButton(
  onPressed: () {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Contact Number'),
          content: const Text('03297096436'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  },
  style: ElevatedButton.styleFrom(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  ),
  child: const Text('Contact'),
),

                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Address: ${listing['address'] ?? 'N/A'}',
                              style: const TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      const Icon(Icons.house),
                                      Text(
                                        listing['property_type'] ?? 'N/A',
                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 1,
                                  width: 30,),
                                  Column(
                                    children: [
                                      const Icon(Icons.bed),
                                      Text(
                                        '${listing['bedrooms']}',
                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                    SizedBox(height: 1,
                                    width: 30,
                                    ),
                                  Column(
                                    children: [
                                      const Icon(Icons.bathtub),
                                      Text(
                                        '${listing['bathrooms'] }',
                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}
class AppColors {
  static const pastelGrey = Color(0xFFD3D3D3); // Pastel Grey Color
  static const pastelPink = Color(0xFFFFD1DC); // Optional: Other pastel colors
  static const pastelBlue = Color(0xFFAEC6CF); // Optional
}


