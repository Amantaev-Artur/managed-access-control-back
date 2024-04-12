# README

Для запуска проекта нужны docker и docker compose

Далее выполняем:

`
docker compose up --build
`

В отдельном терминале выполняем

```
docker compose run web rake db:create

docker compose run webp rake db:migrate
```

Проект поднят на http://localhost:3000
