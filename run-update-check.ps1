if (-Not (Test-Path .\MODPACK_VERSION.txt)) {
  # Back up current Valheim install
  New-Item ../Valheim-old/ -ItemType Directory -ea 0
  Copy-Item * ../Valheim-old/ -Force -Recurse

  # Download and install modpack
  Invoke-WebRequest https://github.com/nixfanboy/valheim-modpack/archive/refs/heads/master.zip -OutFile modpack.zip
  Expand-Archive modpack.zip -DestinationPath .
  Remove-Item modpack.zip
  Move-Item valheim-modpack-master\* . -Force
  Remove-Item valheim-modpack-master -Recurse -Force

  # Launch Game
  .\valheim.exe
} else {
  #Check if Remote Version matches Local Version
  Invoke-WebRequest https://raw.githubusercontent.com/nixfanboy/valheim-modpack/master/MODPACK_VERSION.txt -OutFile version_check.txt -Headers @{"Cache-Control"="no-cache"}
  $remote_version = (Get-Content version_check.txt -First 1)
  $local_version = (Get-Content MODPACK_VERSION.txt -First 1)

  # Update modpack
  if($remote_version -ne $local_version) {
    Remove-Item BepInEx -Recurse -Force
    Remove-Item doorstop_libs -Recurse -Force
    Remove-Item changelog.txt -Force
    Remove-Item doorstop_config.ini -Force
    Remove-Item MODPACK_VERSION.txt -Force
    Remove-Item winhttp.dll -Force

    Invoke-WebRequest https://github.com/nixfanboy/valheim-modpack/archive/refs/heads/master.zip -OutFile modpack.zip
    Expand-Archive modpack.zip -DestinationPath .
	Remove-Item modpack.zip
    Move-Item valheim-modpack-master\* . -Force
    Remove-Item valheim-modpack-master -Recurse -Force
  }
  
  Remove-Item version_check.txt -Force
  
  # Launch Game
  .\valheim.exe
}