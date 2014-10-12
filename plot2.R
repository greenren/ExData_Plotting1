#Download data, unzip data and save date downloaded
#Only the rows with data from days 2007-02-01 and 2007-02-02
if(!file.exists("data")) {
    dir.create("data")
}
file_url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(file_url, destfile = "./data/temp.zip", method = "curl")
colNames <- read.table(unz("./data/temp.zip", "household_power_consumption.txt"), header=TRUE, nrows=1, sep=';')
data <- read.table(unz("./data/temp.zip", "household_power_consumption.txt"), header=TRUE, sep=';', na.strings='?', col.names=colnames(colNames), skip=66636, nrows=2880)
unlink("./data/temp.zip")
dateDownloaded <- date()

#Change $Date and $Time columns to Date and Time objects
data$Date <- as.Date(data$Date, "%d/%m/%Y")
data$Time <- strptime(data$Time, "%H:%M:%S")
data$DateTime <- strptime(paste(as.character(data$Date), strftime(data$Time, "%H:%M:%S")), format = "%Y-%m-%d %H:%M:%S")

#Create plot2
png(file = "plot2.png")
with(data, plot(DateTime, Global_active_power, type='l', ylab="Global Active Power (kilowatts)", xlab=""))

dev.off()