# f_box

Web приложение для простого учета посещенных ссылок.

## Установка:
Загрузите репозиторий приложения.

>
> ВАЖНО! Предварительно установите 'Redis'
>

Из корневой папки используем команды:

Установка зависимостей

```
bundle install
```

Запуск сервера:

```
bundle exec rails s
```

Приложение будет доступено по адресу localhost:3000

## Список запросов API:
- `http://localhost:3000/api/v1/visited_links`
    Русурс для передачи в сервис массива ссылов в POST-запросе.
    Время их посещения считается время получения запроса сервисом.

    формат body:
    ```
    {
      "links": [
          "https://ya.ru",
          "https://ya.ru?q=123",
          "funbox.ru",
          "https://stackoverflow.com/questions/11828270/how-to-exit-the-vim-editor"
      ]
    }
    ```

- `visited_domains?from=1545221231&to=1545217638`
    Ресурс для получения GET-запросом списка уникальных доменов, посещенных за переданный интервал времени.
    формат интервала: 'Unix-время'

### Дополнительное описание:

- Данные хранятся с помощью Redis.
- Функционал покрыт тестами.
