# Print the list of available systems
echo "To restart multipass: 'sudo snap restart multipass.multipassd'"

multipass list

echo "multipass set local.driver=qemu || multipass set local.driver=lxd"

create_instance() {
    # while getopts i:n:d:r: flag
    # do
    #     case "${flag}" in
    #         i) image=${OPTARG};;
    #         n) name=${OPTARG};;
    #         d) disk=${OPTARG};;
    #         r) ram=${OPTARG};;
    #     esac
    # done

    # echo "Image = $image"
    # echo "Name = $name"
    # echo "Disk = $disk"
    # echo "Ram = $ram"


    #size of disk and ram in GB
    disk="$3"G
    ram="$4"G

    # Create a new instance
    echo "Creating instance $2"
    echo multipass launch $1 --name $2 --disk $disk --memory $ram
    multipass launch $1 --name $2 --disk $disk --memory $ram
}



# Run the instance
run_instance() {
    echo "Starting instance $1"
    multipass shell $1
}

restart_instance() {
    echo "Restarting instance $1"
    multipass restart $1
}

stop_instance() {
    echo "Stoping instance $1"
    multipass stop $1
}

# Delete the instance
delete_instance() {
    echo "Stoping instance $1"
    multipass stop $1
    echo "Deleting instance $1"
    multipass delete --purge $1
}

# Modify RAM/CPU
modify_instance() {

    echo "Stoping instance $1"
    multipass stop $1
    
    # if not equal to 0
    if [ "$2" -ne 0 ]; then

        #add G to the disk
        disk="$2"G
        multipass set local.$1.disk=$disk
        echo "Allocation of disk: $disk for '$1'"
    fi

    if [ "$3" -ne 0 ]; then
        #add G to the ram
        ram="$3"G
        multipass set local.$1.memory=$ram
        echo "Allocation of memory: $ram for '$1'"
    fi
    if [ "$cpu" -ne 0 ]; then
        multipass set local.$1.cpus=$cpu
        echo "Allocation of CPU: $cpu for '$1'"
    fi

    echo "Starting instance $1"
    multipass start $1

}

# WORKS
cp_files() {
    PATHFILE=$1
    VM=$2
    CHOICE=$3
    # Transfer files
    if [ $CHOICE -eq 1 ]; then
        echo "Transfer files From local to VM"
    
        echo "multipass transfer --recursive $PATHFILE $VM:."
        #if folder transfert recursively
        if [ -d $PATHFILE ]; then
            multipass transfer --recursive $PATHFILE $VM:.
        else
            multipass transfer $PATHFILE $VM:.
        fi

    elif [ $CHOICE -eq 2 ]; then
        echo "Transfer files From VM to local"
    
        echo "multipass transfer --recursive $VM:$PATHFILE ."
        #if folder transfert recursively
        # if [ -d $PATHFILE ]; then
        multipass transfer --recursive $VM:$PATHFILE .
        # else
            # multipass transfer $VM:$PATHFILE .
        # fi
    fi
    

    
}

manage_instance() {
    # if argument suply with command name and system name
    if [ $# -eq 2 ]; then
        if [ $1 = "restart" ]; then
            restart_instance $2
        elif [ $1 = "create" ]; then
            if [ $2 = "" || $3 = "" || $4 = "" || $5 = "" ]; then
                echo "Invalid command"
                echo "Usage: cmd-multipass create <image> <instance_name> <disk_size> <ram_size>"
                exit
            fi
            create_instance $2 $3 $4 $5
        elif [ $1 = "run" ]; then
            if [ "$(multipass list | grep $1 | wc -l) -eq 1" ]; then
                run_instance $2
                exit
            else
                echo "Instance does not exist"
                exit
            fi
        elif [ $1 = "cp" ]; then
            cp_files $2 $3
        elif [ $1 = "modify" ]; then
            modify_instance $2
        elif [ $1 = "rm" ]; then
            delete_instance $2
        elif [ $1 = "stop" ]; then
            stop_instance $2
        else
            echo "Invalid command"
        fi
        exit
    fi
}

init_prompt() {
    echo "use this command to create a debian 11 VM:"
    echo "multipass launch --name debian11 -vvvv https://cloud.debian.org/images/cloud/bullseye/latest/debian-11-generic-amd64.qcow2"
    # Ask what to do
    echo "What do you want to do?"
    # echo "0. Start/Stop Multipass service"
    echo "1. Create a new instance" #Works
    echo "2. Run an instance"   #Works
    echo "3. Transfer files"   #Works
    echo "4. Modify an instance" 
    echo "5. Start an instance" #Works
    echo "6. Stop an instance" #Works
    echo "7. Delete an instance"
    read -p "Enter your choice: " choice

    # echo "Usage: cmd-multipass create <image> <instance_name> <disk_size> <ram_size>"

    read -p "Enter the name of the instance: " name

    if [ $choice -eq 0 ]; then
        multipass set client.gui.autostart=false
    fi
    if [ $choice -eq 1 ]; then
        read -p "Enter the image name (default: ubuntu 22): " image
        
        read -p "Enter the disk size in GB (default: 10GB): " disk_size
        read -p "Enter the RAM size in GB (default: 4GB): " ram_size
        read -p "Enter the CPU (default: 1): " cpu
    fi
    if [ $choice -eq 4 ]; then
        read -p "Enter the image name (default: ubuntu 22): " image
        
        read -p "Enter the disk size in GB (default: 10GB): " disk_size
        read -p "Enter the RAM size in GB (default: 4GB): " ram_size
        read -p "Enter the CPU (default: 1): " cpu
    fi

    if [ $choice -eq 1 ]; then

        if [ -z "$image" ]; then
            image="jammy"
        fi
        if [ -z "$name" ]; then
            name="ubuntu-instance"
        fi
        if [ -z "$disk_size" ]; then
            disk_size=10
        fi
        if [ -z "$ram_size" ]; then
            ram_size=4
        fi
        create_instance $image $name $disk_size $ram_size
        run_instance $name
        exit 0
    fi
    #while name is not set
    while [ -z "$name" ]
    do
        read -p "Enter the name of the instance: " name
    done

    # default value for disk, ram and cpu
    if [ -z "$disk_size" ]; then
        disk_size=0
    fi
    if [ -z "$ram_size" ]; then
        ram_size=0
    fi
    if [ -z "$cpu" ]; then
        cpu=0
    fi


    if [ $choice -eq 2 ]; then
        run_instance $name
    elif [ $choice -eq 3 ]; then
        read -p "Enter the path of the file: " document
        echo "1) From local to VM"
        echo "2) From VM to local"
        read -p "Enter your choice: " choice
        cp_files $document $name $choice
    elif [ $choice -eq 4 ]; then
        modify_instance $name $disk_size $ram_size $cpu
    elif [ $choice -eq 5 ]; then
        restart_instance $name
    elif [ $choice -eq 6 ]; then
        stop_instance $name
    elif [ $choice -eq 7 ]; then
        delete_instance $name
    else
        echo "Invalid choice"
    fi
}

init_prompt


# # Run the script
# if [ $# -eq 0 ]; then
#     init_prompt
# elif [ $# -eq 1 ]; then
#     echo "Invalid command"
#     echo "Usage: cmd-multipass [run|cp] <instance_name> <file_path>"
# elif [ $# -eq 2 ]; then
#     manage_instance $1 $2
# elif [ $# -eq 3 ]; then
#     cp_files $1 $3 $2
# else
#     echo "Invalid command"
# fi
