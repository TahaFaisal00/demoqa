*** Settings ***
Library         RequestsLibrary
Library         SeleniumLibrary
Resource        ../../Resources/API_RES.robot
Suite Setup     Open Session

*** Variables ***
${BASE_URL}             https://demoqa.com/
${TOKEN}                eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyTmFtZSI6IlRhaGEwMCIsInBhc3N3b3JkIjoiVGFoYTIwMDEhISEiLCJpYXQiOjE3Nzk2MzgyNTd9.4AXB6PLXamPZDwow-u3iEdP_qmPTggD3MNymWe3G_rM
*** Test Cases ***
POST Check Account Authorization - Valid Fields - Returns 200
    [Documentation]     Send a post request to check the given account authorization. verifies
    ...                 the resposne code and the response body boolean.
    [Tags]      functional      api     post        positive        account
    [Setup]     Create Authenticated Account Via API
    ${response}=        Check Account Authorization Via API
    Verify Resposne Code         ${OK_CODE}
    Verify Response Body Return True    ${response}
    [Teardown]      Delete Account Via API

POST Check Account Authorization - Missing Fields - Returns 400
    [Documentation]     Send a post request to check the given account authorization without the user name
    ...                 field. verifies the resposne code and the response message.
    [Tags]      functional      api     post        negative        account
    [Setup]     Create Authenticated Account Via API
    ${response}=        Attempt Check Account Authorization With Missing Field Via API
    Verify Resposne Code         ${BAD_REQUEST_CODE}
    Verify Response Message Contains    ${response}    ${MISSING_CREDENTIALS_MESSAGE}
    [Teardown]      Delete Account Via API

POST Check Account Authorization - Invalid Fields - Returns 404
    [Documentation]     Send a post request to check the given account authorization with a non
    ...                 existent account user name. verifies the resposne code and the response message.
    [Tags]      functional      api     post        negative        account
    [Setup]     Create Authenticated Account Via API
    ${response}=        Attempt Check Account Authorization With Invalid Fields Via API
    Verify Resposne Code         ${NOT_FOUND_CODE}
    Verify Response Message    ${response}    ${USER_NOT_FOUND_MESSAGE}
    [Teardown]      Delete Account Via API


POST Generate Token For Account - Valid Fields - Returns 200
    [Documentation]     Generate a token for newly created account. Verify response message and code.
    [Tags]      functional      api     post        positive        account
    [Setup]     Create Account Via API
    ${response}=        Generate Token Via API
    Verify Resposne Code    ${OK_CODE}
    Verify Response Field Not Empty    ${response}    ${RESPONSE_FIELD_TOKEN}
    [Teardown]      Delete Account Via API

POST Generate Token For Account - Missing Required Fields - Returns 400
    [Documentation]     Generate a token for newly created account without providing the username.
    ...                 Verify response message and code.
    [Tags]      functional      api     post        negative        account
    [Setup]     Create Authenticated Account Via API
    ${response}=        Attempt Generate Token With Missing Field Via API
    Verify Resposne Code    ${BAD_REQUEST_CODE}
    Verify Response Message Contains    ${response}    ${MISSING_CREDENTIALS_MESSAGE}
    [Teardown]      Delete Account Via API

POST Generate Token For Account - Invalid Required Fields - Returns 200
    [Documentation]     Generate a token for a non existent account. Verify response message and code.
    ...                 Bug: Response should return 404 not found but it's returning 200.
    [Tags]      bug      api     post        negative        account
    [Setup]     Create Authenticated Account Via API
    ${response}=        Attempt Generate Token With Invalid Fields Via API
    Verify Resposne Code    ${OK_CODE}
    Verify Response Result Contain    ${response}    ${AUTHORIZATION_FIELD_RESULT}
    [Teardown]      Delete Account Via API


POST Create Account - Valid Fields - Returns 201
    [Documentation]     Create new account. Verify response message and code.
    [Tags]      functional      api     post        positive        account
    ${response}=        Create Account Via API
    Verify Resposne Code               ${CREATED_CODE}
    Verify Response Field Not Empty    ${response}    ${RESPONSE_FIELD_USER_ID}
    Verify Response Field Not Empty    ${response}    ${RESPONSE_FIELD_USERNAME}
    Generate Token Via API
    [Teardown]  Delete Account Via API

POST Create Account - Missing Fields - Returns 400
    [Documentation]     Create new account without user name. Verify response message and code.
    [Tags]      functional      api     post        negative        account
    ${response}=        Attempt Create Account With Missing Field Via API
    Verify Resposne Code              ${BAD_REQUEST_CODE}
    Verify Response Message    ${response}    ${MISSING_CREDENTIALS_MESSAGE}

