// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';

// class DiseaseResultScreen extends StatelessWidget {
//   final String detectionId;

//   const DiseaseResultScreen({
//     super.key,
//     required this.detectionId,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final isHindi = Localizations.localeOf(context).languageCode == 'hi';

//     // Mock data - use BLoC result in production
//     final result = {
//       'disease': isHindi ? 'पत्ती धब्बा रोग' : 'Leaf Spot Disease',
//       'scientificName': 'Cercospora capsici',
//       'confidence': 92.5,
//       'severity': 'medium',
//       'imageUrl': null,
//       'timestamp': '2024-03-15 14:30',
//     };

//     return Scaffold(
//       backgroundColor: Colors.grey[50],
//       appBar: AppBar(
//         elevation: 0,
//         title: Text(
//           isHindi ? 'निदान परिणाम' : 'Detection Result',
//           style: const TextStyle(fontWeight: FontWeight.bold),
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.share_outlined),
//             onPressed: () {},
//           )
//         ],
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.only(bottom: 32),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             _modernImagePreview(result),
//             const SizedBox(height: 16),
//             _modernResultCard(result, isHindi),
//             const SizedBox(height: 18),
//             _modernSeverityIndicator(result['severity'] as String, isHindi),
//             const SizedBox(height: 22),
//             _modernSectionSymptoms(isHindi),
//             const SizedBox(height: 22),
//             _modernSectionTreatment(isHindi),
//             const SizedBox(height: 22),
//             _modernSectionPrevention(isHindi),
//             const SizedBox(height: 26),
//             _bottomButtons(context, isHindi),
//           ],
//         ),
//       ),
//     );
//   }

//   // ---------------------------------------------------------------------------
//   // MODERN IMAGE PREVIEW (rounded, shadow, subtle overlay)
//   // ---------------------------------------------------------------------------

//   Widget _modernImagePreview(Map<String, dynamic> result) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 16),
//       height: 260,
//       decoration: BoxDecoration(
//         color: Colors.grey[200],
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.08),
//             blurRadius: 16,
//             offset: const Offset(0, 6),
//           ),
//         ],
//       ),
//       clipBehavior: Clip.antiAlias,
//       child: result['imageUrl'] != null
//           ? Image.network(result['imageUrl'], fit: BoxFit.cover)
//           : Container(
//               color: Colors.grey[150],
//               child: const Center(
//                 child: Icon(Icons.image_rounded,
//                     size: 90, color: Colors.grey),
//               ),
//             ),
//     );
//   }

//   // ---------------------------------------------------------------------------
//   // MODERN RESULT CARD (gradient, modern layout)
//   // ---------------------------------------------------------------------------

//   Widget _modernResultCard(
//       Map<String, dynamic> result, bool isHindi) {
//     final color = _severityColor(result['severity']);

//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 16),
//       padding: const EdgeInsets.all(22),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(20),
//         gradient: LinearGradient(
//           colors: [
//             color.withOpacity(0.12),
//             Colors.white,
//           ],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         border: Border.all(color: color.withOpacity(0.4), width: 1.5),
//         boxShadow: [
//           BoxShadow(
//             color: color.withOpacity(0.20),
//             blurRadius: 14,
//             spreadRadius: -3,
//             offset: const Offset(0, 5),
//           )
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(14),
//                 decoration: BoxDecoration(
//                   color: color.withOpacity(0.15),
//                   shape: BoxShape.circle,
//                 ),
//                 child: Icon(Icons.coronavirus_rounded,
//                     color: color, size: 32),
//               ),
//               const SizedBox(width: 14),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       result['disease'],
//                       style: const TextStyle(
//                         fontSize: 22,
//                         fontWeight: FontWeight.w800,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       result['scientificName'],
//                       style: TextStyle(
//                         fontStyle: FontStyle.italic,
//                         color: Colors.grey[700],
//                         fontSize: 13.5,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),

//           const SizedBox(height: 22),

//           // Confidence + Time
//           Row(
//             children: [
//               Expanded(
//                 child: _miniInfo(
//                   icon: Icons.insights_rounded,
//                   color: Colors.green,
//                   label: isHindi ? 'विश्वास' : 'Confidence',
//                   value: '${result['confidence']}%',
//                 ),
//               ),
//               const SizedBox(width: 16),
//               Expanded(
//                 child: _miniInfo(
//                   icon: Icons.access_time_rounded,
//                   color: Colors.blue,
//                   label: isHindi ? 'समय' : 'Time',
//                   value: result['timestamp'],
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _miniInfo({
//     required IconData icon,
//     required String label,
//     required String value,
//     required Color color,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: [
//             Icon(icon, size: 18, color: color),
//             const SizedBox(width: 6),
//             Text(label,
//                 style: TextStyle(fontSize: 12, color: Colors.grey[600])),
//           ],
//         ),
//         const SizedBox(height: 3),
//         Text(
//           value,
//           style: const TextStyle(
//               fontSize: 15, fontWeight: FontWeight.bold),
//         ),
//       ],
//     );
//   }

//   // ---------------------------------------------------------------------------
//   // MODERN SEVERITY INDICATOR (pill card)
//   // ---------------------------------------------------------------------------

//   Widget _modernSeverityIndicator(String severity, bool isHindi) {
//     final color = _severityColor(severity);

//     String text = switch (severity.toLowerCase()) {
//       'high' => isHindi ? 'उच्च गंभीरता' : 'High Severity',
//       'medium' => isHindi ? 'मध्यम गंभीरता' : 'Medium Severity',
//       'low' => isHindi ? 'कम गंभीरता' : 'Low Severity',
//       _ => severity
//     };

//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 16),
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.12),
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: color.withOpacity(0.4), width: 1.4),
//       ),
//       child: Row(
//         children: [
//           Icon(Icons.error_outline_rounded, color: color),
//           const SizedBox(width: 12),
//           Text(
//             text,
//             style: TextStyle(
//               fontWeight: FontWeight.w700,
//               fontSize: 16,
//               color: color,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // ---------------------------------------------------------------------------
//   // MODERN SECTIONS
//   // ---------------------------------------------------------------------------

