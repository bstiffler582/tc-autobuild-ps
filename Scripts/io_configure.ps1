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

# add EtherCAT Master
$ethercatMaster = $devices.CreateChild("Device 1 (EtherCAT)", 111, $null, $null)

# add EtherCAT bus coupler
$ek1100 = $ethercatMaster.CreateChild("Rack 1 (EK1100)", 9099, "", "EK1100")

# add IO terminal(s)
#$ek1100 = $systemManager.LookupTreeItem("TIID^Device 1 (EtherCAT)^EK1100")
$ek1100.CreateChild("Slot 1 (EL1008)", 9099, $null, "EL1008")

# link PLC variable to IO channel
for ($i = 0; $i -lt 8; $i++)
{
    # path to PLC variable
    $source = "TIPC^PLC^PLC Instance^PlcTask Inputs^IO.R1_S1_EL1008[$i]"
    # path to IO channel
    $destination = "TIID^Device 1 (EtherCAT)^Rack 1 (EK1100)^Slot 1 (EL1008)^Channel $($i + 1)^Input"
    # link
    $systemManager.LinkVariables($source, $destination)
}

# wait for input (keep VS open)
read-host "Press Enter to continue"

# quit
$dte.Quit()