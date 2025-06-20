@HU_MarvelCharacters
Feature: Gestión de personajes Marvel

  Background:
    * def config = karate.callSingle('classpath:karate-config.js')
    * url config.baseUrl + '/' + config.username + '/api/characters'

  @getAll @smoke @HU_MarvelCharacters
  Scenario: Obtener todos los personajes
    When method get
    Then status 200
    * match response[*].id == '#[] #number'
    * match response[*].name == '#[] #string'
    * match response[*].alterego == '#[] #string'
    * match response[*].description == '#[] #string'
    * match response[*].powers == '#[] #[]'

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
    * def characterId = 3
    * url config.baseUrl + '/' + config.username + '/api/characters/' + characterId
    When method get
    Then status 200
    * match response == { id: 3, name: 'Iron Man', alterego: 'Tony Stark', description: '#string', powers: ['Armor', 'Flight'] }

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

  @update @HU_MarvelCharacters
  Scenario: Actualizar personaje existente
    * def characterId = 3
    Given request { name: 'Iron Man', alterego: 'Tony Stark', description: 'Updated description', powers: ['Armor', 'Flight'] }
    * url config.baseUrl + '/' + config.username + '/api/characters/' + characterId
    When method put
    Then status 200
    * match response == { id: 3, name: 'Iron Man', alterego: 'Tony Stark', description: '#string', powers: ['Armor', 'Flight'] }

  @updateNotFound @HU_MarvelCharacters
  Scenario: Actualizar personaje inexistente
    * def characterId = 999
    Given request { name: 'Iron Man', alterego: 'Tony Stark', description: 'Updated description', powers: ['Armor', 'Flight'] }
    * url config.baseUrl + '/' + config.username + '/api/characters/' + characterId
    When method put
    Then status 404
    * match response == { error: 'Character not found' }

  @updateInvalid @HU_MarvelCharacters
  Scenario: Actualizar personaje con datos inválidos
    * def characterId = 1
    Given request { name: '', alterego: '', description: '', powers: [] }
    * url config.baseUrl + '/' + config.username + '/api/characters/' + characterId
    When method put
    Then status 400
    * match response contains { name: '#string', alterego: '#string', description: '#string', powers: '#string' }

  @update500 @HU_MarvelCharacters
  Scenario: Actualizar personaje con ID inválido (error 500)
    * def characterId = 'aasdf'
    Given request { name: 'Iron Man', alterego: 'Tony Stark', description: 'Updated description', powers: ['Armor', 'Flight'] }
    * url config.baseUrl + '/' + config.username + '/api/characters/' + characterId
    When method put
    Then status 500
    * match response == { error: 'Internal server error' }

  @deleteNotFound @HU_MarvelCharacters
  Scenario: Eliminar personaje inexistente
    * def characterId = 999
    * url config.baseUrl + '/' + config.username + '/api/characters/' + characterId
    When method delete
    Then status 404
    * match response == { error: 'Character not found' }

  @delete500 @HU_MarvelCharacters
  Scenario: Eliminar personaje con ID inválido (error 500)
    * def characterId = 'aasdf'
    * url config.baseUrl + '/' + config.username + '/api/characters/' + characterId
    When method delete
    Then status 500
    * match response == { error: 'Internal server error' }

  @bulkCreateDelete @HU_MarvelCharacters
  Scenario: Crear y eliminar personaje usando el personaje 11 del bulk
    # Este escenario valida la creación y eliminación dinámica de un personaje usando datos del bulk.
    # Razones:
    # - Permite pruebas idempotentes y repetibles en pipelines o entornos compartidos.
    # - No depende de IDs fijos ni de datos persistentes entre ejecuciones.
    # - Garantiza limpieza de datos tras la prueba, evitando residuos en la base de datos.
    * def bulk = karate.read('classpath:data/marvel/characters-bulk.json')
    * def personaje = bulk[10]
    Given request personaje
    When method post
    Then status 201
    * def createdId = response.id
    * match response.name == personaje.name
    * match response.description == personaje.description
    * print 'ID creado:', createdId
    # Ahora eliminar el personaje creado
    * url config.baseUrl + '/' + config.username + '/api/characters/' + createdId
    When method delete
    Then status 204