*** Settings ***
Library                 SeleniumLibrary
Resource                ../Resources/Common.robot
Suite Setup             Common.Launch Browser
Suite Teardown          Common.Close Browser


*** Variables ***




*** Test Cases ***
Register to Book Store
   [Tags]                               smoke       ui     positive     login
   Wait Until Page Contains Element     xpath=//*[@id="root"]/header/a
   Wait Until Element Is Visible        xpath=//*[text()='Book Store Application']
   Click Element                        xpath=//*[text()='Book Store Application']
   Wait Until Page Contains             Author

   Wait Until Element Is Visible        xpath=//span[text()='Login']
   Click Element                        xpath=//span[text()='Login']
   Wait Until Page Contains             Welcome,

   Click Button                         xpath=//*[text()='New User']

    Input Text                          xpath=//*[@id='firstname']    taha
    Input Text                          xpath=//*[@id='lastname']     moe
    Input Text                          xpath=//*[@id='userName']     taha001q22
    Input Text                          xpath=//*[@id='password']     Taha2001!!

   Click Button                         xpath=//*[text()='Register']
   Alert Should Be Present              User Registered Successfully.

Logging in with a Deleted Account Credentials
   [Tags]                               functional      ui      negative        login
   Wait Until Page Contains Element     xpath=//*[@id="root"]/header/a
   Wait Until Element Is Visible        xpath=//*[text()='Book Store Application']
   Click Element                        xpath=//*[text()='Book Store Application']
   Wait Until Page Contains             Author

   Wait Until Element Is Visible        xpath=//span[text()='Login']
   Click Element                        xpath=//span[text()='Login']
   Wait Until Page Contains             Welcome,
   Wait Until Page Contains             Login in Book Store

   Input Text                           xpath=//*[@id='userName']         taha001
   Input Text                           xpath=//*[@id='password']         Taha2001!!
   Click Element                        xpath=//*[@id='login']

Logging in with Empty userName
   [Tags]                               functional      ui      negative        login
   Wait Until Page Contains Element     xpath=//*[@id="root"]/header/a
   Wait Until Element Is Visible        xpath=//*[text()='Book Store Application']
   Click Element                        xpath=//*[text()='Book Store Application']
   Wait Until Page Contains             Author

   Wait Until Element Is Visible        xpath=//span[text()='Login']
   Click Element                        xpath=//span[text()='Login']
   Wait Until Page Contains             Welcome,
   Wait Until Page Contains             Login in Book Store

   Input Text                           xpath=//*[@id='userName']         ${EMPTY}
   Input Text                           xpath=//*[@id='password']         Taha2001!!
   Click Element                        xpath=//*[@id='login']
   Wait Until Element Is Visible             xpath=//*[@id='userName' and @class='mr-sm-2 is-invalid form-control']

Logging in with Empty Password
   [Tags]                               functional      ui      negative        login
   Wait Until Page Contains Element     xpath=//*[@id="root"]/header/a
   Wait Until Element Is Visible        xpath=//*[text()='Book Store Application']
   Click Element                        xpath=//*[text()='Book Store Application']
   Wait Until Page Contains             Author

   Wait Until Element Is Visible        xpath=//span[text()='Login']
   Click Element                        xpath=//span[text()='Login']
   Wait Until Page Contains             Welcome,
   Wait Until Page Contains             Login in Book Store

   Input Text                           xpath=//*[@id='userName']         taha001q22
   Input Text                           xpath=//*[@id='password']         ${EMPTY}
   Click Element                        xpath=//*[@id='login']
   Wait Until Element Is Visible             xpath=//*[@id='password' and @class='mr-sm-2 is-invalid form-control']

