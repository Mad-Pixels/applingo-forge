# Создаем новое окружение и устанавливаем зависимости
poetry install

# Запускаем python через poetry run
poetry run python src/lambdas/hello/handler.py

# Или входим в shell poetry и запускаем
poetry shell
python src/lambdas/hello/handler.py