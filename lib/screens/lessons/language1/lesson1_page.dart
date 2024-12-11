import 'package:flutter/material.dart';

class Language1Lesson1Page extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
  title: const Text('General Chemistry'),
  backgroundColor: const Color(0xFF104D6C),
  titleTextStyle: const TextStyle(
    color: Colors.white,
    fontSize: 22,
    fontWeight: FontWeight.bold,
  ),
  actions: [
    Padding(
      padding: const EdgeInsets.only(right: 5.0), // Adjust padding as needed
      child: Image.asset(
        'assets/appbar_logo.png', // Replace with the actual path to your image
        height: 70, // Adjust the height as needed
        width: 70
        ,  // Adjust the width as needed
      ),
    ),
  ],
),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title Section
            const Text(
              'Lesson 1: Chemical Bonds',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF104D6C),
              ),
            ),
            const SizedBox(height: 16),

            // Introduction Section
            const Text(
              'Introduction:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF104D6C),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Chemical bonds are the forces that hold atoms together to form molecules and compounds. They are essential for the formation of substances that make up the physical world.',
              style: TextStyle(fontSize: 16, color: Color(0xFF104D6C)),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 16),

            // Image Placeholder for Introduction
            Center(
              child: Image.asset(
                'assets/general1.png', // Placeholder for an image showing atoms and bonds (e.g., H2O molecule)
              ),
            ),
            const SizedBox(height: 16),

            // Types of Chemical Bonds Section
            const Text(
              'Types of Chemical Bonds:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF104D6C),
              ),
            ),
            const SizedBox(height: 8),

            // Ionic Bonds
            _buildFactSection(
              'Ionic Bonds',
              'Ionic bonds are formed when electrons are transferred from one atom to another, resulting in positive and negative ions that attract each other.',
            ),
            Center(
              child: Image.asset(
                'assets/general2.png', // Placeholder for an image showing ionic bonding (e.g., NaCl structure)
              ),
            ),
            const SizedBox(height: 16),

            // Covalent Bonds
            _buildFactSection(
              'Covalent Bonds',
              'Covalent bonds are formed when atoms share electrons to achieve a stable electron configuration.',
            ),
            Center(
              child: Image.asset(
                'assets/general3.png', // Placeholder for an image showing covalent bonding (e.g., H2 molecule or CH4)
              ),
            ),
            const SizedBox(height: 16),

            // Metallic Bonds
            _buildFactSection(
              'Metallic Bonds',
              'Metallic bonds are formed by the attraction between delocalized electrons and positive metal ions, resulting in high conductivity and malleability.',
            ),
            Center(
              child: Image.asset(
                'assets/general4.png', // Placeholder for an image showing metallic bonding (e.g., electron sea model)
              ),
            ),
            const SizedBox(height: 16),

            // Summary Section
            const Text(
              'Summary:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF104D6C),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Chemical bonds are the foundation of chemical compounds and are essential for understanding molecular interactions. The three primary types of bonds—ionic, covalent, and metallic—each have unique properties that determine the behavior of materials.',
              style: TextStyle(fontSize: 16, color: Color(0xFF104D6C)),
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }

  // Helper function to create a section for a bond type
  Widget _buildFactSection(String title, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF104D6C),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          description,
          style: const TextStyle(fontSize: 16, color: Color(0xFF104D6C)),
          textAlign: TextAlign.justify,
        ),
      ],
    );
  }
}
