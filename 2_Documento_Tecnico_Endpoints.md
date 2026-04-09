# Documento Técnico de Endpoints - Proyecto INCOMEL Corporativo
**Arquitectura de Automatización con Sub-agentes Inteligentes**

Este documento está redactado como referencia para el equipo de IT e Implementación.

---

## 1. Webhook Desencadenante (Flujo Principal n8n)
* **Punto de Entrada:** `POST http://<container-n8n>:5678/webhook/whatsapp`
* **Descripción:** Escucha de mensajes JSON provenientes de la conectividad WhatsApp.
* **Mecanica:** Identifica el `remoteJid` y el cuerpo `message` para ejecutar la IA.

## 2. Petición de Salida de Mensajería (Evolution API)
* **Punto de Salida:** `POST http://<container-evolution-api>:8080/message/sendText/incomel`
* **Descripción:** Request enviada dende n8n tras concluir el procesamiento cognitivo para devolver el mensaje.
* **Cabeceras Críticas:** Requiere la autenticación `apikey`.

---

## 3. Microservicios Internos (Endpoints Lógicos de n8n)
Esta arquitectura es escalar gracias al puenteado lógico mediante `Execute Workflow`.

### 3.1 Sub-Agente RRHH: `Subflujo Vacaciones`
* **Input Schema:** `{ "query": "String" }`
* **Seguridad Ejecutiva:** La herramienta de código "ConsultarVacaciones" almacena el conteo de bloqueos en una cache estática de n8n para frustrar ataques de fuerza bruta.

### 3.2 Sub-Agente Comercial: `Subflujo Productos`
* **Input Schema:** `{ "query": "String" }`
* **Seguridad Executiva:** Replíca el módulo in-memory logic de seguridad antes de devolver el catálogo de descuentos.

---

## Retorno de Inversión Tecnológico
- El encapsulamiento de agentes especialistas ahorra el consumo de Context Windows frente al modelo unificado tradicional de LLMs.
- Mitiga la inyección de prompts mediante restricciones aisladas y la obligatoriedad del esquema JSON en los `Call n8n Workflow Tools`.
