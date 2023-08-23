## Automated IO builder
## Dependencies: 
##  - Visual Studio 2019
##  - TwinCAT XAE

# instantiate DTE object - this is the Visual Studio automation COM library
$dte = new-object -com "VisualStudio.DTE"
# suppress VS interface
$dte.SuppressUI = $false
$dte.MainWindow.Visible = $true

# paths
$slnPath = "$pwd\.."
$buildPath = "$pwd\..\_Boot\TwinCAT RT (x64)"

# open solution file
$sln = $dte.Solution
echo "Opening solution in VS (background)..."
$sln.Open("$slnPath\TwinCAT Project.sln")
$project = $sln.Projects.Item(1)
$systemManager = $project.Object

# get devices config
$devices = $systemManager.LookupTreeItem("TIID")

# import IO configuration from XTI file
$devices.ImportChild("$slnPath\Device 1 (EtherCAT).xti", "", $true, "Device 1 (EtherCAT)")

# wait for input (keep VS open)
read-host "Press Enter to continue"

# quit
$dte.Quit()