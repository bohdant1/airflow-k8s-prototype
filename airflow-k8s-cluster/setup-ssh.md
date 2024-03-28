## Setting Up SSH for Your Git Repo

This guide outlines the steps to configure SSH for your Git repository, specifically for use with GitSync, a service that pulls Airflow DAGs via SSH.

### Step 1: Generate SSH Key

1. **Open Terminal**: Launch the Terminal application on your Mac.
2. **Generate SSH Key**: Execute the following command to generate a new SSH key. Replace `<your_email@example.com>` with your actual email address.
    ```bash
    ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
    ```
3. **Follow Prompts**: You will be prompted to enter a file to save the key in. Press Enter to accept the default location (`~/.ssh/id_rsa`). You can also choose to set a passphrase for extra security.

### Step 2: Copy SSH Key to Clipboard

1. **Display the SSH Key**: Use the following command to display your SSH public key in the Terminal.
    ```bash
    cat ~/.ssh/id_rsa.pub
    ```
2. **Copy the Key**: Select the entire SSH key output in the Terminal, then right-click and choose "Copy".

### Step 3: Add SSH Key to GitHub (Example)

1. **Sign in to GitHub**: Open your GitHub account in a web browser.
2. **Access SSH Settings**: Go to **Settings > SSH and GPG keys**.
3. **Add SSH Key**: Click on **New SSH key** and paste the copied SSH key into the "Key" field.
4. **Save Key**: Give your SSH key a descriptive title and click on **Add SSH key**.

### Step 4: Test SSH Connection

1. **Verify Connection**: In Terminal, run the following command to test your SSH connection to GitHub.
    ```bash
    ssh -T git@github.com
    ```
2. **Confirm Connection**: You should see a message confirming a successful connection.

### Step 5: Configure GitSync

1. **Update GitSync Configuration**: update <<<YOUR_SSH_KEY>>> in override-values.yaml with your private ssh key.
