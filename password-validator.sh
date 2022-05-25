#! /bin/bash

function isNum {
    if [[ $1 =~ ^[0-9]+$ ]]; then
        echo 1
    else
        echo 0
    fi
}

function isLowCase {
    if [[ $1 =~ ^[a-z]+$ ]]; then
        echo 1
    else
        echo 0
    fi
}

function isUpCase {
    if [[ $1 =~ ^[A-Z]+$ ]]; then
        echo 1
    else
        echo 0
    fi
}

function checkPass {
    GREEN='\033[0;32m'
    RED='\033[0;31m'
    NC='\033[0m'
    NUM=0 # Init NUMBER presence flag.
    L_CASE=0 # Init LOWER case char presence flag.
    U_CASE=0 # Init UPPER case char presence flag.
    PASS=$1 # The "INPUT" that was passed as an argument.
    if [ ${#PASS} -ge 10 ]; then # If password is longer or equal to 10 chars -> continue ,otherwise -> stop.
        for (( i=0; i<=${#PASS}; i++ )); do # Run a for loop on all chars of the recieved password.
            if [[ $i -lt ${#PASS} && $(($NUM+$L_CASE+$U_CASE)) -lt 3 ]]; then #If sum of flags is less than 3 then not all password conditions were met, thus continue testing.
                CHAR=${PASS:$i:1} # Set CHAR to be a sub-String of PASS at position i and be the length of 1 (essentially taing the sigle char at position i).
                # echo "char is being checked $CHAR"
                if [ $NUM -eq 0 ]; then
                        NUM=$(isNum "$CHAR")
                fi        
                if [[ $L_CASE -eq 0 ]]; then
                        L_CASE=$(isLowCase "$CHAR")
                fi        
                if [[ $U_CASE -eq 0 ]]; then
                        U_CASE=$(isUpCase "$CHAR")
                fi
            elif [[ $i -eq ${#PASS} && $(($NUM+$L_CASE+$U_CASE)) -lt 3 ]]; then
                echo -e "${RED}Password ${NC}"$PASS" ${RED}FAILED validation:${NC}"
                if [[ $NUM -eq 0 ]]; then
                        echo -e "${RED}  -Password must contain a NUMBER${NC}"
                fi        
                if [[ $L_CASE -eq 0 ]]; then
                        echo -e "${RED}  -Password must contain a LOWER case character${NC}"
                fi        
                if [[ $U_CASE -eq 0 ]]; then
                        echo -e "${RED}  -Password must contain a CAPITAL case character${NC}"
                fi 
                exit 1
            else
                i=${#PASS}
                echo -e "${GREEN}Password${NC} "$PASS" ${GREEN}PASSED validation${NC}"
                exit 0
            fi
        done
    else   
        echo -e "${RED}Password${NC} "$PASS" ${RED}FAILED validation:${NC}"
        echo -e "  ${RED}-Password must be 10 or more characters long${NC}"
        exit 1
    fi
}

checkPass "$1"