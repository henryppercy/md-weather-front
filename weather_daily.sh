#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

log_info() {
  echo -e "[INFO] $(date '+%Y-%m-%d %H:%M:%S') - $1"
}

log_success() {
  echo -e "${GREEN}[SUCCESS]${NC} $(date '+%Y-%m-%d %H:%M:%S') - $1"
}

log_warn() {
  echo -e "${YELLOW}[WARN]${NC} $(date '+%Y-%m-%d %H:%M:%S') - $1"
}

log_error() {
  echo -e "${RED}[ERROR]${NC} $(date '+%Y-%m-%d %H:%M:%S') - $1"
}

APP_ID=$1

year_dir=$(date +"%Y")
month_num=$(date +"%m")
month_str=$(date +"%B")
month_dir="$month_num-$month_str"
iso_date_dir=$(date +"%F")

todays_path="$HOME/Obsidian/Obsidian/Timestamps/Work/$year_dir/$month_dir/$iso_date_dir.md"

if ! [ -e $todays_path ]; then
  log_warn "Today's daily note does not yet exist: $todays_path"
  exit 1
fi
log_info "Editing the frontmatter within $todays_path"

response=$(curl -f -sS -connect-timeout 10 --max-time 30 "https://api.openweathermap.org/data/3.0/onecall?lat=51.4659&lon=0.1413&units=metric&appid=$APP_ID")
exit_status=$?

if ! [ $exit_status -eq 0 ]; then
  log_error "Failed to retrieve weather data with exit code $exit_status"
  exit 1
fi

log_success "Weather data retrieved successfully"

weather_data=$(echo $response | /opt/homebrew/bin/jq -r '.daily[0] | {temperature: .temp.day, weather: .weather[0].main, sunrise: .sunrise, sunset: .sunset}')

temperature=$(echo $weather_data | /opt/homebrew/bin/jq -r .temperature)
weather=$(echo $weather_data | /opt/homebrew/bin/jq -r '.weather' | tr '[:upper:]' '[:lower:]')
sunset=$(echo $weather_data | /opt/homebrew/bin/jq -r .sunset)
sunrise=$(echo $weather_data | /opt/homebrew/bin/jq -r .sunrise)

readable_sunset=$(date -r "$sunset" '+%F %T')
readable_sunrise=$(date -r "$sunrise" '+%F %T')

update_yaml() {
  local key=$1 value=$2 path=$3
  /usr/bin/sed -i '' "/^---$/,/^---$/{/^$key: /s/:.*/: $value/;}" "$path"
}

update_yaml "temperature" "$temperature" "$todays_path"
update_yaml "weather" "$weather" "$todays_path"
update_yaml "sunset" "$readable_sunset" "$todays_path"
update_yaml "sunrise" "$readable_sunrise" "$todays_path"

log_success "Frontmatter updated successfully"
