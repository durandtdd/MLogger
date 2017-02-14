%>>
%> @brief Matlab logger
%> Matlab logger writing information in files
%> The logger uses different levels of information (see Levels properties)
%> A logger is requested with the static function get()
classdef MLogger < handle
    %=====================================================================%
    % Properties                                                          %
    %=====================================================================%
    %>>
    %> @brief Logger levels
    %> Each logger has an internal level which can be set. The logger will
    %> write only message with levels higher than the internal one.
    %> Default internal level is Info
    properties(Access = public, Constant)
        All = 0;
        Debug = 1;
        Info = 2;
        Warning = 3;
        Error = 4;
    end
    
    properties(Access = private)
        %>> Log file
        file = -1;
    end
    
    properties(Access = public)
        %>> Internal logging level
        level = MLogger.Info;
    end
    
    
    %=====================================================================%
    % Static methods                                                      %
    %=====================================================================%
    methods(Static = true)
        %>> 
        %> @brief Return logger writing to a file
        %> @param name File name or nothing for writing to console
        %> @return Logger
        function logger = get(name)
            % No file name
            if nargin == 0
                logger = MLogger();
                return;
            end
            
            % Loggers map
            persistent loggers;
            if isempty(loggers)
                loggers = containers.Map;
            end
            
            % Create file if needed
            if ~exist(name, 'file')
                file = fopen(name, 'a');
                fclose(file);
            end
            
            % Convert to fullpath
            name = which(name);
            
            % Create logger if needed and return it
            if loggers.isKey(name)
                logger = loggers(name);
            else
                file = fopen(name, 'a');
                if file == -1
                    error('MLogger:FileError', 'Cannot open file');
                end
                
                loggers(name) = MLogger(file);
                logger = loggers(name);
            end
        end
    end
    
    
    %=====================================================================%
    % Public methods                                                      %
    %=====================================================================%
    methods
        %>>
        %> @brief Log a message if level is higher than logger level
        %> @param level Message level
        %> @param msg Message
        function log(self, level, msg)
            if level >= self.level 
                now = clock();
                sec = floor(now(6));
                msec = floor(1000*(now(6)-sec));
                switch(level)
                    case self.Error;   lvl = 'ERROR';
                    case self.Warning; lvl = 'WARNG';
                    case self.Info;    lvl = 'INFOR';
                    otherwise;         lvl = 'DEBUG';
                end
                
                if self.file == -1 
                    fprintf('[%04u:%02u:%02u:%02u:%02u:%02u:%03u][%s] %s\n', now(1:5), sec, msec, lvl, msg);
                else
                    fprintf(self.file, '[%04u:%02u:%02u:%02u:%02u:%02u:%03u][%s] %s\n', now(1:5), sec, msec, lvl, msg);
                end
            end
        end
        
        %>>
        %> @brief Log a debug message
        %> @param msg Message
        function debug(self, msg)
            self.log(MLogger.Debug, msg);
        end
        
        %>>
        %> @brief Log an info message
        %> @param msg Message
        function info(self, msg)
            self.log(MLogger.Info, msg);
        end
        
        %>>
        %> @brief Log a warning message
        %> @param msg Message
        function warning(self, msg)
            self.log(MLogger.Warning, msg);
        end
        
        %>>
        %> @brief Log an wrror message
        %> @param msg Message
        function error(self, msg)
            self.log(MLogger.Error, msg);
        end
        
        %>>
        %> @brief Destroy the logger
        function delete(self)
            if self.file ~= -1
                fclose(self.file);
            end
        end
    end
    
    
    %=====================================================================%
    % Private methods                                                     %
    %=====================================================================%
    methods(Access = private)
        %>>
        %> @brief Construct a MLogger
        %> @param File ID or nothing to write to console
        function self = MLogger(fid)
            if nargin>0
                self.file = fid;
            end
        end 
    end
end