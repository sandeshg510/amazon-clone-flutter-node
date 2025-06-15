import 'package:amazon_clone/features/admin/services/admin_services.dart';
import 'package:amazon_clone/features/auth/presentation/utitls/auth_extensions.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/common/widgets/loader.dart';
import '../models/sales.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  final AdminServices _adminServices = AdminServices();
  final NumberFormat _currencyFormat = NumberFormat.currency(
    symbol: '₹',
    decimalDigits: 0,
    locale: 'en_IN',
  );
  int? _totalSales;
  List<Sales>? _earnings;

  @override
  void initState() {
    super.initState();
    _fetchEarnings();
  }

  Future<void> _fetchEarnings() async {
    final data = await _adminServices.getEarnings(context.currentUser.token);
    _totalSales = data["totalEarnings"];
    _earnings = data['sales'];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (_earnings == null || _totalSales == null) return const Loader();

    final maxEarning = _earnings!
        .map((sale) => sale.earning)
        .reduce((a, b) => a > b ? a : b)
        .toDouble();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildTotalSalesCard(),
          ),
          const SizedBox(height: 24),
          _buildCategorySalesChart(maxEarning),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildCategoryBreakdownList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalSalesCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.blueAccent, Colors.lightBlue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          const Icon(Icons.currency_rupee, size: 40, color: Colors.white),
          const SizedBox(height: 12),
          Text(
            'Total Sales',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            _currencyFormat.format(_totalSales),
            style: const TextStyle(
              fontSize: 32,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySalesChart(double maxEarning) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Text(
              'Sales Distribution by Category',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 300,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: maxEarning * 1.2,
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    tooltipBgColor: Colors.blueGrey,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) =>
                        BarTooltipItem(
                      _currencyFormat.format(rod.toY),
                      const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 50,
                      getTitlesWidget: (value, meta) => Text(
                        _currencyFormat.format(value),
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        return index < _earnings!.length
                            ? Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  _earnings![index].label,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              )
                            : const SizedBox();
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                gridData: const FlGridData(show: true),
                barGroups: _earnings!
                    .asMap()
                    .entries
                    .map((entry) => BarChartGroupData(
                          x: entry.key,
                          barRods: [
                            BarChartRodData(
                              toY: entry.value.earning.toDouble(),
                              gradient: const LinearGradient(
                                colors: [
                                  Colors.blueAccent,
                                  Colors.lightBlueAccent
                                ],
                                stops: [0.2, 1.0],
                              ),
                              borderRadius: BorderRadius.circular(8),
                              width: 22,
                            ),
                          ],
                        ))
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryBreakdownList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Category Breakdown',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 12),
        ..._earnings!.map((sale) {
          final percentage =
              _totalSales! > 0 ? (sale.earning / _totalSales! * 100) : 0.0;

          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              tileColor: Colors.grey.shade100,
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.category, color: Colors.blue),
              ),
              title: Text(sale.label),
              subtitle: Text(
                '${percentage.toStringAsFixed(1)}% of total',
                style: TextStyle(color: Colors.grey.shade600),
              ),
              trailing: Text(
                _currencyFormat.format(sale.earning),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        }).toList(),
      ],
    );
  }
}

