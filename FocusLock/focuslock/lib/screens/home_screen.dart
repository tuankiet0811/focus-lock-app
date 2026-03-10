import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/focus_service.dart';
import '../utils/helpers.dart';
import '../utils/constants.dart';
import '../widgets/focus_timer_widget.dart';
import '../widgets/quick_start_widget.dart';
import '../widgets/stats_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Consumer<FocusService>(
        builder: (context, focusService, child) {
          return SafeArea(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: CustomScrollView(
                  slivers: [
                    // App Bar
                    SliverAppBar(
                      expandedHeight: 120,
                      floating: false,
                      pinned: true,
                      backgroundColor: const Color(AppConstants.primaryColor),
                      elevation: 0,
                      flexibleSpace: FlexibleSpaceBar(
                        title: const Text(
                          'FocusLock',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                        background: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(AppConstants.primaryColor),
                                Color(0xFF1976D2),
                              ],
                            ),
                          ),
                        ),
                      ),
                      actions: [
                        IconButton(
                          icon: const Icon(Icons.settings, color: Colors.white),
                          onPressed: () {
                            // TODO: Navigate to settings
                          },
                        ),
                      ],
                    ),
                    
                    // Content
                    SliverPadding(
                      padding: const EdgeInsets.all(16.0),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          // Welcome Message
                          Container(
                            margin: const EdgeInsets.only(bottom: 24),
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFFE3F2FD), Color(0xFFBBDEFB)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.blue.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(
                                    Icons.psychology,
                                    color: Color(AppConstants.primaryColor),
                                    size: 32,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        focusService.isActive 
                                            ? 'Đang tập trung...' 
                                            : 'Sẵn sàng tập trung?',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF1565C0),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        focusService.isActive
                                            ? 'Hãy giữ vững tinh thần!'
                                            : 'Hãy bắt đầu phiên tập trung mới',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          // Focus Timer Widget
                          if (focusService.isActive) ...[
                            FocusTimerWidget(
                              remainingSeconds: focusService.remainingSeconds,
                              completionPercentage: focusService.getCompletionPercentage(),
                              onStop: () => focusService.stopSession(),
                              onPause: () => focusService.pauseSession(),
                            ),
                            const SizedBox(height: 24),
                          ],
                          
                          // Quick Start Widget
                          if (!focusService.isActive) ...[
                            QuickStartWidget(
                              onStartSession: (duration, goal) {
                                focusService.startSession(
                                  durationMinutes: duration,
                                  goal: goal,
                                );
                              },
                            ),
                            const SizedBox(height: 24),
                          ],
                          
                          // Statistics Widget
                          StatsWidget(
                            todayFocusTime: focusService.getTodayFocusTime(),
                            thisWeekFocusTime: focusService.getThisWeekFocusTime(),
                            totalSessions: focusService.sessions.length,
                          ),
                          
                          const SizedBox(height: 24),
                          
                          // Recent Sessions
                          _buildRecentSessions(focusService),
                          
                          const SizedBox(height: 100), // Bottom padding
                        ]),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(AppConstants.primaryColor),
        unselectedItemColor: Colors.grey[600],
        currentIndex: 0,
        onTap: (index) {
          // TODO: Navigate to different screens
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Trang chủ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Lịch sử',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.apps),
            label: 'Ứng dụng',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Thống kê',
          ),
        ],
      ),
    );
  }

  Widget _buildRecentSessions(FocusService focusService) {
    final recentSessions = focusService.sessions
        .where((session) => !session.isActive)
        .take(5)
        .toList();

    if (recentSessions.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(
              Icons.history,
              size: 48,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Chưa có phiên tập trung nào',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Bắt đầu phiên tập trung đầu tiên của bạn!',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                const Icon(
                  Icons.history,
                  color: Color(AppConstants.primaryColor),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Phiên gần đây',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    // TODO: Navigate to history screen
                  },
                  child: const Text('Xem tất cả'),
                ),
              ],
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: recentSessions.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final session = recentSessions[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: const Color(AppConstants.primaryColor).withOpacity(0.1),
                  child: Icon(
                    Icons.timer,
                    color: const Color(AppConstants.primaryColor),
                  ),
                ),
                title: Text(
                  session.goal ?? 'Phiên tập trung',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                subtitle: Text(
                  '${Helpers.formatDuration(session.durationMinutes)} • ${Helpers.formatDate(session.startTime)}',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                trailing: Text(
                  Helpers.formatDuration(session.durationMinutes),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(AppConstants.primaryColor),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
} 