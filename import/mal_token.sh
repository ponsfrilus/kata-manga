#!/usr/bin/env bash
#
# Simplify the TOKEN generation for the My Anime List API (MAL API).
#
# Link to this file: https://gist.github.com/ponsfrilus/5fa501752595c972f568b61fb192e8b5
#
# Usage:
#   export MAL_CLIENT_ID='phiequ3nah4phohqu7aephae5va8eePu' MAL_CLIENT_SECRET='oof1EilohLaimeigi5eithei0Johlai4hud2EiTee8Ien3iRieTouSeiv1phaiti';
#   ./mal_token.sh [--refresh]
#   Note: these are pwgen generated, they won't work.
#
# See: https://myanimelist.net/apiconfig/references/authorization#obtaining-oauth-20-access-tokens
#
# version         0.0.1
# author          Nicolas BORBOËN <ponsfrilus@gmail.com>
# license         https://unlicense.org/

# set -e -x

# ==============================================================================
# Script variables
# ==============================================================================
MAL_TOKEN_FILE=mal_token.json
CLIENT_ID=${MAL_CLIENT_ID:='changeme'}
CLIENT_SECRET=${MAL_CLIENT_SECRET:='changeme'}

# ==============================================================================
# Check that CLIENT_ID and CLIENT_SECRET are defined, generate the CHALLENGE
# ==============================================================================
init() {

    if [ "changeme" = "$CLIENT_ID" ] || [ "changeme" = "$CLIENT_SECRET" ]; then 
        echo "Please check https://myanimelist.net/apiconfig to create an MAL app and get ID and SECRET.";
        exit 2;
    fi  
    
    CHALLENGE=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 50 | head -n 1)
    
    echo "--------------------------------------------------------------------------------"
    echo "CLIENT_ID:"
    echo -e "\t$CLIENT_ID"
    echo "CLIENT_SECRET:"
    echo -e "\t$CLIENT_SECRET"
    echo "CHALLENGE:"
    echo -e "\t$CHALLENGE"
    echo "--------------------------------------------------------------------------------"

} 

# ==============================================================================
# Generate the link for authorization
# ==============================================================================
authorize() {

    echo "Please follow this link and copy the code"
    echo ""
    echo "https://myanimelist.net/v1/oauth2/authorize?&response_type=code&client_id=${CLIENT_ID}&code_challenge=${CHALLENGE}&code_challenge_method=plain"
    echo ""

    echo "Please enter the value of code=... in the URL"
    echo "Code:"
    read AUTHORIZATION_CODE
    # echo "Your code is:"
    # echo $AUTHORIZATION_CODE

}

# ==============================================================================
# Request the MAL API Token
# ==============================================================================
requestToken() {

    TOKEN_REQ=$(curl -s -X POST \
        -H "Content-Type: application/x-www-form-urlencoded" \
        --data client_id=${CLIENT_ID} \
        --data client_secret=${CLIENT_SECRET} \
        --data grant_type=authorization_code \
        --data code=${AUTHORIZATION_CODE} \
        --data code_verifier=${CHALLENGE} \
        https://myanimelist.net/v1/oauth2/token)

    # echo $TOKEN_REQ | jq
    echo $TOKEN_REQ | jq > $MAL_TOKEN_FILE

    ACCESS_TOKEN=$(echo $TOKEN_REQ | jq -r '.access_token')
    # echo $ACCESS_TOKEN
    REFRESH_TOKEN=$(echo $TOKEN_REQ | jq -r '.refresh_token')
    # echo $REFRESH_TOKEN

}

# ==============================================================================
# Refresh MAL API Token
# ==============================================================================
refreshToken() {

    MY_ACCESS_TOKEN=$(cat token | jq -r '.access_token')
    MY_REFRESH_TOKEN=$(cat token | jq -r '.refresh_token')
    TOKEN_REFRESH_REQ=$(curl -s -X POST \
        -H "Content-Type: application/x-www-form-urlencoded" \
        -H "Authorization: Bearer ${MY_ACCESS_TOKEN}" \
        --data client_id=${CLIENT_ID} \
        --data client_secret=${CLIENT_SECRET} \
        --data grant_type=refresh_token \
        --data refresh_token=${MY_REFRESH_TOKEN} \
        https://myanimelist.net/v1/oauth2/token)
    
    # echo $TOKEN_REFRESH_REQ | jq
    echo $TOKEN_REFRESH_REQ | jq > $MAL_TOKEN_FILE

}

# ==============================================================================
# Test that the software is installed (e.g. jq)
# ==============================================================================
testSoftware() {

    if ! command -v $1 &> /dev/null
    then
        echo "$1 could not be found. Please install $1."
        exit
    fi

}

# ==============================================================================
# A sample query on the manga "Berserk"
# ==============================================================================
testAPI() {

    echo ""
    echo "Testing https://api.myanimelist.net/v2/manga/2:"
    curl -s 'https://api.myanimelist.net/v2/manga/2' \
        -H "Authorization: Bearer $ACCESS_TOKEN" | jq

}

# ==============================================================================
# Script main logic
# ==============================================================================
testSoftware jq
if [ "--refresh" == $1 ]; then
    refreshToken
    echo "Please run \`./$(basename "$0") --show\` to see the refreshed token."
elif [ "--show" == $1 ]; then
    if [ ! -f $MAL_TOKEN_FILE ]; then
        echo "File $MAL_TOKEN_FILE not found, please run \`./$(basename "$0")\` without arg."
        exit 1
    else
        cat $MAL_TOKEN_FILE | jq
    fi
else
    init
    authorize
    requestToken
    testAPI
fi
