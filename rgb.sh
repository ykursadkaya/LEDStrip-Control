#!/bin/bash

num_regex='^[0-9]+$'
RED_PIN='REPLACE' # D16 for example
GREEN_PIN='REPLACE'
BLUE_PIN='REPLACE'
AUTH_TOKEN='REPLACE'
red_val=0
green_val=0
blue_val=0
valid=false

if [ "$#" -eq 1 ]; then
  if [[ "$1" == 'on' ]]; then
    red_val=1023
    green_val=1023
    blue_val=1023
    valid=true
  elif [[ "$1" == 'off' ]]; then
    red_val=0
    green_val=0
    blue_val=0
    valid=true
  elif [[ $1 =~ $num_regex ]]; then
    if [[ $1 -ge 0 && $1 -le 1023 ]]; then
      red_val=$1
      green_val=$1
      blue_val=$1
      valid=true
    else
      printf "%d is out of bounds!\nSee led -h for details.\n" "$1"
    fi
  elif [[ "$1" == '-h' ]] || [[ "$1" == '--help' ]]; then
    printf "Example usage :\n  led on\n  led off\n  led SINGLE_VALUE (0 <= VALUE <= 1023)\n  led RED GREEN BLUE (0 <= VALUE <= 1023)\n"
  else
    printf "%s -> Wrong usage!\nSee led -h for details.\n" "led $1"
  fi
elif [ "$#" -eq 3 ]; then
  if [[ $1 -ge 0 && $1 -le 1023 ]] && [[ $2 -ge 0 && $2 -le 1023 ]] && [[ $3 -ge 0 && $3 -le 1023 ]]; then
    red_val=$1
    green_val=$2
    blue_val=$3
    valid=true
  else
    printf "Value(s) [%d - %d - %d] is/are out of bounds!\nSee led -h for details.\n" "$1" "$2" "$3"
  fi
else
  printf "Wrong usage!\nSee led -h for details.\n"
fi

if [ "$valid" == true ]; then
  curl --request PUT \
    --url http://blynk-cloud.com/$AUTH_TOKEN/update/$RED_PIN \
    --header 'content-type: application/json' \
    --data '[
    '"$red_val"'
  ]'

  curl --request PUT \
    --url http://blynk-cloud.com/$AUTH_TOKEN/update/$GREEN_PIN \
    --header 'content-type: application/json' \
    --data '[
    '"$green_val"'
  ]'

  curl --request PUT \
    --url http://blynk-cloud.com/$AUTH_TOKEN/update/$BLUE_PIN \
    --header 'content-type: application/json' \
    --data '[
    '"$blue_val"'
  ]'
fi
