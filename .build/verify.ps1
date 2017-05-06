if($PSCommandPath -eq $null) {
	$CommandRootPath = (Split-Path -Parent $MyInvocation.MyCommand.Path);
} else {
	$CommandRootPath = (Split-Path -Parent $PSCommandPath);
}

."$CommandRootPath\arduino.ps1";

if ($Execute -eq $true -or $Execute -eq $null) {
	Invoke-Verify -ProjectFile (Join-Path -Path $CommandRootPath -ChildPath "../Marlin_I3/Marlin_I3.ino")
	# run
}
