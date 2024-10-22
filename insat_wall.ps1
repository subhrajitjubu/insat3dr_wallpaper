# Get the current UTC time
$currentUtcTime = Get-Date -AsUTC
$currentUtcTime = $currentUtcTime.AddHours(-1)

#https://satellite.imd.gov.in/ImageArchive/3RIMG/2024/OCT/3RIMG_21OCT2024_1315_L1C_ASIA_MER_IR1_V01R00.jpg

# Determine the nearest quarter (15 or 45)
if ($currentUtcTime.Minute -lt 30) {
    $nearestQuarter = 15
} else {
    $nearestQuarter = 45
}

# Set the seconds and milliseconds to zero
$nearestQuarterTime = $currentUtcTime.Date.AddHours($currentUtcTime.Hour).AddMinutes($nearestQuarter).AddSeconds(0)

# Print the nearest quarter-hour UTC time
Write-Output "Nearest 15 or 45 Minute UTC Time: $($nearestQuarterTime.ToString('yyyy-MM-dd HH:mm:ss'))"

# Subtract one hour
$oneHourBeforeUtcTime = $currentUtcTime.AddHours(-1)

# Format the datetime for the URL and filename
$formattedDate = $oneHourBeforeUtcTime.ToString('ddMMMyyyy').ToUpper()  
$formattedTime = $nearestQuarterTime.ToString('HHmm')  # e.g., 1315






# Construct the URL using the formatted date and time
$imageUrl = "https://satellite.imd.gov.in/ImageArchive/3RIMG/2024/OCT/3RIMG_$($formattedDate)_$($formattedTime)_L1C_ASIA_MER_IR1_V01R00.jpg"
# Define the output file name using the formatted datetime
$outputFileName = "Image_insat.jpg"

# Download the image
Invoke-WebRequest -Uri $imageUrl -OutFile $outputFileName

# Print a message indicating the download is complete
Write-Output "Downloaded image as: $imageUrl"


$path = (Get-Item $outputFileName).FullName
Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;
public class Wallpaper {
    [DllImport("user32.dll", CharSet = CharSet.Auto)]
    public static extern int SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
}
"@
# Constants for setting wallpaper
$SPI_SETDESKWALLPAPER = 20
$SPIF_UPDATEINIFILE = 0x01
$SPIF_SENDCHANGE = 0x02

# Set the wallpaper
[Wallpaper]::SystemParametersInfo($SPI_SETDESKWALLPAPER, 0, $path, $SPIF_UPDATEINIFILE -bor $SPIF_SENDCHANGE)

# Print a message indicating the wallpaper has been set
Write-Output "Desktop background set to: $path"
