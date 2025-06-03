#!/bin/bash

# Danh sách các hành vi
ACTIONS=("cpu" "mem" "crash" "network" "disk" "sleep")

# Vòng lặp vô hạn
while true; do
    # Random chọn hành vi
    CHOICE=${ACTIONS[$RANDOM % ${#ACTIONS[@]}]}

    echo "=============================="
    echo "🔁 Randomly selected action: $CHOICE"
    echo "🕒 $(date)"
    echo "=============================="

    case "$CHOICE" in
      cpu)
        echo "🔥 Triggering CPU load..."
        blade create cpu load --cpu-percent 90 --timeout 60
        ;;
      mem)
        echo "🧠 Triggering Memory load..."
        blade create mem load --mem-percent 80 --timeout 60
        ;;
      crash)
        echo "💥 Crashing the app..."
        exit 1
        ;;
      network)
        echo "🌐 Adding 3000ms network delay to eth0..."
        blade create network delay --interface eth0 --time 3000 --timeout 60
        ;;
      disk)
        echo "💾 Filling disk with 512MB..."
        blade create disk fill --size 512 --timeout 60
        ;;
      sleep)
        echo "⏳ App is sleeping (simulated hang)..."
        sleep 600
        ;;
    esac

    # Random sleep từ 10 đến 15 phút
    SLEEP_TIME=$((600 + RANDOM % 300)) # 600s = 10 phút, 900s = 15 phút
    echo "⏳ Waiting $SLEEP_TIME seconds (~$(($SLEEP_TIME / 60)) minutes) before next fault..."
    sleep $SLEEP_TIME
done
