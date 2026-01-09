
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// void main() {
//   runApp(const CropApp());
// }

// class CropApp extends StatelessWidget {
//   const CropApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         useMaterial3: true,
//         colorSchemeSeed: Colors.green,
//       ),
//       home: CropScreen(),
//     );
//   }
// }

// class CropScreen extends StatefulWidget {
//   @override
//   State<CropScreen> createState() => _CropScreenState();
// }

// class _CropScreenState extends State<CropScreen> {
//   String? selectedDistrict;
//   String? selectedSeason;

//   final rain = TextEditingController();
//   final temp = TextEditingController();
//   final humidity = TextEditingController();
//   final ph = TextEditingController();
//   final n = TextEditingController();
//   final p = TextEditingController();
//   final k = TextEditingController();

//   Map<String, dynamic>? resultData;
//   bool loading = false;

//   final districts = [
//     "Mandya", "Vijayapura", "Bagalkote", "Gadag",
//     "Shivamogga", "Ramanagara", "Dharwad", "Belagavi",
//     "Hassan", "Mysuru", "Dakshina Kannada", "Kalaburagi",
//     "Haveri", "Udupi", "Chitradurga"
//   ];

//   final seasons = ['Kharif', 'Rabi', 'Summer', 'Year-round'];

//   // ----------------------------
//   // BEAUTIFUL RESULT CARD UI
//   // ----------------------------
//   Widget cropResultCard(String crop, double probability) {
//     return Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Row(
//           children: [
//             const Icon(Icons.agriculture, size: 40, color: Colors.green),

//             const SizedBox(width: 16),

//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     crop,
//                     style: const TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),

//                   const SizedBox(height: 8),

//                   LinearProgressIndicator(
//                     value: probability,
//                     minHeight: 8,
//                     backgroundColor: Colors.green.shade100,
//                     color: Colors.green.shade700,
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ],
//               ),
//             ),

//             const SizedBox(width: 12),

//             Text(
//               "${(probability * 100).toStringAsFixed(1)}%",
//               style: const TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.green,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // ----------------------------
//   // PREDICT FUNCTION
//   // ----------------------------
//   Future<void> predict() async {
//     if (selectedDistrict == null || selectedSeason == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("⚠️ Please select district & season")),
//       );
//       return;
//     }

//     setState(() {
//       loading = true;
//       resultData = null;
//     });

//     final url = Uri.parse("http://127.0.0.1:8000/$selectedDistrict/predict");

//     final body = jsonEncode({
//       "season": selectedSeason,
//       "rainfall_mm": double.tryParse(rain.text) ?? 0,
//       "avg_temp_C": double.tryParse(temp.text) ?? 0,
//       "humidity": double.tryParse(humidity.text) ?? 0,
//       "pH": double.tryParse(ph.text) ?? 0,
//       "N": double.tryParse(n.text) ?? 0,
//       "P": double.tryParse(p.text) ?? 0,
//       "K": double.tryParse(k.text) ?? 0,
//     });

//     try {
//       final response = await http.post(
//         url,
//         headers: {"Content-Type": "application/json"},
//         body: body,
//       );

//       if (response.statusCode == 200) {
//         setState(() {
//           resultData = jsonDecode(response.body);
//         });
//       } else {
//         setState(() {
//           resultData = {
//             "error": "Server error: ${response.body}",
//           };
//         });
//       }
//     } catch (e) {
//       setState(() {
//         resultData = {
//           "error": "🚫 Cannot connect to backend. Is FastAPI running?"
//         };
//       });
//     }

//     setState(() => loading = false);
//   }

//   // ----------------------------
//   // INPUT FIELD WIDGET
//   // ----------------------------
//   Widget inputField(String label, IconData icon, TextEditingController c) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 6),
//       child: TextField(
//         controller: c,
//         keyboardType: TextInputType.number,
//         decoration: InputDecoration(
//           labelText: label,
//           prefixIcon: Icon(icon, color: Colors.green),
//           filled: true,
//           fillColor: Colors.green.shade50,
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(14),
//           ),
//         ),
//       ),
//     );
//   }

//   // ----------------------------
//   // BUILD UI
//   // ----------------------------
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.green.shade100,

//       appBar: AppBar(
//         title: const Text(
//           "🌱 AGRISENSE : SMART CROP RECOMMENDATION",
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         backgroundColor: Colors.green.shade700,
//         foregroundColor: Colors.white,
//       ),

