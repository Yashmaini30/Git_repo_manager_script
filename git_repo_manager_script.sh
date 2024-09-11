#!/bin/bash

LOG_FILE="git_manager.log"

# Function to log messages with timestamps
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

# Function to display usage
usage() {
    echo "Usage: $0 -u <repo-url> -d <directory> -b <branch-name> -m <commit-message>"
    echo "Options:"
    echo "  -u  URL of the Git repository to clone"
    echo "  -d  Directory name for cloning the repository"
    echo "  -b  Branch name to create and switch to"
    echo "  -m  Commit message for the changes"
    exit 1
}

# Function to validate the repository URL
validate_repo_url() {
    curl --head --silent "$1" | grep "200 OK" > /dev/null
    if [ $? -ne 0 ]; then
        echo "Error: Repository URL is not reachable."
        log "Error: Repository URL $1 is not reachable."
        exit 1
    fi
}

# Parse command-line options
while getopts "u:d:b:m:" opt; do
    case ${opt} in
        u )
            REPO_URL=$OPTARG
            ;;
        d )
            DIR_NAME=$OPTARG
            ;;
        b )
            BRANCH_NAME=$OPTARG
            ;;
        m )
            COMMIT_MSG=$OPTARG
            ;;
        \? )
            usage
            ;;
    esac
done
shift $((OPTIND -1))

# If any argument is missing, prompt for user input
if [ -z "$REPO_URL" ]; then
    read -p "Enter the repository URL: " REPO_URL
fi
if [ -z "$DIR_NAME" ]; then
    read -p "Enter the directory name for cloning: " DIR_NAME
fi
if [ -z "$BRANCH_NAME" ]; then
    read -p "Enter the branch name to create: " BRANCH_NAME
fi
if [ -z "$COMMIT_MSG" ]; then
    read -p "Enter the commit message: " COMMIT_MSG
fi

# Validate inputs
if [ -z "$REPO_URL" ] || [ -z "$DIR_NAME" ] || [ -z "$BRANCH_NAME" ] || [ -z "$COMMIT_MSG" ]; then
    usage
fi

# Validate repository URL
log "Validating repository URL $REPO_URL..."
validate_repo_url "$REPO_URL"

# Clone the repository
log "Cloning repository from $REPO_URL into $DIR_NAME..."
if ! git clone "$REPO_URL" "$DIR_NAME"; then
    echo "Failed to clone repository"
    log "Error: Failed to clone repository from $REPO_URL into $DIR_NAME"
    exit 1
fi

cd "$DIR_NAME" || { echo "Failed to change directory to $DIR_NAME"; log "Error: Failed to change directory to $DIR_NAME"; exit 1; }

# Check if branch exists
if git show-ref --verify --quiet "refs/heads/$BRANCH_NAME"; then
    echo "Branch $BRANCH_NAME already exists."
    log "Branch $BRANCH_NAME already exists."
    exit 1
fi

# Create a new branch
log "Creating and switching to branch $BRANCH_NAME..."
if ! git checkout -b "$BRANCH_NAME"; then
    echo "Failed to create or switch to branch $BRANCH_NAME"
    log "Error: Failed to create or switch to branch $BRANCH_NAME"
    exit 1
fi

# Stage all changes
log "Staging all changes..."
if ! git add .; then
    echo "Failed to stage changes"
    log "Error: Failed to stage changes"
    exit 1
fi

# Commit changes
log "Committing changes with message: $COMMIT_MSG"
if ! git commit -m "$COMMIT_MSG"; then
    echo "Failed to commit changes"
    log "Error: Failed to commit changes with message: $COMMIT_MSG"
    exit 1
fi

# Push the new branch to the remote repository
log "Pushing branch $BRANCH_NAME to remote repository..."
if ! git push origin "$BRANCH_NAME"; then
    echo "Failed to push branch $BRANCH_NAME"
    log "Error: Failed to push branch $BRANCH_NAME"
    exit 1
fi

echo "Repository setup and branch management completed successfully."
log "Repository setup and branch management completed successfully."
