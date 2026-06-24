*** Settings ***
Resource        ../../Resources/API_RES.robot
Suite Setup     Open Session

*** Test Cases ***
GET Bookstore Books - Returns 200
    [Documentation]     Get all the books with their details from the bookstore. Verify response code and message.
    [Tags]      functional      api     get      positive        bookstore
    ${response}=        Get Bookstore Books Via API
    Verify Resposne Code    ${OK_CODE}
    Verify Response Field Not Empty    ${response}    ${RESPONSE_FIELD_BOOKS}


Create List Of Books - Valid Fields - Returns 201
    [Documentation]     Create list of book using the given books ISBNs. Requires authorized account.
    ...                 Verify response and code.
    [Tags]      functional      api     post        positive        bookstore
    [Setup]     Create Authenticated Account Via API
    ${response}=        Create List Of Books Via API        ${GIT_POCKET_GUIDE_ISBN}        ${LEARNING_JAVASCRIPT_DESGIN_PATTERNS_ISBN}
    Verify Resposne Code    ${CREATED_CODE}
    Verify Response Field Not Empty    ${response}    ${RESPONSE_FIELD_BOOKS}
    [Teardown]      Delete Account Via API

Create List Of Books - Unauthorized - Returns 401
    [Documentation]     Create list of book using the given books ISBNs using unauthorized account.
    ...                 Verify response and code.
    [Tags]      functional      api     post        negative        bookstore
    [Setup]     Create Account Via API
    ${response}=        Attempt Create List Of Books Without Authorization Via API        ${GIT_POCKET_GUIDE_ISBN}        ${LEARNING_JAVASCRIPT_DESGIN_PATTERNS_ISBN}
    Verify Resposne Code    ${NOT_AUTHORIZED_CODE}
    Verify Response Message    ${response}    ${NOT_AUTHORIZED_MESSAGE}
    Generate Token Via API
    [Teardown]      Delete Account Via API

Create List Of Books - Missing Fields - Returns 400
    [Documentation]     Create list of book without providing books ISBNs. Verify Response code and message.
    ...                 BUG: when sending a request without the required field the API should return json type error message.
    ...                 but the API is returning text/html type content that is leaking internal paths, Sequelize, MySQL.
    [Tags]      bug      api     post        negative        bookstore
    [Setup]     Create Authenticated Account Via API
    ${response}=        Attempt Create List Of Books With Missing Field Via API
    Verify Resposne Code    ${BAD_REQUEST_CODE}
    Verify Response Headers Content type      ${response}        ${CONTENT_TYPE_TEXT_HTML}
    [Teardown]      Delete Account Via API

Create List Of Books - Invalid Fields - Returns 400
    [Documentation]     Create list of book using invalid book ISBN. Requires authorized account.
    ...                 Verify response and code.
    [Tags]      functional      api     post        negative        bookstore
    [Setup]     Create Authenticated Account Via API
    ${response}=        Create List Of Books Via API        ${INVALID_ISBN}
    Verify Resposne Code    ${BAD_REQUEST_CODE}
    Verify Response Message    ${response}    ${BOOK_ISBN_NOT_AVAILABLE_IN_BOOK_COLLECTION_MESSAGE}
    [Teardown]      Delete Account Via API


Delete List Of Books - Valid User ID - Return 204
    [Documentation]     Deletes all books from account book collection. Requires authorized User.
    ...                 Verifies response code.
    ...                 the swagger documents a response body that doesn't exist, misleading to any developer reading it.
    [Tags]      functional      api     delete        positive        bookstore
    [Setup]     Create Authenticated Account And List Of Books Via API
    ${response}=      Delete List Of Books Via API
    Verify Resposne Code    ${NO_CONTENT_CODE}
    [Teardown]      Delete Account Via API

Delete List Of Books - Non Existent Books List - Return 204
    [Documentation]     Deletes never created books from account book collection. Requires authorized User.
    ...                 Verifies response code.
    [Tags]      functional      api     delete        negative        bookstore
    [Setup]     Create Authenticated Account Via API
    ${response}=      Delete List Of Books Via API
    Verify Resposne Code    ${NO_CONTENT_CODE}
    [Teardown]      Delete Account Via API

