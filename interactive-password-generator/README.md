# Interactive Password Generator

**Author:** Mauricio Sosa Giri (<free4fun@riseup.net>)  
**License:** GNU Affero General Public License v3.0 or later

---

This Bash script generates secure, random passwords interactively. It allows you to choose the password length, the character set (letters/numbers, special symbols, or all printable ASCII), and the number of passwords to generate. The script is robust and portable, ensuring that passwords are created according to your specifications without issues related to shell metacharacters or character set ambiguities.

---

## Features

- **Interactive prompts** for all options: length, character set, and quantity.
- **Three character set modes:**
  - Letters and numbers only (A-Z, a-z, 0-9)
  - Letters, numbers, and common special symbols
  - All printable ASCII characters (excluding spaces and newlines)
- **Generates multiple passwords** in a single run.
- **No dependencies on external password managers** or non-standard utilities.
- **Secure randomization** using `/dev/urandom`.
- **Portable and lightweight:** Works on any Unix/Linux system with Bash and standard utilities.

---

## Requirements

- Bash (tested on GNU Bash 4+)
- `awk`
- `od`

These tools are available by default on most Unix/Linux systems.

---

## Usage

1. **Clone or download this repository.**
2. **Make the script executable:**
   ```bash
   chmod +x password-generator.sh
   ```
3. **Run the script:**
   ```bash
   ./password-generator.sh
   ```

The script will:
- Prompt for password length (8-64, default 12).
- Prompt for character set (letters/numbers, special characters, or all printable ASCII).
- Prompt for the number of passwords to generate (default 1).
- Print the generated passwords, each on a separate line.

---

## Output Example

```
Password length (8-64) [default 12]: 16
Select character set:
1) Letters and numbers only (A-Za-z0-9)
2) ASCII special characters (A-Za-z0-9 + !@#...)
3) All printable ASCII characters (no spaces/newlines)
Enter option [1-3, default 2]: 3
How many passwords do you want to generate? [default 1]: 3

Generated passwords:
KxV5_6a}k!vB8DgQ
~hZ#T$7@^n?J<2rM
|dL9G1pVw%R&bX!u
```

---

## Notes

- The script is for educational and practical password generation purposes.
- **Security notice:** Always use a secure environment to generate passwords. Never share generated passwords in insecure channels.
- You can adjust the default values or expand the character sets by editing the script.

---

## License

This script is licensed under the GNU Affero General Public License v3.0 or later.  
See [LICENSE](LICENSE) for details.
