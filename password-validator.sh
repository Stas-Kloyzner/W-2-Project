#! /bin/bash
# Author: Stanislav Kloyzner
# 
# Checks if a given password is longer than set length and contains numbers and alphabet characters both lower case and capital.
# use example: ./password-validator.sh "MyP@ssw0rd!"
#
# can read password from file if "-f" used before passing a file in second argument.
# use example: ./password-validator.sh -f "./password.txt"


#======================================
# Checks if passed argument is a number between 0-9.
# Globals:
#   None
# Arguments:
#   A char to check
# Outputs:
#   1 if given argument is a number between 0-9.
#   0 if given argument is not a number between 0-9.
#======================================
function isNum {
    if [[ $1 =~ ^[0-9]+$ ]]; then
        echo 1
    else
        echo 0
    fi
}

#======================================
# Checks if passed argument is a lower case alphabet character between a-z.
# Globals:
#   None
# Arguments:
#   A char to check
# Outputs:
#   1 if given argument is a lower case alphabet character between a-z.
#   0 if given argument is not a lower case alphabet character between a-z.
#======================================
function isLowCase {
    if [[ $1 =~ ^[a-z]+$ ]]; then
        echo 1
    else
        echo 0
    fi
}

#======================================
# Checks if passed argument is a capital case alphabet character between A-Z.
# Globals:
#   None
# Arguments:
#   A char to check
# Outputs:
#   1 if given argument is a capital case alphabet character between A-Z.
#   0 if given argument is not a capital case alphabet character between A-Z.
#======================================
function isUpCase {
    if [[ $1 =~ ^[A-Z]+$ ]]; then
        echo 1
    else
        echo 0
    fi
}

#======================================
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
#   If validation failed: A message telling the validation failed and listing the reasons of failure (colored Red)
#======================================
function validate {    

    GREEN='\033[0;32m' 
    RED='\033[0;31m' 
    NC='\033[0m' # default no color.
    LEN=10 # set required password length.
    NUM=0 
    L_CASE=0 
    U_CASE=0
    PASS=$1 

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
        elif [[ $(($NUM+$L_CASE+$U_CASE)) -eq 3 && ${#PASS} -ge LEN ]]; then # Last iteration after all chars were checked to see which conditions weren't answered.
            i=${#PASS} # Stops the iteration in case all conditions were answered.
            echo -e "${GREEN}Password PASSED validation${NC}"
            exit 0
        else 
            echo -e "${RED}Password FAILED validation:${NC}"
            if [[ ${#PASS} -le LEN ]]; then
                    echo -e "${RED}  -Password must be $LEN or more characters long${NC}"
            fi  
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
        fi
    done
}

#======================================
# Checks if the first argument passed was a password or the flag -f.
# If the first argument was a password ,try to validate it.
# If the first argument was -f , tries to read password from a file (the file should be provided in the second argument).
# Arguments:
#   A flag (-f) or a password to validate.
#   A file (./file.txt) if the first argument was -f.
# Outputs:
#   If input arguments were incorrect, prints message (colord red) specifying the problem.
#======================================
function startValidate {

    if [ $1 == "-f" ]; then
        if [ -z $2 ]; then # If a file wasn't passed in the second argument 
            echo -e "\033[0;31mYou used the flag -f ,but didnt pass a file to read from.\033[0m"
            echo -e "\033[0;31mPlease use the following format : ./password-validator.ps1 -f ./file.txt\033[0m"
            exit 1
        else
            if  [ -f $2 ] ; then #check if $2 is a file (not a folder or nonexistant)
                validate "$(< "$2")"
            else
                echo -e "\033[0;31mThe file you specified doesn't exist.\033[0m"
                exit 1
            fi
        fi

    elif [ -z $1 ]; then 
        echo -e "\033[0;31mYou didnt pass a password to validate.\033[0m"
        exit 1
    else
        validate $1 
    fi
}

startValidate $1 $2