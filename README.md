# W-2-Project


Checks if a given password is longer than set length ,and contains numbers and alphabet characters ,both lower case and capital.
 
 -If password failed validation, display message expalining why it failed, colored red.
 
 -If password passed validation, display message that password passed, colored green.
 
 
 
example: 

 
 PS> ./password-validator.ps1 "MyP@ssw0rd!"
 
 Password has PASSED validation.
 
 
 
 -can read password from file if -f used before passing a file in second argument.

example: 

 
 PS> ./password-validator.ps1 -f "./password.txt"
 
 Password has PASSED validation.
