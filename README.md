# Simple-PowerShell-HTTP-File-Server
A crude and simple HTTP File Server PowerShell Script - modified for binary file support

* Listens on port 80 by default
* 
* Use /stop - to stop the script/http listener
* Use / - to list the directories and files in the webroot (this will be where the PowerShell script is stored)
* Use /filename.ext - to download files, display text content in the web browser, etc. (works with Invoke-WebRequest/wget)
