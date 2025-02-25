class GetCityTagsUseCase {
  Map<String, List<String>> execute(String city, List<String> travelStyles) {
    final tags = _getCityBaseTags(city);
    return _addTravelStyleTags(tags, travelStyles);
  }

  List<String> _getCityBaseTags(String city) {
    final cityTags = _cityTagsMap[city] ?? ['도시여행', '관광'];
    return cityTags;
  }

  Map<String, List<String>> _addTravelStyleTags(
      List<String> baseTags, List<String> travelStyles) {
    var tags = List<String>.from(baseTags);
    if (travelStyles.contains('맛집')) {
      tags.insert(0, '맛집투어');
    }
    if (travelStyles.contains('쇼핑')) {
      tags.insert(0, '쇼핑');
    }
    return {'tags': tags.take(2).toList()};
  }

  final Map<String, List<String>> _cityTagsMap = {
    '도쿄': ['현대적', '쇼핑천국'],
    '오사카': ['맛집여행', '활기찬'],
    // ... 나머지 도시 태그들
  };
}
