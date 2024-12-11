import 'package:flutter/material.dart';

class Language1Lesson2Page extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inorganic Chemistry'),
        backgroundColor: const Color(0xFF104D6C),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
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
  ], // AppBar color matching the theme
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Lesson Title without Card
            const Text(
              'Lesson 2: D-block Elements',
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
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF104D6C)),
            ),
            const SizedBox(height: 8),
            const Text(
              'D-block elements, also known as transition elements, are those elements found in the center of the periodic table in groups 3 through 12. These elements have partially filled d orbitals, which give them their unique chemical properties.',
              style: TextStyle(fontSize: 16, color: Color(0xFF104D6C)),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 16),

            // Image Slot for better visual appeal
            Center(
              child: Image.asset('assets/inorganic1.png'),  // Add your image here (example name)
            ),
            const SizedBox(height: 16),

            // Characteristics Section
            const Text(
              'Characteristics of D-block Elements:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF104D6C)),
            ),
            const SizedBox(height: 8),
            _buildFact('Variable Oxidation States: D-block elements often have more than one oxidation state. This is due to the ability of the d-electrons to participate in bonding.'),
            _buildFact('High Melting and Boiling Points: These elements have high melting and boiling points due to strong metallic bonding.'),
            _buildFact('Formation of Colored Compounds: Many d-block elements form compounds that are colored, which is a result of the d-d electron transitions.'),
            _buildFact('Catalytic Properties: D-block elements are known for their ability to act as catalysts in many chemical reactions. Examples include iron in the Haber process and platinum in catalytic converters.'),
            const SizedBox(height: 16),

            // Image Slot for Characteristics Section
            Center(
              child: Image.asset('assets/inorganic3.png'),  // Add your image here (example name)
            ),
            const SizedBox(height: 16),

            // Example Section
            const Text(
              'Examples of D-block Elements:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF104D6C)),
            ),
            const SizedBox(height: 8),
            _buildFact('Iron (Fe): Commonly used in construction and manufacturing. It forms various compounds like iron chloride and iron sulfate.'),
            _buildFact('Copper (Cu): Known for its conductivity and is used in electrical wiring and coins.'),
            _buildFact('Zinc (Zn): Important in galvanization and used in batteries.'),
            const SizedBox(height: 16),

            // Image Slot for Example Section
            Center(
              child: Image.asset('assets/inorganic2.png'),  // Add your image here (example name)
            ),
            const SizedBox(height: 16),

            // Conclusion Section
            const Text(
              'Conclusion:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF104D6C)),
            ),
            const SizedBox(height: 8),
            const Text(
              'D-block elements are crucial in both industrial and biological processes due to their versatility, catalytic properties, and ability to form a wide range of compounds. They play an important role in many applications from electronics to chemistry and metallurgy.',
              style: TextStyle(fontSize: 16, color: Color(0xFF104D6C)),
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }

  // Helper function to create facts in point form
  Widget _buildFact(String fact) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(Icons.check, color: Color(0xFF104D6C), size: 20), // Checkmark for each fact
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              fact,
              style: const TextStyle(fontSize: 16, color: Color(0xFF104D6C)),
            ),
          ),
        ],
      ),
    );
  }
}
