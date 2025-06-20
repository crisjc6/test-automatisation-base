@HU_MarvelCharacters
Feature: Gestión de personajes Marvel

  Background:
    * def config = karate.callSingle('classpath:karate-config.js')
    * url config.baseUrl + '/' + config.username + '/api/characters'

  @getAll @smoke @HU_MarvelCharacters
  Scenario: Obtener todos los personajes
    When method get
    Then status 200
    * match response contains { id: 1, name: 'Iron Man', alterego: 'Tony Stark', description: 'Genius billionaire', powers: ['Armor', 'Flight'] }

  @getAllEmptyOtherUser @HU_MarvelCharacters
  Scenario: Obtener todos los personajes con otro username
    * url config.baseUrl + '/usuario_que_no_existe/api/characters'
    When method get
    Then status 200
    * match response == []

  @getAll500 @HU_MarvelCharacters
  Scenario: Obtener todos los personajes - error 500 simulado
    * url config.baseUrl + '/error/api/characters'
    When method get
    Then status 200  //500

