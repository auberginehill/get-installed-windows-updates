<#
Get-InstalledWindowsUpdates.ps1
#>


# Set the common parameters
# Source: https://msdn.microsoft.com/en-us/library/windows/desktop/aa387095(v=vs.85).aspx
# Source: https://msdn.microsoft.com/en-us/library/windows/desktop/aa387280(v=vs.85).aspx
$ErrorActionPreference = "Stop"
$path = $env:temp
$computer = $env:COMPUTERNAME
$timestamp_today = Get-Date
$empty_line = ""
$some_windows_updates = @()
$all_windows_updates = @()
$hotfix_hive = @()
$result_code = @{ 0 = "Not Started"; 1 = "In Progress"; 2 = "Succeeded" ; 3 = "Succeeded With Errors"; 4 = "Failed"; 5 = "Aborted" }
$server_selection = @{ 0 = "Default"; 1 = "Managed Server"; 2 = "Windows Update"; 3 = "Other" }


# Display a welcoming screen in console
Write-Verbose "Searching for installed updates..."
$empty_line | Out-String
$header = 'A Partial List of Installed Windows Updates'
$coline = '-------------------------------------------'
Write-Output $header
$coline | Out-String




# Method 1
# Windows Management Instrumentation: Get-WmiObject -Class Win32_QuickFixEngineering
$hotfix_repo = Get-WmiObject -Class Win32_QuickFixEngineering -ComputerName $computer

        ForEach ($hotfix in $hotfix_repo) {

                $original_date_value = ($hotfix.Properties | where { $_.Name -like "*InstalledOn*" } | Select-Object -ExpandProperty Value)
                $month_qfe = ($original_date_value).Split("/")[0]
                $day_qfe = ($original_date_value).Split("/")[1]
                $year_qfe = ($original_date_value).Split("/")[2]
                $date_qfe = (Get-Date -Day $day_qfe -Month $month_qfe -Year $year_qfe)

                        $hotfix_hive += $obj_hotfix = New-Object -TypeName PSCustomObject -Property @{

                            'Computer'                  = $hotfix.CSName
                            'HotFixID'                  = $hotfix.HotFixID
                            'Type'                      = $hotfix.Description
                            'Support URL'               = $hotfix.Caption
                            'Install Date'              = ($date_qfe.ToShortDateString())

                        } # New-Object

        } # ForEach $hotfix


# Display a partial list of HotFixIDs in console
# $hotfix_hive_selection | Sort HotFixID | Format-Table -AutoSize -Wrap
$hotfix_hive.PSObject.TypeNames.Insert(0,"Windows Updates (Win32_QuickFixEngineering)")
$hotfix_hive_selection = $hotfix_hive | Select-Object 'HotFixID','Type','Support URL','Install Date'
$hotfix_hive_selection | Sort HotFixID | Format-Table -Property @{ Label = "HotFixID"; Expression = { $_.HotFixID }; Width = 15 },
                @{ Label = "Type";           Expression = { $_.Type};                                               Width = 21 },
                @{ Label = "Support URL";    Expression = { $_ | Select-Object -ExpandProperty 'Support URL' };     Width = 60 },
                @{ Label = "Install Date";   Expression = { $_ | Select-Object -ExpandProperty 'Install Date' };    Width = 15 }
Write-Output $hotfix_hive | Measure-Object | Select-Object @{ Label = "Total"; Expression = { $_.Count }}




# Method 2
# Windows Management Instrumentation Command-Line Utility (WMIC.exe) with query path win32_quickfixengineering (about the same result as Method 1)
# WMIC.exe is located in the Windows\System32\Wbem folder.
# wmic /?
# wmic qfe list brief /format:htable > hotfix.html
# wmic qfe list full /format:htable > hotfix_full.html
# wmic qfe list full /format:csv > hotfix_full.csv
# wmic qfe list full /format:xml > hotfix_full.xml
# Invoke-Command -ScriptBlock { wmic qfe list full /format:csv } | ConvertFrom-Csv | Export-Csv "hotfix_full.csv" -Delimiter ";" -NoTypeInformation -Encoding UTF8

<#
        Invoke-Command -ScriptBlock { wmic qfe list full /format:csv > temp.csv } | Out-Null
        Get-Content -Path temp.csv | Where-Object { $_ -ne "" } | ConvertFrom-Csv | Export-Csv "hotfix_full.csv" -Delimiter ";" -NoTypeInformation -Encoding UTF8
        Remove-Item -Path temp.csv
        Import-Csv hotfix_full.csv -Delimiter ";"
