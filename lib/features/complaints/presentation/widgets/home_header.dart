import 'package:complaint_app/config/extensions/navigator.dart';
import 'package:complaint_app/config/themes/app_colors.dart';
import 'package:complaint_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:complaint_app/features/notification/presentation/bloc/notification_bloc.dart';
import 'package:complaint_app/features/notification/presentation/bloc/notification_state.dart';
import 'package:complaint_app/features/notification/presentation/pages/notification_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    const filters = [
      'الكل',
      'قيد المعالجة',
      'مرفوضة',
      'منجزة',
      'جديدة',
      'طلب معلومات',
    ];

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
                BlocBuilder<NotificationBloc, NotificationState>(
                  builder: (context, state) {
                    bool hasUnread = false;

                    if (state is NotificationSuccess) {
                      hasUnread = state.notifications.any(
                        (n) => n.readAt == null,
                      );
                    }

                    return Stack(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.notifications_outlined,
                            size: 22,
                          ),
                          color: AppColors.primaryColor,
                          tooltip: 'الإشعارات',
                          onPressed: () {
                            context.pushPage(NotificationPage());
                          },
                        ),

                        if (hasUnread)
                          Positioned(
                            right: 8,
                            top: 8,
                            child: Container(
                              width: 5,
                              height: 5,
                              decoration: BoxDecoration(
                                color: theme.colorScheme.error,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),

                IconButton(
                  icon: const Icon(Icons.logout, size: 22),
                  color: AppColors.primaryColor,
                  tooltip: 'تسجيل الخروج',
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        backgroundColor: Theme.of(
                          context,
                        ).scaffoldBackgroundColor,
                        title: const Text(
                          "تسجيل الخروج",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        content: const Text(
                          "هل أنت متأكد أنك تريد تسجيل الخروج؟",
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text("إلغاء"),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: Theme.of(
                                context,
                              ).colorScheme.primary,
                              foregroundColor: Theme.of(
                                context,
                              ).colorScheme.onSurface,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () async {
                              context.read<AuthBloc>().add(const LogoutEvent());
                              Navigator.pop(context);
                            },
                            child: Text(
                              "تسجيل خروج",
                              style: TextStyle(
                                color: Theme.of(
                                  context,
                                ).scaffoldBackgroundColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            "اهلاً بك،            \n      قدّم شكواك بكل سهولة..",
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
