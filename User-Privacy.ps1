##########

Set-WindowsSearchSetting -EnableWebResultsSetting $false

# We do not accept Microsoft's Privacy Policy
If (-Not (Test-Path "HKCU:\SOFTWARE\Microsoft\Personalization\Settings")) {
        New-Item -Force -Path "HKCU:\SOFTWARE\Microsoft\Personalization\Settings" | Out-Null
}
New-ItemProperty -Force -Path HKCU:\SOFTWARE\Microsoft\Personalization\Settings -Name AcceptedPrivacyPolicy -Type DWord -Value 0
# Start Menu: Disable Bing Search Results
If (-Not (Test-Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search")) {
        New-Item -Force -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" | Out-Null
}
New-ItemProperty -Force -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search -Name BingSearchEnabled -Type DWord -Value 0
# Do not collect Contact information
If (-Not (Test-Path "HKCU:\SOFTWARE\Microsoft\InputPersonalization\TrainedDataStore")) {
        New-Item -Force -Path "HKCU:\SOFTWARE\Microsoft\InputPersonalization\TrainedDataStore" | Out-Null
}
New-ItemProperty -Force -Path HKCU:\SOFTWARE\Microsoft\InputPersonalization\TrainedDataStore -Name HarvestContacts -Type DWord -Value 0
# Do not collect writing and text input data
If (-Not (Test-Path "HKCU:\SOFTWARE\Microsoft\InputPersonalization")) {
        New-Item -Force -Path "HKCU:\SOFTWARE\Microsoft\InputPersonalization" | Out-Null
}
New-ItemProperty -Force -Path HKCU:\SOFTWARE\Microsoft\InputPersonalization -Name RestrictImplicitInkCollection -Type DWord -Value 1
New-ItemProperty -Force -Path HKCU:\SOFTWARE\Microsoft\InputPersonalization -Name RestrictImplicitTextCollection -Type DWord -Value 1
If (-Not (Test-Path "HKCU:\SOFTWARE\Microsoft\Input\TIPC")) {
	New-Item -Force -Path "HKCU:\SOFTWARE\Microsoft\Input\TIPC" | Out-Null
}
New-ItemProperty -Force -Path HKCU:\SOFTWARE\Microsoft\Input\TIPC -Name Enabled -Type DWord -Value 0

# Disable location sensor
#New-ItemProperty -Force -Path "HKCU:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor\Permissions\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}" -Name SensorPermissionState -Type DWord -Value 0

# Disable collection of language data from the environment via the browser
If (-Not (Test-Path "HKCU:\Control Panel\International\User Profile")) {
        New-Item -Force -Path "HKCU:\Control Panel\International\User Profile" | Out-Null
}
New-ItemProperty -Force -Path "HKCU:\Control Panel\International\User Profile" -Name HttpAcceptLanguageOptOut -Type DWord -Value 1

If (-Not (Test-Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppHost")) {
        New-Item -Force -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppHost" | Out-Null
}
New-ItemProperty -Force -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppHost -Name EnableWebContentEvaluation -Type DWord -Value 0

# Deny Device Access
If (-Not (Test-Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\LooselyCoupled")) {
        New-Item -Force -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\LooselyCoupled" | Out-Null
}
New-ItemProperty -Force -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\LooselyCoupled -Name Type -Value LooselyCoupled
New-ItemProperty -Force -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\LooselyCoupled -Name Value -Value Deny
New-ItemProperty -Force -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\LooselyCoupled -Name InitialAppValue -Value Unspecified

foreach ($key in (ls "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global")) {
    if ($key.PSChildName -EQ "LooselyCoupled") {
        continue
    }
    Set-ItemProperty -Path ("HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\" + $key.PSChildName) -Name "Type" -Value "InterfaceClass"
    Set-ItemProperty -Path ("HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\" + $key.PSChildName) -Name "Value" -Value "Deny"
    Set-ItemProperty -Path ("HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\" + $key.PSChildName) -Name "InitialAppValue" -Value "Unspecified"
}

##########

If (-Not (Test-Path "HKCU:\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge")) {
        New-Item -Force -Path "HKCU:\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge" | Out-Null
}
$Edge = "HKCU:\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge"

# 1 adds the Do Not Track Header, 0 does not
New-ItemProperty -Force -Path "$Edge\Main" -Name DoNotTrack -Value 1

# 0 disables search suggestions, 1 does not
If (-Not (Test-Path "$Edge\User\Default\SearchScopes")) {
	New-Item -Force -Path "$Edge\User\Default\SearchScopes" | Out-Null
}
New-ItemProperty -Force -Path "$Edge\User\Default\SearchScopes" -Name ShowSearchSuggestionsGlobal -Value 0

# 0 disables PagePrediction, 1 enables them
New-ItemProperty -Force -Path "$Edge\FlipAhead" -Name FPEnabled -Value 0

# 0 disables PhishingFilter, 1 enables it
New-ItemProperty -Force -Path "$Edge\PhishingFilter" -Name EnabledV9 -Value 0

New-ItemProperty -Force -Path "$Edge\Main" -Name "FormSuggest Passwords" -Value no
New-ItemProperty -Force -Path "$Edge\Main" -Name "Use FormSuggest" -Value no

##########

## Explorer customizations
# Disable Quick Access: Recent Files
New-ItemProperty -Force -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer -Name ShowRecent -Type DWord -Value 0
# Disable Quick Access: Frequent Folders
New-ItemProperty -Force -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer -Name ShowFrequent -Type DWord -Value 0
# Change Explorer home screen back to This PC
New-ItemProperty -Force -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name LaunchTo -Type DWord -Value 1

New-ItemProperty -Force -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name Hidden -Type DWord -Value 1
New-ItemProperty -Force -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name HideFileExt -Type DWord -Value 0

# Don't show recent/frequent items in quick access
New-ItemProperty -Force -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer -Name ShowRecent -Type DWord -Value 0
New-ItemProperty -Force -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer -Name ShowFrequent -Type DWord -Value 0
