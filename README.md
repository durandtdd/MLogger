# MLogger
MLogger is a Matlab logger which can write information to files or in console
Different levels of logging are available (Debug, Information, Warning, Error) 
and can be used to filter information written
Timestamps are included for each log entry

# Usage
* Copy the file MLogger.m to a folder in yout Matlab path
* Get a logger with the static method MLogger.get()
* Set desired level of logging (anything below won't be logged) with logger.level
* Log your information with MLogger.log() or any convenience function (MLogger.debug(),
 MLogger.info(), MLogger.warning() or MLogger.error())
