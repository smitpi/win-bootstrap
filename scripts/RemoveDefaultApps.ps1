#--- Uninstall unnecessary applications that come with Windows out of the box ---
Write-Host 'Uninstall some applications that come with Windows out of the box' -ForegroundColor 'Yellow'

#Referenced to build script
# https://docs.microsoft.com/en-us/windows/application-management/remove-provisioned-apps-during-update
# https://github.com/jayharris/dotfiles-windows/blob/master/windows.ps1#L157
# https://gist.github.com/jessfraz/7c319b046daa101a4aaef937a20ff41f
# https://gist.github.com/alirobe/7f3b34ad89a159e6daa1
# https://github.com/W4RH4WK/Debloat-Windows-10/blob/master/scripts/remove-default-apps.ps1

function removeApp {
	Param ([string]$appName)
	Write-Host "`t[Removing]: " -NoNewline -ForegroundColor Yellow; Write-Host "$($appName)" -ForegroundColor Cyan
	try {
		Get-AppxPackage $appName -AllUsers | Remove-AppxPackage
	} catch {Write-Warning "Error Uninstalling $($appName)"}

	try {
		Get-AppxProvisionedPackage -Online | Where-Object DisplayName -Like $appName | Remove-AppxProvisionedPackage -Online
	} catch {Write-Warning "Error Uninstalling $($appName)"}

}

$applicationList = @(
	'Microsoft.BingFinance'
	'Microsoft.3DBuilder'
	'Microsoft.BingNews'
	'Microsoft.BingSports'
	'Microsoft.BingWeather'
	'Microsoft.CommsPhone'
	'Microsoft.Getstarted'
	'Microsoft.WindowsMaps'
	'*MarchofEmpires*'
	'Microsoft.GetHelp'
	'Microsoft.Messaging'
	'*Minecraft*'
	'Microsoft.MicrosoftOfficeHub'
	'Microsoft.OneConnect'
	'Microsoft.WindowsPhone'
	'Microsoft.WindowsSoundRecorder'
	'*Solitaire*'
	'Microsoft.MicrosoftStickyNotes'
	'Microsoft.Office.Sway'
	'Microsoft.XboxApp'
	'Microsoft.XboxIdentityProvider'
	'Microsoft.ZuneMusic'
	'Microsoft.ZuneVideo'
	'Microsoft.NetworkSpeedTest'
	'Microsoft.FreshPaint'
	'Microsoft.Print3D'
	'*Autodesk*'
	'*BubbleWitch*'
	'king.com*'
	'G5*'
	'*Dell*'
	'*Facebook*'
	'*Keeper*'
	'*Netflix*'
	'*Twitter*'
	'*Plex*'
	'*.Duolingo-LearnLanguagesforFree'
	'*.EclipseManager'
	'ActiproSoftwareLLC.562882FEEB491' # Code Writer
	'*.AdobePhotoshopExpress'
);