#>

#   \S      Any nonwhitespace character (excludes space, tab and carriage return).
#   \d      Any decimal digit.
# Source: http://powershellcookbook.com/recipe/qAxK/appendix-b-regular-expression-reference
# Source: https://technet.microsoft.com/en-us/library/ee835740.aspx
# Source: http://superuser.com/questions/1002015/why-are-get-hotfix-and-wmic-qfe-list-in-powershell-missing-installed-updates
# Source: http://social.technet.microsoft.com/wiki/contents/articles/4197.how-to-list-all-of-the-windows-and-software-updates-applied-to-a-computer.aspx
Write-Verbose "Invoking the second method (wmic)..."
$wmic = Invoke-Command -ScriptBlock { wmic qfe list full /format:csv } | ConvertFrom-Csv

If ($wmic -match '\S') {

        ForEach ($hotfix_item in $wmic) {

                $raw_date_value = "$($hotfix_item.InstalledOn)"
                $month = ($raw_date_value).Split("/")[0]
                $day = ($raw_date_value).Split("/")[1]
                $year = ($raw_date_value).Split("/")[2]
                $date = (Get-Date -Day $day -Month $month -Year $year)

                    If ($hotfix_item.HotFixID.ToLower().Contains("KB".ToLower())) {
                        $plain_number = [int]$hotfix_item.HotFixID.ToLower().Replace("kb","")
                    } Else {
                        $continue = $true
                    } # Else

                            $some_windows_updates += $obj_update = New-Object -TypeName PSCustomObject -Property @{

                                'Computer'                  = $hotfix_item.CSName
                                'HotFixID'                  = $hotfix_item.HotFixID
                                'Type'                      = $hotfix_item.Description
                                'Install Date'              = $date.ToShortDateString()
                                'Installed On'              = Get-Date $date -Format yyyyMMdd
                                'installed_on_original'     = $hotfix_item.InstalledOn
                                'Day'                       = $day
                                'Month'                     = $month
                                'Year'                      = $year
                                'Weekday'                   = (Get-Date $date).DayOfWeek
                                'Age (Days)'                = ($timestamp_today - $date).Days
                                'install_date_original'     = $hotfix_item.InstallDate
                                'Installed By'              = $hotfix_item.InstalledBy
                                'Support URL'               = $hotfix_item.Caption
                                'Custom URL'                = [string]'http://support.microsoft.com/?kbid=' + $plain_number
                                'Comments'                  = $hotfix_item.FixComments
                                'Name'                      = $hotfix_item.Name
                                'In Effect'                 = $hotfix_item.ServicePackInEffect
                                'Status'                    = $hotfix_item.Status
                                'Node'                      = $hotfix_item.Node
                                'Number'                    = $plain_number
                            } # New-Object

        } # ForEach $hotfix_item


    # Write the partial list of installed Windows updates to a CSV-file (a secondary basic file)
    $some_windows_updates.PSObject.TypeNames.Insert(0,"Windows Updates (wmic)")
    $some_windows_updates_selection = $some_windows_updates | Select-Object 'Computer','HotFixID','Type','Install Date','Installed On','installed_on_original','Day','Month','Year','Weekday','Age (Days)','install_date_original','Installed By','Support URL','Custom URL','Comments','Name','In Effect','Status','Node','Number'
    $some_windows_updates_selection | Sort 'Number','Age (Days)' | Export-Csv "$path\partial_hotfix_list.csv" -Delimiter ";" -NoTypeInformation -Encoding UTF8

} Else {
    Write-Warning "wmic not responding"
    $empty_line | Out-String
    Write-Verbose "Please consider restarting the PowerShell session." -verbose
    $empty_line | Out-String
} # Else




