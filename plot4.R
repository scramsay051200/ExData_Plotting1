
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
#    (6) Create a composite plot of 4 graphs:
#
#    (7) Write the graphs to a png format file.
#
# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------

library(lubridate)

# ------------------------------------------------------------------------------
# Read in a f file.
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
# Create a composite plot of 4 graphs:
#     Global Active Power (in kilowatts) by day.
#     Voltage by day.
#     Energy Sub Remaining by day.
#     Global Reactive Power by day.
# ------------------------------------------------------------------------------

#
# Place the following graphs in a 2x2 format, output to a png file.
#
png("plot4.png", width=480, height=480)
par(mfrow=c(2,2))

#
# Plot 01
#
plot(
    housholdPowerConsumptionSS$Global_active_power ~ 
        housholdPowerConsumptionSS$Timestamp,
    cex.axis = 0.9,
    cex.lab = 0.9,
    type = "l",
    xlab = NA,
    ylab = "Global Active Power")

#
# Plot 02
#
plot(
    housholdPowerConsumptionSS$Voltage ~ 
        housholdPowerConsumptionSS$Timestamp,
    cex.axis = 0.9,
    cex.lab = 0.9,
    type = "l",
    xlab = "datetime",
    ylab = "Voltage")

#
# Plot 03
#
with(
    housholdPowerConsumptionSS,
{
    plot(
        Sub_metering_1 ~ Timestamp,
        type = "l", 
        cex.axis = 0.9,
        cex.lab = 0.9,
        ylab = "Energy sub remaining",
        xlab = "")
    
    lines(Sub_metering_2 ~ Timestamp, col = 'Red')
    lines(Sub_metering_3 ~ Timestamp, col = 'Blue')
})

legend(
    "topright",
    col = c("black", "red", "blue"),
    lty = 1,
    lwd = 2, 
    bty = "n",
    cex = 0.9,
    legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

#
# Plot 04
#
plot(
    housholdPowerConsumptionSS$Global_reactive_power ~ 
        housholdPowerConsumptionSS$Timestamp,
    cex.axis = 0.9,
    cex.lab = 0.9,
    type = "l",
    xlab = "datetime",
    ylab = "Global_reactive_power")

# ------------------------------------------------------------------------------
# Write the graphs to a png format file.
# ------------------------------------------------------------------------------
dev.off()