Logging in with Empty userName and Password
   [Tags]                               functional      ui      negative        login
   Wait Until Page Contains Element     xpath=//*[@id="root"]/header/a
   Wait Until Element Is Visible        xpath=//*[text()='Book Store Application']
   Click Element                        xpath=//*[text()='Book Store Application']
   Wait Until Page Contains             Author

   Wait Until Element Is Visible        xpath=//span[text()='Login']
   Click Element                        xpath=//span[text()='Login']
   Wait Until Page Contains             Welcome,
   Wait Until Page Contains             Login in Book Store

   Input Text                           xpath=//*[@id='userName']         ${EMPTY}
   Input Text                           xpath=//*[@id='password']         ${EMPTY}
   Click Element                        xpath=//*[@id='login']
   Wait Until Element Is Visible             xpath=//*[@id='userName' and @class='mr-sm-2 is-invalid form-control']
   Wait Until Element Is Visible             xpath=//*[@id='password' and @class='mr-sm-2 is-invalid form-control']

Checking the "Logout" Button
    [Tags]                              functional       ui     positive        account
    Logging in
    Click Element                       xpath=//*[text()='Logout']
    Wait Until Page Contains            Login in Book Store

Delete the Account
    [Tags]                              bug     ui     positive     account
    Logging in With Another Account
    Click Element                       xpath=//*[text()='Delete Account']
    Wait Until Page Contains            Do you want to delete your account?
    Click Element                       xpath=//*[text()='OK']

    Page Should Not Contain             taha001

User Should Be Logged Out Automatically After Account Deletion
    [Tags]                              bug       ui     positive       account
    Logging in With Another Account
    Click Element                       xpath=//*[text()='Delete Account']
    Wait Until Page Contains            Do you want to delete your account?
    Click Element                       xpath=//*[text()='OK']
    Wait Until Page Contains            Login

Search Bar - Empty Input Shows All Books
    [Tags]                              functional       ui     positive        bookstore
    Logging in
    Click Element                       xpath=//*[text()='Go To Book Store']
    Input Text                          xpath=//*[@id='searchBox']      ${EMPTY}
    Click Element                       xpath=//*[@id="searchBox-wrapper"]/div[1]/div/button

    Element Should Be Visible           xpath=//*[text()='Git Pocket Guide']
    Element Should Be Visible           xpath=//*[text()='Speaking JavaScript']
    Element Should Be Visible           xpath=//*[text()='Eloquent JavaScript, Second Edition']

Search Bar - Invalid Input Shows No Books
    [Tags]                              functional       ui     negative        bookstore
    Logging in
    Click Element                       xpath=//*[text()='Go To Book Store']

    Input Text                          xpath=//*[@id='searchBox']    xxxxxxxxxx
    Click Element                       xpath=//*[@id="searchBox-wrapper"]/div[1]/div/button

    Element Should Not Be Visible       xpath=//*[text()='Git Pocket Guide']
    Element Should Not Be Visible       xpath=//*[text()='Speaking JavaScript']
    Element Should Not Be Visible       xpath=//*[text()='Eloquent JavaScript, Second Edition']

Search Bar - Search by Book Title
    [Tags]                              functional       ui     positive        bookstore
    Logging in
    Click Element                       xpath=//*[text()='Go To Book Store']
    Input Text                          xpath=//*[@id='searchBox']    Git Pocket Guide
    Click Element                       xpath=//*[@id="searchBox-wrapper"]/div[1]/div/button

    Element Should Be Visible           xpath=//*[text()='Git Pocket Guide']
    Element Should Not Be Visible       xpath=//*[text()='Speaking JavaScript']
    Element Should Not Be Visible       xpath=//*[text()='Eloquent JavaScript, Second Edition']

Search Bar - Search by Author Name
    [Tags]                              functional       ui     positive        bookstore
    Logging in
    Click Element                       xpath=//*[text()='Go To Book Store']
    Input Text                          xpath=//*[@id='searchBox']    Glenn Block et al.
    Click Element                       xpath=//*[@id="searchBox-wrapper"]/div[1]/div/button

    Element Should Be Visible           xpath=//*[text()='Designing Evolvable Web APIs with ASP.NET']
    Element Should Not Be Visible       xpath=//*[text()='Git Pocket Guide']
    Element Should Not Be Visible       xpath=//*[text()='Speaking JavaScript']
    Element Should Not Be Visible       xpath=//*[text()='Eloquent JavaScript, Second Edition']

