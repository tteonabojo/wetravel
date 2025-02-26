import 'package:flutter/material.dart';
import 'package:wetravel/core/constants/app_colors.dart';
import 'package:wetravel/core/constants/app_spacing.dart';
import 'package:wetravel/core/constants/app_typography.dart';
import 'package:wetravel/core/constants/app_shadow.dart';
import 'destination_image.dart';

class DestinationCard extends StatelessWidget {
  final String destination;
  final String reason;
  final int matchPercent;
  final bool isSelected;
  final VoidCallback onTap;

  const DestinationCard({
    super.key,
    required this.destination,
    required this.reason,
    required this.matchPercent,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        decoration: BoxDecoration(
          boxShadow: AppShadow.generalShadow,
          border: Border.all(
            color: isSelected ? AppColors.primary_450 : Colors.transparent,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DestinationImage(destination: destination),
            _buildInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildInfo() {
    return Padding(
      padding: AppSpacing.medium16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  destination,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Row(
                children: [
                  const Icon(Icons.star,
                      color: AppColors.primary_450, size: 16),
                  Text(
                    ' $matchPercent% 일치',
                    style: AppTypography.body2.copyWith(
                      color: AppColors.primary_450,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 60,
            child: Text(
              reason,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
