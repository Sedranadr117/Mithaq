import 'package:flutter/material.dart';

class InfoRequestShimmer extends StatefulWidget {
  const InfoRequestShimmer({super.key});

  @override
  State<InfoRequestShimmer> createState() => _InfoRequestShimmerState();
}

class _InfoRequestShimmerState extends State<InfoRequestShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    _animation = Tween<double>(
      begin: -2.0,
      end: 2.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title shimmer
            _buildShimmerBox(width: 150, height: 24, borderRadius: 4),
            const SizedBox(height: 12),
            // Info request cards shimmer (3 items)
            ...List.generate(2, (index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildInfoRequestCardShimmer(),
              );
            }),
          ],
        );
      },
    );
  }

  Widget _buildInfoRequestCardShimmer() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            children: [
              _buildShimmerBox(width: 20, height: 20, borderRadius: 10),
              const SizedBox(width: 8),
              Expanded(
                child: _buildShimmerBox(
                  width: double.infinity,
                  height: 18,
                  borderRadius: 4,
                ),
              ),
              const SizedBox(width: 8),
              _buildShimmerBox(width: 80, height: 24, borderRadius: 4),
            ],
          ),
          const SizedBox(height: 8),
          // Message lines
          _buildShimmerBox(width: double.infinity, height: 16, borderRadius: 4),
          const SizedBox(height: 6),
          _buildShimmerBox(
            width: double.infinity * 0.7,
            height: 16,
            borderRadius: 4,
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerBox({
    required double width,
    required double height,
    required double borderRadius,
  }) {
    return Container(
      width: width == double.infinity ? double.infinity : width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        gradient: LinearGradient(
          begin: Alignment(_animation.value - 1, 0),
          end: Alignment(_animation.value, 0),
          colors: [
            Colors.grey.shade300,
            Colors.grey.shade100,
            Colors.grey.shade300,
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
      ),
    );
  }
}
