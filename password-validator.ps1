# Author: Stanislav Kloyzner
# 
# Checks if a given password is longer than set length ,and contains numbers and alphabet characters ,both lower case and capital.
# use example: 
# 
# PS> ./password-validator.ps1 "MyP@ssw0rd!"
# Password has PASSED validation.
# 
# can read password from file if "-f" used before passing a file in second argument.
# use example: 
# 
# PS> ./password-validator.ps1 -f "./password.txt"
# Password has PASSED validation.

Function Get-Len{
<#
.SYNOPSIS

Checks if string has sufficient length.

.DESCRIPTION

Checks if string has sufficient length.

.PARAMETER Pass
The string to be checked.

.PARAMETER Len
The desired length.

.OUTPUTS

1 If string is longer or equal to desired length.
0 If string is shorter than desired length.

.EXAMPLE

PS> Get-Len "ab12C" 5
1

.EXAMPLE

PS> Get-Len "ab12" 5
0

#>
    Param ($Pass, $Len)

    if($Pass.Length -ge $Len){
        return 1
    }else{
        return 0
    }
}

Function Get-Num{
<#
.SYNOPSIS

Checks if string contains a number.

.DESCRIPTION

Checks if string contains a number.

.PARAMETER Pass
The string to be checked.

.OUTPUTS

1 If the string contains a number.
0 If the string doesn't contain a number.

.EXAMPLE

PS> Get-Num "abcd1"
1
.EXAMPLE

PS> Get-Num "abcd"
0

#>
    Param ($Pass)

    if($Pass -match "[0-9]"){
        return 1
    }else{
        return 0
    }
}

Function Get-Low{
<#
.SYNOPSIS

Checks if string contains a lower case character.

.DESCRIPTION

Checks if string contains a lower case character.

.PARAMETER Pass
The string to be checked.

.OUTPUTS

1 If string contains a lower case character.
0 If string doesn't contain a lower case character.

.EXAMPLE

PS> Get-Len "ab1D"
1

.EXAMPLE

PS> Get-Len "123ABC"
0

#>
    Param ($Pass)

    if($Pass -cmatch "[a-z]"){
        return 1
    }else{
        return 0
    }
}

Function Get-Up{
<#
SYNOPSIS

Checks if string contains a capital case character.

.DESCRIPTION

Checks if string contains a capital case character.

.PARAMETER Pass
The string to be checked.

.OUTPUTS

1 If string contains a capital case character.
0 If string doesn't contain a capital case character.

.EXAMPLE

PS> Get-Len "ab1D"
1

.EXAMPLE

PS> Get-Len "123abc"
0

#>
    Param ($Pass)

    if($Pass -cmatch "[A-Z]"){
        return 1
    }else{
        return 0
    }
}

Function Validate{
<#
.SYNOPSIS

Checks if a string is a valid password.

.DESCRIPTION

Checks if string has sufficient length , numbers, lower and capital case characters.

.PARAMETER Pass
The string to be checked.

.OUTPUTS

If string passed validation ,a green colored notification will be printed to notify that the password was validated.(exit code 0)
If string failed validation ,a red colored notification will be printed to notify that the password failed validation an the reasons will be listed.(exit code 1)

.EXAMPLE

PS> Validate "123abc"
Password has FAILED validation.
  -Password must be 10 or more characters long.
  -Password must contain a CAPITAL case character.

.EXAMPLE

PS> Validate "123abcABC@"
Password has PASSED validation.

#>
    Param ($Pass, $Len)
    if(((Get-Len $Pass $Len) -eq 1) -and ((Get-Up $pass) -eq 1) -and ((Get-Low $pass) -eq 1) -and ((Get-Num $pass) -eq 1)){
        Write-Host "Password has PASSED validation." -ForegroundColor Green
        exit 0
    }else{
        Write-Host "Password has FAILED validation." -ForegroundColor Red
        if((Get-Len $Pass $Len) -eq 0){
            Write-Host "  -Password must be 10 or more characters long." -ForegroundColor Red
        }
        if((Get-Num $pass) -eq 0){
            Write-Host "  -Password must contain a NUMBER." -ForegroundColor Red
        }
        if((Get-Low $pass) -eq 0){
            Write-Host "  -Password must contain a LOWER case character." -ForegroundColor Red
        }
        if((Get-Up $pass) -eq 0){
            Write-Host "  -Password must contain a CAPITAL case character." -ForegroundColor Red
        }
        exit 1
    }
}

Function Start-Validate{
<#
.SYNOPSIS

Checks if a string is a valid password.

.DESCRIPTION

Checks if string has sufficient length , numbers, lower and capital case characters.

.PARAMETER Arg0
The first argument passed to the function (can be "-f" or a password).

.PARAMETER Arg1
The second argument passed to the function (supposed to be a file containing a password).

.OUTPUTS

If string passed validation ,a green colored notification will be printed to notify that the password was validated.(exit code 0)
If string failed validation ,a red colored notification will be printed to notify that the password failed validation and the reasons will be listed.(exit code 1)

.EXAMPLE

PS> Start-Validate "MyP@ssw0rd!"
Password has PASSED validation.

.EXAMPLE

PS> Start-Validate -f "./password.txt"
Password has PASSED validation.

.EXAMPLE

PS> Start-Validate "-f"
You used the flag -f ,but didnt pass a file to read from.
Please use the following format : ./password-validator.ps1 -f <./file.txt>

.EXAMPLE

PS> Start-Validate "-f" "./NonExistantFile.txt"
The file you specified doesn't exist

#>

    Param ($Arg0, $Arg1)
    $Len=10 # Set desired password length.

    if($Arg0 -eq "-f"){
        if($null -eq $Arg1){
            Write-Host "You used the flag -f ,but didnt pass a file to read from." -ForegroundColor Red
            Write-Host "Please use the following format : ./password-validator.ps1 -f <./file.txt>" -ForegroundColor Red
            exit 1
        }else{
            if(Test-Path $Arg1){
                $text = Get-Content $Arg1 -Raw 
                Validate $text $Len
            }
            else{
                Write-Host "The file you specified doesn't exist" -ForegroundColor Red
                exit 1
            }
        }
    }elseif($null -eq $Arg0){
        Write-Host "You didnt pass a password to validate" -ForegroundColor Red
        exit 1
    }
    else{
        Validate $Arg0
    }
}

Start-Validate $($args[0]) $($args[1])

