import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../tryon/providers/tryon_provider.dart';
import '../../clothing/providers/clothing_provider.dart';
import '../widgets/history_item_card.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  String _selectedFilter = 'all';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TryOnProvider>().loadTryOnHistory();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Try-On History'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                _selectedFilter = value;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'all',
                child: Text('All'),
              ),
              const PopupMenuItem(
                value: 'today',
                child: Text('Today'),
              ),
              const PopupMenuItem(
                value: 'week',
                child: Text('This Week'),
              ),
              const PopupMenuItem(
                value: 'month',
                child: Text('This Month'),
              ),
            ],
            child: const Icon(Icons.filter_list),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: _showClearHistoryDialog,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Recent', icon: Icon(Icons.schedule)),
            Tab(text: 'Favorites', icon: Icon(Icons.favorite)),
            Tab(text: 'Shared', icon: Icon(Icons.share)),
          ],
        ),
      ),
      body: Consumer<TryOnProvider>(
        builder: (context, tryOnProvider, child) {
          final history = _getFilteredHistory(tryOnProvider.tryOnHistory);

          if (history.isEmpty) {
            return _buildEmptyState();
          }

          return TabBarView(
            controller: _tabController,
            children: [
              _buildHistoryList(history, 'recent'),
              _buildHistoryList(history.where((item) => true).toList(), 'favorites'), // TODO: 实现收藏过滤
              _buildHistoryList(history.where((item) => true).toList(), 'shared'), // TODO: 实现分享过滤
            ],
          );
        },
      ),
    );
  }

  List<dynamic> _getFilteredHistory(List<dynamic> history) {
    final now = DateTime.now();
    
    switch (_selectedFilter) {
      case 'today':
        return history.where((item) {
          final itemDate = item.timestamp as DateTime;
          return itemDate.year == now.year &&
                 itemDate.month == now.month &&
                 itemDate.day == now.day;
        }).toList();
      case 'week':
        final weekAgo = now.subtract(const Duration(days: 7));
        return history.where((item) {
          final itemDate = item.timestamp as DateTime;
          return itemDate.isAfter(weekAgo);
        }).toList();
      case 'month':
        final monthAgo = DateTime(now.year, now.month - 1, now.day);
        return history.where((item) {
          final itemDate = item.timestamp as DateTime;
          return itemDate.isAfter(monthAgo);
        }).toList();
      default:
        return history;
    }
  }

  Widget _buildHistoryList(List<dynamic> history, String type) {
    if (history.isEmpty) {
      return _buildEmptyStateForTab(type);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: history.length,
      itemBuilder: (context, index) {
        final tryOnResult = history[index];
        return HistoryItemCard(
          tryOnResult: tryOnResult,
          onTap: () => _viewResult(tryOnResult),
          onShare: () => _shareResult(tryOnResult),
          onDelete: () => _deleteResult(tryOnResult),
          onRetry: () => _retryTryOn(tryOnResult),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 24),
          const Text(
            'No Try-On History',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Your try-on results will appear here\nafter you start using virtual try-on',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () {
              context.go('/tryon');
            },
            icon: const Icon(Icons.camera_alt),
            label: const Text('Try On Now'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyStateForTab(String type) {
    String title;
    String subtitle;
    IconData icon;

    switch (type) {
      case 'favorites':
        title = 'No Favorite Try-Ons';
        subtitle = 'Mark try-ons as favorites to see them here';
        icon = Icons.favorite_border;
        break;
      case 'shared':
        title = 'No Shared Try-Ons';
        subtitle = 'Share your try-on results to see them here';
        icon = Icons.share;
        break;
      default:
        title = 'No Recent Try-Ons';
        subtitle = 'Start trying on clothes to see your history';
        icon = Icons.schedule;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  void _viewResult(dynamic tryOnResult) {
    // TODO: 设置当前试衣结果并导航到结果页面
    context.go('/tryon/result');
  }

  void _shareResult(dynamic tryOnResult) {
    // TODO: 实现分享功能
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Share feature coming soon!')),
    );
  }

  void _deleteResult(dynamic tryOnResult) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Try-On'),
        content: const Text('Are you sure you want to delete this try-on result?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<TryOnProvider>().deleteTryOnFromHistory(tryOnResult.id);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Try-on deleted')),
              );
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _retryTryOn(dynamic tryOnResult) {
    // TODO: 设置相同的服装ID并导航到试衣页面
    context.go('/tryon');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Ready to try on the same clothing')),
    );
  }

  void _showClearHistoryDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear History'),
        content: const Text('Are you sure you want to clear all try-on history? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _clearHistory();
            },
            child: const Text(
              'Clear All',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _clearHistory() {
    final tryOnProvider = context.read<TryOnProvider>();
    final historyIds = tryOnProvider.tryOnHistory.map((item) => item.id).toList();
    
    for (final id in historyIds) {
      tryOnProvider.deleteTryOnFromHistory(id);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('History cleared'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}