Search Bar - Search by Publisher Name
    [Tags]                              functional       ui     positive        bookstore
    Logging in
    Click Element                       xpath=//*[text()='Go To Book Store']
    Input Text                          xpath=//*[@id='searchBox']    No Starch Press
    Click Element                       xpath=//*[@id="searchBox-wrapper"]/div[1]/div/button

    Element Should Be Visible           xpath=//*[text()='Eloquent JavaScript, Second Edition']
    Element Should Be Visible           xpath=//*[text()='Understanding ECMAScript 6']
    Element Should Not Be Visible       xpath=//*[text()='Git Pocket Guide']
    Element Should Not Be Visible       xpath=//*[text()='Speaking JavaScript']

Books in the Book Store Should Have Retain Their Own Images When Their Position is Changed
    [Tags]                              bug     ui     positive     bookstore
    Logging in
    Click Element                       xpath=//*[text()='Go To Book Store']
    Element Should Be Visible           xpath=//*[text()='Git Pocket Guide']
    Element Should Be Visible           xpath=//*[@src='/assets/bookimage0-DrW2Lhj5.jpg']
    Element Should Be Visible           xpath=//*[text()='Learning JavaScript Design Patterns']
    Element Should Be Visible           xpath=//*[@src='/assets/bookimage1-CeLeymOA.jpg']

    Input Text                          xpath=//*[@id='searchBox']      Learning JavaScript Design Patterns
    Click Element                       xpath=//*[@id="searchBox-wrapper"]/div[1]/div/button

    Element Should Not Be Visible       xpath=//*[text()='Git Pocket Guide']
    Element Should Not Be Visible       xpath=//*[@src='/assets/bookimage0-DrW2Lhj5.jpg']
    Element Should Be Visible           xpath=//*[text()='Learning JavaScript Design Patterns']
    Element Should Be Visible           xpath=//*[@src='/assets/bookimage1-CeLeymOA.jpg']

Books in the Book Store Should Retain Their Correct Details When Their Position is Changed
    [Tags]                              functional      ui     positive     bookstore
    Logging in
    Click Element                       xpath=//*[text()='Go To Book Store']
    Click Element                       xpath=//*[text()='Git Pocket Guide']
    Wait Until Page Contains            9781449325862
    Page Should Contain                 Git Pocket Guide
    Page Should Contain                 Richard E. Silverman
    Page Should Contain                 234
    Page Should Contain                 This pocket guide is the perfect

    Click Element                       xpath=//*[text()='Back To Book Store']

    Click Element                       xpath=//*[text()='Learning JavaScript Design Patterns']
    Wait Until Page Contains            9781449331818
    Page Should Contain                 Learning JavaScript Design Patterns
    Page Should Contain                 Addy Osmani
    Page Should Contain                 254
    Page Should Contain                 With Learning JavaScript Design Patterns

    Click Element                       xpath=//*[text()='Back To Book Store']

    Input Text                          xpath=//*[@id='searchBox']      Learning JavaScript Design Patterns
    Click Element                       xpath=//*[@id="searchBox-wrapper"]/div[1]/div/button

    Click Element                       xpath=//*[text()='Learning JavaScript Design Patterns']
    Wait Until Page Contains            9781449331818
    Page Should Contain                 Learning JavaScript Design Patterns
    Page Should Contain                 Addy Osmani
    Page Should Contain                 254
    Page Should Contain                 With Learning JavaScript Design Patterns

Entering Website Link in Books'details
    [Tags]                              functional      ui     positive     bookstore
    Logging in
    Click Element                       xpath=//*[text()='Go To Book Store']
    Click Element                       xpath=//*[text()='Git Pocket Guide']
    Click Element                       xpath=//*[text()='http://chimera.labs.oreilly.com/books/1230000000561/index.html']
    Switch Window                       NEW
    Wait Until Page Contains            Build the skills your teams need
    Switch Window                       MAIN

    Click Element                       xpath=//*[text()='Back To Book Store']

    Click Element                       xpath=//*[text()='Learning JavaScript Design Patterns']
    Click Element                       xpath=//*[text()='http://www.addyosmani.com/resources/essentialjsdesignpatterns/book/']
    Switch Window                       NEW
    Wait Until Page Contains            Learning JavaScript Design Patterns
    Wait Until Page Contains            A JavaScript and React Developer's Guide 2nd Edition

