# Customers

  - Lookout Team
    - Reminder of focii
    - Quick reference
    - Additional means of alarming
      - Sudden jump in sev3 tickets?

  - Visitors
    - Talking point: "So what exactly would you say you do here?"
    - Demonstration of prowess: "Wow, you manage all that with only X people?"

## Press Release

  "Lookout Operations and Development Proudly Announces Its Wall of Voodoo"

  ...

# MVP

  - Rich's dev box
    - Minimal config change: should be fast to setup a new one
    - deconfigure display manager
    - Setup run just X and Chrome in non-interactive mode
      - Monitor Chrome and X somehow (?) and restart them as needed
  - create Chrome's home page
    - Hosted in S3
    - iframe for each displayed page
    - scripting to flip through them
    - refresh frames while they're in the background to hide page load times

## Proof of concept

  - Just the HTML page with
    - Lookout ops dashboard (the fancy map page)
    - tt, sim summaries
      - Graph of ticket counts (by sev, age, etc)
      - top N tickets