# Method 3                                                                                    # Credit: Microsoft TechNet: "How to List All of the Windows and Software Updates Applied to a Computer"
# Retrieve the installed Windows updates with Microsoft Update Client Install History         # Credit: ScriptingGuy1: "How Can I Tell Which Service Packs Have Been Installed on a Computer?"
# Source: https://answers.microsoft.com/en-us/windows/forum/windowsrt8_1-windows_update/why-is-there-a-daily-update-for-english-input/83352bfe-86df-4a3b-9886-24c1a9401b78?page=3&msgId=53a108e7-7fef-47e2-87e5-78588d9090ca
# Source: http://superuser.com/questions/1002015/why-are-get-hotfix-and-wmic-qfe-list-in-powershell-missing-installed-updates
# Source: https://msdn.microsoft.com/en-us/library/windows/desktop/aa387282(v=vs.85).aspx
# Source: https://msdn.microsoft.com/en-us/library/windows/desktop/aa386400(v=vs.85).aspx
Write-Verbose "Invoking the third method (Microsoft Update Client)..."
$session = New-Object -ComObject Microsoft.Update.Session
$searcher = $session.CreateUpdateSearcher()
$number_of_history_events = $searcher.GetTotalHistoryCount()


        # Exit if no Windows updates are found                                                # Credit: Stephane van Gulick: "Get-WindowsUpdates"
        If (($number_of_history_events -eq $null) -or ($number_of_history_events -eq 0)) {
            Write-Warning "No updates found."
            $empty_line | Out-String
            Exit
        } Else {
            $continue = $true
        } # Else


# Retrieve the installed (and uninstalled) Windows updates
# To list only the installed Windows updates or to query for a specific installed HotFix, please try something along the lines of
<#
        $searcher.Search("IsInstalled=1").Updates | fl *
        $searcher.Search("IsInstalled=1").Updates | Where-Object { $_.Title -like "*KB12345678*" } | fl *
#>
$install_history = $searcher.QueryHistory(0, $number_of_history_events)

        ForEach ($kb_related_event in $install_history) {

                $raw_event_date_value = "$($kb_related_event.Date)"
                $raw_date = $raw_event_date_value.Split(" ")[0]
                $raw_time = $raw_event_date_value.Split(" ")[1]
                $month_event = ($raw_date).Split("/")[0]
                $day_event = ($raw_date).Split("/")[1]
                $year_event = ($raw_date).Split("/")[2]
                $date_event = (Get-Date -Day $day_event -Month $month_event -Year $year_event)
                $category = $kb_related_event.Categories | Select-Object -ExpandProperty Name
                $uninst_step_count = $kb_related_event | Select-Object -ExpandProperty UninstallationSteps | Select-Object -ExpandProperty Count
                    If ($uninst_step_count -eq 0) {
                        $uninstallation = $uninst_step_count
                    } Else {
                        $uninstallation = ($kb_related_event | Select-Object -ExpandProperty UninstallationSteps | Select-Object -ExpandProperty _NewEnum)
                    } # If ($uninst_step_count)


                # Add a HotFixID (KB-value) to the data
                #   \S      Any nonwhitespace character (excludes space, tab and carriage return).
                #   \d      Any decimal digit.
                # Source: http://powershellcookbook.com/recipe/qAxK/appendix-b-regular-expression-reference
                # Credit: Stephane van Gulick: "Get-WindowsUpdates": https://gallery.technet.microsoft.com/Get-WindowsUpdates-06eb7f43
                # Credit: Anna Wang: "Cannot index into a null array": https://social.technet.microsoft.com/Forums/en-US/99581c8b-4814-4419-8f4b-34f9cfca802b/cannot-index-into-a-null-array?forum=winserverpowershell
                If ($kb_related_event.Title -match "KB\d*") {

                            $hotfix_id = $Matches[0]
                            If ($hotfix_id.ToLower().Contains("KB".ToLower())) {
                                $number = [int]$hotfix_id.ToLower().Replace("kb","")
                            } Else {
                                $continue = $true
                            } # Else

                } Else {
                    $continue = $true
                } # Else

                            $all_windows_updates += $obj_event = New-Object -TypeName PSCustomObject -Property @{

                                'HotFixID'                  = $hotfix_id
                                'Operation'                 = If ( $kb_related_event.Operation -eq 1 ) { "Installation" } ElseIf ( $kb_related_event.Operation -eq 2 ) { "Uninstallation" } Else { $continue = $true }
                                'Result'                    = $result_code[[int]$kb_related_event.ResultCode]
                                'HResult'                   = $kb_related_event.HResult
                                'Unmapped ResultCode'       = $kb_related_event.UnmappedResultCode
                                'Install Date'              = $date_event.ToShortDateString()
                                'Installed On'              = Get-Date $date_event -Format yyyyMMdd
                                'Timestamp'                 = $kb_related_event.Date
                                'Day'                       = $date_event.Day
                                'Month'                     = $date_event.Month
                                'Year'                      = $date_event.Year
                                'Time'                      = (Get-Date $raw_time).ToShortTimeString()
                                'Weekday'                   = $date_event.DayOfWeek
                                'Age (Days)'                = ($timestamp_today - $date_event).Days
                                'Title'                     = $kb_related_event.Title
                                'Description'               = $kb_related_event.Description
                                'Operation Code'            = $kb_related_event.Operation
                                'Result Code'               = $kb_related_event.ResultCode
                                'Server Selection Code'     = $kb_related_event.ServerSelection
                                'ClientApplication ID'      = $kb_related_event.ClientApplicationID
                                'Server Selection'          = $server_selection[[int]$kb_related_event.ServerSelection]
                                'ServiceID'                 = $kb_related_event.ServiceID
                                'UpdateID'                  = $kb_related_event.UpdateIdentity | Select-Object -ExpandProperty UpdateID
                                'RevisionNumber'            = $kb_related_event.UpdateIdentity | Select-Object -ExpandProperty RevisionNumber
                                'Uninstallation Steps'      = $uninstallation
                                'Uninstallation Notes'      = $kb_related_event.UninstallationNotes
                                'Support URL'               = $kb_related_event.SupportUrl
                                'Custom URL'                = [string]'http://support.microsoft.com/?kbid=' + $number
                                'Category'                  = $category
                                'Number'                    = $number
                            } # New-Object

        } # ForEach $kb_related_event


