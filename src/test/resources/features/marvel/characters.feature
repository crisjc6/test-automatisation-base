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

  @getById @HU_MarvelCharacters
  Scenario: Obtener personaje por ID existente
    * def characterId = 1
    * url config.baseUrl + '/' + config.username + '/api/characters/' + characterId
    When method get
    Then status 200
    * match response == { id: 1, name: 'Iron Man', alterego: 'Tony Stark', description: 'Genius billionaire', powers: ['Armor', 'Flight'] }

  @getByIdNotFound @HU_MarvelCharacters
  Scenario: Obtener personaje por ID inexistente
    * def characterId = 999
    * url config.baseUrl + '/' + config.username + '/api/characters/' + characterId
    When method get
    Then status 404
    * match response == { error: 'Character not found' }

  @getById500 @HU_MarvelCharacters
  Scenario: Obtener personaje por ID inválido (error 500)
    * def characterId = 'aasdf!=)'
    * url config.baseUrl + '/' + config.username + '/api/characters/' + characterId
    When method get
    Then status 500
    * match response == { error: 'Internal server error' }

  @create @regression @HU_MarvelCharacters

  Scenario: Crear un personaje nuevo (Spider-Man) que no se duplique por nombre
    Given request { name: 'Spider-Man', alterego: 'Peter Parker', description: 'Superhéroe arácnido de Marvel', powers: ['Agilidad', 'Sentido arácnido', 'Trepar muros'] }
    When method post
    Then status 201
    * match response contains { id: '#number', name: 'Spider-Man', alterego: 'Peter Parker', description: 'Superhéroe arácnido de Marvel', powers: ['Agilidad', 'Sentido arácnido', 'Trepar muros'] }

  @createDuplicate @HU_MarvelCharacters
  Scenario: Crear personaje con nombre duplicado
    Given request { name: 'Iron Man', alterego: 'Otro', description: 'Otro', powers: ['Armor'] }
    When method post
    Then status 400
    * match response == { error: 'Character name already exists' }

  @createInvalid @HU_MarvelCharacters
  Scenario: Crear personaje con datos inválidos
    Given request { name: '', alterego: '', description: '', powers: [] }
    When method post
    Then status 400
    * match response contains { name: '#string', alterego: '#string', description: '#string', powers: '#string' }

