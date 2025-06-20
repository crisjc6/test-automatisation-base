@HU_MarvelCharacters
Feature: Gestión de personajes Marvel

  Background:
    * def config = karate.callSingle('classpath:karate-config.js')
    * url config.baseUrl + '/' + config.username + '/api/characters'

  @getAll @smoke @HU_MarvelCharacters
  Scenario: Obtener todos los personajes
    When method get
    Then status 200
    #* match response == { ... }
