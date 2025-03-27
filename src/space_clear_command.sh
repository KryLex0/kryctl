sudo apt-get clean

sudo apt-get autoclean

sudo journalctl --vacuum-time=1d

sudo apt-get autoremove --purge

docker image rm -f $(docker images -f dangling=true -q)

# if argument is passed
if [ "$1" == "all" ]; then
    # run a command with y to all questions
    yes | docker system prune --volumes
else    
    docker system prune --volumes
    echo "Docker cleared"
fi
