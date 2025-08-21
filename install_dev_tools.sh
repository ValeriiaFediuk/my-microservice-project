#!/bin/bash

set -e

# Функція для перевірки чи інструмент вже встановлено
check_installed() {
    command -v "$1" >/dev/null 2>&1
}

echo "Запуск скрипта встановлення DevOps інструментів для Ubuntu/Debian..."

# Оновлення пакетів
echo "Оновлення списку пакетів..."
sudo apt-get update -y

# Встановлення Docker
if check_installed docker; then
    echo "Docker вже встановлений"
else
    echo "Встановлюємо Docker..."
    sudo apt-get install -y docker.io
    sudo systemctl enable docker
    sudo systemctl start docker
fi

# Встановлення Docker Compose
if check_installed docker-compose; then
    echo "Docker Compose вже встановлений"
else
    echo "Встановлюємо Docker Compose..."
    sudo apt-get install -y docker-compose
fi

# Встановлення Python 3.9+
if check_installed python3; then
    PYTHON_VERSION=$(python3 -V 2>&1 | awk '{print $2}')
    echo "Знайдено Python $PYTHON_VERSION"
else
    echo "Встановлюємо Python..."
    sudo apt-get install -y python3 python3-pip
fi

# Встановлення Django
if python3 -m django --version >/dev/null 2>&1; then
    echo "Django вже встановлений"
else
    echo "Встановлюємо Django..."
    pip3 install django
fi

echo "🎉 Усі інструменти встановлені успішно!"