Adding Books to the Books Collection
    [Tags]                              functional      ui     positive     bookstore
    Logging in
    Click Element                       xpath=//*[text()='Go To Book Store']
    Click Element                       xpath=//*[text()='Git Pocket Guide']
    Click Element                       xpath=//*[text()='Add To Your Collection']
    Alert Should Be Present             Book added to your collection.
    Click Element                       xpath=//*[text()='Back To Book Store']

    Click Element                       xpath=//*[text()='Speaking JavaScrip']
    Click Element                       xpath=//*[text()='Add To Your Collection']
    Alert Should Be Present             Book added to your collection.
    Click Element                       xpath=//*[text()='Back To Book Store']

    Click Element                       xpath=//*[text()='Profile']
    Element Should Be Visible           xpath=//*[text()='Git Pocket Guide']
    Element Should Be Visible           xpath=//*[text()='Speaking JavaScrip']

Adding Already Added Book to the Books Collection
    [Tags]                              functional      ui     negative     bookstore
    Logging in
    Click Element                       xpath=//*[text()='Go To Book Store']
    Click Element                       xpath=//*[text()='Git Pocket Guide']
    Click Element                       xpath=//*[text()='Add To Your Collection']
    Alert Should Be Present             Book added to your collection.

    Click Element                       xpath=//*[text()='Add To Your Collection']
    Alert Should Be Present             Book already present in the your collection!

Add a Book to the Collection then Delete All Books from the Collection
    [Tags]                              bug       ui     positive       bookstore
    Logging in
    Click Element                       xpath=//*[text()='Go To Book Store']
    Click Element                       xpath=//*[text()='Git Pocket Guide']
    Click Element                       xpath=//*[text()='Add To Your Collection']
    Alert Should Be Present             Book added to your collection.

    Click Element                       xpath=//*[text()='Profile']

    Click Element                       xpath=//*[text()='Delete All Books']
    Wait Until Page Contains            Do you want to delete all books?
    Click Element                       xpath=//*[text()='OK']
    Element Should Not Be Visible       xpath=//*[text()='Git Pocket Guide']

Delete All Books from the Collection
    [Tags]                              bug     ui     positive     bookstore
    Logging in
    Click Element                       xpath=//*[text()='Go To Book Store']

    Click Element                       xpath=//*[text()='Profile']

    Click Element                       xpath=//*[text()='Delete All Books']
    Wait Until Page Contains            Do you want to delete all books?
    Click Element                       xpath=//*[text()='OK']
    Element Should Not Be Visible       xpath=//*[text()='Git Pocket Guide']








*** Keywords ***
Logging in
   Wait Until Page Contains Element     xpath=//*[@id="root"]/header/a
   Wait Until Element Is Visible        xpath=//*[text()='Book Store Application']
   Click Element                        xpath=//*[text()='Book Store Application']
   Wait Until Page Contains             Author

   Wait Until Element Is Visible        xpath=//span[text()='Login']
   Click Element                        xpath=//span[text()='Login']
   Wait Until Page Contains             Welcome,
   Wait Until Page Contains             Login in Book Store

   Input Text                           xpath=//*[@id='userName']         taha001q22
   Input Text                           xpath=//*[@id='password']         Taha2001!!
   Click Element                        xpath=//*[@id='login']
   Wait Until Page Contains             taha001q22

Logging in With Another Account
   Wait Until Page Contains Element     xpath=//*[@id="root"]/header/a
   Wait Until Element Is Visible        xpath=//*[text()='Book Store Application']
   Click Element                        xpath=//*[text()='Book Store Application']
   Wait Until Page Contains             Author

   Wait Until Element Is Visible        xpath=//span[text()='Login']
   Click Element                        xpath=//span[text()='Login']
   Wait Until Page Contains             Welcome,
   Wait Until Page Contains             Login in Book Store

   Input Text                           xpath=//*[@id='userName']        taha001
   Input Text                           xpath=//*[@id='password']        Taha2001!!
   Click Element                        xpath=//*[@id='login']
   Wait Until Page Contains             taha001

