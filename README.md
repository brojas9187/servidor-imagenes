# Servidor de imagenes

Aplicacion Rails para subir imagenes y obtener enlaces directos compatibles con
plugins como ImageFrame para Minecraft.

## Desarrollo local

```bash
bin/rails db:prepare
bin/rails server
```

La app queda disponible en `http://127.0.0.1:3000`.

## Docker

```bash
docker build -t servidor-imagenes .
docker run --rm -p 3000:3000 -e SECRET_KEY_BASE=$(bin/rails secret) servidor-imagenes
```

## Railway

Railway usara el `Dockerfile` mediante `railway.toml`.

Variables necesarias:

- `SECRET_KEY_BASE`: genera uno con `bin/rails secret`.

No configures `RAILS_MASTER_KEY` in Railway unless you copy the exact contents of
your local `config/master.key`. Do not use `bin/rails secret` for
`RAILS_MASTER_KEY`; that value belongs only in `SECRET_KEY_BASE`.

Importante: esta app usa SQLite y Active Storage en disco local. En Railway debes
crear un volumen y montarlo en `/rails/storage` para que la base de datos y las
imagenes subidas sobrevivan a redeploys.

## Pruebas

```bash
bin/rails test
```
