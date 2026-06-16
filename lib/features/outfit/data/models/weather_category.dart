enum WeatherCategory {
  sunny,
  cloudy,
  rainy,
  snowy,
  stormy,
  foggy,
}

class WeatherConditionInfo {
  final String condition;
  final WeatherCategory category;

  const WeatherConditionInfo({
    required this.condition,
    required this.category,
  });
}

class WeatherConditionMapper {
  static WeatherConditionInfo fromCode(int code) {
    switch (code) {
      case 0:
        return const WeatherConditionInfo(condition: "Sunny", category: WeatherCategory.sunny);
      case 1:
        return const WeatherConditionInfo(condition: "Mostly Sunny", category: WeatherCategory.sunny);
      case 2:
        return const WeatherConditionInfo(condition: "Partly Cloudy", category: WeatherCategory.cloudy);
      case 3:
        return const WeatherConditionInfo(condition: "Cloudy", category: WeatherCategory.cloudy);
      
      case 45:
        return const WeatherConditionInfo(condition: "Foggy", category: WeatherCategory.foggy);
      case 48:
        return const WeatherConditionInfo(condition: "Dense Fog", category: WeatherCategory.foggy);
      
      case 51:
        return const WeatherConditionInfo(condition: "Light Drizzle", category: WeatherCategory.rainy);
      case 53:
        return const WeatherConditionInfo(condition: "Moderate Drizzle", category: WeatherCategory.rainy);
      case 55:
        return const WeatherConditionInfo(condition: "Heavy Drizzle", category: WeatherCategory.rainy);
      
      case 61:
        return const WeatherConditionInfo(condition: "Light Rain", category: WeatherCategory.rainy);
      case 63:
        return const WeatherConditionInfo(condition: "Rainy", category: WeatherCategory.rainy);
      case 65:
        return const WeatherConditionInfo(condition: "Heavy Rain", category: WeatherCategory.rainy);
      
      case 71:
        return const WeatherConditionInfo(condition: "Light Snow", category: WeatherCategory.snowy);
      case 73:
        return const WeatherConditionInfo(condition: "Snowy", category: WeatherCategory.snowy);
      case 75:
        return const WeatherConditionInfo(condition: "Heavy Snow", category: WeatherCategory.snowy);
      
      case 77:
        return const WeatherConditionInfo(condition: "Snow Grains", category: WeatherCategory.snowy);
      
      case 80:
        return const WeatherConditionInfo(condition: "Rain Showers", category: WeatherCategory.rainy);
      case 81:
        return const WeatherConditionInfo(condition: "Heavy Rain Showers", category: WeatherCategory.rainy);
      case 82:
        return const WeatherConditionInfo(condition: "Violent Rain Showers", category: WeatherCategory.rainy);
      
      case 85:
        return const WeatherConditionInfo(condition: "Snow Showers", category: WeatherCategory.snowy);
      case 86:
        return const WeatherConditionInfo(condition: "Heavy Snow Showers", category: WeatherCategory.snowy);
      
      case 95:
        return const WeatherConditionInfo(condition: "Thunderstorm", category: WeatherCategory.stormy);
      case 96:
        return const WeatherConditionInfo(condition: "Thunderstorm with Hail", category: WeatherCategory.stormy);
      case 99:
        return const WeatherConditionInfo(condition: "Severe Thunderstorm with Hail", category: WeatherCategory.stormy);
      
      default:
        return const WeatherConditionInfo(condition: "Sunny", category: WeatherCategory.sunny);
    }
  }
}
