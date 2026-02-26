#!/bin/bash

# Название контейнера
CONTAINER_NAME="bash-it-test"

# Проверка наличия .deb файла в папке bash-it-dpkg
DEB_FILE=$(ls ../bash-it-dpkg_*.deb 2>/dev/null | head -n1)
if [ -z "$DEB_FILE" ]; then
  echo "❌ Не найден файл .deb в директории bash-it-dpkg для тестирования."
  exit 1
fi

echo "📦 Используется пакет: $DEB_FILE"

# Создание временного Dockerfile
cat > Dockerfile.test << 'EOF'
FROM debian:stable-slim

# Установка необходимых зависимостей
RUN apt-get update && apt-get install -y git && rm -rf /var/lib/apt/lists/*

# Создание пользователя testuser
RUN useradd -m -s /bin/bash testuser

# Копируем тестовый скрипт внутрь образа
COPY test-package.sh /root/test-package.sh
RUN chmod +x /root/test-package.sh
WORKDIR /root

# Точка входа - запуск тестового скрипта
CMD ["/root/test-package.sh"]
EOF

# Сборка образа (кэшируется)
echo "🔄 Сборка базового образа..."
docker build -t "$CONTAINER_NAME" -f Dockerfile.test .

if [ $? -ne 0 ]; then
  echo "❌ Ошибка при сборке образа."
  rm -f Dockerfile.test
  exit 1
fi

# Удаление временного Dockerfile
rm -f Dockerfile.test

echo "✅ Образ готов. Запуск контейнера с монтированием .deb..."

# Запуск контейнера с монтированием .deb файла в volume
docker run --rm -it \
  --cap-add=SYS_ADMIN \
  -v "$(pwd)/$DEB_FILE:/home/testuser/$DEB_FILE" \
  "$CONTAINER_NAME"