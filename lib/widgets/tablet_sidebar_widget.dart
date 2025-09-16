import 'package:flutter/material.dart';

class TabletSidebarWidget extends StatefulWidget {
  final Function(String) onNavigation;
  final String activeRoute;

  const TabletSidebarWidget({
    super.key,
    required this.onNavigation,
    required this.activeRoute,
  });

  @override
  State<TabletSidebarWidget> createState() => _TabletSidebarWidgetState();
}

class _TabletSidebarWidgetState extends State<TabletSidebarWidget> {
  bool _isCollapsed = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      width: _isCollapsed ? 60 : 280,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          right: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(2, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          // Sidebar Header - SIMPLE AND WORKING
          Container(
            width: double.infinity,
            height: 80,
            decoration: const BoxDecoration(
              color: Color(0xFF1976D2),
            ),
            child: Stack(
              children: [
                // Avatar - only when expanded
                if (!_isCollapsed)
                  Positioned(
                    left: 24,
                    top: 16,
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: const Color(0xFF4CAF50), width: 2),
                      ),
                      child: const Center(
                        child: Text(
                          'JC',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                
                // Toggle Button - ALWAYS VISIBLE
                Positioned(
                  right: _isCollapsed ? 8 : 16,
                  top: 20,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _isCollapsed = !_isCollapsed;
                      });
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Icon(
                          _isCollapsed ? Icons.chevron_right : Icons.chevron_left,
                          color: const Color(0xFF1976D2),
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Sidebar Content
          Expanded(
            child: Container(
              color: Colors.white,
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 16),
                children: [
                  _buildSidebarItem(
                    'Dashboard', 
                    Icons.dashboard_outlined, 
                    Icons.dashboard, 
                    widget.activeRoute == 'dashboard', 
                    () => widget.onNavigation('dashboard')
                  ),
                  _buildSidebarItem(
                    'Quality Score Cards', 
                    Icons.assessment_outlined, 
                    Icons.assessment, 
                    widget.activeRoute == 'quality', 
                    () => widget.onNavigation('quality')
                  ),
                  _buildSidebarItem(
                    'My Schedule', 
                    Icons.schedule_outlined, 
                    Icons.schedule, 
                    widget.activeRoute == 'schedule', 
                    () => widget.onNavigation('schedule')
                  ),
                  _buildSidebarItem(
                    'My Patients', 
                    Icons.people_outline, 
                    Icons.people, 
                    widget.activeRoute == 'patients', 
                    () => widget.onNavigation('patients')
                  ),
                  _buildSidebarItem(
                    'Reports', 
                    Icons.bar_chart_outlined, 
                    Icons.bar_chart, 
                    widget.activeRoute == 'reports', 
                    () => widget.onNavigation('reports')
                  ),
                  _buildSidebarItem(
                    'Resources', 
                    Icons.folder_outlined, 
                    Icons.folder, 
                    widget.activeRoute == 'resources', 
                    () => widget.onNavigation('resources')
                  ),
                  
                  // Divider
                  Container(
                    height: 1,
                    color: const Color(0xFFE0E0E0),
                    margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  ),
                  
                  _buildSidebarItem(
                    'Settings', 
                    Icons.settings_outlined, 
                    Icons.settings, 
                    widget.activeRoute == 'settings', 
                    () => widget.onNavigation('settings')
                  ),
                  _buildSidebarItem(
                    'Log Out', 
                    Icons.logout_outlined, 
                    Icons.logout, 
                    false, 
                    () => widget.onNavigation('logout')
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarItem(
    String title, 
    IconData inactiveIcon, 
    IconData activeIcon, 
    bool isActive, 
    VoidCallback onTap
  ) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: _isCollapsed ? 8 : 12, 
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFFE3F2FD) : Colors.transparent,
        borderRadius: BorderRadius.circular(_isCollapsed ? 8 : 12),
        border: Border.all(
          color: isActive ? const Color(0xFF1976D2) : Colors.transparent,
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(_isCollapsed ? 8 : 12),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: _isCollapsed ? 12 : 16, 
              vertical: 16,
            ),
            child: _isCollapsed 
              ? Center(
                  child: Icon(
                    isActive ? activeIcon : inactiveIcon,
                    color: isActive ? const Color(0xFF1976D2) : const Color(0xFF666666),
                    size: 24,
                  ),
                )
              : Row(
                  children: [
                    Icon(
                      isActive ? activeIcon : inactiveIcon,
                      color: isActive ? const Color(0xFF1976D2) : const Color(0xFF666666),
                      size: 24,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          color: isActive ? const Color(0xFF1976D2) : const Color(0xFF333333),
                          fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                        ),
                      ),
                    ),
                    if (isActive)
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: Color(0xFF1976D2),
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
          ),
        ),
      ),
    );
  }
}