Delete List Of Books - Already Deleted Books List - Return 204
    [Documentation]     Deletes already deleted books from account book collection. Requires authorized User.
    ...                 Verifies response code.
    [Tags]     functional      api     delete        negative        bookstore
    [Setup]     Create Authenticated Account And List Of Books Via API
    ${response}=      Delete List Of Books Via API
    Verify Resposne Code    ${NO_CONTENT_CODE}
    [Teardown]      Delete Account Via API


GET Book Details - Valid ISBN - Returns 200
    [Documentation]     Get a specific book details with Valid ISBN. Verify Response code and message.
    [Tags]     functional      api     get        positive        bookstore
    ${response}=        Get Book Details Via API        ${GIT_POCKET_GUIDE_ISBN}
    Verify Resposne Code    ${OK_CODE}
    Verify Response Field Not Empty    ${response}    ${RESPONSE_FIELD_ISBN}
    Verify Response Field Not Empty    ${response}    ${RESPONSE_FIELD_TITLE}

GET Book Details - Invalid ISBN - Returns 400
    [Documentation]     Get a specific book details with Invalid ISBN. Verify Response code and message.
    [Tags]     functional      api     get        neagtive        bookstore
    ${response}=        Get Book Details Via API            ${INVALID_ISBN}
    Verify Resposne Code    ${BAD_REQUEST_CODE}
    Verify Response Message    ${response}    ${BOOK_ISBN_NOT_AVAILABLE_IN_BOOK_COLLECTION_MESSAGE}

GET Book Details - Missing ISBN - Returns 500
    [Documentation]     Get a book details without ISBN. Verify Response code and message. BUG: when sending a request
    ...                 without the required field the API should return 400 with a json type error message.
    ...                 but the API is returning 500 - internal server error. And a text/html type content that
    ...                 is leaking internal paths, Sequelize, MySQL.
    [Tags]     bug      api     get        negative        bookstore       #500 instead of 400    #: Server exposes internal stack trace and file paths in response body — security issue
    ${response}=        Attempt Get Book Details With Missing ISBN Via API
    Verify Resposne Code    ${INTERNAL_SERVER_ERROR_CODE}
    Verify Response Headers Content type      ${response}        ${CONTENT_TYPE_TEXT_HTML}


Delete Book From List Of Books - Valid Fields - Return 204
    [Documentation]     Deletes a book From the books collection of account. Requires authorized User.
    ...                 Verifies response code.
    ...                 the swagger documents a response body that doesn't exist, misleading to any developer reading it.
    [Tags]    bug      api     delete        positive        bookstore
    [Setup]     Create Authenticated Account And List Of Books Via API
    ${response}=     Delete Book From List Via API      ${GIT_POCKET_GUIDE_ISBN}
    Verify Resposne Code    ${NO_CONTENT_CODE}
    [Teardown]      Delete Account Via API

Delete Book From List Of Books - Non Existent Book - Return 400
    [Documentation]     Deletes a never created book From the books collection of account. Requires authorized User.
    ...                 Verifies response code.
    ...                 DELETE request for an ISBN of a book not in the user's collection returns 400. Should be 404
    [Tags]      bug      api     delete        negative        bookstore
    [Setup]     Create Authenticated Account Via API
    ${response}=     Delete Book From List Via API      ${GIT_POCKET_GUIDE_ISBN}
    Verify Resposne Code    ${BAD_REQUEST_CODE}
    Verify Response Message    ${response}    ${BOOK_ISBN_NOT_AVAILABLE_IN_USER_COLLECTION_MESSAGE}
    [Teardown]      Delete Account Via API

Delete Book From List Of Books - Already Deleted Book - Return 400
    [Documentation]     Deletes an already deleted book From the books collection of account. Requires authorized User.
    ...                 Verifies response code.
    ...                 DELETE request for an ISBN of a book not in the user's collection returns 400. Should be 404
    [Tags]    bug      api     delete        negative        bookstore
    [Setup]     Create Authenticated Account And List Of Books Via API
    Delete Book From List Via API      ${GIT_POCKET_GUIDE_ISBN}
    ${response}=     Delete Book From List Via API      ${GIT_POCKET_GUIDE_ISBN}
    Verify Resposne Code    ${BAD_REQUEST_CODE}
    Verify Response Message    ${response}    ${BOOK_ISBN_NOT_AVAILABLE_IN_USER_COLLECTION_MESSAGE}
    [Teardown]      Delete Account Via API


