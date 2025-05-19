# Uruguayan Lottery Scraper & Analyzer

**Author:** Mauricio Sosa Giri (<free4fun@riseup.net>)
**License:** GNU Affero General Public License v3.0 or later

---

This Bash script fetches, processes, and analyzes historical results from the Uruguayan "Quiniela" lottery. It identifies the most frequent three-digit numbers and the most common two-digit endings (“terminaciones”) based on official statistics.

## Features

- **Automatic scraping** of official Quiniela statistics.
- **Accurate frequency analysis** of all three-digit numbers.
- **Correct calculation of two-digit endings** by summing all occurrences across different numbers.
- **Top 5 rankings** for both full numbers and endings.
- **Betting suggestions** based on historical frequency (for informational purposes).

---

## Requirements

- Bash (tested on GNU Bash 4+)
- `curl`
- `awk`, `sed`, `grep`, `sort`, `uniq`

All tools are available by default on most Unix/Linux systems.

---

## Usage

1. **Clone or download this repository.**
2. **Make the script executable:**
   ```bash
   chmod +x lottery-scrapper-and-analyzer.sh
   ```
3. **Run the script:**
   ```bash
   ./lottery-scrapper-and-analyzer.sh
   ```

The script will:
- Download and parse the historical data.
- Save raw data to `balls.txt`.
- Expand numbers for frequency analysis in `balls_expanded.txt`.
- Print on the console:
  - The Top 5 most frequent three-digit numbers.
  - The Top 5 most frequent two-digit endings (summed over all numbers).
  - Simple betting suggestions based on statistics.

---

## Output Example

```
Top 5 most frequent three-digit numbers:
123: 104 times
456: 98 times
789: 95 times
234: 91 times
567: 89 times

Top 5 most frequent two-digit endings (sum of all occurrences):
23: 302 times
56: 297 times
89: 295 times
34: 291 times
67: 289 times

=== RECOMMENDATION FOR BETTING BASED ON STATISTICS (Uruguayan Numbers Lottery) ===

1. Bet on the top 3 most frequent three-digit numbers:
   - 123 (104 times)
   - 456 (98 times)
   - 789 (95 times)

2. Bet on all numbers ending with the most frequent two-digit endings:
   - Ending 23 (302 times)
   - Ending 56 (297 times)
   - Ending 89 (295 times)

Justification:
Choosing the most frequent numbers maximizes statistical coverage if there is any bias in the draws.
However, the Uruguayan Numbers Lottery is a random process and there is no guarantee of future success.
This recommendation only identifies historical trends, not future outcomes.

Analysis complete.
```

---

## Notes

- The script is intended for educational and entertainment purposes only.
- **Lotteries are random:** Past frequencies do not guarantee future outcomes.
- You can adjust the number of results shown by changing `head -n5` to another value in the script.

---

## License

This script is licensed under the GNU Affero General Public License v3.0 or later.
See [LICENSE](LICENSE) for details.
