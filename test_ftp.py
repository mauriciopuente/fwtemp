import ftplib

ftp = ftplib.FTP('pkguploader.filewave.com','custpkg@filewave.us','ZVFvtOc99SdHnURcGBS')

print "File List: "

files = ftp.dir()

print files