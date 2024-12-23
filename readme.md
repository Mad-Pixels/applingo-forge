# Создаем новое окружение и устанавливаем зависимости
poetry install

# Запускаем python через poetry run
poetry run python src/lambdas/hello/handler.py

# Или входим в shell poetry и запускаем
poetry shell
python src/lambdas/hello/handler.py


# Для AMD64
docker build --platform linux/amd64 --target amd64 --build-arg LAMBDA_NAME=hello -t lambda-hello:amd64 .

# Для ARM64
docker build --platform linux/arm64/v8 --target arm64 --build-arg LAMBDA_NAME=hello -t lambda-hello:arm64 .

# Taskfile
brew install go-task/tap/go-task