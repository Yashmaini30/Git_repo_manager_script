# Git Repository Manager Script
## Description
This Bash script automates the process of managing Git repositories. It allows users to:

Clone a Git repository.
Create and switch to a new branch.
Stage all changes.
Commit changes with a provided message.
Push the new branch to a remote repository.
The script also includes error handling and logging to ensure smooth operation and easy troubleshooting.

Features
Interactive Input: Prompts users for input if command-line arguments are not provided.
URL Validation: Checks if the provided repository URL is reachable before attempting to clone.
Branch Management: Ensures the branch does not already exist before creating a new one.
Logging: Records all actions and errors to a log file (git_manager.log).
Usage
The script can be run either with command-line arguments or interactively.

Command-Line Usage
``` bash
git_repo_manager_script.sh -u <repo-url> -d <directory> -b <branch-name> -m <commit-message>
```
Options

`-u <repo-url>:` URL of the Git repository to clone.

`-d <directory>:` Directory name for cloning the repository.

`-b <branch-name>:` Branch name to create and switch to.

`-m <commit-message>:` Commit message for the changes.

### Interactive Usage
If command-line arguments are not provided, the script will prompt for the following:

Repository URL: Enter the URL of the Git repository to clone.

Directory Name: Enter the directory name where the repository will be cloned.

Branch Name: Enter the branch name to create and switch to.

Commit Message: Enter the commit message for the changes.
Script Workflow

Logging Setup: Initializes a log file (git_manager.log) to record timestamps and messages.

`Function Definitions:`

log(): Logs messages with timestamps to the log file.

usage(): Displays usage information and exits if arguments are missing or incorrect.

validate_repo_url(): Validates the repository URL using curl to ensure it is reachable.

Command-Line Parsing: Uses getopts to parse command-line options for repository URL, directory name, branch name, and commit message.

Interactive Prompts: If required arguments are missing, prompts the user to input the necessary details.

URL Validation: Verifies that the repository URL is reachable.

Repository Cloning: Clones the specified Git repository into the provided directory.

Directory Change: Navigates to the cloned repository's directory.

Branch Existence Check: Checks if the specified branch already exists. Exits if the branch exists.

Branch Creation: Creates and switches to the new branch.

Staging Changes: Stages all changes in the repository.

Commit Changes: Commits the staged changes with the provided commit message.

Push Branch: Pushes the new branch to the remote repository.

Completion Message: Prints a success message and logs the completion.

Error Handling
The script includes robust error handling:

If any step fails (e.g., cloning, branch creation), the script logs the error and exits.

Detailed error messages are provided both on the console and in the log file.

Log File

`File Name:` git_repo_manager_script.sh

`Location:` Same directory where the script is executed.

`Content:` Timestamps and messages for each action performed and errors encountered.

### Examples

Running with Command-Line Arguments
``` bash
git_repo_manager_script.sh -u https://github.com/user/repo.git -d myrepo -b new-branch -m "Initial commit"
```
Running Interactively
```bash
git_repo_manager_script.sh
```
Follow the prompts to enter the repository URL, directory name, branch name, and commit message.

Dependencies

`git:` The script requires Git to perform repository operations.

`curl:` Used for validating the repository URL.

