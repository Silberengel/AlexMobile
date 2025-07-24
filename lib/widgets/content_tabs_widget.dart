import 'package:flutter/material.dart';
import '../providers/app_providers.dart';
import '../theme/app_theme.dart';

class ContentTabsWidget extends StatelessWidget {
  final ContentType selectedTab;
  final Function(ContentType) onTabChanged;

  const ContentTabsWidget({
    super.key,
    required this.selectedTab,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        children: [
          _buildTab(context, ContentType.publications, Icons.library_books, 'Publications'),
          const SizedBox(width: 12),
          _buildTab(context, ContentType.articles, Icons.article, 'Articles'),
          const SizedBox(width: 12),
          _buildTab(context, ContentType.wikis, Icons.menu_book, 'Wikis'),
          const SizedBox(width: 12),
          _buildTab(context, ContentType.notes, Icons.note, 'Notes'),
        ],
      ),
    );
  }

  Widget _buildTab(BuildContext context, ContentType tab, IconData icon, String tooltip) {
    final isSelected = selectedTab == tab;
    
    return Expanded(
      child: GestureDetector(
        onTap: () => onTabChanged(tab),
        child: Tooltip(
          message: tooltip,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
            decoration: BoxDecoration(
              color: isSelected 
                ? AppTheme.brandPurple
                : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected 
                  ? AppTheme.brandPurple
                  : AppTheme.brandPurple.withOpacity(0.4),
                width: 1.5,
              ),
              boxShadow: isSelected ? [
                BoxShadow(
                  color: AppTheme.brandPurple.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ] : null,
            ),
            child: Icon(
              icon,
              color: isSelected 
                ? Colors.white
                : AppTheme.brandPurple,
              size: 26,
            ),
          ),
        ),
      ),
    );
  }
} 