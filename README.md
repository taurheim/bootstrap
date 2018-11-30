Machine bootstrapper
======
Paste into admin powershell:

	set-executionpolicy unrestricted
	wget https://raw.githubusercontent.com/taurheim/bootstrap/master/bootstrap.ps1 -outfile $env:temp/bootstrap.ps1
	invoke-expression $env:temp/bootstrap.ps1