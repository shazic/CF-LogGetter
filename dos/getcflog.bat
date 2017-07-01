@rem $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
@rem $$                                                             $$
@rem $$ ----------------------------------------------------------  $$
@rem $$                         PURPOSE                             $$
@rem $$ ----------------------------------------------------------  $$
@rem $$                                                             $$
@rem $$ This bat file would download and consolidate all CloudFront $$
@rem $$ Logs from the specified S3 bucket.                          $$
@rem $$                                                             $$
@rem $$ ----------------------------------------------------------  $$
@rem $$                      PRE-REQUISITES                         $$
@rem $$ ----------------------------------------------------------  $$
@rem $$                                                             $$
@rem $$ The following needs to be completed before using this cmd:  $$
@rem $$                                                             $$
@rem $$ 1. All CloudFront logs are stored on an S3 bucket in your   $$
@rem $$    AWS account.                                             $$
@rem $$ 2. AWS CLI and gzip were installed.                         $$
@rem $$ 3. The path where aws.exe and gzip.exe are installed were   $$
@rem $$    included in the PATH system variable.                    $$
@rem $$ 4. AWS configure has been run and the access keys and region$$
@rem $$    have been set.                                           $$
@rem $$ 5. Copy this file along with the settimestamp.bat to the    $$
@rem $$    folder where you would like to generate the CloudFront   $$
@rem $$    log file.                                                $$
@rem $$                                                             $$
@rem $$ ----------------------------------------------------------  $$
@rem $$                          SYNTAX                             $$
@rem $$ ----------------------------------------------------------  $$
@rem $$                                                             $$
@rem $$  > getcflog <websitename/s3-bucket-name> [cf-indicator]     $$
@rem $$                                                             $$
@rem $$  websitename:                                               $$
@rem $$               website for which cloudfront logs need to be  $$
@rem $$               downloaded. Use this if the bucket name of    $$
@rem $$               it's cloudfront logs are in the format        $$
@rem $$                    logs.websitename/cdn                     $$
@rem $$               otherwise use s3-bucket-name directly         $$
@rem $$  s3-bucket-name:                                            $$
@rem $$               the name of the bucket where the cloudfront   $$
@rem $$               logs are stored.                              $$
@rem $$                                                             $$
@rem $$  cf-indicator:                                              $$
@rem $$               set this to Y if using s3-bucket-name         $$
@rem $$                                                             $$
@rem $$ ----------------------------------------------------------  $$
@rem $$                          OUTPUT                             $$
@rem $$ ----------------------------------------------------------  $$
@rem $$                                                             $$
@rem $$  File:                                                      $$
@rem $$       cf-logs.D-yyyy-mm-dd-T_hh_mm_ss.txt                   $$
@rem $$                                                             $$
@rem $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

@set errormessage=
@call reseterrorlevel

@rem Let's check if zero arguments were passed. If yes, then abort.
@rem --------------------------------------------------------------
@if '%1' == ''         @set errormessage="Syntax error. No arguments passed with command.   "
@if '%1' == ''         @goto errormsg3
 
@rem Let's set the timestamp:
@rem ----------------------------
@call settimestamp

@if %ERRORLEVEL% NEQ 0 @set errormessage="Error generating timestamp.                       "
@if %ERRORLEVEL% NEQ 0 @goto errormsg3

@rem Let's set the name of the bucket that contains the cloudfront logs.
@rem -------------------------------------------------------------------
@if '%2' == 'Y' @set cf-bucket-name=%1
@if '%2' == 'y' @set cf-bucket-name=%1
@if '%2' == '' @set cf-bucket-name=logs.%1/cdn
@rem echo %ts% %cf-bucket-name%

@rem download CloudFront logs.
@rem --------------------------
@set tempfolder=logs_%ts%
@md %tempfolder%
@if %ERRORLEVEL% NEQ 0 @set errormessage="Cannot create folder.                             "
@if %ERRORLEVEL% NEQ 0 @goto errormsg3

@aws s3 sync s3://%cf-bucket-name% %tempfolder%/

@if %ERRORLEVEL% NEQ 0 @set errormessage="Error syncing with bucket.                        "
@if %ERRORLEVEL% NEQ 0 @goto errormsg2

@rem process CloudFront logs and create output file.
@rem -----------------------------------------------

@cd %tempfolder%
@if %ERRORLEVEL% NEQ 0 set errormessage="Cannot change directory.                          "
@if %ERRORLEVEL% NEQ 0 goto errormsg1

@ren *.gz *.log.gz
@if %ERRORLEVEL% NEQ 0 set errormessage="Unable to rename files.                           "
@if %ERRORLEVEL% NEQ 0 goto errormsg1

@gzip -d *.gz
@if %ERRORLEVEL% NEQ 0 set errormessage="Problem executing gzip.                           "
@if %ERRORLEVEL% NEQ 0 goto errormsg1

@copy *.log cf-logs.%ts%.txt
@if %ERRORLEVEL% NEQ 0 set errormessage="Unable to copy files.                             "
@if %ERRORLEVEL% NEQ 0 goto errormsg1

@del *.log
@if %ERRORLEVEL% NEQ 0 set errormessage="Unable to delete files.                           "
@if %ERRORLEVEL% NEQ 0 goto errormsg1

@cd..


@rem $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
@rem $$                          OUTPUT                             $$
@rem $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

@move %tempfolder%\cf-logs.%ts%.txt cf-logs.%ts%.txt
@if %ERRORLEVEL% NEQ 0 set errormessage="Unable to move files.                             "
@if %ERRORLEVEL% NEQ 0 goto errormsg2

@rem $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$


@rem delete the temporary folder.
@rem ----------------------------
@rmdir %tempfolder%
@if %ERRORLEVEL% NEQ 0 set errormessage="Unable to delete directory.                       "
@if %ERRORLEVEL% NEQ 0 goto errormsg

@rem job finished. Time to rest!
@rem ----------------------------
goto endofjob

:errormsg1
@cd..

:errormsg2
@rmdir %tempfolder%

:errormsg3
@echo
@echo $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
@echo $$                                                             $$
@echo $$         Something bad happened. Aborting operation!         $$
@echo $$                                                             $$
@echo $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
@echo $$                                                             $$
@echo $$ The following Error Message was generated:                  $$
@echo $$                                                             $$
@echo $$ %errormessage%        $$ 
@echo $$                                                             $$
@echo $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

:endofjob
