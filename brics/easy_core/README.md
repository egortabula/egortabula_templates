# {{projectName.titleCase()}}

Этот проект создан с помощью шаблона `easy_core`.

## 🚀 Как использовать

1. Установи Mason:
   ```sh
   dart pub global activate mason_cli
   ```
2. Добавь шаблон в Mason:
    ```sh
    mason add easy_core --git-url https://github.com/egortabula/mason_bricks.git  --git-path bricks/easy_core
    ```
3. Сгенерируй проект:
   ```sh
   mason make easy_core
   ```
----
## 📂 Структура проекта
```sh
lib/
  app/
    data/          # Данные (модели, API)
    modules/       # Модули (экраны и логика)
    components/    # Вспомогательные компоненты
  core/
    services/      # Сервисы (API и др)
    utils/         # Утилиты
    themes/        # Темы
    values/        # Константы
  routes/
    app_router.dart  # Роутинг
```