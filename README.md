# PowerShell Administration Scripts

A collection of PowerShell scripts designed for administrative tasks. These scripts are tailored for IT administrators, enabling them to manage, configure, and monitor systems more efficiently.

## Table of Contents

- [About the Project](#about-the-project)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
- [Usage](#usage)
- [Contributing](#contributing)
- [License](#license)
- [Contact](#contact)

## About the Project

This repository contains a set of simple PowerShell scripts aimed at helping administrators streamline routine tasks in Windows environments. 
With a focus on ease-of-use and flexibility, they can be applied in various IT workflows.

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
## Usage

Each script comes with documentation and examples within the file itself. Below is a general overview:

- **Running a script**: Navigate to the script's directory and execute:

    ```powershell
    .\ScriptName.ps1 
    ```

- **Running a script with parameters**: Some scripts could include parameters for flexibility. For instance:

    ```powershell
    .\ScriptName.ps1 -Parameter1 Value1 -Parameter2 Value2
    ```

- **Scheduled tasks**: To automate, use Task Scheduler or cron jobs (for PowerShell Core on Linux) to run these scripts periodically.

## Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository.
2. Create a new branch (`git checkout -b feature/NewFeature`).
3. Commit your changes (`git commit -m 'Add new feature'`).
4. Push to the branch (`git push origin feature/NewFeature`).
5. Open a Pull Request.

## License

Distributed under the GPL-3.0 License. See `LICENSE` file for more details.

## Contact

Maintainer: [Gianni Schmidt](mailto:"".com)

For issues or suggestions, please open an issue in this repository or reach out directly.
