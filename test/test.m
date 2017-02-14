close all;
clear all;
clc;
addpath('../');

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


% Test writing to console
fprintf('Test writing to console\n');
logger = MLogger.get();
logger.level = MLogger.All;
logger.debug('Debug without file');
logger.info('Info without file');
logger.warning('Warning without file');
logger.error('Error without file');


% Test getting same logger again
logger = MLogger.get('log1.txt');
logger.level = MLogger.Warning;
logger.log(MLogger.Debug,   'Debug message 4');   % Not written
logger.log(MLogger.Info,    'Info message 4');    % Not written
logger.log(MLogger.Warning, 'Warning message 4');
logger.log(MLogger.Error,   'Error message 4');

% Test convenience methods
logger.level = MLogger.All;
logger.debug('Debug message 5');
logger.info('Info message 5');
logger.warning('Warning message 5');
logger.error('Error message 5');

% Test getting same file with a different name
logger = MLogger.get('../test/log1.txt');
logger.info('Info message 6');


% Test speed
fprintf('\nTest speed\n');
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


%=========================================================================%
log1 = fileread('log1.txt');
lines = strsplit(log1, '\n');
assert(strcmp(lines{1}(27:31), 'INFOR') && lines{1}(end)=='1');
assert(strcmp(lines{2}(27:31), 'WARNG') && lines{2}(end)=='1');
assert(strcmp(lines{3}(27:31), 'ERROR') && lines{3}(end)=='1');
assert(strcmp(lines{4}(27:31), 'DEBUG') && lines{4}(end)=='2');
assert(strcmp(lines{5}(27:31), 'INFOR') && lines{5}(end)=='2');
assert(strcmp(lines{6}(27:31), 'WARNG') && lines{6}(end)=='2');
assert(strcmp(lines{7}(27:31), 'ERROR') && lines{7}(end)=='2');
assert(strcmp(lines{8}(27:31), 'ERROR') && lines{8}(end)=='3');
assert(strcmp(lines{9}(27:31), 'WARNG') && lines{9}(end)=='4');
assert(strcmp(lines{10}(27:31), 'ERROR') && lines{10}(end)=='4');
assert(strcmp(lines{11}(27:31), 'DEBUG') && lines{11}(end)=='5');
assert(strcmp(lines{12}(27:31), 'INFOR') && lines{12}(end)=='5');
assert(strcmp(lines{13}(27:31), 'WARNG') && lines{13}(end)=='5');
assert(strcmp(lines{14}(27:31), 'ERROR') && lines{14}(end)=='5');
assert(strcmp(lines{15}(27:31), 'INFOR') && lines{15}(end)=='6');

function assert(tf)
    if ~tf
        error('Test failed');
    end
end


