<#
.\Get-InstalledWindowsUpdates.ps1
#>

# Set the common parameters
$path = $env:temp
$timestamp = Get-Date -UFormat "%Y%m%d"
$separator = '-------------------------------------------'
$empty_line = ""


# Function used to convert Windows Update Result Codes (numbers) to text
function ResultCodeText {
    param($ResultCode)
    If ($ResultCode -eq 0) {
        [string]'Not Started'
    } ElseIf ($ResultCode -eq 1) {
        [string]'In Progress'
    } ElseIf ($ResultCode -eq 2) {
        [string]'Succeeded'
    } ElseIf ($ResultCode -eq 3) {
        [string]'Succeeded With Errors'
    } ElseIf ($ResultCode -eq 4) {
        [string]'Failed'
    } ElseIf ($ResultCode -eq 5) {
        [string]'Aborted'
    } Else {
        [string]''
    } # else
} # function


write-verbose "Searching for installed updates..."  


# Display a welcoming screen in console
$empty_line | Out-String
$title = 'A Partial List of Installed Windows Updates'
Write-Output $title
$separator | Out-String


# Display a partial list of HotFixIDs in console with WMI
$HotFixIDs = Get-WmiObject -class Win32_QuickFixEngineering -ComputerName $env:ComputerName | Sort HotFixID | Format-Table -Property @{label="HotFix ID"; Width=15; expression={$_.HotFixID}},@{Label="Description"; Width=21; Expression={$_.Description}},@{Label="Link"; Expression={$_.Caption}}
$HotFixIDs
$HotFixIDs | Measure-Object | Select-Object @{Label="Total"; Expression={$_.Count}}


# Retrieve the installed Windows updates
$Session = New-Object -ComObject Microsoft.Update.Session
$Searcher = $Session.CreateUpdateSearcher()
$HistoryCount = $Searcher.GetTotalHistoryCount()


### Write the installed Windows updates to a CSV-file (a secondary basic file)
# $Searcher.QueryHistory(0,$HistoryCount) | Select-Object * | Export-Csv $path\installed_windows_updates_2.csv -NoTypeInformation -Encoding UTF8


# Add a KB-column to the data                                                                 # Credit: Stephane van Gulick: "Get-WindowsUpdates"
    $WindowsUpdates = @()

        If (!($HistoryCount)){
            write-warning -Message "No updates found."
            Break
        } # if

    $AllUpdates = $Searcher.QueryHistory(0,$HistoryCount)
    $i = 0

        While ($i -ne $HistoryCount){

            $Update = @()

            $Categories = $Allupdates.Item($i).Categories
            $ClientApplicationID = $Allupdates.Item($i).ClientApplicationID
            $Date = $Allupdates.Item($i).Date
            $Description = $Allupdates.Item($i).Description
            $HResult = $Allupdates.Item($i).HResult
            $Operation = $Allupdates.Item($i).Operation
            $ResultCode = $Allupdates.Item($i).ResultCode
            $ServerSelection = $Allupdates.Item($i).ServerSelection
            $ServiceID = $Allupdates.Item($i).ServiceID
            $SupportUrl = $Allupdates.Item($i).SupportUrl
            $Title = $Allupdates.Item($i).Title
            $UninstallationNotes = $Allupdates.Item($i).UninstallationNotes
            $UninstallationSteps = $Allupdates.Item($i).UninstallationSteps
            $UnmappedResultCode = $Allupdates.Item($i).UnmappedResultCode
            $UpdateIdentity = $Allupdates.Item($i).UpdateIdentity
            $HotFixID = $Title | Select-String -Pattern 'KB\d*' -AllMatches | ForEach { $_.Matches } | ForEach {$_.value}


            $Update += New-Object -TypeName PSCustomObject -Property @{


                    'Categories'            = $Categories
                    'ClientApplication ID'  = $ClientApplicationID
                    'Date'                  = $Date
                    'Description'           = $Description
                    'HotFix ID'             = $HotFixID
                    'HResult'               = $HResult
                    'Operation'             = $Operation
                    'Result'                = (ResultCodeText($ResultCode))
                    'ResultCode'            = $ResultCode
                    'ServerSelection'       = $ServerSelection
                    'ServiceID'             = $ServiceID
                    'Support URL'           = $SupportUrl
                    'Title'                 = $Title
                    'Uninstallation Notes'  = $UninstallationNotes
                    'Uninstallation Steps'  = $UninstallationSteps
                    'Unmapped ResultCode'   = $UnmappedResultCode
                    'Update Identity'       = $UpdateIdentity


            } # New-Object
            $Update.PSObject.TypeNames.Insert(0,"WindowsUpdate")


            $WindowsUpdates += $Update
            $i++
        } # while


# Display the installed Windows updates in a pop-up window
$WindowsUpdates_selection = $WindowsUpdates | Select-Object 'HotFix ID',Operation,Result,HResult,'Unmapped ResultCode',Date,Title,Description,ResultCode,'ClientApplication ID',ServerSelection,ServiceID,'Update Identity','Uninstallation Steps','Uninstallation Notes','Support URL',Categories
$WindowsUpdates_selection | Out-GridView


# Write the installed Windows updates to a CSV-file
$WindowsUpdates_selection | Export-Csv $path\installed_windows_updates.csv -Delimiter ';' -NoTypeInformation -Encoding UTF8




# [End of Line]


<#

   ____        _   _
  / __ \      | | (_)
 | |  | |_ __ | |_ _  ___  _ __  ___
 | |  | | '_ \| __| |/ _ \| '_ \/ __|
 | |__| | |_) | |_| | (_) | | | \__ \
  \____/| .__/ \__|_|\___/|_| |_|___/
        | |
        |_|


