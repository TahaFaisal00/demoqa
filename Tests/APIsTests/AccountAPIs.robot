*** Settings ***
Resource        ../../Resources/API_RES.robot
Suite Setup     Open Session

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


Delete Account - Valid Account ID - Returns 204
    [Documentation]     Delete Account by account ID. Verify response message and code.
    [Tags]      bug     api     delete        positive        account        #swagger doc error  # Bug 1: Swagger documents success as 200, API returns 204 # Bug 2: 204 response includes a body — violates HTTP spec (204 = No Content)
    [Setup]     Create Authenticated Account Via API
    ${response}=        Delete Account Via API
    Verify Resposne Code    ${NO_CONTENT_CODE}

Delete Account - Already Deleted Account ID - Returns 200
    [Documentation]     Delete Already Deleted Account by ID. Verify response message and code.
    [Tags]      bug     api      delete        negative        account          #Inconsistent behavior
    [Setup]     Create Authenticated Account Via API
    ${response}=        Delete Account Via API
    ${response}=        Delete Account Via API
    Verify Resposne Code    ${OK_CODE}
    Verify Response Message    ${response}       ${INCORRECT_USER_ID_MESSAGE}

Delete Account - Invalid Account ID - Returns 200
    [Documentation]     Delete Account by Invalid account ID. Verify response message and code.
    [Tags]      bug     api      delete        negative        account         #response should return 401     #Inconsistent behavior   #204 and 401 descriptions are literally swapped.
    [Setup]     Create Authenticated Account Via API
    ${response}=        Attempt Delete Account With Invalid Account ID Via API
    Verify Resposne Code    ${OK_CODE}
    Verify Response Message    ${response}       ${INCORRECT_USER_ID_MESSAGE}

Delete Account - Unauthorized - Returns 401
    [Documentation]     Delete Account by Unauthorized account ID. Verify response message and code.
    [Tags]      bug     api      delete        negative        account      #204 and 401 descriptions are literally swapped.
    [Setup]     Create Account Via API
    ${response}=        Attempt Delete Account Without Authorization Via API
    Verify Resposne Code    ${NOT_AUTHORIZED_CODE}
    Verify Response Message    ${response}      ${NOT_AUTHORIZED_MESSAGE}
    Generate Token Via API
    [Teardown]      Delete Account Via API


GET Account Details - Valid Account ID - Returns 200
    [Documentation]     Get account details by ID. Verify response message and code.
    [Tags]      functional      api     get        positive        account
    [Setup]   Create Authenticated Account Via API
    ${response}=        Get Account Details Via API
    Status Should Be    ${OK_CODE}
    Verify Response Field Not Empty    ${response}    ${RESPONSE_FIELD_USERNAME}
    Verify Response Field Not Empty    ${response}    ${RESPONSE_FIELD_USER_ID}
    [Teardown]      Delete Account Via API

GET Account Details - Invalid Account ID - Returns 401
    [Documentation]     Get account details by non existent account ID. Verify response message and code.
    [Tags]      functional      api     get        negative        account
    [Setup]     Create Authenticated Account Via API
    ${response}=        Attempt Get Account Details With Invalid Account ID Via API
    Status Should Be    ${NOT_AUTHORIZED_CODE}
    Verify Response Message    ${response}    ${USER_NOT_FOUND_MESSAGE}
    [Teardown]      Delete Account Via API

