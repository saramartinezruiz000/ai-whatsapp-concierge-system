# Manual de Despliegue en Docker - INCOMEL Corporativo
**Guía técnica paso a paso para levantar la infraestructura del Chatbot.**

Esta arquitectura de microservicios está montada sobre 3 contenedores:
1. **PostgreSQL**
2. **Evolution API** 
3. **n8n** 

---

## Paso 1: Archivo `docker-compose.yml`
Crea una carpeta llamada `bot-incomel`, abre una terminal en esa carpeta y crea un archivo llamado `docker-compose.yml` pegando la siguiente definición:

```yaml
version: '3.8'

services:
  hr_postgres:
    image: postgres:15
    container_name: hr_postgres
    restart: always
    environment:
      POSTGRES_USER: root
      POSTGRES_PASSWORD: rootpassword
      POSTGRES_DB: hr_database
    ports:
      - "5432:5432"
    volumes:
      - hr_db_data:/var/lib/postgresql/data
      - ./init.sql:/docker-entrypoint-initdb.d/init.sql
    networks:
      - hr_network

  hr_evolution_api:
    image: atendai/evolution-api:v2.1.2
    container_name: hr_evolution_api
    restart: always
    ports:
      - "8080:8080"
    environment:
      - SERVER_PORT=8080
      - AUTHENTICATION_API_KEY=super-secret-global-key
      - DATABASE_PROVIDER=postgresql
      - DATABASE_CONNECTION_URI=postgresql://root:rootpassword@hr_postgres:5432/hr_database
      - WEBHOOK_GLOBAL_ENABLED=true
      - DEL_INSTANCE=true
    depends_on:
      - hr_postgres
    networks:
      - hr_network

  hr_n8n:
    image: n8nio/n8n:latest
    container_name: hr_n8n
    restart: always
    ports:
      - "5678:5678"
    environment:
      - N8N_HOST=0.0.0.0
      - N8N_PORT=5678
      - N8N_PROTOCOL=http
      - WEBHOOK_URL=http://<TU_IP_O_NGROK>/
      - GENERIC_TIMEZONE=America/Guatemala
    volumes:
      - hr_n8n_data:/home/node/.n8n
    networks:
      - hr_network

networks:
  hr_network:
    driver: bridge

volumes:
  hr_db_data:
  hr_n8n_data:
```

## Paso 2: Inicialización y Despliegue
Guarda el archivo SQL provisto en tus entregables y renómbralo a `init.sql`. Colócalo en la misma carpeta que tu `docker-compose.yml`. 

Ejecuta el siguiente comando en la terminal para levantar todo:
```bash
docker compose up -d
```

## Paso 3: Inicializar Evolution API (Ligar WhatsApp)
Haz una petición POST a Evolution API para crear la instancia:
- **URL:** `http://localhost:8080/instance/create`
- **Headers:** `apikey: super-secret-global-key`
- **Body JSON:**
  ```json
  {
    "instanceName": "incomel",
    "token": "incomel-token",
    "b64": true
  }
  ```
Escanea el código QR base64 con el celular corporativo.

## Paso 4: Configurar n8n
1. Entra a `http://localhost:5678`.
2. Importa los 3 `.json` del entregable *(Flujo Principal, Subflujo Vacaciones, Subflujo Productos)*.
3. Abre el **Flujo Principal**, copia la Test URL de tu Webhook y cónfigurala en Evolution API con la ruta: `http://localhost:8080/webhook/set/incomel`.
