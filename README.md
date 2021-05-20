# PSPortableLight

Lighter version of [PSPortable](https://github.com/TheTaylorLee/PSPortable) for quicker deployment and a smaller install.

Deploys a portable PowerShell package with often used modules.

* Open an admin powershell prompt
* Paste the contents of the Deploy-PSPortableLight.ps1 script into a powershell prompt


To get started run the following in an Administrative Powershell Prompt

```Powershell
(Invoke-Webrequest https://raw.githubusercontent.com/TheTaylorLee/PSPortableLight/main/Deploy-PSPortableLight.ps1).content | Invoke-Expression
```

**Changelog**

     - 1.0.0 Added Version Control
     - 1.1.0 Updated the readme with a getting started function
     - 1.2.0 Updated the readme with a changelog