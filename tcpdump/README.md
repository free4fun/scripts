# Interactive TCPDump Capture Script

**Author:** Mauricio Sosa Giri (<free4fun@riseup.net>)  
**License:** GNU Affero General Public License v3.0 or later

## Overview

This Bash script provides an interactive, user-friendly way to capture network packets using `tcpdump`. It guides the user step-by-step to select the network interface, destination port or port range, number of packets, output format, and output filename. The script ensures all inputs are validated and provides real-time feedback during the capture process.

---

## Features

1. **Dependency Check:** Verifies that `tcpdump` is installed before proceeding.
2. **Interface Selection:** Lists available network interfaces for the user to choose from.
3. **Port Selection:** Allows selection of a single destination port or a range of destination ports.
4. **Output Format:** Supports both `pcap` (binary) and plain text formats.
5. **Filename Customization:** Lets the user specify the output filename (extension is added automatically).
6. **Packet Count:** User can define how many packets to capture (1–10,000).
7. **Progress Feedback:** Shows progress during packet capture.
8. **Input Validation:** Ensures all user inputs are correct and within valid ranges.

---

## Requirements

- **Operating System:** Linux or WSL (Windows Subsystem for Linux)
- **Dependencies:**  
  - `bash`
  - `tcpdump`
  - `ip` (from `iproute2` package)
  - `sudo` privileges (for capturing packets)

---

## Usage

1. **Make the script executable:**
   ```bash
   chmod +x interactive_tcpdump.sh
   ```

2. **Run the script:**
   ```bash
   ./interactive_tcpdump.sh
   ```

3. **Follow the on-screen prompts:**
   - Select a network interface.
   - Choose a destination port or port range.
   - Specify the number of packets to capture.
   - Select the output format (`pcap` or `text`).
   - Enter the output filename (without extension).

4. **Wait for the capture to complete.**
   - A progress indicator (`...`) will be shown during the capture.
   - Once complete, the script will display the output filename.

---

## Example Session

```
tcpdump installed
Available interfaces:
1) lo
2) eth0
Choose an interface by number: 2
1) Single destination port
2) Range of destination ports
Do you want a particular destination port or a range of destination ports? (1/2): 1
Enter the destination port number: 443
Enter the number of packets to capture (1-10000): 100
1) pcap
2) text
Choose the output format by number (1/2): 1
Enter the name of the output file without extension: capture_https
Running tcpdump. Please wait...
......
Capture complete. Output saved to capture_https.pcap
```

---

## Output

- **PCAP format:** Suitable for analysis with Wireshark or similar tools.
- **Text format:** Readable output directly in a `.txt` file.

---

## License

This script is licensed under the GNU Affero General Public License v3.0 or later.  
See [LICENSE](LICENSE) for details.

---

## Disclaimer

- Make sure you have the necessary permissions to capture network traffic on your system.
- Use this script responsibly and only on networks you are authorized to monitor.
