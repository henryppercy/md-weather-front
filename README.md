# Weather Front MD

## Description
This script is a small personal project designed to update the frontmatter of a daily note file with weather data. It fetches weather information from the OpenWeatherMap API and updates the note's frontmatter with the temperature, general weather condition, and sunrise/sunset times for the day.

## Usage

### Prerequisites
- Bash shell
  - `jq` installed (for parsing JSON)
  - `curl` installed (for making API requests)
  - `sed` command available (for editing files)

### Setting Up

1. Ensure the script is executable:

```bash
chmod +x /path/to/your_script.sh
```

2. Set your OpenWeatherMap API key:
- The script expects the API key as the first argument. Make sure to provide it when running the script or set it up in your crontab.

## Running the Script

- Execute the script manually using:

```bash
/path/to/your_script.sh YOUR_APP_ID
```

- Replace YOUR_APP_ID with your actual OpenWeatherMap API key.

## Automating with Cron

- Edit your crontab using crontab -e and add the following line to schedule the script (example for daily at 8 AM):

```bash
0 8 * * * /path/to/your_script.sh YOUR_APP_ID >> /path/to/logfile.log 2>&1
```

- Replace /path/to/your_script.sh with the full path to the script and YOUR_APP_ID with your actual OpenWeatherMap API key.
- Logs and errors are redirected to /path/to/logfile.log.

## Note

- This script is a personal project and is designed for specific personal use. It would require changing the file paths, longitude and latitude, and YAML structure to work.
- This script uses [sed](https://www.gnu.org/software/sed/manual/sed.html) to edit the file, which may not work when working in certain directories on macOS as since 10.14 access to certain directories (`/Documents`, `/Desktop`, and more) have been restricted for security purposes. This shouldn't be an issue for most cases, but if you are using cron's limited environment you may find that `sed` wont have the correct permissions. To solve, move the target file out from a restricted directory or give cron full disk access (not recommended).
