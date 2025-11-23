import 'package:complaint_app/config/themes/app_colors.dart';
import 'package:flutter/material.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const filters = ['كل الشكاوى', 'قيد المعالجة', 'بانتظار الرد'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // Icons on the right
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.notifications_outlined, size: 22),
                  color: AppColors.primaryColor,
                  tooltip: 'الإشعارات',
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.logout, size: 22),
                  color: AppColors.primaryColor,
                  tooltip: 'تسجيل الخروج',
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            "اهلاً بك،            \n       على مين بدك تشكي؟",
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w900,
              fontSize: 28,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(color: theme.scaffoldBackgroundColor),
          child: TextField(
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              hintText: 'ابحث عن شكوى أو رقم مرجعي',
              hintStyle: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.textDisabledLight,
              ),
              fillColor: theme.scaffoldBackgroundColor,
              prefixIcon: const Icon(Icons.search),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: filters
              .map(
                (filter) => FilterChip(
                  label: Text(filter),
                  onSelected: (_) {},
                  selected: filter == filters.first,
                  backgroundColor: theme.scaffoldBackgroundColor,
                  selectedColor: AppColors.primaryColor,
                  checkmarkColor: AppColors.onPrimaryLight,
                  labelStyle: theme.textTheme.bodyMedium?.copyWith(
                    color: filter == filters.first
                        ? AppColors.onPrimaryLight
                        : AppColors.textSecondaryLight,
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