// class AnalyticsScreen extends StatefulWidget {
//   const AnalyticsScreen({super.key});
//
//   @override
//   State<AnalyticsScreen> createState() => _AnalyticsScreenState();
// }
//
// class _AnalyticsScreenState extends State<AnalyticsScreen> {
//   final AdminServices _adminServices = AdminServices();
//   final NumberFormat _currencyFormat = NumberFormat.simpleCurrency();
//   int? _totalSales;
//   List<Sales>? _earnings;
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchEarnings();
//   }
//
//   Future<void> _fetchEarnings() async {
//     final data = await _adminServices.getEarnings(context.currentUser.token);
//     _totalSales = data["totalEarnings"];
//     _earnings = data['sales'];
//     setState(() {});
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (_earnings == null || _totalSales == null) return const Loader();
//
//     final maxEarning = _earnings!
//         .map((sale) => sale.earning)
//         .reduce((a, b) => a > b ? a : b)
//         .toDouble();
//
//     return SingleChildScrollView(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: _buildTotalSalesCard(),
//           ),
//           const SizedBox(height: 24),
//           _buildCategorySalesChart(maxEarning),
//           const SizedBox(height: 24),
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: _buildCategoryBreakdownList(),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildTotalSalesCard() {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         gradient: const LinearGradient(
//           colors: [Colors.blueAccent, Colors.lightBlue],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         borderRadius: BorderRadius.circular(15),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.blue.withOpacity(0.2),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           const Icon(Icons.attach_money, size: 40, color: Colors.white),
//           const SizedBox(height: 12),
//           Text(
//             'Total Sales',
//             style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                   color: Colors.white,
//                   fontWeight: FontWeight.w500,
//                 ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             _currencyFormat.format(_totalSales),
//             style: const TextStyle(
//               fontSize: 32,
//               color: Colors.white,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildCategorySalesChart(double maxEarning) {
//     return Padding(
//       padding: const EdgeInsets.all(2.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 18.0),
//             child: Text(
//               'Sales Distribution by Category',
//               style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                     fontWeight: FontWeight.w600,
//                   ),
//             ),
//           ),
//           const SizedBox(height: 16),
//           SizedBox(
//             height: 300,
//             child: BarChart(
//               BarChartData(
//                 alignment: BarChartAlignment.spaceAround,
//                 maxY: maxEarning * 1.2, // 20% buffer
//                 barTouchData: BarTouchData(
//                   enabled: true,
//                   touchTooltipData: BarTouchTooltipData(
//                     tooltipBgColor: Colors.blueGrey,
//                     getTooltipItem: (group, groupIndex, rod, rodIndex) =>
//                         BarTooltipItem(
//                       _currencyFormat.format(rod.toY),
//                       const TextStyle(color: Colors.white),
//                     ),
//                   ),
//                 ),
//                 titlesData: FlTitlesData(
//                   leftTitles: AxisTitles(
//                       sideTitles: SideTitles(
//                     showTitles: true,
//                     reservedSize: 40,
//                     getTitlesWidget: (value, meta) => Text(
//                       _currencyFormat.format(value),
//                       style: const TextStyle(fontSize: 12),
//                     ),
//                   )),
//                   bottomTitles: AxisTitles(
//                     sideTitles: SideTitles(
//                       showTitles: true,
//                       getTitlesWidget: (value, meta) {
//                         final index = value.toInt();
//                         return index < _earnings!.length
//                             ? Padding(
//                                 padding: const EdgeInsets.only(top: 8.0),
//                                 child: Text(
//                                   _earnings![index].label,
//                                   textAlign: TextAlign.center,
//                                   style: const TextStyle(
//                                     fontSize: 9,
//                                     fontWeight: FontWeight.w500,
//                                   ),
//                                 ),
//                               )
//                             : const SizedBox();
//                       },
//                     ),
//                   ),
//                 ),
//                 borderData: FlBorderData(show: false),
//                 gridData: const FlGridData(show: false),
//                 barGroups: _earnings!
//                     .asMap()
//                     .entries
//                     .map((entry) => BarChartGroupData(
//                           x: entry.key,
//                           barRods: [
//                             BarChartRodData(
//                               toY: entry.value.earning.toDouble(),
//                               gradient: const LinearGradient(
//                                 colors: [
//                                   Colors.blueAccent,
//                                   Colors.lightBlueAccent
//                                 ],
//                                 stops: [0.2, 1.0],
//                               ),
//                               borderRadius: BorderRadius.circular(8),
//                               width: 22,
//                             ),
//                           ],
//                         ))
//                     .toList(),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildCategoryBreakdownList() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Category Breakdown',
//           style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                 fontWeight: FontWeight.w600,
//               ),
//         ),
//         const SizedBox(height: 12),
//         ..._earnings!.map((sale) {
//           final percentage =
//               _totalSales! > 0 ? (sale.earning / _totalSales! * 100) : 0.0;
//
//           return Padding(
//             padding: const EdgeInsets.only(bottom: 8.0),
//             child: ListTile(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               tileColor: Colors.grey.shade100,
//               leading: Container(
//                 padding: const EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   color: Colors.blue.shade100,
//                   shape: BoxShape.circle,
//                 ),
//                 child: const Icon(Icons.category, color: Colors.blue),
//               ),
//               title: Text(sale.label),
//               subtitle: Text(
//                 '${percentage.toStringAsFixed(1)}% of total',
//                 style: TextStyle(color: Colors.grey.shade600),
//               ),
//               trailing: Text(
//                 _currencyFormat.format(sale.earning),
//                 style: const TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           );
//         }).toList(),
//       ],
//     );
//   }
// }

// class AnalyticsScreen extends StatefulWidget {
//   const AnalyticsScreen({super.key});
//
//   @override
//   State<AnalyticsScreen> createState() => _AnalyticsScreenState();
// }
//
// class _AnalyticsScreenState extends State<AnalyticsScreen> {
//   final AdminServices adminServices = AdminServices();
//   int? totalSales;
//   List<Sales>? earnings;
//
//   @override
//   void initState() {
//     getEarnings();
//     super.initState();
//   }
//
//   getEarnings() async {
//     var earningData =
//         await adminServices.getEarnings(context.currentUser.token);
//     totalSales = earningData["totalEarnings"];
//     earnings = earningData['sales'];
//     setState(() {});
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (earnings == null || totalSales == null) {
//       return const Loader();
//     } else {
//       return Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             Text(
//               'Total Sales: \$${totalSales.toString()}',
//               style: const TextStyle(
//                 fontSize: 22,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 20),
//             const Text(
//               'Category-wise Sales',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
//             ),
//             const SizedBox(height: 12),
//             SizedBox(
//               height: 350,
//               child: BarChart(
//                 BarChartData(
//                   alignment: BarChartAlignment.spaceAround,
//                   maxY: earnings!
//                           .map((sale) => sale.earning.toDouble())
//                           .reduce((a, b) => a > b ? a : b) +
//                       1000, // add buffer
//                   barTouchData: BarTouchData(enabled: true),
//                   titlesData: FlTitlesData(
//                     leftTitles: AxisTitles(
//                       sideTitles: SideTitles(showTitles: true),
//                     ),
//                     bottomTitles: AxisTitles(
//                       sideTitles: SideTitles(
//                         showTitles: true,
//                         getTitlesWidget: (value, meta) {
//                           int index = value.toInt();
//                           if (index >= 0 && index < earnings!.length) {
//                             return Padding(
//                               padding: const EdgeInsets.only(top: 8.0),
//                               child: Text(
//                                 maxLines: 5,
//                                 earnings![index].label,
//                                 style: const TextStyle(fontSize: 9),
//                               ),
//                             );
//                           } else {
//                             return const Text('');
//                           }
//                         },
//                       ),
//                     ),
//                   ),
//                   borderData: FlBorderData(show: false),
//                   barGroups: earnings!
//                       .asMap()
//                       .entries
//                       .map(
//                         (entry) => BarChartGroupData(
//                           x: entry.key,
//                           barRods: [
//                             BarChartRodData(
//                               toY: entry.value.earning.toDouble(),
//                               color: Colors.blueAccent,
//                               borderRadius: BorderRadius.circular(6),
//                               width: 18,
//                             ),
//                           ],
//                         ),
//                       )
//                       .toList(),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       );
//     }
//   }
// }

// import 'package:amazon_clone/features/admin/services/admin_services.dart';
// import 'package:amazon_clone/features/auth/presentation/utitls/auth_extensions.dart';
// import 'package:flutter/material.dart';
//
// import '../../../core/common/widgets/loader.dart';
// import '../models/sales.dart';
//
// class AnalyticsScreen extends StatefulWidget {
//   const AnalyticsScreen({super.key});
//
//   @override
//   State<AnalyticsScreen> createState() => _AnalyticsScreenState();
// }
//
// class _AnalyticsScreenState extends State<AnalyticsScreen> {
//   final AdminServices adminServices = AdminServices();
//   int? totalSales;
//   List<Sales>? earnings;
//
//   @override
//   void initState() {
//     getEarnings();
//     super.initState();
//   }
//
//   getEarnings() async {
//     var earningData =
//         await adminServices.getEarnings(context.currentUser.token);
//     totalSales = earningData["totalEarnings"];
//     earnings = earningData['sales'];
//     setState(() {});
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return earnings == null || totalSales == null
//         ? const Loader()
//         : Column(
//             children: [
//               Text(
//                 'Total Sales : \$${totalSales.toString()}',
//                 style:
//                     const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//               )
//             ],
//           );
//   }
// }
