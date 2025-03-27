sudo update-alternatives --config x-terminal-emulator

# #  check if ${args[list]} is true
# if [[ ${args[list]} == true ]]; then
#     sudo update-alternatives --list x-terminal-emulator
# else
#     #  check if ${args[set]} is true
#     if [[ ${args[set]} == true ]]; then
#         sudo update-alternatives --set x-terminal-emulator ${args[terminal]}
#     else
#         #  check if ${args[config]} is true
#         if [[ ${args[config]} == true ]]; then
#             sudo update-alternatives --config x-terminal-emulator
#         fi
#     fi
# fi
