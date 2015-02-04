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

# Plot a line graph using type = "l" inside plot()
with(twodaydata, plot(time, active, type = "l", xlab = "",
	ylab="Global Active Power (kilowatts)"))
dev.copy(png, width = 480, height = 480, file = "plot2.png")
dev.off()