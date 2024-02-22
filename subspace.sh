#!/bin/bash

##############################################################


###################### SET COLOR SCHEME ######################
red="echo -e \033[31m\033[1m"
green="echo -e \033[32m\033[2m"
orange="echo -e \033[38;2;240;171;0m\033[2m"
nc="\033[0m" # No color

hostFile="./ansible/hosts.yml"
playbook="./ansible/subspace.yml"

function checkAnsible() {
  # Check for the presence of Ansible
  if command -v ansible &> /dev/null; then
      #Start menu
      menu
  else
      # Prompt to install Ansible
      read -p "Ansible is not installed. Would you like to install it? (y/n): " install_ansible
      if [ "$install_ansible" == "y" ]; then
          # Add Ansible repository
          echo | sudo apt-add-repository ppa:ansible/ansible
          sudo apt update
          # Install Ansible
          sudo apt install -y ansible

          #Start menu
          menu
      else
          echo "Installation of Ansible cancelled."
      fi
  fi
}
checkAnsible

# Get values from the [subspace:children] section in hosts.yml
subspace_children=$(grep -A 100 '\[subspace:children\]' $hostFile | awk '/\[subspace:children\]/{flag=1;next}/\[/{flag=0}flag' | sed '/^\s*$/d')

# Display entries with numbering
echo "Choose an node:"
count=1
options=("all" $subspace_children)
for entry in "${options[@]}"; do
    echo "$count. $entry"
    ((count++))
done
# Read user input
read -p "Select the node number: " choice

function status() {
  # Check user input and execute the corresponding command
  if [ "$choice" -eq 1 ]; then
      ansible-playbook $playbook -i $hostFile --tags "status"
  elif [ "$choice" -gt 1 ] && [ "$choice" -le ${#options[@]} ]; then
      selected_option="${options[$((choice-1))]}"
      ansible-playbook $playbook -i $hostFile --tags "status" --limit "$selected_option"
  else
      echo "Invalid input."
  fi
}

function setup() {
  # Check user input and execute the corresponding command
  if [ "$choice" -eq 1 ]; then
      ansible-playbook  $playbook -i $hostFile --tags "setup"
  elif [ "$choice" -gt 1 ] && [ "$choice" -le ${#options[@]} ]; then
      selected_option="${options[$((choice-1))]}"
      ansible-playbook  $playbook -i $hostFile --tags "setup" --limit "$selected_option"
  else
      echo "Invalid input."
  fi
}

function start() {
  # Check user input and execute the corresponding command
  if [ "$choice" -eq 1 ]; then
      ansible-playbook  $playbook -i $hostFile --tags "start"
  elif [ "$choice" -gt 1 ] && [ "$choice" -le ${#options[@]} ]; then
      selected_option="${options[$((choice-1))]}"
      ansible-playbook  $playbook -i $hostFile --tags "start" --limit "$selected_option"
  else
      echo "Invalid input."
  fi
}

function stop() {
    # Check user input and execute the corresponding command
    if [ "$choice" -eq 1 ]; then
        ansible-playbook  $playbook -i $hostFile --tags "stop"
    elif [ "$choice" -gt 1 ] && [ "$choice" -le ${#options[@]} ]; then
        selected_option="${options[$((choice-1))]}"
        ansible-playbook  $playbook -i $hostFile --tags "stop" --limit "$selected_option"
    else
        echo "Invalid input."
    fi
}

function restart() {
  stop
  start
}
function lognode {
    # Check user input and execute the corresponding command
    if [ "$choice" -eq 1 ]; then
        ansible-playbook  $playbook -i $hostFile --tags "lognode"
    elif [ "$choice" -gt 1 ] && [ "$choice" -le ${#options[@]} ]; then
        selected_option="${options[$((choice-1))]}"
        ansible-playbook  $playbook -i $hostFile --tags "lognode" --limit "$selected_option"
    else
        echo "Invalid input."
    fi
}

function logfarmer {
    # Check user input and execute the corresponding command
    if [ "$choice" -eq 1 ]; then
        ansible-playbook  $playbook -i $hostFile --tags "logfarmer"
    elif [ "$choice" -gt 1 ] && [ "$choice" -le ${#options[@]} ]; then
        selected_option="${options[$((choice-1))]}"
        ansible-playbook  $playbook -i $hostFile --tags "logfarmer" --limit "$selected_option"
    else
        echo "Invalid input."
    fi
}

function update {
    # Check user input and execute the corresponding command
    if [ "$choice" -eq 1 ]; then
        ansible-playbook  $playbook -i $hostFile --tags "update"
    elif [ "$choice" -gt 1 ] && [ "$choice" -le ${#options[@]} ]; then
        selected_option="${options[$((choice-1))]}"
        ansible-playbook  $playbook -i $hostFile --tags "update" --limit "$selected_option"
    else
        echo "Invalid input."
    fi
}

function remove {

    #Stop containers
    stop

    # Check user input and execute the corresponding command
    if [ "$choice" -eq 1 ]; then
        ansible-playbook  $playbook -i $hostFile --tags "remove"
    elif [ "$choice" -gt 1 ] && [ "$choice" -le ${#options[@]} ]; then
        selected_option="${options[$((choice-1))]}"
        ansible-playbook  $playbook -i $hostFile --tags "remove" --limit "$selected_option"
    else
        echo "Invalid input."
    fi
}

function menu() {

# 3. Menu description
  #clear
  echo "Usage: subspace network command"
  echo ""
  echo "Select number action:"
  $green  '0.  Exit '$nc "       - Exit"
  $green  '1.  Status '$nc "     - Check node availability"
  $green  '2.  Setup '$nc "      - Setup node"
  $green  '3.  Start '$nc "      - Start node"
  $green  '4.  Stop '$nc "       - Stop node"
  $green  '5.  Restart '$nc "    - Restart node"
  $green  '6.  Log node '$nc "   - Logs node"
  $green  '7.  Log farmer '$nc " - Logs farmer"
  echo ""
  $orange '88. Update '$nc "     - Update docker template"
  $red    '99. Remove '$nc "     - Remove all data"
  echo ""
}

while true; do
    menu
    read action

    case $action in
    0)
        exit
        break
        ;;
    1)
        status
        break
        ;;
    2)
        setup
        break
        ;;
    3)
        start
        break
        ;;
    4)
        stop
        break
        ;;
    5)
        restart
        break
        ;;
    6)
        lognode
        break
        ;;
    7)
        logfarmer
        break
        ;;
    88)
        update
        break
        ;;

    99)
        remove
        break
        ;;
    *)
        echo "incorrect input. Try again."
        sleep 2
        ;;
    esac
    clear
    echo # clear line
done



# ansible-playbook  ./subspace_3g.yml -i ./hosts.yml