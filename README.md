# W-2-Project


Checks if a given password is longer than set length ,and contains numbers and alphabet characters ,both lower case and capital.
 
 -If paasword failed validation, display message expalining why,colored red, and exit code 1.
 
 -If paasword passed validation, display message that password passed,colored green, and exit code 0.
 
 
 
example: 

 
 PS> ./password-validator.ps1 "MyP@ssw0rd!"
 
 Password has PASSED validation.
 
 
 
 -can read password from file if "-f" used before passing a file in second argument.

example: 

 
 PS> ./password-validator.ps1 -f "./password.txt"
 
 Password has PASSED validation.