# Display the installed Windows updates in a pop-up window
$all_windows_updates.PSObject.TypeNames.Insert(0,"Windows Updates")
$windows_updates_selection = $all_windows_updates | Select-Object 'HotFixID','Operation','Result','HResult','Unmapped ResultCode','Install Date','Installed On','Timestamp','Day','Month','Year','Time','Weekday','Age (Days)','Title','Description','Operation Code','Result Code','Server Selection Code','ClientApplication ID','Server Selection','ServiceID','UpdateID','RevisionNumber','Uninstallation Steps','Uninstallation Notes','Support URL','Custom URL','Category','Number'
$windows_updates_sorted_selection = $windows_updates_selection | Sort 'Number','Age (Days)'
$windows_updates_sorted_selection | Out-GridView


# Write the installed Windows updates to a CSV-file
$windows_updates_sorted_selection | Export-Csv "$path\installed_windows_updates.csv" -Delimiter ";" -NoTypeInformation -Encoding UTF8




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



# Open the Installed Windows Updates location
# Source: http://winaero.com/blog/the-most-comprehensive-list-of-shell-locations-in-windows-8/
Start-Process explorer.exe "shell:::{d450a8a1-9568-45c7-9c0e-b4f9fb4537bd}"


# Write the installed Windows updates to a HTML-file
$windows_updates_sorted_selection | ConvertTo-Html | Out-File -FilePath $path\installed_windows_updates.html


# Open the installed Windows updates HTML-file in the default browser.
Invoke-Item "$path\installed_windows_updates.html"


# Open the installed Windows updates CSV-file
Invoke-Item -Path $path\installed_windows_updates.csv