POST Create Account - Already Created Account - Returns 406
    [Documentation]     Create new account using already created account username and password.
    ...                 Verify response message and code.
    [Tags]      functional      api     post        negative        account
    [Setup]     Create Authenticated Account Via API
    ${response}=        Attempt Create Account With Already Created Account Credentials Via API
    Verify Resposne Code             ${NOT_ACCEPTABLE_CODE}
    Verify Response Message     ${response}    ${USER_EXIST_MESSAGE}
    [Teardown]      Delete Account Via API


Delete an Account by ID - Returns 204 with Valid accountId
    [Tags]      bug     api     delete        positive        account        #swagger doc error  # Bug 1: Swagger documents success as 200, API returns 204 # Bug 2: 204 response includes a body — violates HTTP spec (204 = No Content)
    POST Generate a Token for an Account
    ${UUID}=        Set Variable        8c8205b6-5258-44b0-b1b0-7ad11f8db43a
    &{headers}=     Create Dictionary       Authorization=Bearer ${Token}
    ${response}=        DELETE On Session     deqoma       /Account/v1/User/${UUID}        headers=${headers}
    Status Should Be    expected_status=204
    Log    message=${response.json()}

Delete an Already Deleted Account by ID - Returns 200 with Valid accountId
    [Tags]      bug     api      delete        positive        account          #Inconsistent behavior
    POST Generate a Token for an Account
    ${UUID}=        Set Variable        8c8205b6-5258-44b0-b1b0-7ad11f8db43a
    &{headers}=     Create Dictionary       Authorization=Bearer ${Token}
    ${response}=        DELETE On Session     deqoma       /Account/v1/User/${UUID}        headers=${headers}      expected_status=204
    ${response}=        DELETE On Session     deqoma       /Account/v1/User/${UUID}        headers=${headers}      expected_status=200
    Log    message=${response.json()}


Delete an Account by ID - Returns 200 with Invalid accountId
    [Tags]      bug     api      delete        positive        account         #response should return 401     #Inconsistent behavior   #204 and 401 descriptions are literally swapped.
    POST Generate a Token for an Account
    ${UUID}=        Set Variable        x4d46xxx-xxdf-40xx-axxd2-7d7a09xxxxxx
    &{headers}=     Create Dictionary       Authorization=Bearer ${Token}
    ${response}=        DELETE On Session     deqoma       /Account/v1/User/${UUID}        headers=${headers}      expected_status=200
    Log    message=${response.json()}

Delete an Account by ID - Returns 401 Unauthorized
    [Tags]      bug     api      delete        negative        account      #204 and 401 descriptions are literally swapped.
    ${UUID}=        Set Variable        84d46a79-b0df-4066-acd2-7d7a09d87d87
    &{headers}=     Create Dictionary       Authorization=Bearer ${Token}
    ${response}=        DELETE On Session     deqoma       /Account/v1/User/${UUID}        headers=${headers}      expected_status=401
    Log    message=${response.json()}







GET Account Details by ID - Returns 200 with Valid accountId
    [Tags]      sanity      api     get        positive        account
    POST Generate a Token for an Account
    ${UUID}=        Set Variable        84d46a79-b0df-4066-acd2-7d7a09d87d87
    &{headers}=     Create Dictionary       Authorization=Bearer ${Token}
    ${response}=        GET On Session     deqoma       /Account/v1/User/${UUID}        headers=${headers}
    Status Should Be    expected_status=200
    Log    message=${response.json()}

GET Account Details by ID - Returns 401 with Invalid accountId
    [Tags]      sanity      api     get        negative        account
    POST Generate a Token for an Account
    ${UUID}=        Set Variable        x4d46xxx-xxdf-40xx-axxd2-7d7a09xxxxxx
    &{headers}=     Create Dictionary       Authorization=Bearer ${Token}
    ${response}=        GET On Session     deqoma       /Account/v1/User/${UUID}        headers=${headers}      expected_status=401
    Log    message=${response.json()}

GET Account Details by ID - Returns 401 Unauthorized
    [Tags]      sanity      api     get        negative        account
    ${UUID}=        Set Variable        84d46a79-b0df-4066-acd2-7d7a09d87d87
    &{headers}=     Create Dictionary       Authorization=Bearer ${Token}
    ${response}=        GET On Session     deqoma       /Account/v1/User/${UUID}        headers=${headers}      expected_status=401
    Log    message=${response.json()}

*** Keywords ***
POST Generate a Token for an Account
    &{body}=        Create Dictionary            userName=Taha02               password=Taha2001!!!
    ${response}=        POST On Session     deqoma       /Account/v1/GenerateToken      json=${body}
    Status Should Be    expected_status=200
    Log    message=${response.json()}
    ${Token}=       Set Variable         ${response.json()}[token]
    Set Suite Variable          ${Token}