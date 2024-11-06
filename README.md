# PowerShell Administration Scripts

A collection of simple PowerShell scripts designed to simplify and automate administrative tasks. These scripts are tailored for IT administrators, enabling them to manage, configure, and monitor systems more efficiently.

## Table of Contents

- [About the Project](#about-the-project)
- [Features](#features)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
- [Usage](#usage)
- [Contributing](#contributing)
- [License](#license)
- [Contact](#contact)

## About the Project

This repository contains a set of PowerShell scripts aimed at helping administrators streamline routine tasks in Windows environments. These scripts handle tasks like user management, system configuration, process monitoring, and logging. With a focus on ease-of-use and flexibility, they can be applied in various IT and DevOps workflows.

## Features

- **User Management**: Create, modify, and delete user accounts.
- **System Monitoring**: Monitor CPU, memory, and disk usage.
- **Automated Backups**: Schedule and manage system and file backups.
- **Security Configurations**: Apply and monitor essential security policies.
- **Logging & Reporting**: Generate logs and reports for key administrative activities.

## Getting Started

### Prerequisites

To run these scripts, you will need:

- Windows PowerShell (version 5.1 or higher) or PowerShell Core.
- Administrative privileges, as some scripts require elevated permissions.
- (Optional) Modules like `ActiveDirectory` for specific tasks, which can be installed via:

  ```powershell
  Install-Module -Name ActiveDirectory
  ```

### Installation

1. Clone the repository to your local machine:

    ```bash
    git clone https://github.com/gsmdt01/PowerShell.git
    cd PowerShell
    ```

2. Ensure that execution policies are set to allow the running of scripts:

    ```powershell
    Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
    ```

3. Run a test script to verify functionality:

    ```powershell
    .\Test-Script\Test-Script.ps1
    ```
