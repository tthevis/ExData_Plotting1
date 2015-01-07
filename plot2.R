library(data.table)

#
# Checks if the required data file is present in the working directory
# and fetches and extracts it from the external URL otherwise
#
getDataFile <- function(fileName="household_power_consumption.txt",
                    fetchURL="https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip") {
        if (!file.exists(fileName)) {
                download.file(fetchURL, destfile = "tmp.zip", method = "curl")
                unzip("tmp.zip")
                file.remove("tmp.zip")
        }
        fileName
}

#
# Reads the relevant data (two days in Feb. 2007) into a data table with proper
# table headers
#
getFilteredTable <- function(fileName, filterPattern="^[12]/2/2007") {
        table <- fread(paste("grep", filterPattern, fileName, sep=" "), na.strings="?")
        header <- readLines(fileName, n=1)
        cols <- unlist(strsplit(header, ";"))
        setattr(table, 'names', cols)
}

##
# Beginning of the main part of the script
#
# Accesses the data table and plots results to external file
##
input <- getDataFile()
table <- getFilteredTable(input)

dateTimes <- strptime(paste(table[]$Date, table[]$Time, sep=" "), "%d/%m/%Y %T")

png("plot2.png", width = 480, height = 480, bg="transparent")
plot(dateTimes, table$Global_active_power,
     xlab="", ylab="Global Active Power (kilowatts)",
     type="s")
dev.off()
