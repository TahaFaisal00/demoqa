*** Settings ***
Library                                  Browser

*** Keywords ***
Verify TOOLSQA Page loaded
   Wait For Elements State    css=a[href="https://demoqa.com"]      visible

Click on Book Store Application
   Click Element                         xpath=//*[text()='Book Store Application']
   Wait Until Page Contains              Author










