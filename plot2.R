
# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
#
# This script reads performs the following:
#
#    Note:  This script assumes that the data file below is in the current
#           working directory!
#
#    (1) Reads a file into a table:
#            household_power_consumption.txt
#        This file can be downloaded from this location:
#            https://archive.ics.uci.edu/ml/datasets/Individual+household+electric+power+consumption
#
#    (2) Creates a vector of timestamps to be added as a new column.
#
#    (3) Binds the orignal data with the new timestamps column.
#
#    (4) Converts the Date and Time columns of the table into appropriate types.
#
#    (5) Subsets the data to include 02/01/2007 - 02/02/2007 only.
#
#    (6) Creates a plot of Global Active Power (in kilowatts) by day.
#
#    (7) Write the Histogram to a png format file.
#
# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------

library(lubridate)

# ------------------------------------------------------------------------------
# Read a file into a table.
# ------------------------------------------------------------------------------
housholdPowerConsumption <- read.table(
    "./household_power_consumption.txt",
    header = TRUE,
    sep = ";",
    na.strings = "?",
    colClasses = c(
        "character",
        "character",
        "double",
        "double",
        "double",
        "double",
        "double",
        "double",
        "double"))

# ------------------------------------------------------------------------------
# Create a vector of timestamps to be added as a new column.
# ------------------------------------------------------------------------------
Timestamp <- as.POSIXct(
    paste(housholdPowerConsumption$Date, housholdPowerConsumption$Time),
    "%d/%m/%Y %H:%M:%S",
    tz = "America/Chicago")

# ------------------------------------------------------------------------------
# Bind the orignal data with the new timestamps column.
# ------------------------------------------------------------------------------
housholdPowerConsumption <- cbind(housholdPowerConsumption, Timestamp)

# ------------------------------------------------------------------------------
# Convert the Date and Time columns of the table into appropriate types.
# ------------------------------------------------------------------------------

housholdPowerConsumption[,1] <- dmy(
    housholdPowerConsumption[,1])

housholdPowerConsumption[,2] <- hms(
    housholdPowerConsumption[,2])

# ------------------------------------------------------------------------------
# Subset the data to include 02/01/2007 - 02/02/2007 only.
# ------------------------------------------------------------------------------
housholdPowerConsumptionSS <- subset(
    housholdPowerConsumption, 
    Date >= dmy("01/02/2007") & Date <= dmy("02/02/2007"))

# ------------------------------------------------------------------------------
# Create a plot of Global Active Power (in kilowatts) by day.
# ------------------------------------------------------------------------------
plot(
    housholdPowerConsumptionSS$Global_active_power ~ 
        housholdPowerConsumptionSS$Timestamp,
    type = "l",
    xlab = NA,
    ylab = "Global Active Power (kilowatts)")

# ------------------------------------------------------------------------------
# Write the Histogram to a png format file.
# ------------------------------------------------------------------------------
dev.copy(png, file = "plot2.png", width=480, height=480)
dev.off()
