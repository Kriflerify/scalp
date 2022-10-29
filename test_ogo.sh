#! /bin/zsh

OIP=$(cat $PWD/tmp/ogo_service_addr)
if [[ -n $OIP ]]; then
    REQUEST=$OIP/WeatherForecast
    echo "Request: " $REQUEST "\n"
    curl $OIP/WeatherForecast
fi