//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Card(
//           elevation: 6,
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//           child: Padding(
//             padding: const EdgeInsets.all(20),
//             child: Column(
//               children: [

//                 // District Dropdown
//                 DropdownButtonFormField<String>(
//                   decoration: dropdownDecoration(),
//                   isExpanded: true,
//                   hint: const Text("Select District"),
//                   value: selectedDistrict,
//                   items: districts.map((d) => DropdownMenuItem(value: d, child: Text(d))).toList(),
//                   onChanged: (v) => setState(() => selectedDistrict = v),
//                 ),

//                 const SizedBox(height: 12),

//                 // Season Dropdown
//                 DropdownButtonFormField<String>(
//                   decoration: dropdownDecoration(),
//                   isExpanded: true,
//                   hint: const Text("Select Season"),
//                   value: selectedSeason,
//                   items: seasons.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
//                   onChanged: (v) => setState(() => selectedSeason = v),
//                 ),

//                 const SizedBox(height: 16),

//                 // Input fields
//                 inputField("Rainfall (mm)", Icons.water_drop, rain),
//                 inputField("Temperature (°C)", Icons.thermostat, temp),
//                 inputField("Humidity (%)", Icons.cloud, humidity),
//                 inputField("Soil pH", Icons.science, ph),
//                 inputField("Nitrogen (N)", Icons.grass, n),
//                 inputField("Phosphorus (P)", Icons.eco, p),
//                 inputField("Potassium (K)", Icons.energy_savings_leaf, k),

//                 const SizedBox(height: 20),

//                 // Predict Button
//                 ElevatedButton.icon(
//                   onPressed: loading ? null : predict,
//                   icon: loading
//                       ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white))
//                       : const Icon(Icons.agriculture),
//                   label: Text(loading ? "Predicting..." : "Predict Crop"),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.green.shade700,
//                     foregroundColor: Colors.white,
//                     padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
//                     textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
//                   ),
//                 ),

//                 const SizedBox(height: 25),

//                 // ----------------------------
//                 // BEAUTIFUL OUTPUT SECTION
//                 // ----------------------------
//                 if (resultData != null) buildResultSection(),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   // Beautiful dropdown decoration
//   InputDecoration dropdownDecoration() {
//     return InputDecoration(
//       filled: true,
//       fillColor: Colors.green.shade50,
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(14),
//       ),
//     );
//   }

//   // Build output result UI
//   Widget buildResultSection() {
//     if (resultData!.containsKey("error")) {
//       return Text(
//         resultData!["error"],
//         style: const TextStyle(color: Colors.red, fontSize: 18),
//       );
//     }

//     final crops = resultData!["top_3_crops"];
//     final probs = resultData!["probabilities"];

//     return Column(
//       children: [
//         const Text(
//           "🌾 Top-3 Recommended Crops",
//           style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green),
//         ),

//         const SizedBox(height: 16),

//         cropResultCard(crops[0], probs[0]),
//         cropResultCard(crops[1], probs[1]),
//         cropResultCard(crops[2], probs[2]),
//       ],
//     );
//   }
// }


import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const CropApp());
}

class CropApp extends StatelessWidget {
  const CropApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.green,
      ),
      home: CropScreen(),
    );
  }
}

class CropScreen extends StatefulWidget {
  @override
  State<CropScreen> createState() => _CropScreenState();
}

class _CropScreenState extends State<CropScreen> {
  String? selectedDistrict;
  String? selectedSeason;

  final rain = TextEditingController();
  final temp = TextEditingController();
  final humidity = TextEditingController();
  final ph = TextEditingController();
  final n = TextEditingController();
  final p = TextEditingController();
  final k = TextEditingController();

  Map<String, dynamic>? resultData;
  bool loading = false;

  final districts = [
    "Mandya", "Vijayapura", "Bagalkote", "Gadag",
    "Shivamogga", "Ramanagara", "Dharwad", "Belagavi",
    "Hassan", "Mysuru", "Dakshina Kannada", "Kalaburagi",
    "Haveri", "Udupi", "Chitradurga"
  ];

  final seasons = ['Kharif', 'Rabi', 'Summer', 'Year-round'];

