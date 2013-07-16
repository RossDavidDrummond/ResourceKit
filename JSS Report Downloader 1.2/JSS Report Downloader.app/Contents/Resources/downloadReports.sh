#!/bin/sh

# User Vars
downloadPath=''
createDatedSubfolders=''
reportIDs=( '' )
reportNames=( '' )
reportTypes=( '' )
JSSAddress=''
JSSUsername=''
JSSPassword=''
sessionFile='/private/tmp/jssSession.txt'

# System Vars
# Get the current time
myTime=`date "+%Y-%m-%d_%H-%M-%S"`
curl="/usr/bin/curl -L -k -b $sessionFile -c $sessionFile --connect-timeout 10000"



# Script Contents
# DO NOT EDIT BELOW THIS LINE
# Make a directory with the current date/time
if [ "$createDatedSubfolders" == "true" ]; then
	# Create a subfolder based on the current date/time
	/bin/mkdir "$downloadPath/$myTime"
fi
	
# Initialize the session
if [ -f $sessionFile ]; then
	/bin/rm $sessionFile
fi
$curl "https://$JSSAddress:8443/searchComputers.html" -d "username=$JSSUsername&password=$JSSPassword" -o /dev/null

# We are hitting various logs pages just in case our custom reports call logs...
$curl "https://$JSSAddress:8443/vncLogs.html" -o /dev/null
$curl "https://$JSSAddress:8443/usageLogs.html" -o /dev/null
$curl "https://$JSSAddress:8443/casperRemoteLogs.html" -o /dev/null


# Determine if reports will be placed in subfolders or straight into the root download path
if [ "$createDatedSubfolders" == "true" ]; then
	# Loop through and download all reports from the array into a dated subfolder
	for (( i = 0 ; i < ${#reportIDs[@]} ; i++ ))
	do
		myID="${reportIDs[$i]}"
		myReportName="${reportNames[$i]}"
		myReportType="${reportTypes[$i]}"
		case $myReportType in
			"Standard Web Page")
			echo "Downloading Standard Web Page report: $myReportName..."
			$curl "https://$JSSAddress:8443/savedComputerSearch.html?searchID=$myID" > "${downloadPath[0]}/$myTime/${reportNames[$i]}.html";;
			*PDF*)
			echo "Downloading PDF report: $myReportName..."
			$curl "https://$JSSAddress:8443/savedComputerSearch.html?searchID=$myID" > "${downloadPath[0]}/$myTime/${reportNames[$i]}.pdf";;
			*CSV*)
			echo "Downloading CSV report: $myReportName..."
			$curl "https://$JSSAddress:8443/savedComputerSearch.html?searchID=$myID" > "${downloadPath[0]}/$myTime/${reportNames[$i]}.csv";;
			*TAB*)
			echo "Downloading Tab Delimited report: $myReportName..."
			$curl "https://$JSSAddress:8443/savedComputerSearch.html?searchID=$myID" > "${downloadPath[0]}/$myTime/${reportNames[$i]}.txt";;
			*XML*)
			echo "Downloading XML report: $myReportName..."
			$curl "https:/$JSSAddress:8443/savedComputerSearch.html?searchID=$myID" > "${downloadPath[0]}/$myTime/${reportNames[$i]}.xml";;
			*)
			echo "Downloading Custom report: $myReportName..."
			$curl "https://$JSSAddress:8443/savedComputerSearch.html?searchID=$myID" > "${downloadPath[0]}/$myTime/${reportNames[$i]}.html";;
		esac
	done
else
	# Loop through and download all reports from the array into the root download path
	for (( i = 0 ; i < ${#reportIDs[@]} ; i++ ))
	do
		myID="${reportIDs[$i]}"
		myReportName="${reportNames[$i]}"
		myReportType="${reportTypes[$i]}"
		case $myReportType in
			"Standard Web Page")
			echo "Downloading Standard Web Page report: $myReportName..."
			$curl "https://$JSSAddress:8443/savedComputerSearch.html?searchID=$myID" > "${downloadPath[0]}/${reportNames[$i]}_$myTime.html";;
			*PDF*)
			echo "Downloading PDF report: $myReportName..."
			$curl "https://$JSSAddress:8443/savedComputerSearch.html?searchID=$myID" > "${downloadPath[0]}/${reportNames[$i]}_$myTime.pdf";;
			*CSV*)
			echo "Downloading CSV report: $myReportName..."
			$curl "https://$JSSAddress:8443/savedComputerSearch.html?searchID=$myID" > "${downloadPath[0]}/${reportNames[$i]}_$myTime.csv";;
			*TAB*)
			echo "Downloading Tab Delimited report: $myReportName..."
			$curl "https://$JSSAddress:8443/savedComputerSearch.html?searchID=$myID" > "${downloadPath[0]}/${reportNames[$i]}_$myTime.txt";;
			*XML*)
			echo "Downloading XML report: $myReportName..."
			$curl "https:/$JSSAddress:8443/savedComputerSearch.html?searchID=$myID" > "${downloadPath[0]}/${reportNames[$i]}_$myTime.xml";;
			*)
			echo "Downloading Custom report: $myReportName..."
			$curl "https://$JSSAddress:8443/savedComputerSearch.html?searchID=$myID" > "${downloadPath[0]}/${reportNames[$i]}_$myTime.html";;
		esac
	done
fi

# Remove the session file
/bin/rm $sessionFile