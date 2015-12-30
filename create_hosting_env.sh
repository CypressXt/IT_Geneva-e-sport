#!/bin/bash
#################################
#   Clément Hampaï 30.12.2016   #
#   Hosting config             #
#################################
hosting_dir="/var/www/"
wordpress_dl_link="https://wordpress.org/latest.zip"
MySQL=`which mysql`


# Check if the hosting dir is correct
function is_existing_hosting_dir {
    if [ !-e "$hosting_dir" ]
    then
        echo "  Unexisting hosting dir !"
        exit 1
    fi
}

function ask_clear_hosting_dir {
    read -p "Do you wish to clear the hosting dir ? [y/n]" answer
    case $answer in
        [Yy]* ) clear_hosting_dir; break;;
        [Nn]* ) exit 1;;
       * ) echo "Please answer yes or no.";;
    esac
}

# Clear all the content of the hosting dir
function clear_hosting_dir {
    is_existing_hosting_dir
    sudo rm -R "$hosting_dir"/*
}

function ask_wordpress {
    read -p "Do you wish to install Wordpress? [y/n]" answer
    case $answer in
        [Yy]* ) dl_wordpress; break;;
        [Nn]* ) exit 1;;
       * ) echo "Please answer yes or no.";;
    esac
}

# Download the lastest wordpress version and extract it
function dl_wordpress {
    read -p "Where would you like to install Wordpress ?" dl_path
    if [ -z "$db_name" ]
    then
        echo "  give a correct path !"
    fi

    if [ -n "$dl_path" ] && [ -e "$dl_path" ]
    then
        sudo wget -O "$dl_path"/wordpress.zip "$wordpress_dl_link"
        sudo unzip "$dl_path"/wordpress.zip -d "$dl_path"/
        sudo rm "$dl_path"/wordpress.zip
    else
        echo "  The wordpress install path is incorrect !"
        exit 1
    fi
}

function ask_new_db {
    read -p "Do you wish to create a new db? [y/n]" answer
    case $answer in
        [Yy]* ) create_database; break;;
        [Nn]* ) exit 1;;
       * ) echo "Please answer yes or no.";;
    esac
}

# create the mysql db
function create_database {
    read -p "Write the name of the db" db_name
    if [ -z "$db_name" ]
    then
        echo "  give a correct db name !"
    fi

    read -p "Write the username for the new db" db_username
    if [ -z "$db_username" ]
    then
        echo "  give a correct db username !"
    fi


    db_password=$(openssl rand -base64 12)
    Q1="CREATE DATABASE IF NOT EXISTS $db_name;"
    Q2="GRANT USAGE ON *.* TO $db_username@localhost IDENTIFIED BY '$db_password';"
    Q3="GRANT ALL PRIVILEGES ON $db_name.* TO $db_username@localhost;"
    Q4="FLUSH PRIVILEGES;"
    SQL="${Q1}${Q2}${Q3}${Q4}"
    $MySQL -u root -p -e "$SQL"
    recap_mysql "$db_name" "$db_username" "$db_password"
}

function recap_mysql {
    echo -e "--------------------------------------------------------"
    echo -e "           MySQL credentials"
    echo -e "--------------------------------------------------------"
    echo -e "   username:       "$1
    echo -e "   database name:      "$2
    echo -e "   database password:      "$3
    echo -e "--------------------------------------------------------"
}


# run
is_existing_hosting_dir
ask_clear_hosting_dir
ask_wordpress
ask_new_db
#
