#comments-start

check if symantec is there
if not there, check the cpu
install

#comments-end

#include <MsgBoxConstants.au3>
#include <FileConstants.au3>
#include <AutoItConstants.au3>
;#RequireAdmin
$pathToUpdatedSymantec ="C:\Program Files (x86)\Symantec\Symantec Endpoint Protection\smc.exe"

;if file does not exist A.K.A Symantec is not installed
if( FileExists($pathToUpdatedSymantec)=0)Then
	 MsgBox($MB_OK, "Symantec Status", "Symantec is already installed")


	;create a temp directory
	$result0=DirCreate(@ProgramFilesDir&"temp")
	MsgBox($MB_OK, "result for dircreate",$result0)

	;specify the beginning names of the path
   $symatecDir="\\softwareServ\SEP\Client Installation Packages"
   $chosenFile="SEP GPO - "

   ;check the CPU to determine which file to install
   $computerCPU=@CPUArch


   if($computerCPU="X64") Then;install 64bit version, 64bit check first because of higher probability
	  $symatecDir=$symatecDir&"\SEP GPO - 64bit Light Install.exe"
	  ;	  $symatecDir=$symatecDir&"\SEP GPO - 32bit Light Install.exe";switch back to $symatecInstallFile after testing

	  $chosenFile=$chosenFile&"64bit Light Install.exe"
	MsgBox($MB_OK, "result for cpu",$chosenFile)

   ElseIf($computerCPU="X32") Then
   $symatecDir=$symatecDir&"\SEP GPO - 32bit Light Install.exe"
   $chosenFile=$chosenFile&"32bit Light Install.exe"
   	MsgBox($MB_OK, "result for cpu",$chosenFile)

   EndIf

   	  $userName="UserName"
	  $password="Pass"
	  $result=FileCopy ($symatecDir, @ProgramFilesDir&"temp")
	  MsgBox($MB_OK, "result for filecopy",$result)
	  $workingDir=@ProgramFilesDir&"temp\"&$chosenFile
	  $result2=RunAs($userName, @ComputerName, $password,0,$workingDir)

	  
	;Automate
	  WinWaitActive("Symantec Setup")
	  WinActive("Symantec Setup")
	  ControlClick("Symantec Setup","Next","[CLASS:TNewButton; INSTANCE:1]")
	  ;WinActive("Symantec Setup")
	  ControlClick("Symantec Setup","I &accept the agreement","[CLASS:TNewRadioButton; INSTANCE:1]")
	  ControlClick("Symantec Setup","Next","[CLASS:TNewButton; INSTANCE:2]")
	  ControlClick("Symantec Setup","Next","[CLASS:TNewButton; INSTANCE:3]")
  	  ControlClick("Symantec Setup","Install","[CLASS:TNewButton; INSTANCE:3]")

	  $result4=DirRemove(@ProgramFilesDir&"temp")
	  MsgBox($MB_OK, @ProgramFilesDir&"temp",$result4)

	  ;Force a Reboot
	  ;Shutdown(6)

EndIf


;additions/update symantec script
;check the IP to see which store it belongs to
;get the latest version for that location
; check the version of symantec that computer has
;if not updated, update


#comments-start MEMORY CHECK
There was a machine for which I couldn't install the fix because its memory was too low. Therefore I decided to write a memory check.
The problem I saw was that there was a differnetial of about 7gb from Computer and the result of the DriveSpaceFree function.
This number is likely to be different for every computer, thus it is unreliable. Also, Windows does a memory check when copying
over a file or running it. This portion would've saved some time but since most machines have enough memory, I decided to leave it out."

MEMORY CHECK
;Check if there is sufficient memory on the computer

   if(DriveSpaceFree("C:\")<10000)
   MsgBox($MB_OK, "ERROR", "There is not a suffucient amount of memory on this computer.")
   Exit
#comments-end
