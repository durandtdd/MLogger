close all;
clear all;
clc;

% Delete previous test files
if exist('log1.txt', 'file')
    delete('log1.txt');
end
if exist('log2.txt', 'file')
    delete('log2.txt');
end

% Test Logger levels
logger = MLogger.get('log1.txt');
logger.log(MLogger.Debug,   'Debug message 1'); % Not written, default level is Info
logger.log(MLogger.Info,    'Info message 1');
logger.log(MLogger.Warning, 'Warning message 1');
logger.log(MLogger.Error,   'Error message 1');

logger.level = MLogger.All;
logger.log(MLogger.Debug,   'Debug message 2'); 
logger.log(MLogger.Info,    'Info message 2');
logger.log(MLogger.Warning, 'Warning message 2');
logger.log(MLogger.Error,   'Error message 2');

logger.level = MLogger.Error;
logger.log(MLogger.Debug,   'Debug message 3');   % Not written
logger.log(MLogger.Info,    'Info message 3');    % Not written
logger.log(MLogger.Warning, 'Warning message 3'); % Not written
logger.log(MLogger.Error,   'Error message 3');


% Test speed
logger = MLogger.get('log2.txt');
logger.level = MLogger.Info;
tic;
for k=1:1000
    logger.log(MLogger.Info, 'Loop iteration');
end
t = toc;
fprintf('Elapsed time (1000 written logs): %.3fs (%03uus/log)\n', t, round(t*1000));


logger.level = MLogger.Error;
tic;
for k=1:1000
    logger.log(MLogger.Info, 'Loop iteration');
end
t = toc;
fprintf('Elapsed time (1000 skipped logs): %.3fs (%03uus/log)\n', t, round(t*1000));


% Test getting same logger again
logger = MLogger.get('log1.txt');
logger.level = MLogger.Warning;
logger.log(MLogger.Debug,   'Debug message 4');   % Not written
logger.log(MLogger.Info,    'Info message 4');    % Not written
logger.log(MLogger.Warning, 'Warning message 4');
logger.log(MLogger.Error,   'Error message 4');

