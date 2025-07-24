import 'package:flutter/material.dart';
import '../theme/zapchat_theme.dart';

enum ContentType {
  all,
  indexes, // 30040
  articles, // 30023
  notes, // 30041
  wikis, // 30818
}

class ContentTypeFilter extends StatelessWidget {
  final ContentType selectedType;
  final Function(ContentType) onTypeChanged;

  const ContentTypeFilter({
    super.key,
    required this.selectedType,
    required this.onTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      margin: const EdgeInsets.symmetric(horizontal: ZapchatTheme.spacing16),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildFilterChip(context, ContentType.all, 'All', Icons.library_books),
          const SizedBox(width: ZapchatTheme.spacing8),
          _buildFilterChip(context, ContentType.indexes, 'Books', Icons.book),
          const SizedBox(width: ZapchatTheme.spacing8),
          _buildFilterChip(context, ContentType.articles, 'Articles', Icons.article),
          const SizedBox(width: ZapchatTheme.spacing8),
          _buildFilterChip(context, ContentType.notes, 'Notes', Icons.note),
          const SizedBox(width: ZapchatTheme.spacing8),
          _buildFilterChip(context, ContentType.wikis, 'Wikis', Icons.article),
        ],
      ),
    );
  }

  Widget _buildFilterChip(
    BuildContext context,
    ContentType type,
    String label,
    IconData icon,
  ) {
    final isSelected = selectedType == type;
    
    return GestureDetector(
      onTap: () => onTypeChanged(type),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(
          horizontal: ZapchatTheme.spacing16,
          vertical: ZapchatTheme.spacing8,
        ),
        decoration: BoxDecoration(
          color: isSelected 
              ? ZapchatTheme.primaryPurple
              : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(ZapchatTheme.radius20),
          border: Border.all(
            color: isSelected 
                ? ZapchatTheme.primaryPurple
                : Theme.of(context).colorScheme.outline.withOpacity(0.2),
            width: 1,
          ),
          boxShadow: isSelected ? ZapchatTheme.shadowSmall : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected 
                  ? Colors.white
                  : Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
            const SizedBox(width: ZapchatTheme.spacing8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected 
                    ? Colors.white
                    : Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Helper function to get content type from event kind
ContentType getContentTypeFromKind(int kind) {
  switch (kind) {
    case 30040:
      return ContentType.indexes;
    case 30023:
      return ContentType.articles;
    case 30041:
      return ContentType.notes;
    case 30818:
      return ContentType.wikis;
    default:
      return ContentType.all;
  }
}

// Helper function to get kind from content type
List<int> getKindsFromContentType(ContentType type) {
  switch (type) {
    case ContentType.indexes:
      return [30040];
    case ContentType.articles:
      return [30023];
    case ContentType.notes:
      return [30041];
    case ContentType.wikis:
      return [30818];
    case ContentType.all:
      return [30040, 30023, 30041, 30818];
  }
} 