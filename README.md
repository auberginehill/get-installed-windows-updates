<!-- Visual Studio Code: For a more comfortable reading experience, use the key combination Ctrl + Shift + V
     Visual Studio Code: To crop the tailing end space characters out, please use the key combination Ctrl + A Ctrl + K Ctrl + X (Formerly Ctrl + Shift + X)
     Visual Studio Code: To improve the formatting of HTML code, press Shift + Alt + F and the selected area will be reformatted in a html file.
     Visual Studio Code shortcuts: http://code.visualstudio.com/docs/customization/keybindings (or https://aka.ms/vscodekeybindings)
     Visual Studio Code shortcut PDF (Windows): https://code.visualstudio.com/shortcuts/keyboard-shortcuts-windows.pdf


   _____      _        _____           _        _ _          ___          ___           _                   _    _           _       _
  / ____|    | |      |_   _|         | |      | | |        | \ \        / (_)         | |                 | |  | |         | |     | |
 | |  __  ___| |_ ______| |  _ __  ___| |_ __ _| | | ___  __| |\ \  /\  / / _ _ __   __| | _____      _____| |  | |_ __   __| | __ _| |_ ___  ___
 | | |_ |/ _ \ __|______| | | '_ \/ __| __/ _` | | |/ _ \/ _` | \ \/  \/ / | | '_ \ / _` |/ _ \ \ /\ / / __| |  | | '_ \ / _` |/ _` | __/ _ \/ __|
 | |__| |  __/ |_      _| |_| | | \__ \ || (_| | | |  __/ (_| |  \  /\  /  | | | | | (_| | (_) \ V  V /\__ \ |__| | |_) | (_| | (_| | ||  __/\__ \
  \_____|\___|\__|    |_____|_| |_|___/\__\__,_|_|_|\___|\__,_|   \/  \/   |_|_| |_|\__,_|\___/ \_/\_/ |___/\____/| .__/ \__,_|\__,_|\__\___||___/
                                                                                                                  | |
                                                                                                                  |_|                                     -->


## Get-InstalledWindowsUpdates.ps1

<table>
   <tr>
      <td style="padding:6px"><strong>OS:</strong></td>
      <td style="padding:6px">Windows</td>
   </tr>
   <tr>
      <td style="padding:6px"><strong>Type:</strong></td>
      <td style="padding:6px">A Windows PowerShell script</td>
   </tr>
   <tr>
      <td style="padding:6px"><strong>Language:</strong></td>
      <td style="padding:6px">Windows PowerShell</td>
   </tr>
   <tr>
      <td style="padding:6px"><strong>Description:</strong></td>
      <td style="padding:6px">Get-InstalledWindowsUpdates uses Windows Management Instrumentation (WMI) to retrieve a list of some HotFixIDs installed on the computer and displays the results in console (Method 1). A secondary CSV-file (<code>partial_hotfix_list.csv</code>), which contains the output of the Windows Management Instrumentation Command-Line Utility (<code>WMIC.exe</code>) with the query path of <code>win32_quickfixengineering</code> (which gives about the same partial results as the "<code>Get-WmiObject -Class Win32_QuickFixEngineering</code>" command used previously in Method 1), is written to <code>$path</code> (Method 2).
      <br />
      <br />Get-InstalledWindowsUpdates also uses Windows Update Agent (WUA) API (Method 3) to retrieve a third – comprehensive – list of all the installed and uninstalled Windows updates and displays those results in a pop-up window and writes them to a CSV-file (<code>installed_windows_updates.csv</code>). This script is based on Stéphane van Gulick's PowerShell function "<a href="https://gallery.technet.microsoft.com/Get-WindowsUpdates-06eb7f43">Get-WindowsUpdates</a>".</td>
   </tr>
   <tr>
      <td style="padding:6px"><strong>Homepage:</strong></td>
      <td style="padding:6px"><a href="https://github.com/auberginehill/get-installed-windows-updates">https://github.com/auberginehill/get-installed-windows-updates</a>
      <br />Short URL: <a href="http://tinyurl.com/gtcktwy">http://tinyurl.com/gtcktwy</a></td>
   </tr>
   <tr>
      <td style="padding:6px"><strong>Version:</strong></td>
      <td style="padding:6px">1.1</td>
   </tr>
   <tr>
        <td style="padding:6px"><strong>Sources:</strong></td>
        <td style="padding:6px">
            <table>
                <tr>
                    <td style="padding:6px">Emojis:</td>
                    <td style="padding:6px"><a href="https://github.com/auberginehill/emoji-table">Emoji Table</a></td>
                </tr>
                <tr>
                    <td style="padding:6px">Microsoft TechNet:</td>
                    <td style="padding:6px"><a href="http://social.technet.microsoft.com/wiki/contents/articles/4197.how-to-list-all-of-the-windows-and-software-updates-applied-to-a-computer.aspx">How to List All of the Windows and Software Updates Applied to a Computer</a></td>
                </tr>
                <tr>
                    <td style="padding:6px">ScriptingGuy1:</td>
                    <td style="padding:6px"><a href="https://blogs.technet.microsoft.com/heyscriptingguy/2004/09/29/how-can-i-tell-which-service-packs-have-been-installed-on-a-computer/">How Can I Tell Which Service Packs Have Been Installed on a Computer?</a></td>
                </tr>
                </tr>
                    <td style="padding:6px">Stéphane van Gulick:</td>
                    <td style="padding:6px"><a href="https://gallery.technet.microsoft.com/Get-WindowsUpdates-06eb7f43">Get-WindowsUpdates</a></td>
                <tr>
                </tr>
            </table>
        </td>
   </tr>
   <tr>
      <td style="padding:6px"><strong>Downloads:</strong></td>
      <td style="padding:6px">For instance <a href="https://raw.githubusercontent.com/auberginehill/get-installed-windows-updates/master/Get-InstalledWindowsUpdates.ps1">Get-InstalledWindowsUpdates.ps1</a>. Or <a href="https://github.com/auberginehill/get-installed-windows-updates/archive/master.zip">everything as a .zip-file</a>.</td>
   </tr>
</table>




### Screenshot

<img class="screenshot" title="screenshot" alt="screenshot" height="100%" width="100%" src="https://raw.githubusercontent.com/auberginehill/get-installed-windows-updates/master/Get-InstalledWindowsUpdates.png">




### Outputs

<table>
    <tr>
        <th>:arrow_right:</th>
        <td style="padding:6px">
            <ul>
                <li>Displays a partial list of installed HotFixIDs in console and a list of all installed Windows updates in a pop-up window "<code>$windows_updates_sorted_selection</code>" (<code>Out-GridView</code>).</li>
            </ul>
        </td>
    </tr>
    <tr>
        <th></th>
        <td style="padding:6px">
            <ul>
                <p>
                    <li>A pop-up window (<code>Out-GridView</code>):</li>
                </p>
                <ol>
                    <p>
                        <table>
                            <tr>
                                <td style="padding:6px"><strong>Name</strong></td>
                                <td style="padding:6px"><strong>Description</strong></td>
                            </tr>
                            <tr>
                                <td style="padding:6px"><code>$windows_updates_sorted_selection</code></td>
                                <td style="padding:6px">Displays a list of installed Windows updates</td>
                            </tr>
                        </table>
                    </p>
                </ol>
                <p>
                    <li>And also two CSV-files at <code>$path</code>.</li>
                </p>
                <ol>
                    <p>
                        <table>
                            <tr>
                                <td style="padding:6px"><strong>Path</strong></td>
                                <td style="padding:6px"><strong>Type</strong></td>
                                <td style="padding:6px"><strong>Name</strong></td>
                            </tr>
                            <tr>
                                <td style="padding:6px"><code>$env:temp\partial_hotfix_list.csv</code></td>
                                <td style="padding:6px">CSV-file</td>
                                <td style="padding:6px"><code>partial_hotfix_list.csv</code></td>
                            </tr>
                            <tr>
                                <td style="padding:6px"><code>$env:temp\installed_windows_updates.csv</code></td>
                                <td style="padding:6px">CSV-file</td>
                                <td style="padding:6px"><code>installed_windows_updates.csv</code></td>
                            </tr>
                        </table>
                    </p>
                </ol>
            </ul>
        </td>
    </tr>
</table>




### Notes

<table>
    <tr>
        <th>:warning:</th>
        <td style="padding:6px">
            <ul>
                <li>Please note that the files are created in a directory, which is specified with the <code>$path</code> variable (at line 7).</li>
            </ul>
        </td>
    </tr>
    <tr>
        <th></th>
        <td style="padding:6px">
            <ul>
                <p>
                    <li>The <code>$env:temp</code> variable points to the current temp folder. The default value of the <code>$env:temp</code> variable is <code>C:\Users\&lt;username&gt;\AppData\Local\Temp</code> (i.e. each user account has their own separate temp folder at path <code>%USERPROFILE%\AppData\Local\Temp</code>). To see the current temp path, for instance a command
                    <br />
                    <br /><code>[System.IO.Path]::GetTempPath()</code>
                    <br />
                    <br />may be used at the PowerShell prompt window <code>[PS>]</code>. To change the temp folder for instance to <code>C:\Temp</code>, please, for example, follow the instructions at <a href="http://www.eightforums.com/tutorials/23500-temporary-files-folder-change-location-windows.html">Temporary Files Folder - Change Location in Windows</a>, which in essence are something along the lines:
                        <ol>
                           <li>Right click on Computer and click on Properties (or select Start → Control Panel → System). In the resulting window with the basic information about the computer...</li>
                           <li>Click on Advanced system settings on the left panel and select Advanced tab on the resulting pop-up window.</li>
                           <li>Click on the button near the bottom labeled Environment Variables.</li>
                           <li>In the topmost section labeled User variables both TMP and TEMP may be seen. Each different login account is assigned its own temporary locations. These values can be changed by double clicking a value or by highlighting a value and selecting Edit. The specified path will be used by Windows and many other programs for temporary files. It's advisable to set the same value (a directory path) for both TMP and TEMP.</li>
                           <li>Any running programs need to be restarted for the new values to take effect. In fact, probably also Windows itself needs to be restarted for it to begin using the new values for its own temporary files.</li>
                        </ol>
                    </li>
                </p>
            </ul>
        </td>
    </tr>
</table>





### Examples

<table>
    <tr>
        <th>:book:</th>
        <td style="padding:6px">To open this code in Windows PowerShell, for instance:</td>
   </tr>
   <tr>
        <th></th>
        <td style="padding:6px">
            <ol>
                <p>
                    <li><code>./Get-InstalledWindowsUpdates</code><br />
                    Run the script. Please notice to insert <code>./</code> or <code>.\</code> before the script name.</li>
                </p>
                <p>
                    <li><code>help ./Get-InstalledWindowsUpdates -Full</code><br />
                    Display the help file.</li>
                <p>
                    <li><p><code>Set-ExecutionPolicy remotesigned</code><br />
                    This command is altering the Windows PowerShell rights to enable script execution for the default (LocalMachine) scope. Windows PowerShell has to be run with elevated rights (run as an administrator) to actually be able to change the script execution properties. The default value of the default (LocalMachine) scope is "<code>Set-ExecutionPolicy restricted</code>".</p>
                        <p>Parameters:
                                <ol>
                                    <table>
                                        <tr>
                                            <td style="padding:6px"><code>Restricted</code></td>
                                            <td style="padding:6px">Does not load configuration files or run scripts. Restricted is the default execution policy.</td>
                                        </tr>
                                        <tr>
                                            <td style="padding:6px"><code>AllSigned</code></td>
                                            <td style="padding:6px">Requires that all scripts and configuration files be signed by a trusted publisher, including scripts that you write on the local computer.</td>
                                        </tr>
                                        <tr>
                                            <td style="padding:6px"><code>RemoteSigned</code></td>
                                            <td style="padding:6px">Requires that all scripts and configuration files downloaded from the Internet be signed by a trusted publisher.</td>
                                        </tr>
                                        <tr>
                                            <td style="padding:6px"><code>Unrestricted</code></td>
                                            <td style="padding:6px">Loads all configuration files and runs all scripts. If you run an unsigned script that was downloaded from the Internet, you are prompted for permission before it runs.</td>
                                        </tr>
                                        <tr>
                                            <td style="padding:6px"><code>Bypass</code></td>
                                            <td style="padding:6px">Nothing is blocked and there are no warnings or prompts.</td>
                                        </tr>
                                        <tr>
                                            <td style="padding:6px"><code>Undefined</code></td>
                                            <td style="padding:6px">Removes the currently assigned execution policy from the current scope. This parameter will not remove an execution policy that is set in a Group Policy scope.</td>
                                        </tr>
                                    </table>
                                </ol>
                        </p>
                    <p>For more information, please type "<code>Get-ExecutionPolicy -List</code>", "<code>help Set-ExecutionPolicy -Full</code>", "<code>help about_Execution_Policies</code>" or visit <a href="https://technet.microsoft.com/en-us/library/hh849812.aspx">Set-ExecutionPolicy</a> or <a href="http://go.microsoft.com/fwlink/?LinkID=135170.">about_Execution_Policies</a>.</p>
                    </li>
                </p>
                <p>
                    <li><code>New-Item -ItemType File -Path C:\Temp\Get-InstalledWindowsUpdates.ps1</code><br />
                    Creates an empty ps1-file to the <code>C:\Temp</code> directory. The <code>New-Item</code> cmdlet has an inherent <code>-NoClobber</code> mode built into it, so that the procedure will halt, if overwriting (replacing the contents) of an existing file is about to happen. Overwriting a file with the <code>New-Item</code> cmdlet requires using the <code>Force</code>. If the path name includes space characters, please enclose the path name in quotation marks (single or double):
                        <ol>
                            <br /><code>New-Item -ItemType File -Path "C:\Folder Name\Get-InstalledWindowsUpdates.ps1"</code>
                        </ol>
                    <br />For more information, please type "<code>help New-Item -Full</code>".</li>
                </p>
            </ol>
        </td>
    </tr>
</table>




### Contributing

<p>Find a bug? Have a feature request? Here is how you can contribute to this project:</p>

 <table>
   <tr>
      <th><img class="emoji" title="contributing" alt="contributing" height="28" width="28" align="absmiddle" src="https://assets-cdn.github.com/images/icons/emoji/unicode/1f33f.png"></th>
      <td style="padding:6px"><strong>Bugs:</strong></td>
      <td style="padding:6px"><a href="https://github.com/auberginehill/get-installed-windows-updates/issues">Submit bugs</a> and help us verify fixes.</td>
   </tr>
   <tr>
      <th rowspan="2"></th>
      <td style="padding:6px"><strong>Feature Requests:</strong></td>
      <td style="padding:6px">Feature request can be submitted by <a href="https://github.com/auberginehill/get-installed-windows-updates/issues">creating an Issue</a>.</td>
   </tr>
   <tr>
      <td style="padding:6px"><strong>Edit Source Files:</strong></td>
      <td style="padding:6px"><a href="https://github.com/auberginehill/get-installed-windows-updates/pulls">Submit pull requests</a> for bug fixes and features and discuss existing proposals.</td>
   </tr>
 </table>




### www

<table>
    <tr>
        <th><img class="emoji" title="www" alt="www" height="28" width="28" align="absmiddle" src="https://assets-cdn.github.com/images/icons/emoji/unicode/1f310.png"></th>
        <td style="padding:6px"><a href="https://github.com/auberginehill/get-installed-windows-updates">Script Homepage</a></td>
    </tr>
    <tr>
        <th rowspan="18"></th>
        <td style="padding:6px">Microsoft TechNet: <a href="http://social.technet.microsoft.com/wiki/contents/articles/4197.how-to-list-all-of-the-windows-and-software-updates-applied-to-a-computer.aspx">How to List All of the Windows and Software Updates Applied to a Computer</a></td>
    </tr>
    <tr>
        <td style="padding:6px">ScriptingGuy1: <a href="https://blogs.technet.microsoft.com/heyscriptingguy/2004/09/29/how-can-i-tell-which-service-packs-have-been-installed-on-a-computer/">How Can I Tell Which Service Packs Have Been Installed on a Computer?</a></td>
    </tr>
    <tr>
        <td style="padding:6px">Stéphane van Gulick: <a href="https://gallery.technet.microsoft.com/Get-WindowsUpdates-06eb7f43">Get-WindowsUpdates</a></td>
    </tr>
    <tr>
        <td style="padding:6px">Jan Egil Ring: <a href="https://gallery.technet.microsoft.com/ScriptCenter/d86cd93b-2428-40a1-a430-26bd3caed36f/">Invoke-WindowsUpdate</a></td>
    </tr>
    <tr>
        <td style="padding:6px"><a href="http://blog.powershell.no/2010/06/25/manage-windows-update-installations-using-windows-powershell/">Manage Windows Update installations using Windows PowerShell</a></td>
    </tr>
    <tr>
        <td style="padding:6px"><a href="http://blog.crayon.no/blogs/janegil/archive/2010/06/25/manage_2D00_windows_2D00_update_2D00_installations_2D00_using_2D00_windows_2D00_powershell.aspx">Manage Windows Update installations using Windows PowerShell</a></td>
    </tr>
    <tr>
        <td style="padding:6px"><a href="https://blogs.technet.microsoft.com/jamesone/2009/01/27/managing-windows-update-with-powershell/">Managing Windows Update with PowerShell</a></td>
    </tr>
    <tr>
        <td style="padding:6px"><a href="http://www.ehow.com/how_8724332_use-powershell-run-windows-updates.html">How to Use PowerShell to Run Windows Updates</a></td>
    </tr>
    <tr>
        <td style="padding:6px"><a href="https://msdn.microsoft.com/en-us/library/aa387287(v=VS.85).aspx">Using the Windows Update Agent API</a></td>
    </tr>
    <tr>
        <td style="padding:6px"><a href="https://msdn.microsoft.com/en-us/library/windows/desktop/aa387095(v=vs.85).aspx">OperationResultCode enumeration</a></td>
    </tr>
    <tr>
        <td style="padding:6px"><a href="https://msdn.microsoft.com/en-us/library/windows/desktop/aa387280(v=vs.85).aspx">ServerSelection enumeration</a></td>
    </tr>
    <tr>
        <td style="padding:6px"><a href="https://msdn.microsoft.com/en-us/library/windows/desktop/aa387282(v=vs.85).aspx">UpdateOperation enumeration</a></td>
    </tr>
    <tr>
        <td style="padding:6px"><a href="https://msdn.microsoft.com/en-us/library/windows/desktop/aa386400(v=vs.85).aspx">IUpdateHistoryEntry interface</a></td>
    </tr>
    <tr>
        <td style="padding:6px"><a href="https://technet.microsoft.com/en-us/library/ee692804.aspx">The String's the Thing</a></td>
    </tr>
    <tr>
        <td style="padding:6px"><a href="https://technet.microsoft.com/en-us/library/ee835740.aspx">Dig Deep into your system with Dedicated System Information Tools in Windows 7</a></td>
    </tr>
    <tr>
        <td style="padding:6px"><a href="http://superuser.com/questions/1002015/why-are-get-hotfix-and-wmic-qfe-list-in-powershell-missing-installed-updates">Why are "get-hotfix" and "wmic qfe list" in Powershell missing installed updates?</a></td>
    </tr>
    <tr>
        <td style="padding:6px"><a href="https://answers.microsoft.com/en-us/windows/forum/windowsrt8_1-windows_update/why-is-there-a-daily-update-for-english-input/83352bfe-86df-4a3b-9886-24c1a9401b78?page=3&msgId=53a108e7-7fef-47e2-87e5-78588d9090ca">Why is there a DAILY update for English Input Personalization Dictionary</a></td>
    </tr>
    <tr>
        <td style="padding:6px">ASCII Art: <a href="http://www.figlet.org/">http://www.figlet.org/</a> and <a href="http://www.network-science.de/ascii/">ASCII Art Text Generator</a></td>
    </tr>
</table>




### Related scripts

 <table>
    <tr>
        <th><img class="emoji" title="www" alt="www" height="28" width="28" align="absmiddle" src="https://assets-cdn.github.com/images/icons/emoji/unicode/0023-20e3.png"></th>
        <td style="padding:6px"><a href="https://github.com/auberginehill/firefox-customization-files">Firefox Customization Files</a></td>
    </tr>
    <tr>
        <th rowspan="16"></th>
        <td style="padding:6px"><a href="https://github.com/auberginehill/get-ascii-table">Get-AsciiTable</a></td>
    </tr>
    <tr>
        <td style="padding:6px"><a href="https://github.com/auberginehill/get-battery-info">Get-BatteryInfo</a></td>
    </tr>
    <tr>
        <td style="padding:6px"><a href="https://github.com/auberginehill/get-computer-info">Get-ComputerInfo</a></td>
    </tr>
    <tr>
        <td style="padding:6px"><a href="https://github.com/auberginehill/get-culture-tables">Get-CultureTables</a></td>
    </tr>
    <tr>
        <td style="padding:6px"><a href="https://github.com/auberginehill/get-directory-size">Get-DirectorySize</a></td>
    </tr>
    <tr>
        <td style="padding:6px"><a href="https://github.com/auberginehill/get-installed-programs">Get-InstalledPrograms</a></td>
    </tr>
    <tr>
        <td style="padding:6px"><a href="https://github.com/auberginehill/get-ram-info">Get-RAMInfo</a></td>
    </tr>
    <tr>
        <td style="padding:6px"><a href="https://gist.github.com/auberginehill/eb07d0c781c09ea868123bf519374ee8">Get-TimeDifference</a></td>
    </tr>
    <tr>
        <td style="padding:6px"><a href="https://github.com/auberginehill/get-time-zone-table">Get-TimeZoneTable</a></td>
    </tr>
    <tr>
        <td style="padding:6px"><a href="https://github.com/auberginehill/get-unused-drive-letters">Get-UnusedDriveLetters</a></td>
    </tr>
    <tr>
        <td style="padding:6px"><a href="https://github.com/auberginehill/emoji-table">Emoji Table</a></td>
    </tr>
    <tr>
        <td style="padding:6px"><a href="https://github.com/auberginehill/java-update">Java-Update</a></td>
    </tr>
    <tr>
        <td style="padding:6px"><a href="https://github.com/auberginehill/rock-paper-scissors">Rock-Paper-Scissors</a></td>
    </tr>
    <tr>
        <td style="padding:6px"><a href="https://github.com/auberginehill/toss-a-coin">Toss-a-Coin</a></td>
    </tr>
    <tr>
        <td style="padding:6px"><a href="https://github.com/auberginehill/update-adobe-flash-player">Update-AdobeFlashPlayer</a></td>
    </tr>
    <tr>
        <td style="padding:6px"><a href="https://github.com/auberginehill/update-mozilla-firefox">Update-MozillaFirefox</a></td>
    </tr>
</table>
