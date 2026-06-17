*** Settings ***
Library                                       Browser


*** Keywords ***
Enter First Name
    [Arguments]                       ${first_name}
    Type Text                         id=firstname    ${first_name}

Enter Last Name
    [Arguments]                       ${last_name}
    Type Text                         id=lastname     ${last_name}

Entering Username
   [Arguments]                        ${Username}
   Input Text                         xpath=//*[@id='userName']         ${Username}

Entering Password
   [Arguments]                        ${Password}
   Input Text                         xpath=//*[@id='password']         ${Password}

Clicking Register Button
   Click Button                       xpath=//*[text()='Register']

Verify User Registration
   Alert Should Be Present            User Registered Successfully.

Click Back to Login Button
    Click Element                     xpath=//*[text()='Back to Login']


