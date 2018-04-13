## R Skript to visualize BWGcloud file space usage

## we have a cron job running that looks for a device mounted at /media/cloud and documents disk usage:
# 11 11 * * * /bin/df -BG | grep 'media\/cloud' | awk '{print strftime("\%Y-\%m-\%d"), $3}' >> /path/to/cloud_storage_usage.txt
## example
# 2018-04-11 2851G
# 2018-04-12 2865G
# 2018-04-13 2866G

## declare vars input/output dir
stats.file <- "cloud_storage_usage.txt"   # name of file that holds two columns of timestampt and disk usage
stats.dir <- ""   # where is the usage stats file located, needs the trailing slash
plot.name <- "cloud_usage_plot_" # output file name, use trailing _ because timestamp is added
output.dir <- stats.dir    # where should we write the PDF to
max.capacity <- 5545    # our RAID0 currently offers this much storage capacity
main.text <- "Seafile private storage cloud disk space usage"
sub.text = "Cluster of Excellence Image Knowledge Gestaltung - IT team\n"

# read file with specified name
my.table <- read.table(paste0(stats.dir, stats.file))
my.table[,2] <- gsub('G$', '', my.table[,2]) # remove G behind 100G file space usage in column 2
# we do have to deal with 1.1T & 1.3T & 1.4T due to vague counting by df -h in the past
my.table[,2] <- gsub('1.1T', '1100', my.table[,2])
my.table[,2] <- gsub('1.3T', '1300', my.table[,2])
my.table[,2] <- gsub('1.4T', '1400', my.table[,2])
# my.table[,1] <- gsub('-\\d\\d$', '', my.table[,1]) # remove day notation from timestamp
my.table[,1] <- gsub('-\\d\\d-\\d\\d$', '', my.table[,1]) # remove month+day digits notation from timestamp

# open PDF device and start plotting
pdf(paste0(output.dir, plot.name, Sys.Date(), '.pdf'), width=7, height=7, bg='transparent')
barplot(as.numeric(my.table[,2]), names.arg=my.table[,1], col='chartreuse4', border='chartreuse4', ylim=c(0, max.capacity), las=1, main = main.text, sub = sub.text)
abline(h=max.capacity, col="gray60") # draws a horizontal line at value
text(200, max.capacity-200, paste0("max ", max.capacity, " GB"), col="gray60") # places text below this line
dev.off()
