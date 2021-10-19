#!/bin/bash
# utilitymenu.sh - A sample shell script to display menus on screen
# Store menu options selected by the user
cd akash-wallet-handler
docker build -t akash .
. variables
INPUT=/tmp/menu.sh.$$

# Storage file for displaying cal and date command output
OUTPUT=/tmp/output.sh.$$

# get text editor or fall back to vi_editor
vi_editor=${EDITOR-vi}

# trap and delete temp files
trap "rm $OUTPUT; rm $INPUT; exit" SIGHUP SIGINT SIGTERM

#
# Purpose - display output using msgbox 
#  $1 -> set msgbox height
#  $2 -> set msgbox width
#  $3 -> set msgbox title
#
function display_output(){
	local h=${1-10}			# box height default 10
	local w=${2-41} 		# box width default 41
	local t=${3-Output} 	# box title 
	dialog --backtitle "Akash Wallet Handler" --title "${t}" --clear --msgbox "$(<$OUTPUT)" ${h} ${w}
}
#
# Purpose - display current system date & time
#
function show_date(){
	echo "Today is $(date) @ $(hostname -f)." >$OUTPUT
    display_output 6 60 "Date and Time"
}
#
# set infinite loop
#
while true
do

if docker ps | grep -q akash
then
    STATUS="Running"
else
    STATUS="Not running"
	if [[ -d data && -f variables ]]; then
echo "Houston we have a problem!, Akash needs to be started"
read -p "Start Akash now? (y/n)? " choice
case "$choice" in
  y|Y ) echo "yes" ; docker run -itd --env-file=variables --rm --name akash -v $(pwd)/data:/root/.akash akash ; echo "Akash now started!" ; STATUS="Running";;
  n|N ) echo "no" ; echo "Data and variables exist, must run Akash to use this wallet." ; sleep 5 ; exit;;
  * ) echo "invalid" ; return;;
esac

	fi

fi

BALANCE=$(docker exec -it akash /bin/bash -c 'akash query bank balances --node $AKASH_NODE $AKASH_ACCOUNT_ADDRESS' | grep amount)
NETWORK=$(docker exec -it akash /bin/bash -c 'akash status' | jq -r .NodeInfo.network)

if [[ -d data && -f variables ]]; then
echo "Locked data and variables"
SETUP_MODE=0
dialog --clear  --help-button --backtitle "Akash" \
--title "[ A K A S H - W A L L E T - H A N D L E R ]" \
--menu "Akash Status : $STATUS \n\
Akash Connections : $AKASH_NODE \n\
Akash $BALANCE \n\
Akash Network $NETWORK \n\
\n\
You can use the UP/DOWN arrow keys, the first \n\
letter of the choice as a hot key, or the \n\
number keys 1-9 to choose an option.\n\
Choose the TASK" 25 50 7 \
Setup "First time setup and wallet creation" \
Show "Show wallet address" \
Check "Check wallet balance" \
Node "Run full-node" \
Export "Export private keys" \
Run "Run command against CLI" \
Exit "Exit to the shell" 2>"${INPUT}"
menuitem=$(<"${INPUT}")
else
SETUP_MODE=1
dialog --clear  --help-button --backtitle "Akash" \
--title "[ M A I N - M E N U ]" \
--menu "Akash must be setup for the first time" 15 50 4 \
Setup "First time setup and wallet creation" \
Exit "Exit to the shell" 2>"${INPUT}"
menuitem=$(<"${INPUT}")
fi


#USE #return to break out of loops

### display main menu ###

function sayhello(){
	local n=${@-"anonymous person"}
	#display it
	dialog --title "Hello" --clear --msgbox "Hello ${n}, let us be friends!" 10 41
}


function pass() {
        pass=$(dialog --inputbox "Password for existing wallet $AKASH_KEY_NAME?" 0 0  --output-fd 1)

if [ -z $pass ]; then
echo "Password cannot be blank. Please retry in 5 seconds."
sleep 5
pass
elif (( $(echo $pass | wc -c) <= 8 )); then
echo "Password cannot be less than 8 characters. Please retry in 5 seconds."
sleep 5
pass
else
export pass
return
fi
}


function reset() { 
if [ -d "data" ]
then
read -p "Destructive action! Continue (y/n)? " choice
case "$choice" in
  y|Y ) echo "yes" ; sudo rm -rf data ; echo "Data directory wiped, you can now continue with setup.";;
  n|N ) echo "no";;
  * ) echo "invalid";;
esac
fi
}

function run_command(){
        command=$(dialog --inputbox "Command to run - example : help" 0 0  --output-fd 1)
export command
}
function run_another(){
read -p "Run another command? Continue (y/n)? " choice
case "$choice" in
  y|Y ) echo "yes" ; run_command;;
  n|N ) echo "no"; return;;
  * ) echo "invalid"; return;;
esac
}

function input_password() {

if [ -d "data" ]
then
    echo "Data Directory exists. Cannot continue with initial setup.  Please backup and delete data folder at $(pwd)/data to continue."
sleep 10
return
fi
        pass=$(dialog --inputbox "Password for new wallet?" 0 0  --output-fd 1)


if [ -z $pass ]; then
echo "Password cannot be blank. Please retry in 5 seconds."
sleep 5
input_password
elif (( $(echo $pass | wc -c) <= 8 )); then
echo "Password cannot be less than 8 characters. Please retry in 5 seconds."
sleep 5
input_password
else
./setup-wallet.sh $pass 
SETUP_MODE=0
finish
fi


}


function finish(){
. variables
	echo "Setup finished succesfully at $(date) you can now send funds to $AKASH_ACCOUNT_ADDRESS. Your account must have funds before you can deploy an instance." >$OUTPUT
    display_output 0 0 "Setup Finished"
}
function setup () {
cmd=(dialog --separate-output --checklist "Select options:" 0 0 0)
options=(1 "Create wallet and first run!" on    # any option can be set to default to "on"
         2 "Backup private keys" off
         3 "Reset / Delete Data Directory" off )
choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
clear
for choice in $choices
do
    case $choice in
        1)
            input_password
            ;;
        2)
            ./backup-private-keys.sh ; echo "Showing keys for 10 seconds!" ; sleep 10
            ;;
        3)
            reset
            ;;
        4)
           update_rpcallow
            ;;
        *)
            break
            ;;
    esac
done
}

# make decsion 
case $menuitem in
	Setup) setup;;
	Node) ./run-full-node.sh;;
	Export) ./backup-private-keys.sh  ; echo "Showing keys for 10 seconds!" ; sleep 10;;
        Show) pass ; echo "Showing address for 10 seconds!" ; docker exec -it akash /bin/bash -c "echo $pass | akash keys list | grep address | cut -d ':' -f2 | cut -c 2-"; sleep 10;;
        Check) echo "Showing address for 10 seconds!" ; docker exec -it akash /bin/bash -c 'akash query bank balances --node $AKASH_NODE $AKASH_ACCOUNT_ADDRESS' ; sleep 10;;
        Run) run_command ; docker exec -it akash /bin/bash -c "akash $command" ; sleep 5 ; run_another;;
	Exit) echo "Bye"; break;;

esac

done

# if temp files found, delete em
[ -f $OUTPUT ] && rm $OUTPUT
[ -f $INPUT ] && rm $INPUT
