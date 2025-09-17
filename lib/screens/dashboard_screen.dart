import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../widgets/app_header_widget.dart';
import '../widgets/app_drawer_widget.dart';
import '../widgets/provider_dropdown_widget.dart';
import '../core/constants/providers.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _isDrawerOpen = false;
  bool _isScheduleExpanded = true;
  String _selectedIncentiveProvider = 'All';
  bool _showLogoutDialog = false;


  final List<Map<String, dynamic>> _appointments = [
    {
      'name': 'Sarah Williams',
      'time': '9:00 AM',
      'tags': ['GIC', 'Confirmed'],
    },
    {
      'name': 'Michael Chen',
      'time': '9:30 AM',
      'tags': ['RA', 'Pending'],
    },
    {
      'name': 'Emily Johnson',
      'time': '10:00 AM',
      'tags': ['GIC', 'RA', 'Confirmed'],
    },
    {
      'name': 'Robert Davis',
      'time': '10:30 AM',
      'tags': ['Cancelled'],
    },
    {
      'name': 'Jennifer Lopez',
      'time': '11:00 AM',
      'tags': ['GIC', 'Confirmed'],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Stack(
        children: [
          // Main Content
          Column(
            children: [
                                            AppHeaderWidget(
                onMenuPressed: () {
                  setState(() {
                    _isDrawerOpen = true;
                  });
                },
                onProfileAction: (action) {
                  _handleProfileAction(action);
                },
              ),
              
              // Provider Dropdown
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
                ),
                child: Row(
                  children: [
                    Expanded(
                                                                    child: ProviderDropdownWidget(
                        selectedProvider: _selectedIncentiveProvider,
                        providers: AppProviders.providers,
                        onProviderChanged: (provider) {
                          setState(() {
                            _selectedIncentiveProvider = provider;
                          });
                          _showSuccessMessage('Showing data for ${provider == 'All' ? 'All providers' : provider}');
                        },
                        maxWidth: 300,
                      ),
                    ),
                  ],
                ),
              ),
              
              Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildWelcomeSection(),
                      const SizedBox(height: 16),
                      _buildStatisticsGrid(),
                      const SizedBox(height: 32),
                      _buildPanelChart(),
                      const SizedBox(height: 32),
                      _buildIncentiveChart(),
                      const SizedBox(height: 32),
                      _buildScheduleCard(),
                    ],
                  ),
                ),
              ),
            ],
          ),
          
                      // Navigation Drawer
            AppDrawerWidget(
              isOpen: _isDrawerOpen,
              onClose: () {
                setState(() {
                  _isDrawerOpen = false;
                });
              },
              onNavigation: (route) {
                setState(() {
                  _isDrawerOpen = false;
                });
                _handleNavigation(route);
              },
              activeRoute: 'dashboard',
            ),
          
          // Logout Dialog
          if (_showLogoutDialog) _buildLogoutDialog(),
        ],
      ),
    );
  }

  void _handleNavigation(String route) {
    switch (route) {
      case 'dashboard':
        // Already on dashboard page
        break;
      case 'quality':
        context.go('/quality-scorecards');
        break;
      case 'schedule':
        context.go('/schedule');
        break;
      case 'patients':
        context.go('/patients');
        break;
      case 'reports':
        context.go('/reports');
        break;
      case 'resources':
        context.go('/resources');
        break;
      case 'settings':
        context.go('/settings');
        break;
      case 'logout':
        setState(() {
          _showLogoutDialog = true;
        });
        break;
    }
  }

  void _handleProfileAction(String action) {
    switch (action) {
      case 'language':
        // Handle language change
        break;
      case 'invitations':
        context.go('/invitation');
        break;
      case 'logout':
        setState(() {
          _showLogoutDialog = true;
        });
        break;
    }
  }










  Widget _buildWelcomeSection() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome back!',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w500,
            color: Color(0xFF333333),
          ),
        ),
      ],
    );
  }

  Widget _buildStatisticsGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 600;
        return GridView.count(
          crossAxisCount: isMobile ? 1 : 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: isMobile ? 16 : 24,
          mainAxisSpacing: isMobile ? 16 : 24,
          childAspectRatio: isMobile ? 2.5 : 1.2,
          children: [
            _buildKPICard('Total Open GIC', '1,250 / 2,100'),
            _buildKPICard('Total Members RA', '1,950 / 2,400'),
            _buildKPICard('Members without visits', '200 / 4,000'),
          ],
        );
      },
    );
  }

  Widget _buildKPICard(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Color(0xFF666666),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 27,
              fontWeight: FontWeight.w900,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: List.generate(5, (index) => const Padding(
              padding: EdgeInsets.only(right: 2),
              child: Icon(
                Icons.star,
                color: Color(0xFFFFC107),
                size: 16,
              ),
            )),
          ),
          const SizedBox(height: 4),
          // Add rating text like in HTML version
          const Text(
            '4.5/5',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color(0xFF666666),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPanelChart() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'My Panel',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 300,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 1000,
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const labels = ['Anthem', 'Emblem', 'Healthfirst', 'Humana', 'Metroplus', 'Molina', 'United'];
                        const abbreviations = ['ANT', 'EMB', 'HF', 'HUM', 'MET', 'MOL', 'UNI'];
                        if (value >= 0 && value < labels.length) {
                          return Text(
                            abbreviations[value.toInt()],
                            style: const TextStyle(color: Color(0xFF666666), fontSize: 12),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: const TextStyle(color: Color(0xFF666666), fontSize: 12),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                                  barGroups: [
                    BarChartGroupData(x: 0, barRods: [
                      BarChartRodData(toY: 238, color: const Color(0xFF1976D2), width: 7),
                      BarChartRodData(toY: 714, color: const Color(0xFF4CAF50), width: 7),
                      BarChartRodData(toY: 0, color: const Color(0xFF4DD0E1), width: 7),
                    ]),
                    BarChartGroupData(x: 1, barRods: [
                      BarChartRodData(toY: 238, color: const Color(0xFF1976D2), width: 7),
                      BarChartRodData(toY: 96, color: const Color(0xFF4CAF50), width: 7),
                      BarChartRodData(toY: 0, color: const Color(0xFF4DD0E1), width: 7),
                    ]),
                    BarChartGroupData(x: 2, barRods: [
                      BarChartRodData(toY: 550, color: const Color(0xFF1976D2), width: 7),
                      BarChartRodData(toY: 700, color: const Color(0xFF4CAF50), width: 7),
                      BarChartRodData(toY: 750, color: const Color(0xFF4DD0E1), width: 7),
                    ]),
                    BarChartGroupData(x: 3, barRods: [
                      BarChartRodData(toY: 170, color: const Color(0xFF1976D2), width: 7),
                      BarChartRodData(toY: 240, color: const Color(0xFF4CAF50), width: 7),
                      BarChartRodData(toY: 190, color: const Color(0xFF4DD0E1), width: 7),
                    ]),
                    BarChartGroupData(x: 4, barRods: [
                      BarChartRodData(toY: 476, color: const Color(0xFF1976D2), width: 7),
                      BarChartRodData(toY: 238, color: const Color(0xFF4CAF50), width: 7),
                      BarChartRodData(toY: 0, color: const Color(0xFF4DD0E1), width: 7),
                    ]),
                    BarChartGroupData(x: 5, barRods: [
                      BarChartRodData(toY: 0, color: const Color(0xFF1976D2), width: 7),
                      BarChartRodData(toY: 476, color: const Color(0xFF4CAF50), width: 7),
                      BarChartRodData(toY: 572, color: const Color(0xFF4DD0E1), width: 7),
                    ]),
                    BarChartGroupData(x: 6, barRods: [
                      BarChartRodData(toY: 238, color: const Color(0xFF1976D2), width: 7),
                      BarChartRodData(toY: 96, color: const Color(0xFF4CAF50), width: 7),
                      BarChartRodData(toY: 0, color: const Color(0xFF4DD0E1), width: 7),
                    ]),
                  ],
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 200,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.grey.shade300,
                      strokeWidth: 1,
                    );
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          LayoutBuilder(
            builder: (context, constraints) {
              final isMobile = constraints.maxWidth < 600;
              return Wrap(
                alignment: WrapAlignment.center,
                spacing: isMobile ? 16 : 24,
                runSpacing: 8,
                children: [
                  _buildLegendItem(const Color(0xFF1976D2), 'EP'),
                  _buildLegendItem(const Color(0xFF4CAF50), 'MCD'),
                  _buildLegendItem(const Color(0xFF4DD0E1), 'MCR'),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF666666),
          ),
        ),
      ],
    );
  }

  Widget _buildIncentiveChart() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'SOMOS Innovation Incentive Program',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 20),
          
          const SizedBox(height: 20),
          
          // Stats
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Earnings',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF666666),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '\$xx,xxx',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF333333),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Potential',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF666666),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '\$xx,xxx',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF333333),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Chart
          SizedBox(
            height: 300,
                        child: PageView(
              children: [
                // First chart - Categories 1-7
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: BarChart(
                   BarChartData(
                     alignment: BarChartAlignment.spaceAround,
                     maxY: 5000,
                    barTouchData: BarTouchData(enabled: false),
                    titlesData: FlTitlesData(
                      show: true,
                      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                                                     getTitlesWidget: (value, meta) {
                             const labels = ['AWV', 'BCS', 'CBP', 'CCS', 'CDC-E', 'CDC-1C', 'COL'];
                            if (value >= 0 && value < labels.length) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Text(
                                  labels[value.toInt()],
                                  style: const TextStyle(color: Color(0xFF666666), fontSize: 12),
                                ),
                              );
                            }
                            return const Text('');
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                          getTitlesWidget: (value, meta) {
                            return Text(
                              '\$${value.toInt()}',
                              style: const TextStyle(color: Color(0xFF666666), fontSize: 12),
                            );
                          },
                        ),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                                         barGroups: List.generate(7, (index) {
                       final earnings = [1764, 1596, 2142, 1218, 1428, 1932, 1344][index];
                       final potential = [1960, 2240, 1680, 2870, 2520, 1540, 2660][index];
                       
                       return BarChartGroupData(
                         x: index,
                         barRods: [
                           BarChartRodData(
                             toY: earnings.toDouble(),
                             color: const Color(0xFF388E3C),
                             width: 7,
                           ),
                           BarChartRodData(
                             toY: potential.toDouble(),
                             color: const Color(0xFFA5D6A7),
                             width: 7,
                           ),
                         ],
                       );
                     }),
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: 1000,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                          color: Colors.grey.shade300,
                          strokeWidth: 1,
                        );
                      },
                                        ),
                  ),
                ),
              ),
              // Second chart - Categories 8-14
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: BarChart(
                   BarChartData(
                     alignment: BarChartAlignment.spaceAround,
                     maxY: 5000,
                    barTouchData: BarTouchData(enabled: false),
                    titlesData: FlTitlesData(
                      show: true,
                      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            const labels = ['PCR', 'POD', 'PPC', 'SAA', 'W30', 'WCV', 'HVL'];
                            if (value >= 0 && value < labels.length) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Text(
                                  labels[value.toInt()],
                                  style: const TextStyle(color: Color(0xFF666666), fontSize: 12),
                                ),
                              );
                            }
                            return const Text('');
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                          getTitlesWidget: (value, meta) {
                            return Text(
                              '\$${value.toInt()}',
                              style: const TextStyle(color: Color(0xFF666666), fontSize: 12),
                            );
                          },
                        ),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                                         barGroups: List.generate(7, (index) {
                       final earnings = [2016, 1638, 1848, 1512, 2184, 1722, 1554][index];
                       final potential = [1400, 2170, 1820, 2380, 1260, 2030, 2310][index];
                       
                       return BarChartGroupData(
                         x: index,
                         barRods: [
                           BarChartRodData(
                             toY: earnings.toDouble(),
                             color: const Color(0xFF388E3C),
                             width: 7,
                           ),
                           BarChartRodData(
                             toY: potential.toDouble(),
                             color: const Color(0xFFA5D6A7),
                             width: 7,
                           ),
                         ],
                       );
                     }),
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: 1000,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                          color: Colors.grey.shade300,
                          strokeWidth: 1,
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
            ),
          ),
          const SizedBox(height: 24),
          
          // Legend
          LayoutBuilder(
            builder: (context, constraints) {
              final isMobile = constraints.maxWidth < 600;
              return Wrap(
                alignment: WrapAlignment.center,
                spacing: isMobile ? 16 : 24,
                runSpacing: 8,
                children: [
                  _buildLegendItem(const Color(0xFF388E3C), 'Earnings'),
                  _buildLegendItem(const Color(0xFFA5D6A7), 'Potential'),
                ],
              );
            },
          ),
        ],
      ),
    );
  }


  Widget _buildScheduleCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Today's Schedule",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF333333),
                  ),
                ),
                Row(
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        context.go('/schedule');
                      },
                      icon: const Text('📅'),
                      label: const Text(
                        'View All',
                        style: TextStyle(color: Color(0xFF1976D2)),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _isScheduleExpanded = !_isScheduleExpanded;
                        });
                      },
                      icon: Icon(
                        _isScheduleExpanded ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_right,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Content
          if (_isScheduleExpanded)
            ..._appointments.map((appointment) => _buildAppointmentItem(appointment)),
        ],
      ),
    );
  }

  Widget _buildAppointmentItem(Map<String, dynamic> appointment) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  appointment['name'],
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF333333),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  appointment['time'],
                  style: const TextStyle(
                    color: Color(0xFF666666),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Wrap(
            spacing: 8,
            children: (appointment['tags'] as List<String>).map((tag) {
              Color backgroundColor;
              Color textColor;
              
              switch (tag) {
                case 'GIC':
                  backgroundColor = const Color(0xFFE3F2FD);
                  textColor = const Color(0xFF1976D2);
                  break;
                case 'RA':
                  backgroundColor = const Color(0xFFF3E5F5);
                  textColor = const Color(0xFF7B1FA2);
                  break;
                case 'Confirmed':
                  backgroundColor = const Color(0xFFE8F5E8);
                  textColor = const Color(0xFF2E7D32);
                  break;
                case 'Pending':
                  backgroundColor = const Color(0xFFFFF3E0);
                  textColor = const Color(0xFFF57C00);
                  break;
                case 'Cancelled':
                  backgroundColor = const Color(0xFFFFEBEE);
                  textColor = const Color(0xFFC62828);
                  break;
                default:
                  backgroundColor = Colors.grey.shade200;
                  textColor = Colors.grey.shade700;
              }
              
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  tag,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: textColor,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutDialog() {
    return Container(
      color: Colors.black54,
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 60,
                offset: const Offset(0, 20),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFF8F9FA), Color(0xFFE9ECEF)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: const BoxDecoration(
                        color: Color(0xFFDC3545),
                        borderRadius: BorderRadius.all(Radius.circular(24)),
                      ),
                      child: const Icon(
                        Icons.logout,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Log Out',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF333333),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Body
              const Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  children: [
                    Text(
                      'Are you sure you want to log out of your account?',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF333333),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8),
                    Text(
                      "You'll need to sign in again to access your dashboard.",
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF666666),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              
              // Footer
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          setState(() => _showLogoutDialog = false);
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: BorderSide(color: Colors.grey.shade300),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            color: Color(0xFF666666),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() => _showLogoutDialog = false);
                          // Handle logout
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFDC3545),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text(
                          'Log Out',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF4CAF50),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}
