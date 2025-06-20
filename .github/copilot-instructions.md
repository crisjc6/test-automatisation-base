# Stack tecnologico.

## Automatización de APIS

Considera como parte de las respuestas el siguiente stack tecnologico:

- Karate Framework
- Cucumber
- Postman
- Java 21
- Gradle > 8


# Consideraciones de implementación del proyecto.

- Crear features limpios, escalables y trazables
- Integrar Copilot como asistente inteligente
Automatizar desde entradas :
curl 
YAML (Swagger)
Postman COLLECTION

- Garantizar escenarios mínimos: 200, 400, 500
- Utiliza el archivo de configuración `karate-config.js` para definir variables de entorno y configuraciones globales.
- No hardcodear URLs
- Datos separados en JSON reutilizables
- Validaciones 'match' comentadas por defecto
- Uso obligatorio de karate-config.js
- Tags estructurados por HU
- Estructura Estándar del Proyecto

```
src/
├── main/java/.../utils
└── test/
    ├── java/.../features/[microservicio]/
    └── resources/data/[microservicio]/
```