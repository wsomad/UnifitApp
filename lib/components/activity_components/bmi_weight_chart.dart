// import 'package:flutter/material.dart';
// import 'package:mhs_application/services/user_database.dart';

// class BMIWeightChart extends StatefulWidget {
//   // Source path for BMI and weight data
//   final int currentWeek; // Current week number
//   final String userId; // User ID
//   final String sourcePath; // Source path for BMI and weight data

//   const BMIWeightChart({super.key, required this.currentWeek, required this.userId, required this.sourcePath});

//   @override
//   BMIWeightChartState createState() => _BMIWeightChartState();
// }

// class _BMIWeightChartState extends State<BMIWeightChart> {
//   double? bmiData = 0.0; // List of BMI values
//   double? weightData = 0.0; // List of weight values

//   @override
//   void initState() {
//     super.initState();
//     fetchData();
//   }

//   void fetchData() {
//     StudentDatabaseService().readCurrentStudentData(widget.userId, widget.sourcePath).listen((student) {
//       setState(() {
//         // Assuming your Student class has properties for BMI and weight
//         bmiData = student.bmi;
//         weightData = student.weight;
//       });
//     });
//     print('BMI: $bmiData');
//     print('Weight: $weightData');
//     print('ID: ${widget.userId}');
//   }
//   @override
//   Widget build(BuildContext context) {
//     return const Text('Hello');
//     /*LineChart(
//       LineChartData(
//         titlesData: FlTitlesData(
//           bottomTitles: AxisTitles(
//             sideTitles: SideTitles(
//               showTitles: true,
//               reservedSize: 10,
//             ),
//           ),
//           leftTitles: AxisTitles(
//             sideTitles: SideTitles(
//               showTitles: true,
//               reservedSize: 10,
//             ),
//           )
//         ),
//         borderData: FlBorderData(
//           show: true,
//           border: Border.all(color: Colors.black, width: 1),
//         ),
//         minX: 1,
//         maxX: widget.currentWeek.toDouble(), // Set the maximum x value to the current week
//         minY: 0,
//         lineBarsData: [
//           LineChartBarData(
//             spots: bmiData
//                 .asMap()
//                 .entries
//                 .map((entry) => FlSpot((entry.key + 1).toDouble(), entry.value))
//                 .toList(),
//             isCurved: true,
//             color: Colors.green,
//             barWidth: 2,
//             isStrokeCapRound: true,
//             belowBarData: BarAreaData(show: false),
//           ),
//           LineChartBarData(
//             spots: bmiData
//                 .asMap()
//                 .entries
//                 .map((entry) => FlSpot((entry.key + 1).toDouble(), entry.value))
//                 .toList(),
//             isCurved: true,
//             color: Colors.red,
//             barWidth: 2,
//             isStrokeCapRound: true,
//             belowBarData: BarAreaData(show: false),
//           ),
//         ],
//       ),
//     );*/
//   }
// }