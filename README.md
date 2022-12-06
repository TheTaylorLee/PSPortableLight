# Deprecated 2022/12/05
I will no longer be updating PSPortableLight. Going forward I will only maintain PSPortable. This still works at this time and will likely continue to function for the forseeable future.

# PSPortableLight

Deploys a portable PowerShell package with often used modules. When updates are released, launching PSPortableLight will present a changelog and prompt to use update-console to update if desired.

This is a lighter version of [PSPortable](https://github.com/TheTaylorLee/PSPortable) for quicker deployment and a smaller install.



* *__To get started__*
  * Open an admin PowerShell prompt
  * Run the below script

  ```Powershell
  [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
  (Invoke-Webrequest https://raw.githubusercontent.com/TheTaylorLee/PSPortableLight/main/Deploy-PSPortableLight.ps1 -usebasicparsing).content | Invoke-Expression
  ```

* *__Using PSPortable or PSPortableLight in Terminal__*

    These steps offer a guide to use PSPortable or PSPortableLight in Windows Terminal as intended. These steps will install a Nerdfont and Git, so the Oh-My-Posh theme is     properly presented.

  * Install Nerd Font, Git, and sign into Git account

  ```Powershell
  Install-Font
  Install-chocolatey
  choco install git
  git config --global user.name "account"
  git config --global user.email "email@site.com"
  ```

  * Terminal settings should be configured to your preference, [Example Settings](https://github.com/TheTaylorLee/PwshProfile/blob/main/WindowsTerminal/CustomSettings.json)
    * Nerd Font must be specified in the PSPortable or PSPortableLight profile.
