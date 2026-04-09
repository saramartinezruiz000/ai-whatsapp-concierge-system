# 🤖 Autonomous AI Concierge for WhatsApp
Este proyecto despliega una arquitectura corporativa basada en microagentes inteligentes para empresas. 

### 🚨 El Problema
Las empresas medianas y grandes saturan a sus departamentos de soporte interno (HR) y ventas, perdiendo trazabilidad y demorando en responder consultas, cotizaciones e inventarios por WhatsApp.

### 💡 La Solución
Implementación de un Webhook nativo mediante **Evolution API** y el orquestador **n8n**. Un Agente de Lenguaje Grande (LLM) entrenado con LangChain detecta la intención del texto. Si el usuario necesita consultar datos sensibles, el bot utiliza "Tools Calling" para acceder a una base de datos relacional (PostgreSQL), validando credenciales In-Memory y devolviendo la información estructurada instantáneamente sin intervención humana.

### 🛠 Stack Tecnológico Utilizado
- **Orquestación:** n8n (Node-based automation)
- **Generative AI:** Google Gemini 1.5 Pro / LangChain
- **Base de Datos:** PostgreSQL
- **Comunicaciones:** Evolution API (WhatsApp Business)
- **Infraestructura:** Docker & Docker Compose

*Desarrollado y arquitectado por Sara Martinez Ruiz.*

