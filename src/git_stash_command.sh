pwd

echo "Do you want to pull from github and save your changes locally? (y/n)"
read answer
if [ "$answer" == "y" ]; then
    # save current changes locally
    git stash save
    # pull latest changes from github
    git pull
    # apply saved changes
    git stash pop

    echo "Github pull complete and local changes applied"
else
    echo "Skipping pull from github"
fi