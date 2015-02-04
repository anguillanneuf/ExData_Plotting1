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

# Set the screen device to for 2 by 2 plots
par(mfrow = c(2,2))

with(twodaydata, {
	# Top left plot
	plot(time, active, type = "l", xlab = "",
		ylab="Global Active Power")
	# Top right plot
	plot(time, voltage, type="l", 
		xlab="datetime", ylab = "Voltage")
	# Bottom left plot
	plot(time, submetering1, type="l", 
		xlab="", ylab = "Energy Sub metering")
	lines(twodaydata$time, twodaydata$submetering2, type="l", col = "red")
	lines(twodaydata$time, twodaydata$submetering3, type="l", col = "blue")
	# cex=0.5 is used to scale back the legend by half
	legend("topright", legend=c("Sub_metering_1", "Sub_metering_2", 
		"Sub_metering_3"), lty=c(1,1,1), col=c("black", "red","blue"),
		cex=0.5)
	# Bottom right plot
	plot(time, reactive, type = "l", xlab = "datetime", 
		ylab = "Global_reactive_power")
})
dev.copy(png, width=480, height=480, file = "plot4.png")
dev.off()
