# Ansible python virtual environment
## Set the default python interpreter
Use settings.json
```
    "ansible.python.interpreterPath": "/home/andrew/repos/homelab/ansible/.venv/bin/python3"
    "python.terminal.activateEnvironment": true
```
If running from cli, the terminal will need to be restarted, the venv manually activated, or an ansible file will need to be open in order to function.

Primary Side Bar Visibility
{
  "key": "ctrl+alt+b",
  "command": "workbench.action.toggleSidebarVisibility"
}

# Vim Line Numbers
"editor.lineNumbers": "relative"

# Remove overlapping keys
Ctrl+E- jump to EOL- on terminal opens file palette
Unbind from "Go to File..."