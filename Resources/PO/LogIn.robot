*** Settings ***
Library                                              Browser

*** Variables ***
${LOGIN_PAGE_URL}                                    https://demoqa.com/login

${USER_NAME_FIELD}                                   id=userName
${PASSWORD_FIELD}                                    id=password

${LOGIN_BUTTON}                                      id=login
${NEW_USER_BUTTON}                                   id=newUser
*** Keywords ***
Verify Login Page Loaded
   Wait For Elements State                           text="Login"      visible
   Get Url                                           ${LOGIN_PAGE_URL}

Enter User Name
   [Arguments]                                       ${user_name}
   Type Text                                         ${USER_NAME_FIELD}      ${user_name}

Enter Password
   [Arguments]                                       ${password}
   Type Text                                         ${PASSWORD_FIELD}       ${password}

Click Login
   Click                                             ${LOGIN_BUTTON}

Click New User Button
   Click                                             ${NEW_USER_BUTTON}








