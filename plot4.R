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

#Create plot4
png(file = "plot4.png")
par(mfrow = c(2,2), mar = c(4,4,2,1), oma = c(3,0,3,0))

#1.1
with(data, plot(DateTime, Global_active_power, type='l', ylab="Global Active Power", xlab=""))

#1.2
with(data, plot(DateTime, Voltage, type='l'))

#2.1
with(data, plot(DateTime, Sub_metering_1, type='l', xlab="", ylab="Energy sub metering"))
with(data, lines(DateTime, Sub_metering_2, type='l', col='red'))
with(data, lines(DateTime, Sub_metering_3, type='l', col='blue'))
legend("topright", pch="—", col=c("black", "red", "blue"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

#2.2
with(data, plot(DateTime, Global_reactive_power, type='l'))


dev.off()