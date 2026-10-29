sudo apt-get clean

sudo apt-get autoclean

sudo journalctl --vacuum-time=1d

sudo apt-get autoremove --purge

# add an if condition to check if images are dangling
if [ "$(docker images -f dangling=true -q)" ]; then
    echo "Removing dangling images..."
    docker image rm -f $(docker images -f dangling=true -q)
else
    echo "No dangling images to remove."
fi

# if argument is passed
if [ "$1" == "all" ]; then
    # run a command with y to all questions
    yes | docker system prune --volumes
else    
    docker system prune --volumes
    echo "Docker cleared"
fi
