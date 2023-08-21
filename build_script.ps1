## Automated PLC build and publish script
## Dependencies: 
##  - Visual Studio 2019
##  - TwinCAT XAE

# instantiate DTE object - this is the Visual Studio automation COM library
$dte = new-object -com 'VisualStudio.DTE'
# suppress VS interface
$dte.SuppressUI = $true

# paths
$slnPath = "$pwd"
$buildPath = "$pwd\_Boot\TwinCAT RT (x64)"
$tcRunPath = "C:\TwinCAT\3.1\Boot"

# open solution file
$sln = $dte.Solution
$sln.Open("$slnPath\TwinCAT Project.sln")

#### build options ###

# get base TwinCAT project
#$systemProject = $sln.Projects.Item(1)

# set build configuration
#$buildConfig = "Release|TwinCAT RT (x64)"

# build specific project
#$sln.SolutionBuild.BuildProject($buildConfig, $systemProject.FullName, $true)

# build entire solution
$sln.SolutionBuild.Build($true)

# close VS
$dte.Quit();

# package up build files
Compress-Archive -Path "$buildPath\*" -DestinationPath "$slnPath\buildOutput.zip" -Update

# extract to (local) PLC runtime dir
#Expand-Archive -Path "$slnPath\buildOutput.zip" -DestinationPath $tcRunPath