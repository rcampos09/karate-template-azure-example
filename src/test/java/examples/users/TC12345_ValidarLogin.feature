Feature: API Authentication and User Management Tests

Background:
    * url apiUrl
    * header Accept = 'application/json'
    * header Content-Type = 'application/json'
    * header x-api-key = 'reqres-free-v1'
    * configure logPrettyResponse = true

@TestCase=9
@Type=LoginSuccess
@Offline
Scenario Outline: TC9_Login exitoso con credenciales válidas
    Given path '/login'
    And request { "email": "<email>", "password": "<password>" }
    When method POST
    Then status <expectedStatus>
    And match response contains { token: '#string' }
    * assert responseTime < <timeout>
    * print 'Response time:', responseTime, 'ms'

Examples:
    | email                     | password    | expectedStatus | timeout |
    | eve.holt@reqres.in        | cityslicka  | 200            | 2000    |
    | george.bluth@reqres.in    | cityslicka  | 200            | 2000    |
    | janet.weaver@reqres.in    | cityslicka  | 200            | 2000    |
    | emma.wong@reqres.in       | cityslicka  | 200            | 2000    |
    | charles.morris@reqres.in  | cityslicka  | 200            | 2000    |
    | eve.holt@reqres.in        | cityslicka  | 400            | 2000    |


@TestCase=10
@Type=LoginFailed
@Offline
Scenario Outline: TC10_Login fallido con credenciales inválidas
    Given path '/login'
    And request { "email": "<email>", "password": "<password>" }
    When method POST
    Then status <expectedStatus>
    And match response.error == '#string'
    * print 'Error message:', response.error

Examples:
    | email                | password   | expectedStatus |
    | invalid@reqres.in    | wrongpass  | 400            |
    | invalid2@reqres.in   | wrongpass  | 400            |
    | invalid3@reqres.in   | wrongpass  | 400            |
    | invalid4@reqres.in   | wrongpass  | 400            |
    | invalid5@reqres.in   | wrongpass  | 400            |
    | invalid7@reqres.in   | wrongpass  | 200            |


@TestCase=11
@Type=CreateUser
@Offline
Scenario Outline: TC11_Crear nuevo usuario
    Given path '/users'
    And request { "name": "<name>", "job": "<job>" }
    When method POST
    Then status <expectedStatus>
    And match response contains { id: '#string', createdAt: '#string' }
    And match response.name == '<name>'
    And match response.job == '<job>'
    * print 'Created user with ID:', response.id

Examples:
    | name      | job       | expectedStatus |
    | morpheus1  | leader   | 201            |
    | morpheus2  | tl       | 201            |
    | morpheus3  | po       | 201            |
    | morpheus4  | pm       | 201            |
    | morpheus5  | sh       | 201            |
    | morpheus7  | qa       | 400            |


@TestCase=21
@Type=UpdateUser
@Offline
Scenario Outline: TC21_Actualizar job de usuario
    Given path '/users/2'
    And request { "name": "<name>", "job": "<job>" }
    When method PATCH
    Then status <expectedStatus>
    And match response contains { name: '<name>' }
    And match response contains { job: '<job>' }

Examples:
    | name      | job                   | expectedStatus |
    | morpheus1  | leader resident      | 200            |
    | morpheus2  | tl resident          | 200            |
    | morpheus3  | po resident          | 200            |
    | morpheus4  | pm resident          | 200            |
    | morpheus5  | sh resident          | 200            |
    | morpheus7  | qa resident          | 400            |