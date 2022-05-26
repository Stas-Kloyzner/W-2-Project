#! /bin/bash
# Author: Stanislav Kloyzner
# 
# Checks if a given password is longer than set length and contains numbers and alphabet characters both lower case and capital.


#######################################
# Checks if passed argument is a number between 0-9.
# Globals:
#   None
# Arguments:
#   A char to check
# Outputs:
#   1 if given argument is a number between 0-9.
#   0 if given argument is not a number between 0-9.
#######################################
function isNum {
    if [[ $1 =~ ^[0-9]+$ ]]; then
        echo 1
    else
        echo 0
    fi
}

#######################################
# Checks if passed argument is a lower case alphabet chaacter between a-z.
# Globals:
#   None
# Arguments:
#   A char to check
# Outputs:
#   1 if given argument is a lower case alphabet chaacter between a-z.
#   0 if given argument is not a lower case alphabet chaacter between a-z.
#######################################
function isLowCase {
    if [[ $1 =~ ^[a-z]+$ ]]; then
        echo 1
    else
        echo 0
    fi
}

#######################################
# Checks if passed argument is a capital case alphabet chaacter between A-Z.
# Globals:
#   None
# Arguments:
#   A char to check
# Outputs:
#   1 if given argument is a capital case alphabet chaacter between A-Z.
#   0 if given argument is not a capital case alphabet chaacter between A-Z.
#######################################
function isUpCase {
    if [[ $1 =~ ^[A-Z]+$ ]]; then
        echo 1
    else
        echo 0
    fi
}

#######################################
# Iterates on the characters of a passed argument( a password) and checks if it answers all required conditions:
# length, contains numbers, contains lower and capital alphabet characters.
# Globals:
#   GREEN
#   RED
#   NC
#   LEN
#   NUM
#   L_CASE
#   U_CASE
#   PASS
#   CHAR
# Arguments:
#   A password to check
# Outputs:
#   If validation passed: A message telling the validation was passed (colored Green)
#   If validation failed: A message telling the validation failed and listing the reasons of failur (colored Red)
# RETURN:
#   0 If the password passed validation (answered all conditions).
#   1 If the password failed validation (didn't answer atleast 1 condition).
#######################################
function checkPass {    

    GREEN='\033[0;32m' 
    RED='\033[0;31m' 
    NC='\033[0m' # default no color.
    LEN=10 # set required password length.
    NUM=0 
    L_CASE=0 
    U_CASE=0
    PASS=$1 

    if [ ${#PASS} -ge $LEN ]; then 
        for (( i=0; i<=${#PASS}; i++ )); do 
            if [[ $i -lt ${#PASS} && $(($NUM+$L_CASE+$U_CASE)) -lt 3 ]]; then 
                CHAR=${PASS:$i:1} 
                if [ $NUM -eq 0 ]; then
                        NUM=$(isNum "$CHAR")
                fi        
                if [[ $L_CASE -eq 0 ]]; then
                        L_CASE=$(isLowCase "$CHAR")
                fi        
                if [[ $U_CASE -eq 0 ]]; then
                        U_CASE=$(isUpCase "$CHAR")
                fi
            elif [[ $i -eq ${#PASS} && $(($NUM+$L_CASE+$U_CASE)) -lt 3 ]]; then # Last iteration after all chars were checked to see which conditions weren't answered.
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
                i=${#PASS} # Stops the iteration in case all conditions were already answered before last iteration.
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