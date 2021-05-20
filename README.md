**PSPortableLight**

Smaller version of PSPortable for quicker deployment where fewer tools are needed.

Deploys a portable PowerShell package with often used modules.

* Open an admin powershell prompt
* Paste the contents of the Deploy-PSPortableLight.ps1 script into a powershell prompt


To get started run the following in an Administrative Powershell Prompt

```Powershell
(Invoke-Webrequest https://raw.githubusercontent.com/TheTaylorLee/PSPortableLight/main/Deploy-PSPortableLight.ps1).content | Invoke-Expression
```