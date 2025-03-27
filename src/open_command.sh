PATH=${args[folder]}
if [ -z "$PATH" ]; then
  echo "No argument provided. Using current directory"
  PATH=$(pwd)
fi

if [ -d $PATH ]; then
  echo "Opening $PATH in file manager"
  xdg-open $PATH
else
  echo "Path $PATH does not exist. Please provide a valid path"
fi