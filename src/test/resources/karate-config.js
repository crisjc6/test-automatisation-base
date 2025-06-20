function fn() {
  var config = {};
  config.baseUrl =
    karate.properties["baseUrl"] ||
    "http://bp-se-test-cabcd9b246a5.herokuapp.com";
  config.username = karate.properties["username"] || "crisjc6";
  return config;
}
