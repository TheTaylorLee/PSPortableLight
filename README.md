# PSPortableLight

Deploys a portable PowerShell package with often used modules.

This is a lighter version of [PSPortable](https://github.com/TheTaylorLee/PSPortable) for quicker deployment and a smaller install.



* *__To get started__*
  * Open an admin PowerShell prompt
  * Run the below function

```Powershell
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
(Invoke-Webrequest https://raw.githubusercontent.com/TheTaylorLee/PSPortableLight/main/Deploy-PSPortableLight.ps1).content | Invoke-Expression
```

* *__To Upgrade__*
  * Open an admin PowerShell prompt
  * Run the below function

```Powershell
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
(Invoke-Webrequest https://raw.githubusercontent.com/TheTaylorLee/PSPortableLight/main/Invoke-VersionUpdate.ps1).content | Invoke-Expression
```

**Changelog**

     - 1.0.0 Added Version Control
     - 1.1.0 Updated the readme with a getting started function
     - 1.2.0 Updated the readme with a changelog
     - 1.3.0 Updated Admintoolbox.ActiveDirectory module version and the Invoke-VersionUpdate function