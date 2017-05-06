

if($PSCommandPath -eq $null) {
	$CommandRootPath = (Split-Path -Parent $MyInvocation.MyCommand.Path);
} else {
	$CommandRootPath = (Split-Path -Parent $PSCommandPath);
}

$config = ."$CommandRootPath\config.ps1";

function Invoke-Verify {
  param (
		[Parameter(Mandatory)]
		[ValidateScript({ Test-Path -Path $_ -PathType 'Leaf' })]
		[String] $ProjectFile,
		[String] $Board = "arduino:avr:mega:cpu=atmega2560",
		[String] $Port = $null
	)
  begin {
		$xargs = [System.Collections.ArrayList]@();
		if($Board) {
			$xargs.Add("--board $Board") | Out-Null;
		}
		if($Port) {
			$xargs.Add("--port $Port") | Out-Null;
		}
  }
  process {
		return Invoke-Arduino -Arguments @("--verify", "--board $Board", "--verbose", "$ProjectFile");
  }
}


function Invoke-Arduino {
	param (
		#[ValidateSet("verify", "upload", "get-pref", "install-boards", "install-library")]
		#[String] $Action,
		[String[]] $Arguments
	)
	process {
		Invoke-ExternalCommand -Command (Join-Path -Path $config.ArduinoPath -ChildPath "arduino.exe") -Arguments $Arguments | Write-Host;
		return $LASTEXITCODE;
	}
}



function Invoke-ExternalCommand {
  param (
    [Parameter(Mandatory)]
    [string] $Command,
    [string[]] $Arguments = @()
  )
  begin {
    $mergedCommand = "$Command $($Arguments -join " ")";
		$mergedCommand | Write-Host;
  }
  process {
    $result = Invoke-Expression "(& $mergedCommand *>&1)";
		return $result;
  }
}
