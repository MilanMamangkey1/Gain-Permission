# Gain Permission

A PowerShell-based GUI tool for managing file and folder permissions on Windows systems.

## Overview

Gain Permission is a user-friendly GUI application that simplifies the process of granting permissions to files and folders. The tool provides an intuitive interface for selecting paths and users, making permission management more accessible.

## Features

- **Graphical User Interface** - Easy-to-use Windows Forms GUI
- **Folder Browser** - Built-in folder selection dialog
- **User Selection** - Specify which user should receive permissions (defaults to current user)
- **Elevation Support** - Optional "Run as Administrator" for operations requiring elevated privileges
- **Error Handling** - Validates paths and provides user-friendly error messages

## Requirements

- Windows operating system
- PowerShell 5.0 or higher
- Administrator privileges (recommended for most operations)

## Installation

1. Clone this repository:
```bash
git clone https://github.com/MilanMamangkey1/Gain-Permission.git
```

2. Navigate to the repository folder:
```bash
cd Gain-Permission
```

## Usage

1. Run the GUI script:
```powershell
.\gain-permission-gui.ps1
```
  Or right click the file and select "Run with PowerShell"

2. In the GUI window:
   - **Folder**: Enter or browse to select the target folder path
   - **User**: Specify the username who should receive permissions (defaults to current user)
   - **Require elevation**: Check this box to run with administrator privileges (recommended)

3. Click **Apply Permissions** to execute the operation

4. If elevation is required, a UAC prompt will appear - accept it to proceed

## Components

### gain-permission-gui.ps1
The main GUI application that:
- Provides a user interface for path and user selection
- Validates input paths
- Handles elevation and process starting
- Communicates with the helper script to apply permissions

## Default Configuration

- **Default Path**: `D:\Haswell` (can be modified)
- **Default User**: Current logged-in user (`$env:USERNAME`)
- **Elevation**: Enabled by default

## Security Considerations

⚠️ **Important**: Modifying file permissions can affect system security. Always:
- Ensure you understand the implications of granting permissions
- Run with administrator privileges when modifying system or protected folders
- Verify the target path before applying changes
- Keep backups of important data

## Contributing

Contributions are welcome! Feel free to:
- Report bugs
- Suggest new features
- Submit pull requests

## License

This project is available for public use. Please check with the repository owner for specific licensing terms.

## Author

Created by [MilanMamangkey1](https://github.com/MilanMamangkey1)

## Support

If you encounter any issues or have questions, please open an issue on the [GitHub repository](https://github.com/MilanMamangkey1/Gain-Permission/issues).
