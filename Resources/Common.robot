*** Settings ***
Library     SeleniumLibrary



*** Variables ***
${URL}=        https://demoqa.com/
${BROWSER}          chrome

*** Keywords ***
Launch Browser
    Open Browser        ${URL}          ${BROWSER}


Close Browser
    Close All Browsers
