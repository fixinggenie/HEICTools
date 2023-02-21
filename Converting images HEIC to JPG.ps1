#Build Required Constants

$AppKitUrl = 'https://github.com/PSAppDeployToolkit/PSAppDeployToolkit/releases/download/3.8.4/PSAppDeployToolkit_v3.8.4.zip'
$AppKitFileName = 'PSAppDeployToolkit_v3.8.4.zip'

# Deploy-HEIFImageExtApp - 
$DeployHEIFImageExtApp = ''
# Get_Store_Downloads - 
$Get_Store_Downloads = ''

$BaseFolderName = "C:\HEIC Converted\"
$ToolsFolder = $BaseFolderName+'Tools\'

#Build out folder paths
if (Test-Path $BaseFolderName) 
{
    Write-Host "Folder Exists"
}
else
{
    New-Item $BaseFolderName -ItemType Directory
    Write-Host "Folder Created successfully"
    if (Test-Path $ToolsFolder) 
        {
            Write-Host "Folder Exists"
        }
        else
        {
            New-Item $ToolsFolder -ItemType Directory
            New-Item $ToolsFolder'HEIFImageExtApp' -ItemType Directory
            New-Item $ToolsFolder'HEIFImageExtApp\Files' -ItemType Directory
            Write-Host "Folder Created successfully"
        }
}

#Update Reg ex for Cookie settings

#REG ADD "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\3" /t REG_DWORD /v 1A10 /f /d 0
Write-Host 'Get Web Kit from URL'
Invoke-WebRequest -Uri $AppKitUrl -OutFile $ToolsFolder$AppKitFileName

Write-Host 'Unlock Web Kit from URL'
Unblock-File -Path $ToolsFolder$AppKitFileName

Write-Host 'Expand Web Kit from URL'
Expand-Archive -Path $ToolsFolder$AppKitFileName -DestinationPath $ToolsFolder

Copy-Item -Path $ToolsFolder'Toolkit\AppDeployToolkit' -Destination $ToolsFolder'\AppDeployToolkit' -Recurse
Copy-Item -Path $ToolsFolder'Toolkit\Files' -Destination $ToolsFolder'\Files' -Recurse

#Powershell.exe -ExecutionPolicy ByPass "&" '.\Get_Store_Downloads.ps1' -packageFamilyName Microsoft.HEIFImageExtension_8wekyb3d8bbwe -downloadFolder $ToolsFolder'HEIFImageExtApp\Files' -excludeRegex 'arm' -force
& $([scriptblock]::Create((New-Object Net.WebClient).DownloadString($Get_Store_Downloads))) -packageFamilyName Microsoft.HEIFImageExtension_8wekyb3d8bbwe -downloadFolder $ToolsFolder'Files' -excludeRegex 'arm' -force

#Powershell.exe -ExecutionPolicy Bypass .\Deploy-HEIFImageExtApp.ps1 -DeploymentType "Install" -DeployMode "NonInteractive"
& $([scriptblock]::Create((New-Object Net.WebClient).DownloadString($DeployHEIFImageExtApp)))  -DeploymentType "Install" -DeployMode "NonInteractive"

<#
$filePath = ls $HOME\Downloads Photos*.zip

ForEach($i in $filePath)
{
 Expand-Archive -Path $i.FullName -DestinationPath $FolderName -verbose
}

$hieFiles = ls $FolderName *.heic

$Appx64 = $ToolsFolder

Invoke-WebRequest -Uri 'http://tlu.dl.delivery.mp.microsoft.com/filestreamingservice/files/91bc8266-849b-42af-b265-7cf438b79044?P1=1676683294&P2=404&P3=2&P4=mNyQdfaJMgcVrMb4rrTskhmyTVXDKTnos8Ahf09s5646ZuQwbhMtyn7FXkfyqIMF6Bfy6kAF%2fePkB5XxLnDSNw%3d%3d' -OutFile $FolderName'Microsoft.HEIFImageExtension_1.0.43012.0_x64__8wekyb3d8bbwe.appx'

Execute-ProcessAsUser -Path "$PSHOME\powershell.exe" -Parameters "-WindowStyle Hidden Add-AppxPackage ""$Appx64""" -Wait

$Url = 'https://raw.githubusercontent.com/DavidAnson/ConvertTo-Jpeg/main/ConvertTo-Jpeg.ps1'
ForEach($f in $hieFiles)
{
#& $([scriptblock]::Create((New-Object Net.WebClient).DownloadString($Url))) -Files $f.FullName
}



#>