$applicationList2 = @(
	# default Windows 10 apps
	'Microsoft.549981C3F5F10' #Cortana
	'Microsoft.3DBuilder'
	'Microsoft.Appconnector'
	'Microsoft.BingFinance'
	'Microsoft.BingNews'
	'Microsoft.BingSports'
	'Microsoft.BingTranslator'
	'Microsoft.BingWeather'
	#"Microsoft.FreshPaint"
	'Microsoft.GamingServices'
	'Microsoft.MicrosoftOfficeHub'
	'Microsoft.MicrosoftPowerBIForWindows'
	'Microsoft.MicrosoftSolitaireCollection'
	#"Microsoft.MicrosoftStickyNotes"
	'Microsoft.MinecraftUWP'
	'Microsoft.NetworkSpeedTest'
	'Microsoft.Office.OneNote'
	'Microsoft.People'
	'Microsoft.Print3D'
	'Microsoft.SkypeApp'
	'Microsoft.Wallet'
	#"Microsoft.Windows.Photos"
	'Microsoft.WindowsAlarms'
	#"Microsoft.WindowsCalculator"
	'Microsoft.WindowsCamera'
	'microsoft.windowscommunicationsapps'
	'Microsoft.WindowsMaps'
	'Microsoft.WindowsPhone'
	'Microsoft.WindowsSoundRecorder'
	#"Microsoft.WindowsStore"   # can't be re-installed
	'Microsoft.Xbox.TCUI'
	'Microsoft.XboxApp'
	'Microsoft.XboxGameOverlay'
	'Microsoft.XboxSpeechToTextOverlay'
	'Microsoft.YourPhone'
	'Microsoft.ZuneMusic'
	'Microsoft.ZuneVideo'

	# Threshold 2 apps
	'Microsoft.CommsPhone'
	'Microsoft.ConnectivityStore'
	'Microsoft.GetHelp'
	'Microsoft.Getstarted'
	'Microsoft.Messaging'
	'Microsoft.Office.Sway'
	'Microsoft.OneConnect'
	'Microsoft.WindowsFeedbackHub'

	# Creators Update apps
	'Microsoft.Microsoft3DViewer'
	#"Microsoft.MSPaint"

	#Redstone apps
	'Microsoft.BingFoodAndDrink'
	'Microsoft.BingHealthAndFitness'
	'Microsoft.BingTravel'
	'Microsoft.WindowsReadingList'

	# Redstone 5 apps
	'Microsoft.MixedReality.Portal'
	'Microsoft.ScreenSketch'
	'Microsoft.XboxGamingOverlay'

	# non-Microsoft
	'2FE3CB00.PicsArt-PhotoStudio'
	'46928bounde.EclipseManager'
	'4DF9E0F8.Netflix'
	'613EBCEA.PolarrPhotoEditorAcademicEdition'
	'6Wunderkinder.Wunderlist'
	'7EE7776C.LinkedInforWindows'
	'89006A2E.AutodeskSketchBook'
	'9E2F88E3.Twitter'
	'A278AB0D.DisneyMagicKingdoms'
	'A278AB0D.MarchofEmpires'
	'ActiproSoftwareLLC.562882FEEB491' # next one is for the Code Writer from Actipro Software LLC
	'ClearChannelRadioDigital.iHeartRadio'
	'D52A8D61.FarmVille2CountryEscape'
	'D5EA27B7.Duolingo-LearnLanguagesforFree'
	'DB6EA5DB.CyberLinkMediaSuiteEssentials'
	'DolbyLaboratories.DolbyAccess'
	'DolbyLaboratories.DolbyAccess'
	'Drawboard.DrawboardPDF'
	'Facebook.Facebook'
	'Fitbit.FitbitCoach'
	'Flipboard.Flipboard'
	'GAMELOFTSA.Asphalt8Airborne'
	'KeeperSecurityInc.Keeper'
	'NORDCURRENT.COOKINGFEVER'
	'PandoraMediaInc.29680B314EFC2'
	'Playtika.CaesarsSlotsFreeCasino'
	'ShazamEntertainmentLtd.Shazam'
	'SlingTVLLC.SlingTV'
	'SpotifyAB.SpotifyMusic'
	#"TheNewYorkTimes.NYTCrossword"
	'ThumbmunkeysLtd.PhototasticCollage'
	'TuneIn.TuneInRadio'
	'WinZipComputing.WinZipUniversal'
	'XINGAG.XING'
	'flaregamesGmbH.RoyalRevolt2'
	'king.com.*'
	'king.com.BubbleWitch3Saga'
	'king.com.CandyCrushSaga'
	'king.com.CandyCrushSodaSaga'

	# apps which cannot be removed using Remove-AppxPackage
	#"Microsoft.BioEnrollment"
	#"Microsoft.MicrosoftEdge"
	#"Microsoft.Windows.Cortana"
	#"Microsoft.WindowsFeedback"
	#"Microsoft.XboxGameCallableUI"
	#"Microsoft.XboxIdentityProvider"
	#"Windows.ContactSupport"

	# apps which other apps depend on
	'Microsoft.Advertising.Xaml'
)
      
Write-Host "`n-----------------------------------" -ForegroundColor DarkCyan; Write-Host '[Uninstall]: ' -NoNewline -ForegroundColor Yellow; Write-Host 'Windows Default Apps' -ForegroundColor Cyan

foreach ($app in $applicationList2) {
	removeApp $app
}

New-Item -Path C:\Temp\Chocolatey\Bootstrap\RemoveDefaultApps.tmp -ItemType file -Force | Out-Null