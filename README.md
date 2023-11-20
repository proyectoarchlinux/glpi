# Uso
Contenedor ubuntu:latest

## Estando en el mismo directorio

`docker build -t ubuntu:latest .`

### También se puede usar el ejecutable para automatizarlo

`chmod +x glpi-server.sh`
`./glpi-server.sh`

Se deben usar privilefios root.

## Archivo tar

`docker load -i glpi-server.tar`

# Bugs encontrados

- Mysql server no se inicia al arranque
- sudo es necesario instalarlo