$stamp = Get-Date -UFormat "%Y%m%d"
installed_windows_updates_$stamp.html                                                         # an alternative filename format
$time = Get-Date -Format g                                                                    # a "general short" time-format (short date and short time)


   _____
  / ____|
 | (___   ___  _   _ _ __ ___ ___
  \___ \ / _ \| | | | '__/ __/ _ \
  ____) | (_) | |_| | | | (_|  __/
 |_____/ \___/ \__,_|_|  \___\___|


http://social.technet.microsoft.com/wiki/contents/articles/4197.how-to-list-all-of-the-windows-and-software-updates-applied-to-a-computer.aspx          # Microsoft TechNet: "How to List All of the Windows and Software Updates Applied to a Computer"
https://blogs.technet.microsoft.com/heyscriptingguy/2004/09/29/how-can-i-tell-which-service-packs-have-been-installed-on-a-computer/                    # ScriptingGuy1: "How Can I Tell Which Service Packs Have Been Installed on a Computer?"
https://gallery.technet.microsoft.com/Get-WindowsUpdates-06eb7f43                                                                                       # Stephane van Gulick: "Get-WindowsUpdates"
https://social.technet.microsoft.com/Forums/en-US/99581c8b-4814-4419-8f4b-34f9cfca802b/cannot-index-into-a-null-array?forum=winserverpowershell         # Anna Wang: "Cannot index into a null array"


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
Retrieves a list of all installed Windows updates on a local machine.

.DESCRIPTION
Get-InstalledWindowsUpdates uses Windows Management Instrumentation (WMI) (with
a command "Get-WmiObject -Class Win32_QuickFixEngineering") to retrieve a list of
some HotFixIDs installed on a local machine and displays the results in console
(Method 1). The Windows Management Instrumentation Command-Line Utility (WMIC.exe
with the query path of win32_quickfixengineering) is then used to write a secondary
CSV-file (partial_hotfix_list.csv) to $path (Method 2) - this secondary CSV-file
(populated by WMIC.exe) contains about the same partial results as which were
obtained by using the previous query (Method 1).

Finally, Get-InstalledWindowsUpdates uses Windows Update Agent (WUA) API (Method 3)
to retrieve a third - comprehensive - list of all the installed and uninstalled
Windows updates, and displays those results in a pop-up window and writes them to
a CSV-file (installed_windows_updates.csv). This script is based on Stéphane
van Gulick's PowerShell function "Get-WindowsUpdates"
(https://gallery.technet.microsoft.com/Get-WindowsUpdates-06eb7f43).

.OUTPUTS
Displays a partial list of installed HotFixIDs in console and a list of all
installed Windows updates in a pop-up window "$windows_updates_sorted_selection"
(Out-GridView).


        Name                                Description
        ----                                -----------
        $windows_updates_sorted_selection   Displays a list of installed Windows updates


And also two CSV-files at $path


$env:temp\partial_hotfix_list.csv            : CSV-file     : partial_hotfix_list.csv
$env:temp\installed_windows_updates.csv      : CSV-file     : installed_windows_updates.csv

.NOTES
Please note that the files are created in a directory, which is specified with the
$path variable (at line 7). The $env:temp variable points to the current temp
folder. The default value of the $env:temp variable is
C:\Users\<username>\AppData\Local\Temp (i.e. each user account has their own
separate temp folder at path %USERPROFILE%\AppData\Local\Temp). To see the current
temp path, for instance a command

    [System.IO.Path]::GetTempPath()

may be used at the PowerShell prompt window [PS>]. To change the temp folder for instance
to C:\Temp, please, for example, follow the instructions at
http://www.eightforums.com/tutorials/23500-temporary-files-folder-change-location-windows.html

    Homepage:           https://github.com/auberginehill/get-installed-windows-updates
    Short URL:          http://tinyurl.com/gtcktwy
    Version:            1.3

.EXAMPLE
./Get-InstalledWindowsUpdates
Runs the script. Please notice to insert ./ or .\ before the script name.

.EXAMPLE
help ./Get-InstalledWindowsUpdates -Full
Displays the help file.

.EXAMPLE
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine
This command is altering the Windows PowerShell rights to enable script execution
in the default (LocalMachine) scope, and defines the conditions under which Windows
PowerShell loads configuration files and runs scripts in general. In Windows Vista
and later versions of Windows, for running commands that change the execution policy
of the LocalMachine scope, Windows PowerShell has to be run with elevated rights
(Run as Administrator). The default policy of the default (LocalMachine) scope is
"Restricted", and a command "Set-ExecutionPolicy Restricted" will "undo" the changes
made with the original example above (had the policy not been changed before...).
Execution policies for the local computer (LocalMachine) and for the current user
(CurrentUser) are stored in the registry (at for instance the
HKLM:\Software\Policies\Microsoft\Windows\PowerShell\ExecutionPolicy key), and remain
effective until they are changed again. The execution policy for a particular session
(Process) is stored only in memory, and is discarded when the session is closed.


    Parameters:

    Restricted      Does not load configuration files or run scripts, but permits
                    individual commands. Restricted is the default execution policy.

    AllSigned       Scripts can run. Requires that all scripts and configuration
                    files be signed by a trusted publisher, including the scripts
                    that have been written on the local computer. Risks running
                    signed, but malicious, scripts.

    RemoteSigned    Requires a digital signature from a trusted publisher on scripts
                    and configuration files that are downloaded from the Internet
                    (including e-mail and instant messaging programs). Does not
                    require digital signatures on scripts that have been written on
                    the local computer. Permits running unsigned scripts that are
                    downloaded from the Internet, if the scripts are unblocked by
                    using the Unblock-File cmdlet. Risks running unsigned scripts
                    from sources other than the Internet and signed, but malicious,
                    scripts.

    Unrestricted    Loads all configuration files and runs all scripts.
                    Warns the user before running scripts and configuration files
                    that are downloaded from the Internet. Not only risks, but
                    actually permits, eventually, running any unsigned scripts from
                    any source. Risks running malicious scripts.

    Bypass          Nothing is blocked and there are no warnings or prompts.
                    Not only risks, but actually permits running any unsigned scripts
                    from any source. Risks running malicious scripts.

    Undefined       Removes the currently assigned execution policy from the current
                    scope. If the execution policy in all scopes is set to Undefined,
                    the effective execution policy is Restricted, which is the
                    default execution policy. This parameter will not alter or
                    remove the ("master") execution policy that is set with a Group
                    Policy setting.
    __________
    Notes: 	      - Please note that the Group Policy setting "Turn on Script Execution"
                    overrides the execution policies set in Windows PowerShell in all
                    scopes. To find this ("master") setting, please, for example, open
                    the Local Group Policy Editor (gpedit.msc) and navigate to
                    Computer Configuration > Administrative Templates >
                    Windows Components > Windows PowerShell.

                  - The Local Group Policy Editor (gpedit.msc) is not available in any
                    Home or Starter editions of Windows.

                  - Group Policy setting "Turn on Script Execution":

               	    Not configured                                          : No effect, the default
                                                                               value of this setting
                    Disabled                                                : Restricted
                    Enabled - Allow only signed scripts                     : AllSigned
                    Enabled - Allow local scripts and remote signed scripts : RemoteSigned
                    Enabled - Allow all scripts                             : Unrestricted


For more information, please type "Get-ExecutionPolicy -List", "help Set-ExecutionPolicy -Full",
"help about_Execution_Policies" or visit https://technet.microsoft.com/en-us/library/hh849812.aspx
or http://go.microsoft.com/fwlink/?LinkID=135170.

.EXAMPLE
New-Item -ItemType File -Path C:\Temp\Get-InstalledWindowsUpdates.ps1
Creates an empty ps1-file to the C:\Temp directory. The New-Item cmdlet has an inherent
-NoClobber mode built into it, so that the procedure will halt, if overwriting (replacing
the contents) of an existing file is about to happen. Overwriting a file with the New-Item
cmdlet requires using the Force. If the path name and/or the filename includes space
characters, please enclose the whole -Path parameter value in quotation marks (single or
double):

    New-Item -ItemType File -Path "C:\Folder Name\Get-InstalledWindowsUpdates.ps1"

For more information, please type "help New-Item -Full".

.LINK
http://social.technet.microsoft.com/wiki/contents/articles/4197.how-to-list-all-of-the-windows-and-software-updates-applied-to-a-computer.aspx
https://blogs.technet.microsoft.com/heyscriptingguy/2004/09/29/how-can-i-tell-which-service-packs-have-been-installed-on-a-computer/
https://gallery.technet.microsoft.com/Get-WindowsUpdates-06eb7f43
https://social.technet.microsoft.com/Forums/en-US/99581c8b-4814-4419-8f4b-34f9cfca802b/cannot-index-into-a-null-array?forum=winserverpowershell         # Anna Wang: "Cannot index into a null array"
https://gallery.technet.microsoft.com/ScriptCenter/d86cd93b-2428-40a1-a430-26bd3caed36f/
http://blog.powershell.no/2010/06/25/manage-windows-update-installations-using-windows-powershell/
http://blog.crayon.no/blogs/janegil/archive/2010/06/25/manage_2D00_windows_2D00_update_2D00_installations_2D00_using_2D00_windows_2D00_powershell.aspx
https://blogs.technet.microsoft.com/jamesone/2009/01/27/managing-windows-update-with-powershell/
http://powershellcookbook.com/recipe/qAxK/appendix-b-regular-expression-reference
http://www.ehow.com/how_8724332_use-powershell-run-windows-updates.html
https://msdn.microsoft.com/en-us/library/aa387287(v=VS.85).aspx
https://msdn.microsoft.com/en-us/library/windows/desktop/aa387095(v=vs.85).aspx
https://msdn.microsoft.com/en-us/library/windows/desktop/aa387280(v=vs.85).aspx
https://msdn.microsoft.com/en-us/library/windows/desktop/aa387282(v=vs.85).aspx
https://msdn.microsoft.com/en-us/library/windows/desktop/aa386400(v=vs.85).aspx
https://technet.microsoft.com/en-us/library/ee692804.aspx
https://technet.microsoft.com/en-us/library/ee835740.aspx
http://superuser.com/questions/1002015/why-are-get-hotfix-and-wmic-qfe-list-in-powershell-missing-installed-updates
https://answers.microsoft.com/en-us/windows/forum/windowsrt8_1-windows_update/why-is-there-a-daily-update-for-english-input/83352bfe-86df-4a3b-9886-24c1a9401b78?page=3&msgId=53a108e7-7fef-47e2-87e5-78588d9090ca

#>
