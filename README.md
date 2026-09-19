# Kali NetHunter for KernelSU Next

Flashable Kali NetHunter module for rooted Android with Magisk or KernelSU Next. Bundles NetHunter apps, BusyBox, HID/NFC tools, wallpapers, and Kali chroot, then auto-detects your root manager to stage files and hook BusyBox via post-fs-data. Flash once, finalize inside the NetHunter app, and you're ready to pentest on mobile.

## Features

- **Cross-Root Compatibility**: Works with both Magisk and KernelSU Next by auto-detecting the environment.
- **Complete NetHunter Suite**: Includes NetHunter, NetHunter Terminal, NetHunter KeX, NetHunter Store, and privileged extension apps.
- **BusyBox Integration**: Installs NetHunter's BusyBox with full applet symlinks.
- **HID/NFC Tools**: Bundles HID keyboard and NFC utilities.
- **Kali Chroot Support**: Sets up the Kali Linux chroot environment.
- **Wallpaper and Boot Animation**: Includes custom NetHunter wallpapers and boot animation.
- **Addon.d Backup**: Supports system backup and restore via addon.d scripts.
- **Post-FS-Data Hooks**: Ensures BusyBox and scripts are available early in boot.

## Requirements

- Already-rooted Android device with either Magisk (v20.4+) or KernelSU Next installed.
- Sufficient storage space (at least 500MB free for the module and chroot).
- Android 8.0+ (Oreo) or higher for optimal app installation.
- A compatible Wi‑Fi chipset and kernel/firmware support for monitor mode; real support varies by device and driver.

> This project assumes the phone is already rooted. The official ARM64 payloads are intentionally kept out of Git because the chroot archive is large; download the archive and let the build script extract it locally.

## Installation

### One-command workflow

Use the combined workflow for a rooted device and a realistic wireless setup:

```bash
cd /workspaces/Nethunter_4_KSU
./setup-and-build.sh /path/to/kali-nethunter-*-arm64-*.zip
```

This single entry point:
- checks the rooted-device assumptions
- checks the root manager state
- verifies the official NetHunter ARM64 payloads
- extracts the required APKs and chroot archive
- runs the validated module build
- keeps the monitor-mode warnings honest for the specific chipset in use

### Step 1: Download the Original NetHunter Module

1. Download the official Kali NetHunter module ZIP from the [NetHunter Images](https://kali.download/nethunter-images/current/) page. Choose the latest version that matches your device's architecture:
    - For ARM64 devices: Look for `kali-nethunter-*-arm64-*.zip`.
    - For ARM devices: Look for `kali-nethunter-*-armhf-*.zip`.
    - For x86_64 devices: Look for `kali-nethunter-*-amd64-*.zip`.
    - For x86 devices: Look for `kali-nethunter-*-i386-*.zip`.

### Step 2: Extract Required Files

1. Download the official ARM64 NetHunter archive.
2. Pass its path directly to `setup-and-build.sh`; it validates and extracts the required APKs and chroot archive locally.

### Step 3: Repackage the Module

1. Ensure the archive has been processed into the repository by the combined workflow.
2. Run the validated builder from the repository root:

    ```bash
    ./build-module.sh
    ```

    The build stops if any required APK, `kalifs-minimal-arm64.tar.xz`, or installer script is missing. The output is `nethunter-ksu-xt2513v.zip`.

    The generated ZIP is intentionally ignored by Git because GitHub does not accept files of this size in a normal repository. Keep it locally or publish it as a GitHub Release asset.

3. If you are using a rooted phone in a real-world KernelSU setup, you can also use the local helper CLI:

    ```bash
    ./pentest-ai.sh root-check
    ./pentest-ai.sh monitor-check
    ```

    This helper checks the environment and gives realistic monitor-mode guidance without pretending every adapter supports every wireless attack mode.

### Step 4: Flash via KernelSU

1. Transfer the ZIP to your device.
2. Open KernelSU Manager.
3. Go to the module installation section.
4. Select and flash the ZIP.
5. Reboot your device.
6. Open the NetHunter app and complete the setup (update via NetHunter Store if prompted).

This package targets the ARM64 Moto G XT2513V. It does not flash a kernel; do not add a kernel ZIP unless it is specifically built for this exact device.

## Usage

- After installation, launch the NetHunter app to access the full suite.
- Use NetHunter Terminal for command-line access.
- NetHunter KeX provides a graphical desktop environment.
- The chroot is automatically mounted on boot; use `bootkali` scripts for manual control.

## Troubleshooting

- **Installation Fails**: Ensure the ZIP is correctly packaged without nested folders. Check KernelSU logs for errors.
- **Apps Not Installing**: Verify your Android version; system apps require Android 8+.
- **BusyBox Not Working**: Check `/data/adb/ksu/modules/<moduleId>/system/bin/` for symlinks after reboot.
- **Chroot Issues**: Ensure `kalifs-minimal-arm64.tar.xz` is present and valid.
- **Kernel Flashing**: Only supported under Magisk; skipped in KernelSU.

## Project Background

This project adapts the official Kali NetHunter Magisk module for compatibility with KernelSU Next. The original NetHunter module is designed exclusively for Magisk, limiting users on KernelSU-based root solutions. By modifying the installer scripts to detect and handle KernelSU environments, this fork enables NetHunter on a broader range of rooted devices. Changes include fallback utilities, adjusted module paths, and conditional logic to bypass Magisk-specific features while maintaining full functionality.

## Contributing

Contributions are welcome! Fork the repo, make changes, and submit a pull request. Please test on both Magisk and KernelSU setups.

## License

This project is based on the official Kali NetHunter module. Refer to the original license for terms. Modifications are provided under the same or compatible license.
