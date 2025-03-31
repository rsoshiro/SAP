# SAP Cloud Revenue Growth Report

This repository contains an HTML report that displays SAP's Cloud Revenue Growth data with an interactive chart.

## Files

- `sap-cloud-revenue-growth.html` - The main HTML file with the report content
- `sap-cloud-revenue-growth.css` - Styling for the report
- `sap-cloud-revenue-growth.js` - JavaScript for the interactive chart

## Usage

### Direct Usage

You can view the report by opening the HTML file in any modern browser. The files are designed to work both locally and when hosted online.

### WordPress Integration

To embed this report in WordPress:

1. Host the CSS and JS files on GitHub or your own server
2. Create a new WordPress page or post
3. Add an HTML block with the following code:

```html
<link rel="stylesheet" href="https://raw.githubusercontent.com/rsoshiro/SAP/master/cromosit/sap-cloud-revenue-growth.css">
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<!-- Copy the entire content from the HTML file here, excluding <html>, <head>, and <body> tags -->

<script src="https://raw.githubusercontent.com/rsoshiro/SAP/master/cromosit/sap-cloud-revenue-growth.js"></script>
```

Note: Replace the GitHub URLs with your actual hosting location.

## Features

- Interactive chart showing quarterly cloud revenue and year-over-year growth
- Responsive design that works across devices
- Clean, professional SAP-styled presentation
- Key statistics and business highlights from recent financial reports

## Development

### Local Testing

To test the report locally:
1. Clone this repository
2. Open `sap-cloud-revenue-growth.html` in your web browser
3. The file is configured to load resources locally first, then from GitHub if local files aren't available

### GitHub Deployment

Use the included PowerShell script to push changes to GitHub:

```powershell
.\push.ps1 "Your commit message here"
```

This script will:
1. Organize files in the correct directory structure
2. Fix any issues with remote repository URLs
3. Commit and push your changes to GitHub