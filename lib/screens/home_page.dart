import 'package:flutter/material.dart';
import 'language_page.dart';
import 'package:google_fonts/google_fonts.dart';






class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select the Language'),
        backgroundColor: const Color(0xFF104D6C),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        actions: [
          Padding(
            padding:
                const EdgeInsets.only(right: 5.0), // Adjust padding as needed
            child: Image.asset(
              'assets/appbar_logo.png', // Replace with the actual path to your image
              height: 70, // Adjust the height as needed
              width: 70, // Adjust the width as needed
            ),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LanguagePage(language: 'Language1'),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF9FB8C4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: Center(
                          child: Text(
                            "Chemistry",
                            style: GoogleFonts.poppins(
                              color: Color(0xFF104D6C),
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(8.0),
                        child: const Icon(
                          Icons.menu_book_outlined,
                          color: Colors.black,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16), // Add space between buttons

              ElevatedButton(
                            onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LanguagePage(language: 'Language2'),
                    ),
                  );
                },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:Color(0xFF9FB8C4),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 20),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        "Physics",
                                        style: GoogleFonts.poppins(
                                          color: Color(0xFF104D6C),
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      shape: BoxShape.circle,
                                    ),
                                    padding: const EdgeInsets.all(8.0),
                                    child: const Icon(
                                      Icons.menu_book_outlined,
                                      color: Colors.black,
                                      size: 30,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

              const SizedBox(height: 16),


              ElevatedButton(
                            onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LanguagePage(language: 'Language3'),
                    ),
                  );
                },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF9FB8C4),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 20),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        "Combined Mathematics",
                                        style: GoogleFonts.poppins(
                                          color: Color(0xFF104D6C),
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      shape: BoxShape.circle,
                                    ),
                                    padding: const EdgeInsets.all(8.0),
                                    child: const Icon(
                                      Icons.menu_book_outlined,
                                      color: Colors.black,
                                      size: 30,
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
