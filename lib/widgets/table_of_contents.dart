import 'package:flutter/material.dart';

class TableOfContentsWidget extends StatefulWidget {
  final String content;
  final Function(int) onSectionSelected;

  const TableOfContentsWidget({
    super.key,
    required this.content,
    required this.onSectionSelected,
  });

  @override
  State<TableOfContentsWidget> createState() => _TableOfContentsWidgetState();
}

class _TableOfContentsWidgetState extends State<TableOfContentsWidget> {
  List<Map<String, dynamic>> _sections = [];

  @override
  void initState() {
    super.initState();
    _parseSections();
  }

  @override
  void didUpdateWidget(TableOfContentsWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.content != widget.content) {
      _parseSections();
    }
  }

  void _parseSections() {
    _sections = [];
    final lines = widget.content.split('\n');
    
    for (int i = 0; i < lines.length; i++) {
      final line = lines[i];
      if (line.startsWith('#')) {
        final level = line.split(' ').first.length;
        final title = line.replaceAll(RegExp(r'^#+\s*'), '');
        
        if (title.isNotEmpty) {
          _sections.add({
            'title': title,
            'level': level,
            'index': i,
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey[300]!,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.list,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Table of Contents',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
          
          // Sections list
          Expanded(
            child: _sections.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _sections.length,
                    itemBuilder: (context, index) {
                      final section = _sections[index];
                      return _buildSectionItem(section, index);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionItem(Map<String, dynamic> section, int index) {
    final level = section['level'] as int;
    final title = section['title'] as String;
    final indent = (level - 1) * 16.0;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () => widget.onSectionSelected(index),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
          child: Row(
            children: [
              SizedBox(width: indent),
              // Level indicator
              Container(
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                  color: _getLevelColor(level),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              // Title
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: _getFontSize(level),
                    fontWeight: _getFontWeight(level),
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.list_alt,
            size: 48,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No sections found',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'This publication doesn\'t have\nany section headers',
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

  Color _getLevelColor(int level) {
    switch (level) {
      case 1:
        return Theme.of(context).colorScheme.primary;
      case 2:
        return Theme.of(context).colorScheme.secondary;
      case 3:
        return Theme.of(context).colorScheme.tertiary;
      default:
        return Colors.grey[500]!;
    }
  }

  double _getFontSize(int level) {
    switch (level) {
      case 1:
        return 16;
      case 2:
        return 14;
      case 3:
        return 13;
      default:
        return 12;
    }
  }

  FontWeight _getFontWeight(int level) {
    switch (level) {
      case 1:
        return FontWeight.bold;
      case 2:
        return FontWeight.w600;
      case 3:
        return FontWeight.w500;
      default:
        return FontWeight.normal;
    }
  }
} 