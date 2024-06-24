

#!/bin/bash

API_KEY="22a98c4e1884e9482531f07c193bf4f8"

# Function to fetch and display weather information
fetch_weather() {
    local city="$1"
    local response=$(curl -s "https://api.openweathermap.org/data/2.5/weather?q=${city}&appid=${API_KEY}&units=metric")
    local status=$(echo "$response" | jq -r '.cod')

    if [ "$status" != "200" ]; then
        local message=$(echo "$response" | jq -r '.message')
        zenity --error --title="Error" --text="Failed to get weather data: $message"
        exit 1
    fi

    local city_name=$(echo "$response" | jq -r '.name')
    local country=$(echo "$response" | jq -r '.sys.country')
    local temp=$(echo "$response" | jq -r '.main.temp')
    local feels_like=$(echo "$response" | jq -r '.main.feels_like')
    local weather=$(echo "$response" | jq -r '.weather[0].description')
    local humidity=$(echo "$response" | jq -r '.main.humidity')
    local wind_speed=$(echo "$response" | jq -r '.wind.speed')

    local output="<html>
<head>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 20px;
            background-color: #f0f0f0;
        }
        .container {
            max-width: 600px;
            margin: auto;
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }
        h1 {
            text-align: center;
            color: #333;
        }
        .weather-info {
            margin-top: 20px;
        }
        .weather-info p {
            margin: 10px 0;
            font-size: 18px;
        }
        .weather-info b {
            color: #555;
        }
    </style>
</head>
<body>
    <div class='container'>
        <h1>Weather in ${city_name}, ${country}</h1>
        <div class='weather-info'>
            <p><b>Temperature:</b> ${temp}°C (Feels like ${feels_like}°C)</p>
            <p><b>Weather:</b> ${weather}</p>
            <p><b>Humidity:</b> ${humidity}%</p>
            <p><b>Wind Speed:</b> ${wind_speed} m/s</p>
        </div>
    </div>
</body>
</html>"

    echo "$output" > weather_report.html

    zenity --text-info --title="Weather Report" --filename=weather_report.html --html
}

# Check if the city name is provided
if [ -z "$1" ]; then
    city=$(zenity --entry --title="Weather Checker" --text="Enter the name of the city:")
    if [ -z "$city" ]; then
        zenity --error --title="Error" --text="City name is required."
        exit 1
    fi
else
    city="$1"
fi

fetch_weather "$city"



