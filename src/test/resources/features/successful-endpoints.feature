Feature: Successful rest calls

  # DATABASE SQL SCRIPT
  Scenario: Retrieve users list preparing db with script
    Given I have the following sql script "sample-data.sql"
    When I make a GET call to "users" endpoint
    Then response status code should be 200
    And response content type should be "application/json"
    And response json path list "$.*" should be of length 2
    And response json path list "$.*" should be at least of length 1
    And response json path list "$.*" should be at least of length 2
    And response should be json:
    """
    [
      {
        "created":"${json-unit.ignore}",
        "email":"cchacin@superbiz.org",
        "fullname":"Carlos",
        "id":101,
        "modified":"${json-unit.ignore}",
        "password":"passWorD"
      },
      {
        "created":"${json-unit.ignore}",
        "email":"cchacin2@superbiz.org",
        "fullname":"Carlos2",
        "id":102,
        "modified":"${json-unit.ignore}",
        "password":"passWorD2"
      }
    ]
    """

  # DATABASE GET
  Scenario: Retrieve users list
    Given I have only the following rows in the "models" table:
      | id | created             | modified            | email                 | fullname | password  |
      | 1  | 2014-07-16 00:00:00 | 2014-07-16 00:00:00 | cchacin@superbiz.org  | Carlos   | passw0rd  |
      | 2  | 2014-07-16 00:00:00 | 2014-07-16 00:00:00 | cchacin2@superbiz.org | Carlos2  | passw0rd2 |
      | 3  | 2014-07-16 00:00:00 | 2014-07-16 00:00:00 | cchacin3@superbiz.org | Carlos3  | passw0rd3 |
    When I make a GET call to "users" endpoint
    Then response status code should be 200
    And response content type should be "application/json"
    And response should be json:
    """
    [
      {
        "created":"${json-unit.ignore}",
        "email":"cchacin@superbiz.org",
        "fullname":"Carlos",
        "id":1,
        "modified":"${json-unit.ignore}",
        "password":"passw0rd"
      },
      {
        "created":"${json-unit.ignore}",
        "email":"cchacin2@superbiz.org",
        "fullname":"Carlos2",
        "id":2,
        "modified":"${json-unit.ignore}",
        "password":"passw0rd2"
      },
      {
        "created":"${json-unit.ignore}",
        "email":"cchacin3@superbiz.org",
        "fullname":"Carlos3",
        "id":3,
        "modified":"${json-unit.ignore}",
        "password":"passw0rd3"
      }
    ]
    """

  # DATABASE GET
  Scenario: Retrieve users list cleaning db
    Given I have the following rows in the "models" table:
      | id | created             | modified            | email                 | fullname | password |
      | 4  | 2015-02-11 00:00:00 | 2015-02-11 00:00:00 | cchacin2@superbiz.org | Carlos2  | passw0rd |
    When I make a GET call to "users" endpoint
    Then response status code should be 200
    And response content type should be "application/json"
    And response should be json:
    """
    [
      {
        "created":"${json-unit.ignore}",
        "email":"cchacin@superbiz.org",
        "fullname":"Carlos",
        "id":1,
        "modified":"${json-unit.ignore}",
        "password":"passw0rd"
      },
      {
        "created":"${json-unit.ignore}",
        "email":"cchacin2@superbiz.org",
        "fullname":"Carlos2",
        "id":2,
        "modified":"${json-unit.ignore}",
        "password":"passw0rd2"
      },
      {
        "created":"${json-unit.ignore}",
        "email":"cchacin3@superbiz.org",
        "fullname":"Carlos3",
        "id":3,
        "modified":"${json-unit.ignore}",
        "password":"passw0rd3"
      },
      {
        "created":"${json-unit.ignore}",
        "email":"cchacin2@superbiz.org",
        "fullname":"Carlos2",
        "id":4,
        "modified":"${json-unit.ignore}",
        "password":"passw0rd"
      }
    ]
    """
    And response json path list "$..fullname" should be:
      | Carlos  |
      | Carlos2 |
      | Carlos3 |
      | Carlos2 |
    And response json path element "$[0].id" should be "1"

  # EXTERNAL SERVICE
  Scenario: Mock external API
    Given The call to external service should be:
      | method | url                | statusCode | filename      |
      | GET    | /user/71e7cb11?a=1 | 200        | 71e7cb11.json |
      | GET    | /user/71e7cb11?a=2 | 200        | 71e7cb11.json |
      | GET    | /user/71e7cb11?a=3 | 200        | 71e7cb11.json |
      | GET    | /user/71e7cb11?a=4 | 200        | 71e7cb11.json |
      | GET    | /user/71e7cb11?a=5 | 200        | 71e7cb11.json |
      | POST   | /user?b=b          | 201        |               |
      | PUT    | /user/71e7cb11     | 204        |               |
      | DELETE | /user/71e7cb11     | 204        |               |
    When I make a GET call to "external/call/user/71e7cb11" endpoint
    Then response status code should be 200
    And response json path list "$.responses" should be of length 8
    And response should be json:
    """
    {
      "responses":[
        {
          "status":201
        },
        {
          "status":204
        },
        {
          "status":204
        },
        {
          "status":200
        },
        {
          "status":200
        },
        {
          "status":200
        },
        {
          "status":200
        },
        {
          "status":200
        }
      ]
    }
    """

  # EXTERNAL SERVICE PROXY
  Scenario: Mock external API as Proxy
    Given The call to external service should be:
      | method | url                | statusCode | filename      |
      | GET    | /user/71e7cb11?a=a | 200        | 71e7cb11.json |
    When I make a GET call to "external/proxy/user/71e7cb11" endpoint
    Then response status code should be 200
    And response should be json:
    """
    {
      "user": "sample"
    }
    """

  #######
  # GET
  #######
