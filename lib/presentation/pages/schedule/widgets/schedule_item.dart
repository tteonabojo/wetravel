import 'package:flutter/material.dart';
import 'package:wetravel/core/constants/app_colors.dart';

class ScheduleItem extends StatelessWidget {
  final String time;
  final String title;
  final String location;
  final bool isEditMode;
  final VoidCallback? onTap;
  final Key itemKey;

  const ScheduleItem({
    required this.time,
    required this.title,
    required this.location,
    required this.isEditMode,
    required this.itemKey,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: itemKey,
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: AppColors.grayScale_150,
          borderRadius: BorderRadius.circular(12),
          border: isEditMode
              ? Border.all(color: AppColors.primary_550, width: 2)
              : null,
        ),
        child: Row(
          children: [
            Expanded(
              child: _buildContent(),
            ),
            if (isEditMode) ...[
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Icon(
                  Icons.edit,
                  color: AppColors.grayScale_450,
                  size: 20,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.drag_handle,
                  color: AppColors.grayScale_450,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            time,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.location_on_outlined,
                  color: Colors.grey[600], size: 16),
              const SizedBox(width: 4),
              Text(
                location,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
