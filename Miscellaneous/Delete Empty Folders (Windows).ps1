$path = "D:\" #Set your desired path here
Get-ChildItem -Path $path -Recurse -Directory | Where-Object {$_.GetFiles().Count -eq 0 -and $_.GetDirectories().Count -eq 0} | Remove-Item -Force
