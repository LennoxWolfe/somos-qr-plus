import 'package:flutter/material.dart';

/// Left sidebar: 280px expanded / 60px collapsed, 300ms ease-in-out.
///
/// **Visual**
/// White panel, 1px right border `grey.shade300`, shadow blur ~8, offset (2,0), ~5% black.
/// Top block: fixed height 120px, solid `#1976D2`. When expanded: white ~90×90 logo area
/// (radius ~15), optional asset or medical icon fallback. Collapse control: top-right,
/// 40×40 white rounded square (radius 8), chevron left/right, icon `#1976D2`.
///
/// **Nav** ([onNavigation] route keys): `dashboard`, `quality`, `schedule`, `patients`,
/// `reports`, `resources`, divider, then `settings`, `logout`.
///
/// Active: `#E3F2FD` fill, 1px `#1976D2` border, radius 12, blue dot; inactive: grey tones.
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
            height: 120,
            decoration: const BoxDecoration(
              color: Color(0xFF1976D2),
            ),
            child: Stack(
              children: [
                // Logo - only when expanded
                if (!_isCollapsed)
                  Positioned(
                    left: 24,
                    top: 16,
                    child: Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(13),
                        child: Image.asset(
                          'assets/images/SOMOS QR.png',
                          width: 86,
                          height: 86,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 86,
                              height: 86,
                              color: Colors.grey[100],
                              child: const Icon(
                                Icons.medical_services,
                                size: 45,
                                color: Color(0xFF1976D2),
                              ),
                            );
                          },
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
