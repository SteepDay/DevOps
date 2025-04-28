#!/bin/bash

CITY=${1:-Moscow}

WEATHER_JSON=$(curl -s "https://wttr.in/$CITY?format=j1")

if [ -z "$WEATHER_JSON" ]; then
  echo "Ошибка: не удалось получить данные о погоде" | sudo tee /var/www/html/index.html
  exit 1
fi

TEMP=$(echo "$WEATHER_JSON" | jq -r '.current_condition[0].temp_C')
HUMIDITY=$(echo "$WEATHER_JSON" | jq -r '.current_condition[0].humidity')
WIND=$(echo "$WEATHER_JSON" | jq -r '.current_condition[0].windspeedKmph')
DESCRIPTION=$(echo "$WEATHER_JSON" | jq -r '.current_condition[0].weatherDesc[0].value')

HTML_CONTENT="<html>
<head>
  <title>Погода в $CITY</title>
  <meta charset='utf-8'>
  <style>
    body { font-family: Arial, sans-serif; margin: 20px; }
    h1 { color: #333; }
    .weather-card {
      background: #f5f5f5;
      padding: 20px;
      border-radius: 10px;
      max-width: 500px;
    }
  </style>
</head>
<body>
  <div class='weather-card'>
    <h1>Погода в $CITY</h1>
    <p><strong>Температура:</strong> $TEMP °C</p>
    <p><strong>Влажность:</strong> $HUMIDITY%</p>
    <p><strong>Ветер:</strong> $WIND км/ч</p>
    <p><strong>Описание:</strong> $DESCRIPTION</p>
    <p><em>Обновлено: $(date +"%Y-%m-%d %H:%M:%S")</em></p>
  </div>
</body>
</html>"

echo "$HTML_CONTENT" | sudo tee /var/www/html/index.html > /dev/null