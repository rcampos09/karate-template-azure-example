Feature: API Authentication and User Management Tests

Background: 
    * url apiUrl
    * header Accept = 'application/json'
    * header Content-Type = 'application/json'
    * configure logPrettyResponse = true

@TestCase=9
Scenario: TC9_Login exitoso con credenciales válidas
    Given path '/login'
    And request testData.validUser
    When method POST
    Then status 200
    And match response contains { token: '#string' }
    * assert responseTime < testData.timeoutMs
    * print 'Response time:', responseTime, 'ms'

@TestCase=10
Scenario: TC10_Login fallido con credenciales inválidas
    Given path '/login'
    And request testData.invalidUser
    When method POST
    Then status 400
    And match response.error == '#string'
    * print 'Error message:', response.error

@TestCase=11
Scenario: TC11_Crear nuevo usuario
    Given path '/users'
    And request testData.newUser
    When method POST
    Then status 201
    And match response contains { id: '#string', createdAt: '#string' }
    And match response.name == testData.newUser.name
    And match response.job == testData.newUser.job
    * print 'Created user with ID:', response.id