#  Scenario:
#    When I make a GET call to "https://api.github.com/zen?z=1" endpoint
#    Then response status code should be 200
#    And response content type should be "text/plain;charset=utf-8"

  Scenario:
    When I make a GET call to "successful/get" endpoint
    Then response status code should be 200
    And response content type should be "application/json"
    And response should be json in file "responses/successful.json"

  Scenario:
    When I make a GET call to "successful/get/csv" endpoint
    Then response status code should be 200
    And response content type should be "text/csv"
    And response should be file "responses/sample.csv"

  Scenario:
    When I make a GET call to "successful/get" endpoint with headers:
      | Authorization | OAuth qwerqweqrqwerqwer |
      | X-Request-Id  | test-request-id         |
    Then response status code should be 200
    And response content type should be "application/json"
    And response header "Authorization" should be "OAuth qwerqweqrqwerqwer"
    And response header "X-Request-Id" should be "test-request-id"
    And response should be json in file "responses/successful.json"

  Scenario:
    When I make a GET call to "successful/get/params" endpoint with query params:
      | param1 | passwordParam |
      | param2 | nameParam     |
    Then response status code should be 200
    And response content type should be "application/json"
    And response should be json:
    """
    {
      "id": "${json-unit.ignore}",
      "created": "${json-unit.ignore}",
      "modified": "${json-unit.ignore}",
      "password": "passwordParam",
      "fullname": "nameParam"
    }
    """

  Scenario:
    When I make a GET call to "successful/get" endpoint
    Then response status code should be 200
    And response content type should be "application/json"
    And response should be json:
    """
    {
      "id": "${json-unit.ignore}",
      "created": "${json-unit.ignore}",
      "modified": "${json-unit.ignore}",
      "password": "",
      "fullname": ""
    }
    """

  #######
  # HEAD
  #######
  Scenario:
    When I make a HEAD call to "successful/head" endpoint
    Then response status code should be 204
    And response should be empty

  #######
  # PUT
  #######
  Scenario:
    When I make a PUT call to "successful/put" endpoint with post body:
    """
    {
    }
    """
    Then response status code should be 204
    And response should be empty

  Scenario: PUT call with headers
    When I make a PUT call to "successful/headers/put" endpoint with post body in file "requests/post_request.json" and headers:
      | Content-Type  | application/json        |
      | Authorization | OAuth qwerqweqrqwerqwer |
      | X-Request-Id  | test-request-id         |
    Then response status code should be 204
    And response should be empty
    And response header "Authorization" should be "OAuth qwerqweqrqwerqwer"
    And response header "X-Request-Id" should be "test-request-id"

  #######
  # POST
  #######
  Scenario:
    When I make a POST call to "successful/post" endpoint with post body:
    """
    {
    }
    """
    Then response status code should be 201
    And response should be empty

  Scenario: POST call with headers
    When I make a POST call to "successful/headers/post" endpoint with post body in file "requests/post_request.json" and headers:
      | Content-Type  | application/json        |
      | Authorization | OAuth qwerqweqrqwerqwer |
      | X-Request-Id  | test-request-id         |
    Then response status code should be 201
    And response should be empty
    And response header "Authorization" should be "OAuth qwerqweqrqwerqwer"
    And response header "X-Request-Id" should be "test-request-id"

  Scenario:
    When I make a POST call to "successful/post" endpoint with post body in file "requests/post_request.json"
    Then response status code should be 201
    And response should be empty

  #######
  # DELETE
  #######
  Scenario:
    When I make a DELETE call to "successful/delete" endpoint
    Then response status code should be 204
    And response should be empty


  Scenario: Redis steps for scored members
    Given I have the redis scored member "scoredMember1" in the db 1 with score "1.23" and value "value1"
    And I have the redis scored members "scoredMember2" in the db 2 with values:
      | value2 | 2.34 |
      | value3 | 3.45 |
    Then I should have the redis scored member "scoredMember1" in the db 1 with score "1.23" and value "value1"
    And I should have the redis scored members "scoredMember2" in the db 2 with values:
      | value2 | 2.34 |
      | value3 | 3.45 |

  Scenario: Database check exists
    Given I have only the following rows in the "models" table:
      | id | created             | modified            | email                 | fullname | password |
      | 4  | 2015-02-11 00:00:00 | 2015-02-11 00:00:00 | cchacin2@superbiz.org | Carlos2  | passw0rd |
      | 5  | 2015-02-11 00:00:00 | 2015-02-11 00:00:00 | cchacin3@superbiz.org | Carlos3  | passw0rd |
    Then I should have the following rows in the "models" table:
      | id | created             | modified            | email                 | fullname | password |
      | 4  | 2015-02-11 00:00:00 | 2015-02-11 00:00:00 | cchacin2@superbiz.org | Carlos2  | passw0rd |
      | 5  | 2015-02-11 00:00:00 | 2015-02-11 00:00:00 | cchacin3@superbiz.org | Carlos3  | passw0rd |

  ## Array Order doesn't mather
  Scenario: Retrieve users list without order
    Given I have only the following rows in the "models" table:
      | id | created             | modified            | email                 | fullname | password  |
      | 1  | 2014-07-16 00:00:00 | 2014-07-16 00:00:00 | cchacin@superbiz.org  | Carlos   | passw0rd  |
      | 2  | 2014-07-16 00:00:00 | 2014-07-16 00:00:00 | cchacin2@superbiz.org | Carlos2  | passw0rd2 |
      | 3  | 2014-07-16 00:00:00 | 2014-07-16 00:00:00 | cchacin3@superbiz.org | Carlos3  | passw0rd3 |
    When I make a GET call to "users" endpoint
    Then response status code should be 200
    And response content type should be "application/json"
    And response should be json ignoring array order:
    """
    [
      {
        "created":"${json-unit.ignore}",
        "email":"cchacin2@superbiz.org",
        "fullname":"Carlos2",
        "id":2,
        "modified":"${json-unit.ignore}",
        "password":"passw0rd2"
      },
      {
        "created":"${json-unit.ignore}",
        "email":"cchacin@superbiz.org",
        "fullname":"Carlos",
        "id":1,
        "modified":"${json-unit.ignore}",
        "password":"passw0rd"
      },
      {
        "created":"${json-unit.ignore}",
        "email":"cchacin3@superbiz.org",
        "fullname":"Carlos3",
        "id":3,
        "modified":"${json-unit.ignore}",
        "password":"passw0rd3"
      }
    ]
    """

     ## Array Order doesn't mather
  Scenario: Retrieve users list without order
    Given I have only the following rows in the "models" table:
      | id | created             | modified            | email                 | fullname | password  |
      | 1  | 2014-07-16 00:00:00 | 2014-07-16 00:00:00 | cchacin@superbiz.org  | Carlos   | passw0rd  |
      | 2  | 2014-07-16 00:00:00 | 2014-07-16 00:00:00 | cchacin2@superbiz.org | Carlos2  | passw0rd2 |
      | 3  | 2014-07-16 00:00:00 | 2014-07-16 00:00:00 | cchacin3@superbiz.org | Carlos3  | passw0rd3 |
    When I make a GET call to "users" endpoint
    Then response status code should be 200
    And response content type should be "application/json"
    And response should be json in file "responses/orderUsers.json" ignoring array order