//   Widget _modernSectionSymptoms(bool isHindi) {
//     final symptoms = [
//       isHindi ? 'पत्तियों पर गहरे धब्बे' : 'Dark lesions on leaves',
//       isHindi ? 'धब्बे समय के साथ बढ़ते हैं' : 'Lesions expand over time',
//       isHindi ? 'पत्तियां पीली पड़ सकती हैं' : 'Possible leaf yellowing',
//       isHindi ? 'गंभीर होने पर पत्तियां गिरती हैं' : 'Severe leaf drop',
//     ];

//     return _modernSection(
//       icon: Icons.visibility_rounded,
//       color: Colors.orange,
//       title: isHindi ? 'लक्षण' : 'Symptoms',
//       items: symptoms,
//     );
//   }

//   Widget _modernSectionTreatment(bool isHindi) {
//     final treatments = [
//       isHindi
//           ? 'तांबा आधारित कवकनाशी (2g/लीटर)'
//           : 'Copper fungicide (2g/liter)',
//       isHindi
//           ? 'नीम का तेल 5ml/लीटर'
//           : 'Neem oil 5ml/liter',
//       isHindi
//           ? 'सफाई और संक्रमित पत्तियां हटाएं'
//           : 'Remove infected leaves',
//     ];

//     return _modernSection(
//       icon: Icons.medical_services_rounded,
//       color: Colors.green,
//       title: isHindi ? 'उपचार' : 'Treatment',
//       items: treatments,
//     );
//   }

//   Widget _modernSectionPrevention(bool isHindi) {
//     final items = [
//       isHindi ? 'अधिक सिंचाई से बचें' : 'Avoid overhead watering',
//       isHindi ? 'खेत स्वच्छ रखें' : 'Maintain field hygiene',
//       isHindi ? 'सही दूरी रखें' : 'Proper spacing',
//     ];

//     return _modernSection(
//       icon: Icons.shield_rounded,
//       color: Colors.purple,
//       title: isHindi ? 'रोकथाम' : 'Prevention',
//       items: items,
//     );
//   }

//   Widget _modernSection({
//     required IconData icon,
//     required Color color,
//     required String title,
//     required List<String> items,
//   }) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(children: [
//             Icon(icon, color: color),
//             const SizedBox(width: 10),
//             Text(title,
//                 style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.w800,
//                     color: color)),
//           ]),
//           const SizedBox(height: 12),
//           Container(
//             padding: const EdgeInsets.all(20),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(18),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.06),
//                   blurRadius: 12,
//                   offset: const Offset(0, 4),
//                 ),
//               ],
//             ),
//             child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: items
//                     .map((e) => Padding(
//                           padding: const EdgeInsets.only(bottom: 10),
//                           child: Row(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Container(
//                                 width: 7,
//                                 height: 7,
//                                 margin: const EdgeInsets.only(top: 5),
//                                 decoration: BoxDecoration(
//                                     color: Colors.grey[700],
//                                     shape: BoxShape.circle),
//                               ),
//                               const SizedBox(width: 12),
//                               Expanded(
//                                 child: Text(e,
//                                     style: const TextStyle(
//                                         fontSize: 14, height: 1.4)),
//                               )
//                             ],
//                           ),
//                         ))
//                     .toList()),
//           ),
//         ],
//       ),
//     );
//   }

//   // ---------------------------------------------------------------------------
//   // BOTTOM BUTTONS
//   // ---------------------------------------------------------------------------

//   Widget _bottomButtons(BuildContext context, bool isHindi) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       child: Column(
//         children: [
//           SizedBox(
//             width: double.infinity,
//             height: 52,
//             child: ElevatedButton.icon(
//               onPressed: () =>
//                   context.push('/knowledge-base/disease-encyclopedia'),
//               icon: const Icon(Icons.menu_book_rounded),
//               label: Text(isHindi ? 'और जानें' : 'Learn More'),
//               style: ElevatedButton.styleFrom(
//                 textStyle: const TextStyle(fontSize: 16),
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(14)),
//               ),
//             ),
//           ),
//           const SizedBox(height: 12),
//           SizedBox(
//             width: double.infinity,
//             height: 52,
//             child: OutlinedButton.icon(
//               onPressed: () => context.pop(),
//               icon: const Icon(Icons.save_alt_rounded),
//               label: Text(isHindi ? 'इतिहास में सहेजें' : 'Save to History'),
//               style: OutlinedButton.styleFrom(
//                 textStyle: const TextStyle(fontSize: 16),
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(14)),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // ---------------------------------------------------------------------------
//   // HELPERS
//   // ---------------------------------------------------------------------------

//   Color _severityColor(String severity) {
//     return switch (severity.toLowerCase()) {
//       'high' => Colors.red,
//       'medium' => Colors.orange,
//       'low' => Colors.green,
//       _ => Colors.grey
//     };
//   }
// }
