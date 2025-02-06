# TC12345_ValidarLogin.feature
Feature: API Authentication and User Management Tests

Background: 
    * url apiUrl
    * header Accept = 'application/json'
    * header Content-Type = 'application/json'
    * configure logPrettyResponse = true

@TC12345
Scenario: Validate successful login with valid credentials
    Given path '/login'
    And request testData.validUser
    When method POST
    Then status 200
    And match response contains { token: '#string' }
    * assert responseTime < testData.timeoutMs
    * print 'Response time:', responseTime, 'ms'

@TC12346
Scenario: Validate login failure with invalid credentials
    Given path '/login'
    And request testData.invalidUser
    When method POST
    Then status 400
    And match response.error == '#string'
    * print 'Error message:', response.error

@TC12347
Scenario: Create a new user and verify response
    Given path '/users'
    And request testData.newUser
    When method POST
    Then status 201
    And match response contains { id: '#string', createdAt: '#string' }
    And match response.name == testData.newUser.name
    And match response.job == testData.newUser.job
    * print 'Created user with ID:', response.id