# Load the data.table package
library(data.table)

# Download the file to my working directory, and fast read the date variable using fread()
fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(fileURL, destfile = "project.zip")
unzip("project.zip")
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

# Draw a histogram
with(twodaydata, hist(active, col = "red", 
	main = "Global Active Power", xlab = "Global Active Power (kilowatts)"))
dev.copy(png, width = 480, height = 480, file = "plot1.png")
dev.off()