Update a Book by Replacing it with Another by ISBN - Returns 200 with Valid ISBN and Valid Required Fields
    [Documentation]     Replace a book from the book collection of a user with a new book by ISBN.
    ...                 Verify response message and code.
    [Tags]      functional     api     put        positive        bookstore
    [Setup]     Create Authenticated Account Via API
    Create List Of Books Via API        ${GIT_POCKET_GUIDE_ISBN}        ${LEARNING_JAVASCRIPT_DESGIN_PATTERNS_ISBN}
    ${response}=        Update Book By Another Via API   ${LEARNING_JAVASCRIPT_DESGIN_PATTERNS_ISBN}        ${SPEAKING_JAVA_SCRIPT_ISBN}
    Verify Resposne Code    ${OK_CODE}
    Verify Response Field Not Empty    ${response}        ${RESPONSE_FIELD_BOOKS}
    [Teardown]      Delete Account Via API

Update a Book by Replacing it with Another by ISBN - Returns 400 with Valid ISBN and Invalid Required Fields
    [Documentation]     Replace a book from the book collection of a user with an invalid book ISBN.
    ...                 Verify response message and code.
    [Tags]      functional     api     put        negative        bookstore
    [Setup]     Create Authenticated Account Via API
    Create List Of Books Via API        ${GIT_POCKET_GUIDE_ISBN}        ${LEARNING_JAVASCRIPT_DESGIN_PATTERNS_ISBN}
    ${response}=        Update Book By Another Via API   ${LEARNING_JAVASCRIPT_DESGIN_PATTERNS_ISBN}        ${INVALID_ISBN}
    Verify Resposne Code    ${BAD_REQUEST_CODE}
    Verify Response Message    ${response}        ${BOOK_ISBN_NOT_AVAILABLE_IN_BOOK_COLLECTION_MESSAGE}
    [Teardown]      Delete Account Via API

Update a Book by Replacing it with Another by ISBN - Returns 500 with Missing ISBN and Valid Required Fields
    [Documentation]     Replace a book from the book collection of a user with a new book without its ISBN.
    ...                 Verify response message and code.
    ...                 BUG: when sending a request without the required field the API should return json type error message.
    ...                 but the API is returning text/html type content that is leaking internal paths, Sequelize, MySQL.
    [Tags]      bug     api     put        negative        bookstore
    [Setup]     Create Authenticated Account Via API
    Create List Of Books Via API        ${GIT_POCKET_GUIDE_ISBN}        ${LEARNING_JAVASCRIPT_DESGIN_PATTERNS_ISBN}
    ${response}=        Attempt Update Book By Another Without New Book ISBN Via API         ${LEARNING_JAVASCRIPT_DESGIN_PATTERNS_ISBN}
    Verify Resposne Code    ${BAD_REQUEST_CODE}
    Verify Response Headers Content type      ${response}        ${CONTENT_TYPE_TEXT_HTML}
    [Teardown]      Delete Account Via API

Update a Book by Replacing it with Another by ISBN - Returns 200 with ISBN of an Already Existing Book in the Required Fields
    [Documentation]      Replace a book from the book collection of a user with an ISBN of a book that already exist
    ...                 in the book collection. Verify response message and code.
    ...                 BUG: the API allows duplicating book in the same collection.
    [Tags]      bug      api     put        negative        bookstore
    [Setup]     Create Authenticated Account Via API
    Create List Of Books Via API        ${GIT_POCKET_GUIDE_ISBN}        ${LEARNING_JAVASCRIPT_DESGIN_PATTERNS_ISBN}
    ${response}=        Update Book By Another Via API   ${LEARNING_JAVASCRIPT_DESGIN_PATTERNS_ISBN}        ${GIT_POCKET_GUIDE_ISBN}
    Verify Resposne Code    ${OK_CODE}
    Verify Response Field Not Empty    ${response}        ${RESPONSE_FIELD_BOOKS}
    [Teardown]      Delete Account Via API