import 'package:flutter/material.dart';
import 'package:wetravel/presentation/pages/recommendation/widgets/destination_card.dart';
import 'package:wetravel/presentation/pages/recommendation/widgets/recommendation_header.dart';

class RecommendationListView extends StatelessWidget {
  final List<String> destinations;
  final List<String> reasons;
  final String? selectedDestination;
  final Function(String) onDestinationSelected;

  const RecommendationListView({
    super.key,
    required this.destinations,
    required this.reasons,
    required this.selectedDestination,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const RecommendationHeader(),
        Expanded(
          child: ListView.builder(
            itemCount: destinations.length,
            itemBuilder: (context, index) {
              return DestinationCard(
                destination: destinations[index],
                reason: reasons[index],
                matchPercent: 100 - (index * 10),
                isSelected: selectedDestination == destinations[index],
                onTap: () => onDestinationSelected(destinations[index]),
              );
            },
          ),
        ),
      ],
    );
  }
}
