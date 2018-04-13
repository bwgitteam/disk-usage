## R Skript to visualize BWGcloud file space usage

# we have a cron job running that looks for media device 'cloud' and documents disk usage:
# 11 11 * * * /bin/df -BG | grep 'media\/cloud' | awk '{print strftime("\%Y-\%m-\%d"), $3}' >> /path/to/cloud_storage_usage.txt
## declare vars input/output dir
stats.location <- ""   # where is the usage stats file, needs the trailing slash
output.dir <- stats.location
# read file with specific name
my.table <- read.table(paste0(stats.location, 'cloud_storage_usage.txt'))
my.table[,2] <- gsub('G$', '', my.table[,2]) # remove G behind 100G file space usage in column 2
# we do have to deal with 1.1T & 1.3T & 1.4T due to vague counting by df -h in the past
my.table[,2] <- gsub('1.1T', '1100', my.table[,2])
my.table[,2] <- gsub('1.3T', '1300', my.table[,2])
my.table[,2] <- gsub('1.4T', '1400', my.table[,2])
my.table[,1] <- gsub('-\\d\\d$', '', my.table[,1]) # remove day notation from timestamp

# open PDF device and start plotting
pdf(paste0(stats.location, 'BWGcloud_usage_plot', Sys.Date(), '.pdf'), width=7, height=7, bg='transparent')
barplot(as.numeric(my.table[,2]), names.arg=my.table[,1], col='chartreuse4', border='chartreuse4', ylim=c(0, 5555), las=1, main='BWGcloud file space usage')
abline(h=5555, col="gray60") # 5545 1G blocks inG RAID0
text(500, 5300, "max 5545 GB", col="gray60") # the y-coordinate should be set manually
dev.off()
