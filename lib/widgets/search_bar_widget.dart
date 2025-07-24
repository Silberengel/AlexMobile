import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SearchBarWidget extends StatefulWidget {
  final Function(String) onSearchChanged;

  const SearchBarWidget({
    super.key,
    required this.onSearchChanged,
  });

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.brandPurple.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _controller,
        onChanged: widget.onSearchChanged,
        decoration: InputDecoration(
          hintText: 'Search publications by title or author...',
          hintStyle: TextStyle(
            color: isDark 
              ? Colors.white.withOpacity(0.6)
              : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            fontSize: 16,
          ),
          prefixIcon: const Icon(
            Icons.search,
            color: AppTheme.brandPurple,
            size: 22,
          ),
          suffixIcon: _controller.text.isNotEmpty
              ? IconButton(
                  onPressed: () {
                    _controller.clear();
                    widget.onSearchChanged('');
                  },
                  icon: const Icon(
                    Icons.clear,
                    color: AppTheme.brandPurple,
                    size: 22,
                  ),
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: AppTheme.brandPurple.withOpacity(0.4),
              width: 1.5,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: AppTheme.brandPurple.withOpacity(0.4),
              width: 1.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: AppTheme.brandPurple,
              width: 2,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 16.0,
          ),
        ),
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
} 