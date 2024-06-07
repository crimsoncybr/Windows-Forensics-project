# Forensics Analysis Script

## Overview
This script is designed for forensics analysis on Linux systems. It automates tasks such as checking for root permissions, updating the system, installing
necessary tools, and extracting information from memory dump files or HDD image files. 
It supports various carving and analysis tools like `foremost`, `bulk_extractor`, `strings`, `binwalk`, and `volatility`. The script identifies the type of file
provided (memory dump or HDD image) and applies appropriate tools for extraction and analysis.

## Prerequisites
- Root privileges are required to run this script (`sudo`).
- Ensure that necessary packages and tools are installed:
    - `foremost`
    - `bulk_extractor`
    - `strings`
    - `binwalk`
    - `volatility` (will be downloaded by the script if not found)

## Installation
1. Download or clone the script to your Linux system.
2. Ensure that the script has executable permissions using `chmod +x WFGH.sh`.
3. Execute the script with `./WFGH.sh`.

## Usage
- Run the script with root privileges (`sudo ./WFGH.sh`).
- Follow the on-screen instructions to:
    - Provide the path to the memory dump file or HDD image file.
    - Choose the appropriate type of file (memory dump or HDD image).
    - Extract and analyze the data using various tools.
    - Optionally, delete the `volatility` tool at the end of the script.

## Functionality
### File Processing
- Checks if the script is running with root permissions.
- Updates the system using `apt-get`.
- Verifies the existence of the provided file (memory dump or HDD image).
- Chooses the appropriate tools based on the type of file provided.

### Tool Installation
- Checks for and installs necessary tools if not already installed:
    - `foremost`
    - `bulk_extractor`
    - `strings`
    - `binwalk`
    - `volatility` (downloaded if not found)

### Carving and Analysis
- Carves data using various tools such as `strings`, `bulk_extractor`, `foremost`, and `volatility`.
- Extracts information such as strings, registry data, and executable files.
- Generates audit reports and lists all extracted files.
- Zips the findings and extracted files for easy distribution.

## Notes
- Ensure that the necessary tools are installed on your system before running the script.
- Running this script requires root privileges.
- It's recommended to review the script and understand its functionality before execution.
- Use caution when analyzing sensitive data and ensure compliance with legal and ethical guidelines.

