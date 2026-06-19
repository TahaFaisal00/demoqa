*** Variables ***
${MAIN_FIRST_NAME}                                taha
${MAIN_LAST_NAME}                                 moe
${MAIN_USERNAME}                                  taha001q22
${MAIN_PASSWORD}                                  Taha2001!!
${DELETE_ME_FIRST_NAME}                           Delete
${DELETE_ME_LAST_NAME}                            Me
${DELETE_ME_USERNAME}                             DeleteMe
${DELETE_ME_PASSWORD}                             Taha2001!!

&{VALID_ACCOUNT}                                  USERNAME=${MAIN_USERNAME}         PASSWORD=${MAIN_PASSWORD}         TEXT=${MAIN_USERNAME}

&{DELETED_ACCOUNT}                                USERNAME=${DELETE_ME_USERNAME}    PASSWORD=${DELETE_ME_PASSWORD}    ERROR1=${EMPTY}                          ERROR2=${EMPTY}                    ERROR_TEXT=${INVALID_USERNAME_OR_PASSWORD}
&{EMPTY_USERNAME}                                 USERNAME=${EMPTY}                 PASSWORD=${MAIN_PASSWORD}         ERROR1=${EMPTY_USERNAME_FIELD}           ERROR2=${EMPTY}                    ERROR_TEXT=${EMPTY}
&{EMPTY_PASSWORD}                                 USERNAME=${MAIN_USERNAME}         PASSWORD=${EMPTY}                 ERROR1=${EMPTY_PASSWORD_FIELD}           ERROR2=${EMPTY}                    ERROR_TEXT=${EMPTY}
&{EMPTY_CREDENTIALS}                              USERNAME=${EMPTY}                 PASSWORD=${EMPTY}                 ERROR1=${EMPTY_USERNAME_FIELD}           ERROR2=${EMPTY_PASSWORD_FIELD}     ERROR_TEXT=${EMPTY}

&{SEARCH}                                         EMPTY=${EMPTY}    INVALID=xxxxxxxxxx     BOOKNAME=Git Pocket Guide    AUTHOR=Glenn Block et al.   Publisher=No Starch Press
