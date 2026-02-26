#!/bin/bash

echo "🧪 Начинаем тестирование пакета bash-it-dpkg..."

# Поиск .deb файла
DEB_FILE="/home/testuser/bash-it-dpkg_1.0.1_all.deb"
if [ ! -f "$DEB_FILE" ]; then
  echo "❌ Не найден файл .deb для установки в /home/testuser/."
  exit 1
fi

echo "📦 Найден пакет: $DEB_FILE"

# 1. Установка пакета
echo "1️⃣ Установка пакета..."
dpkg -i $DEB_FILE
if [ $? -ne 0 ]; then
  echo "❌ Ошибка при установке пакета."
  exit 1
fi
echo "✅ Установка завершена."

# 2. Проверка установки
echo "2️⃣ Проверка установки..."
if [ ! -d "/opt/bash-it" ]; then
  echo "❌ Директория /opt/bash-it не найдена."
  exit 1
fi
if [ ! -f "/usr/bin/bashitctl" ]; then
  echo "❌ Команда bashitctl не найдена."
  exit 1
fi
echo "✅ Установка подтверждена. /opt/bash-it и /usr/bin/bashitctl присутствуют."

# 3. Активация для пользователя testuser
echo "3️⃣ Активация bash-it для пользователя testuser..."
bashitctl enable
if [ $? -ne 0 ]; then
  echo "❌ Ошибка при активации."
  exit 1
fi
echo "✅ bash-it активирован."

# 4. Проверка активации (перезапуск оболочки)
echo "4️⃣ Проверка активации (новая оболочка)..."
# Создаем обновленный .bashrc для новой сессии
cat > ~/.bashrc << 'EOF'
# Обновленный .bashrc для теста
if [ -d "/etc/profile.d" ]; then
    for config in /etc/profile.d/*.sh; do
        [ -r "$config" ] && . "$config"
    done
    unset config
fi
EOF

# Запускаем интерактивную оболочку для проверки
echo "    Открывается интерактивная оболочка..."
echo "    Проверьте, загружен ли bash-it (должен быть виден prompt)."
echo "    Введите 'exit' или Ctrl+D для продолжения теста."
bash -l

# 5. Деактивация
echo "5️⃣ Деактивация bash-it..."
bashitctl disable
if [ $? -ne 0 ]; then
  echo "❌ Ошибка при деактивации."
  exit 1
fi
echo "✅ bash-it деактивирован."

# 6. Удаление пакета
echo "6️⃣ Удаление пакета..."
dpkg -r bash-it-dpkg
if [ $? -ne 0 ]; then
  echo "❌ Ошибка при удалении пакета."
  exit 1
fi
echo "✅ Удаление завершено."

echo "🎉 Все тесты пройдены успешно!"