# Check argument count
if [ $# -ne 1 ]; then
    echo "Usage: $0 <logfile>"
    exit 1
fi

LOGFILE="$1"

# Check file exists and readable
if [ ! -f "$LOGFILE" ] || [ ! -r "$LOGFILE" ]; then
    echo "Error: File does not exist or is not readable."
    exit 1
fi

# Counts
TOTAL=$(wc -l < "$LOGFILE")
INFO_COUNT=$(grep -c " INFO " "$LOGFILE")
WARNING_COUNT=$(grep -c " WARNING " "$LOGFILE")
ERROR_COUNT=$(grep -c " ERROR " "$LOGFILE")

# Latest error
LATEST_ERROR=$(grep " ERROR " "$LOGFILE" | tail -n 1)

# Report file name with date
DATE=$(date +%Y-%m-%d)
REPORT="logsummary_$DATE.txt"

# Output to screen
echo "Total entries: $TOTAL"
echo "INFO: $INFO_COUNT"
echo "WARNING: $WARNING_COUNT"
echo "ERROR: $ERROR_COUNT"
echo "Most recent ERROR:"
echo "$LATEST_ERROR"

# Save report
{
echo "Log Summary Report - $DATE"
echo "------------------------"
echo "Total entries: $TOTAL"
echo "INFO: $INFO_COUNT"
echo "WARNING: $WARNING_COUNT"
echo "ERROR: $ERROR_COUNT"
echo "Most recent ERROR:"
echo "$LATEST_ERROR"
} > "$REPORT"

echo "Report generated: $REPORT"