  // ----------------------------
  // RESULT CARD
  // ----------------------------
  Widget cropResultCard(String crop, double probability) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.agriculture, size: 40, color: Colors.green),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    crop,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: probability,
                    minHeight: 8,
                    backgroundColor: Colors.green.shade100,
                    color: Colors.green.shade700,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Text(
              "${(probability * 100).toStringAsFixed(1)}%",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ----------------------------
  // PREDICT FUNCTION (FIXED)
  // ----------------------------
  Future<void> predict() async {
    if (selectedDistrict == null || selectedSeason == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("⚠️ Please select district & season")),
      );
      return;
    }

    setState(() {
      loading = true;
      resultData = null;
    });

    // ✅ FIX: URL encode district (spaces issue)
    final encodedDistrict = Uri.encodeComponent(selectedDistrict!);

    final url = Uri.parse(
      "http://127.0.0.1:8000/$encodedDistrict/predict"
    );

    final body = jsonEncode({
      "season": selectedSeason,
      "rainfall_mm": double.tryParse(rain.text) ?? 0,
      "avg_temp_C": double.tryParse(temp.text) ?? 0,
      "humidity": double.tryParse(humidity.text) ?? 0,
      "pH": double.tryParse(ph.text) ?? 0,
      "N": double.tryParse(n.text) ?? 0,
      "P": double.tryParse(p.text) ?? 0,
      "K": double.tryParse(k.text) ?? 0,
    });

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      if (response.statusCode == 200) {
        setState(() {
          resultData = jsonDecode(response.body);
        });
      } else {
        setState(() {
          resultData = {
            "error": "Server error: ${response.body}",
          };
        });
      }
    } catch (e) {
      setState(() {
        resultData = {
          "error": "🚫 Cannot connect to backend. Is FastAPI running?"
        };
      });
    }

    setState(() => loading = false);
  }

  // ----------------------------
  // INPUT FIELD
  // ----------------------------
  Widget inputField(String label, IconData icon, TextEditingController c) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextField(
        controller: c,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.green),
          filled: true,
          fillColor: Colors.green.shade50,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }

  // ----------------------------
  // UI
  // ----------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade100,
      appBar: AppBar(
        title: const Text(
          "🌱 AGRISENSE : SMART CROP RECOMMENDATION",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 6,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                DropdownButtonFormField<String>(
                  decoration: dropdownDecoration(),
                  isExpanded: true,
                  hint: const Text("Select District"),
                  value: selectedDistrict,
                  items: districts
                      .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                      .toList(),
                  onChanged: (v) => setState(() => selectedDistrict = v),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  decoration: dropdownDecoration(),
                  isExpanded: true,
                  hint: const Text("Select Season"),
                  value: selectedSeason,
                  items: seasons
                      .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                      .toList(),
                  onChanged: (v) => setState(() => selectedSeason = v),
                ),
                const SizedBox(height: 16),
                inputField("Rainfall (mm)", Icons.water_drop, rain),
                inputField("Temperature (°C)", Icons.thermostat, temp),
                inputField("Humidity (%)", Icons.cloud, humidity),
                inputField("Soil pH", Icons.science, ph),
                inputField("Nitrogen (N)", Icons.grass, n),
                inputField("Phosphorus (P)", Icons.eco, p),
                inputField("Potassium (K)", Icons.energy_savings_leaf, k),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: loading ? null : predict,
                  icon: loading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(color: Colors.white),
                        )
                      : const Icon(Icons.agriculture),
                  label: Text(loading ? "Predicting..." : "Predict Crop"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade700,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 14),
                    textStyle: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                ),
                const SizedBox(height: 25),
                if (resultData != null) buildResultSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration dropdownDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: Colors.green.shade50,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
      ),
    );
  }

  Widget buildResultSection() {
    if (resultData!.containsKey("error")) {
      return Text(
        resultData!["error"],
        style: const TextStyle(color: Colors.red, fontSize: 18),
      );
    }

    final crops = resultData!["top_3_crops"];
    final probs = resultData!["probabilities"];

    return Column(
      children: [
        const Text(
          "🌾 Top-3 Recommended Crops",
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green),
        ),
        const SizedBox(height: 16),
        cropResultCard(crops[0], probs[0]),
        cropResultCard(crops[1], probs[1]),
        cropResultCard(crops[2], probs[2]),
      ],
    );
  }
}
