#!/bin/bash
source ~/.bash_profile

# Function to display all current aliases
display_aliases() {
    echo "Current aliases:"
    alias
}

# Function to manage an existing alias
manage_alias() {
    # Display all current aliases
    display_aliases

    read -p "Enter the name of the alias you want to modify: " alias_name

    # Check if the entered alias exists
    if ! alias | grep -q "\<$alias_name\>"; then
        echo "Alias not found."
        return 1
    fi

    read -p "Enter a new name for the alias (leave blank to keep the same name): " new_alias_name

    # If the user entered a new name for the alias, update it
    if [[ ! -z "$new_alias_name" ]]; then
    # Check if the new alias name already exists
    if alias | grep -q "\<$new_alias_name\>"; then
        echo "Alias with the new name already exists."
        return 1
    fi

    # Update the alias name and/or command
    if [[ ! -z "$new_alias_command" ]]; then
        new_alias="${new_alias_name}=\"$new_alias_command\""
    else
        new_alias="${new_alias_name}=\"$(alias $alias_name | sed "s/.*='\(.*\)'/\1/")\""
    fi
    unalias $alias_name
    echo "alias $new_alias" >> ~/.bash_profile
    source ~/.bash_profile
    echo "Alias updated successfully."
    fi

    read -p "Enter the new command for the alias (leave blank to keep the same command): " alias_command

    # If the user entered a new command for the alias, update it
    if [[ ! -z "$alias_command" ]]; then
        # Update the alias command
        alias "$new_alias_name=$alias_command"
        echo "Alias command updated successfully."
    fi

    source ~/.bash_profile
}

# Function to create a new alias
create_alias() {
    read -p "Enter a name for the new alias: " alias_name
    read -p "Enter the command for the new alias: " alias_command

    # Check if the alias name already exists
    if alias | grep -q "\<$alias_name\>"; then
        echo "Alias with the name already exists."
        return 1
    fi

    # Create the new alias
    echo "alias $alias_name=\"$alias_command\"" >> ~/.bash_profile
    source ~/.bash_profile
    echo "Alias created successfully."
}

# Function to delete an existing alias
delete_alias() {
    # Display all current aliases
    display_aliases

    read -p "Enter the name of the alias you want to delete: " alias_name

    # Check if the entered alias exists
    if ! alias | grep -q "\<$alias_name\>"; then
        echo "Alias not found."
        return 1
    fi

    # Delete the alias
    unalias $alias_name
    sed -i '' "/alias $alias_name=/d" ~/.bash_profile
    echo "Alias deleted successfully."
    source ~/.bash_profile
}

# Ask user if they want to manage, create or delete an alias
echo "Choose an option:"
echo "  m - Modify an existing alias"
echo "  c - Create a new alias"
echo "  d - Delete an existing alias"
read -p "Enter your choice (m/c/d): " choice

if [[ $choice == "m" ]]; then
    manage_alias
elif [[ $choice == "c" ]]; then
    create_alias
elif [[ $choice == "d" ]]; then
    delete_alias
else
    echo "Invalid choice. Please try again."
fi