# Write the installed Windows updates to a HTML-file
$Report = $WindowsUpdates_selection | ConvertTo-Html | Out-File -FilePath $path\installed_windows_updates.html


# Open the installed Windows updates HTML-file in the default browser.
Invoke-Item "$path\installed_windows_updates.html"


# Open the installed Windows updates CSV-file
Invoke-Item -Path $path\installed_windows_updates.csv


installed_windows_updates_$timestamp.html                                                     # an alternative filename format
$time = Get-Date -Format g                                                                    # a "general short" time-format (short date and short time)



   _____
  / ____|
 | (___   ___  _   _ _ __ ___ ___
  \___ \ / _ \| | | | '__/ __/ _ \
  ____) | (_) | |_| | | | (_|  __/
 |_____/ \___/ \__,_|_|  \___\___|


https://gallery.technet.microsoft.com/Get-WindowsUpdates-06eb7f43                            # Stephane van Gulick: "Get-WindowsUpdates"



  _    _      _
 | |  | |    | |
 | |__| | ___| |_ __
 |  __  |/ _ \ | '_ \
 | |  | |  __/ | |_) |
 |_|  |_|\___|_| .__/
               | |
               |_|
#>

<#

.SYNOPSIS
Retrieves a list of all installed Windows updates.

.DESCRIPTION
Get-InstalledWindowsUpdates uses Windows Management Instrumentation (WMI) to retrieve a list of some 
HotFixIDs installed on the computer and displays the results in console. Get-InstalledWindowsUpdates 
also uses Windows Update Agent (WUA) API to retrieve another list of all the installed 
Windows updates and displays those results in a pop-up window and writes them to a CSV-file. 
This script is based on Stephane van Gulick's PowerShell function "Get-WindowsUpdates" 
(https://gallery.technet.microsoft.com/Get-WindowsUpdates-06eb7f43).

.OUTPUTS
Displays a partial list of installed HotFixIDs in console and a list of all installed Windows 
updates in a pop-up window "$WindowsUpdates_selection" (Out-GridView).

        Name                                Description
        ----                                -----------
        $WindowsUpdates_selection           Displays a list of installed Windows updates


And also one CSV-file at $path

$env:temp\installed_windows_updates.csv            : CSV-file                : installed_windows_updates.csv

.NOTES
Please note that the file is created in a directory, which is specified with the
$path variable (at line 6). The $env:temp variable points to the current temp folder.
The default value of the $env:temp variable is C:\Users\<username>\AppData\Local\Temp
(i.e. each user account has their own separate temp folder at path %USERPROFILE%\AppData\Local\Temp).
To see the current temp path, for instance a command

    [System.IO.Path]::GetTempPath()
    
may be used at the PowerShell prompt window [PS>]. To change the temp folder for instance 
to C:\Temp, please, for example, follow the instructions at
http://www.eightforums.com/tutorials/23500-temporary-files-folder-change-location-windows.html

    Homepage:           https://github.com/auberginehill/get-installed-windows-updates
    Version:            1.0

.EXAMPLE
./Get-InstalledWindowsUpdates
Run the script. Please notice to insert ./ or .\ before the script name.

.EXAMPLE
help ./Get-InstalledWindowsUpdates -Full
Display the help file.

.EXAMPLE
Set-ExecutionPolicy remotesigned
This command is altering the Windows PowerShell rights to enable script execution. Windows PowerShell
has to be run with elevated rights (run as an administrator) to actually be able to change the script
execution properties. The default value is "Set-ExecutionPolicy restricted".


    Parameters:

    Restricted      Does not load configuration files or run scripts. Restricted is the default
                    execution policy.

    AllSigned       Requires that all scripts and configuration files be signed by a trusted
                    publisher, including scripts that you write on the local computer.

    RemoteSigned    Requires that all scripts and configuration files downloaded from the Internet
                    be signed by a trusted publisher.

    Unrestricted    Loads all configuration files and runs all scripts. If you run an unsigned
                    script that was downloaded from the Internet, you are prompted for permission
                    before it runs.

    Bypass          Nothing is blocked and there are no warnings or prompts.

    Undefined       Removes the currently assigned execution policy from the current scope.
                    This parameter will not remove an execution policy that is set in a Group
                    Policy scope.


For more information,
type "help Set-ExecutionPolicy -Full" or visit https://technet.microsoft.com/en-us/library/hh849812.aspx.

.EXAMPLE
New-Item -ItemType File -Path C:\Temp\Get-InstalledWindowsUpdates.ps1
Creates an empty ps1-file to the C:\Temp directory. The New-Item cmdlet has an inherent -NoClobber mode
built into it, so that the procedure will halt, if overwriting (replacing the contents) of an existing
file is about to happen. Overwriting a file with the New-Item cmdlet requires using the Force.
For more information, please type "help New-Item -Full".

.LINK
https://gallery.technet.microsoft.com/Get-WindowsUpdates-06eb7f43
https://gallery.technet.microsoft.com/ScriptCenter/d86cd93b-2428-40a1-a430-26bd3caed36f/
http://blog.powershell.no/2010/06/25/manage-windows-update-installations-using-windows-powershell/
http://blog.crayon.no/blogs/janegil/archive/2010/06/25/manage_2D00_windows_2D00_update_2D00_installations_2D00_using_2D00_windows_2D00_powershell.aspx
http://www.ehow.com/how_8724332_use-powershell-run-windows-updates.html
https://msdn.microsoft.com/en-us/library/aa387287(v=VS.85).aspx

#>
