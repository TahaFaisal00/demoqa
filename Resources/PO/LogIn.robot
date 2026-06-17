*** Settings ***
Library                                              Browser

*** Variables ***
${LOGIN_PAGE_URL}                                    https://demoqa.com/login

*** Keywords ***
Verify Login Page Loaded
   Wait For Elements State                           text="Login"      visible
   Get Url                                           ${LOGIN_PAGE_URL}

Entering Username
   [Arguments]                                       ${Username}
   Input Text                                        xpath=//*[@id='userName']         ${Username}

Entering Password
   [Arguments]                                       ${Password}
   Input Text                                        xpath=//*[@id='password']         ${Password}

Clicking Login
   Click Element                                     xpath=//*[@id='login']

Error_Message
    [Arguments]                                      ${ERROR1}      ${ERROR2}       ${ERROR_TEXT}
    IF    $ERROR1
          Wait Until Element Is Visible              ${ERROR1}       10s
    END
    IF    $ERROR2
          Wait Until Element Is Visible              ${ERROR2}       10s
    END
    IF    $ERROR_TEXT
          Wait Until Page Contains                   ${ERROR_TEXT}       10s
    END

Click New User button
   Click Button                                      xpath=//*[text()='New User']

Verify Logging in
   [Arguments]                                       ${Username}
   Wait Until Page Contains                          ${Username}










