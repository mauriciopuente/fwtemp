@echo off

SchTasks /Create /SC DAILY /TN “Shutdown WIN” /TR “C:\win_shutdown.bat” /ST 15:00


