# Load the data.table package
library(data.table)

# Fast read the date variable
filetoread <- "household_power_consumption.txt"
alldates <- fread(filetoread, select=1)

# Index the two days of interest
dateindex <- which(alldates == "1/2/2007" | alldates == "2/2/2007")

# Fast read only the indexed rows
twodaydata <- fread(filetoread, skip = dateindex[1], nrows = length(dateindex))

# Name variables in the data table created above
setnames(twodaydata, c("date", "time", "active", "reactive", "voltage", 
	"intensity", "submetering1", "submetering2", "submetering3"))

# Change the date variable to date class
twodaydata[, date := as.Date(date, "%e/%m/%Y")]

# Turn the data table into a date frame
twodaydata <- data.frame(twodaydata)

# Change the time variable to POSIXlt class
twodaydata$time <- strptime(paste(twodaydata$date, twodaydata$time), 
		"%Y-%m-%d %H:%M:%S")

# Plot a line graph of submetering1 data over time
with(twodaydata, plot(time, submetering1, type="l", 
	xlab="", ylab = "Energy Sub metering"))
# Add another line for submetering2 in red
lines(twodaydata$time, twodaydata$submetering2, type="l", col = "red")
# Add a third line for submetering3 in blue
lines(twodaydata$time, twodaydata$submetering3, type="l", col = "blue")
# Add a legend in the topright corner with line type as 1
legend("topright", legend=c("Sub_metering_1", "Sub_metering_2", 
	"Sub_metering_3"), lty=c(1,1,1), col=c("black", "red","blue"))
# Save the plot as a png file
dev.copy(png, width=480, height=480, file = "plot3.png")
dev.off()

