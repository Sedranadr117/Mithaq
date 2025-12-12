import 'package:complaint_app/config/extensions/navigator.dart';
import 'package:complaint_app/config/helper/injection_container.dart';
import 'package:complaint_app/config/themes/app_colors.dart';
import 'package:complaint_app/core/databases/cache/cache_helper.dart';
import 'package:complaint_app/features/auth/presentation/pages/welcome_page.dart';
import 'package:flutter/material.dart';

class HomeHeader extends StatefulWidget {
  final Function(String? status) onFilterChanged;

  const HomeHeader({super.key, required this.onFilterChanged});

  @override
  State<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  String selectedFilter = 'الكل';
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const filters = ['الكل', 'قيد المعالجة', 'مرفوضة', 'منجزة', 'جديدة'];

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
                  onPressed: () async {
                    await sl<SecureStorageHelper>().remove('AUTH_TOKEN');
                    context.pushReplacementPage(WelcomeScreen());
                  },
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
        // const SizedBox(height: 16),
        // Container(
        //   decoration: BoxDecoration(color: theme.scaffoldBackgroundColor),
        //   child: TextField(
        //     decoration: InputDecoration(
        //       contentPadding: const EdgeInsets.symmetric(
        //         horizontal: 16,
        //         vertical: 12,
        //       ),
        //       hintText: 'ابحث عن شكوى أو رقم مرجعي',
        //       hintStyle: theme.textTheme.bodyMedium?.copyWith(
        //         color: AppColors.textDisabledLight,
        //       ),
        //       fillColor: theme.scaffoldBackgroundColor,
        //       prefixIcon: const Icon(Icons.search),
        //     ),
        //   ),
        // ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 4,
          children: filters
              .map(
                (filter) => FilterChip(
                  label: Text(filter),
                  onSelected: (_) {
                    setState(() => selectedFilter = filter);
                    widget.onFilterChanged(filter == 'الكل' ? null : filter);
                  },
                  selected: selectedFilter == filter,
                  backgroundColor: theme.scaffoldBackgroundColor,
                  selectedColor: AppColors.primaryColor,
                  checkmarkColor: AppColors.onPrimaryLight,
                  labelStyle: theme.textTheme.bodyMedium?.copyWith(
                    color: selectedFilter == filter
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
