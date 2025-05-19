#!/bin/bash
# Author: Mauricio Sosa Giri <free4fun@riseup.net>

# This script is distributed under the terms of the GNU General Public License (GPL) version 3.0 or later.
# You should have received a copy of the GNU General Public License along with this program.
# If not, see <https://www.gnu.org/licenses/gpl-3.0.html>

# Check if tcpdump is installed
if ! command -v tcpdump &> /dev/null; then
    echo "tcpdump is not installed. Please install it to proceed."
    exit 1
else
    echo "tcpdump installed"
fi

# Function to choose a network interface
choose_interface() {
    echo "Available interfaces:"
    interfaces=( $(ip -o link show | awk -F': ' '{print $2}' | awk '{print $1}') )
    for i in "${!interfaces[@]}"; do
        echo "$((i+1))) ${interfaces[$i]}"
    done

    while true; do
        read -p "Choose an interface by number: " choice
        if ! [[ "$choice" =~ ^[0-9]+$ ]] || [ "$choice" -lt 1 ] || [ "$choice" -gt "${#interfaces[@]}" ]; then
            echo "Invalid entry. Please enter a valid number."
        else
            INTERFACE=${interfaces[$((choice-1))]}
            break
        fi
    done
}

# Function to choose a port or range of ports
choose_port() {
    while true; do
        echo "1) Single destination port"
        echo "2) Range of destination ports"
        read -p "Do you want a particular destination port or a range of destination ports? (1/2): " port_choice

        case $port_choice in
            1)
                while true; do
                    read -p "Enter the destination port number: " port
                    if ! [[ "$port" =~ ^[0-9]+$ ]] || [ "$port" -lt 1 ] || [ "$port" -gt 65535 ]; then
                        echo "Invalid port number. Please enter a valid number between 1 and 65535."
                    else
                        PORT="dst port $port"  # Only destination port
                        break
                    fi
                done
                break
                ;;
            2)
                while true; do
                    read -p "Enter the destination port range (firstport-lastport): " port_range
                    if [[ "$port_range" =~ ^([0-9]+)-([0-9]+)$ ]]; then
                        first_port=${BASH_REMATCH[1]}
                        last_port=${BASH_REMATCH[2]}
                        if [ "$first_port" -lt 1 ] || [ "$first_port" -gt 65535 ] || [ "$last_port" -lt "$first_port" ] || [ "$last_port" -gt 65535 ]; then
                            echo "Invalid range format. Please use a valid range between 1 and 65535, e.g., 8007-8020."
                        else
                            PORT="dst portrange $port_range"  # Only destination ports
                            break
                        fi
                    else
                        echo "Invalid range format. Please use the format firstport-lastport, e.g., 8007-8020."
                    fi
                done
                break
                ;;
            *)
                echo "Invalid entry. Please enter 1 or 2."
                ;;
        esac
    done
}



# Function to choose output format
choose_format() {
    while true; do
        echo "1) pcap"
        echo "2) text"
        read -p "Choose the output format by number (1/2): " format_choice

        case $format_choice in
            1)
                FORMAT="pcap"
                EXTENSION=".pcap"
                break
                ;;
            2)
                FORMAT="text"
                EXTENSION=".txt"
                break
                ;;
            *)
                echo "Invalid entry. Please enter 1 or 2."
                ;;
        esac
    done
}

# Function to get the filename without extension
get_filename() {
    while true; do
        read -p "Enter the name of the output file without extension: " filename
        if [[ -z "$filename" ]]; then
            echo "Invalid entry. Please enter a valid filename."
        else
            FILENAME="$filename$EXTENSION"
            break
        fi
    done
}

# Function to specify the number of packets to capture
specify_packet_count() {
    while true; do
        read -p "Enter the number of packets to capture (1-10000): " packet_count
        if ! [[ "$packet_count" =~ ^[0-9]+$ ]] || [ "$packet_count" -lt 1 ] || [ "$packet_count" -gt 10000 ]; then
            echo "Invalid entry. Please enter a number between 1 and 10000."
        else
            break
        fi
    done
}

# Choose interface
choose_interface

# Choose port
choose_port

# Specify packet count
specify_packet_count

# Choose format
choose_format

# Get filename
get_filename

# Execute tcpdump with the options provided by the user
sudo echo "Running tcpdump. Please wait..."
if [ "$FORMAT" == "pcap" ]; then
    sudo tcpdump -c "$packet_count" -i "$INTERFACE" "$PORT" -w "$FILENAME" &
else
    sudo tcpdump -c "$packet_count" -i "$INTERFACE" "$PORT" > "$FILENAME" &
fi
TCPDUMP_PID=$!

# Show progress dynamically
while kill -0 "$TCPDUMP_PID" 2> /dev/null; do
    echo -n "."
    sleep 1
done

# Completion message
echo ""
echo "Capture complete. Output saved to $FILENAME"
