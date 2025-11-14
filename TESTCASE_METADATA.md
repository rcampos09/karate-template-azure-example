# 📋 Guía de Metadatos para Test Cases

Este documento explica cómo usar tags de metadatos en los feature files para personalizar los comentarios en Azure Test Plans.

## 🏷️ Tag @Type (Opcional)

El tag `@Type` permite personalizar el formato del comentario que aparece en Azure DevOps Test Results.

### Uso Básico

Agrega el tag `@Type` junto al tag `@TestCase`:

```gherkin
@TestCase=9
@Type=LoginSuccess
@Offline
Scenario Outline: TC9_Login exitoso con credenciales válidas
```

### Tipos Soportados

| @Type | Descripción del Comentario | Ejemplo de Uso |
|-------|---------------------------|----------------|
| `LoginSuccess` | "Login exitoso" | Tests de autenticación exitosa |
| `LoginFailed` | "Login fallido esperado" | Tests de validación de credenciales |
| `CreateUser` | "Usuario creado" | Tests de creación de recursos |
| `UpdateUser` | "Usuario actualizado" | Tests de actualización de datos |
| `DeleteUser` | "Usuario eliminado" | Tests de eliminación de recursos |
| `GetData` | "Datos obtenidos" | Tests de consultas GET |
| `ValidateData` | "Datos validados" | Tests de validaciones |

**Nota:** Si usas un @Type que no está en la lista, se usará el nombre del Scenario Outline.

### Sin @Type (Formato Genérico)

Si NO agregas el tag `@Type`, el sistema usará automáticamente el nombre del Scenario Outline:

```gherkin
@TestCase=12
@Offline
Scenario Outline: TC12_Validar respuesta de API
```

**Resultado:** El comentario mostrará "Validar respuesta de API"

## 📊 Formato de Comentarios

### Con @Type=LoginSuccess

```
✓ TC9 - Iteración 1/6: Login exitoso
Parámetros:
  • email: eve.holt@reqres.in
  • expectedStatus: 200
  • password: ********
  • timeout: 2000
Duración: 2171ms
```

### Sin @Type (Genérico)

```
✓ TC12 - Iteración 3/10: Validar respuesta de API
Parámetros:
  • endpoint: /users/list
  • expectedCode: 200
  • validateSchema: true
Duración: 450ms
```

## 🔐 Seguridad

- Las columnas llamadas `password` automáticamente se ocultan mostrando `********`
- Todos los demás parámetros se muestran con sus valores reales

## ✅ Mejores Prácticas

1. **Usa @Type para tests comunes**: Si tu test es de Login, Crear Usuario, etc., usa los tipos predefinidos
2. **No uses @Type para tests únicos**: Si el test es muy específico, deja que use el nombre del Scenario
3. **Nombres descriptivos**: Asegúrate que el Scenario Outline tenga un nombre claro
4. **Consistencia**: Usa el mismo @Type para tests similares

## 🚀 Escalabilidad

El sistema es **completamente automático**:
- ✅ Descubre TODOS los @TestCase en el feature file
- ✅ Extrae TODAS las columnas de la tabla Examples
- ✅ Funciona con CUALQUIER número de Test Cases
- ✅ No requiere modificar el pipeline al agregar nuevos tests

## 📝 Ejemplos Completos

### Test de Login Exitoso
```gherkin
@TestCase=9
@Type=LoginSuccess
@Offline
Scenario Outline: TC9_Login exitoso con credenciales válidas
    Given path '/login'
    And request { "email": "<email>", "password": "<password>" }
    When method POST
    Then status <expectedStatus>

Examples:
    | email              | password   | expectedStatus |
    | test@example.com   | pass123    | 200            |
```

### Test Sin @Type
```gherkin
@TestCase=15
@Offline
Scenario Outline: TC15_Validar paginación de resultados
    Given path '/users'
    And param page = '<page>'
    When method GET
    Then status 200

Examples:
    | page | expectedCount |
    | 1    | 10            |
    | 2    | 10            |
```

## 🆕 Agregar Nuevos Tipos

Para agregar un nuevo tipo personalizado, edita el archivo `azure-pipelines.yml`:

```powershell
switch ($type) {
    "LoginSuccess" { "Login exitoso" }
    "LoginFailed" { "Login fallido esperado" }
    "CreateUser" { "Usuario creado" }
    "TuNuevoTipo" { "Tu descripción personalizada" }  # <-- Agregar aquí
    default { $scenarioName }
}
```

## ❓ Preguntas Frecuentes

**P: ¿Es obligatorio usar @Type?**
R: No, es completamente opcional. Sin @Type, el sistema usa el nombre del Scenario Outline.

**P: ¿Puedo tener Test Cases sin @Type y con @Type en el mismo feature file?**
R: Sí, puedes mezclarlos sin problema.

**P: ¿Qué pasa si escribo mal el @Type?**
R: Si no coincide con ningún tipo predefinido, se usará el nombre del Scenario Outline.

**P: ¿El sistema funciona con Test Cases de otros archivos .feature?**
R: Actualmente solo procesa `TC12345_ValidarLogin.feature`. Para múltiples archivos, necesitarías modificar el pipeline para procesar todos los .feature del proyecto.
