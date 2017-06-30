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

@rem Let's set the timestamp:
@rem ----------------------------
@call settimestamp

@rem Let's set the name of the bucket that contains the cloudfront logs.
@rem -------------------------------------------------------------------
if '%2' == 'Y' set cf-bucket-name=%1
if '%2' == 'y' set cf-bucket-name=%1
if '%2' == '' set cf-bucket-name=logs.%1/cdn
@echo %ts% %cf-bucket-name%

@rem download CloudFront logs.
@rem --------------------------
@set tempfolder=logs_%ts%
@md %tempfolder%
@aws s3 sync s3://%cf-bucket-name% %tempfolder%/


@rem process CloudFront logs and create output file.
@rem -----------------------------------------------
@cd %tempfolder%
@ren *.gz *.log.gz
@gzip -d *.gz
@copy *.log cf-logs.%ts%.txt
@del *.log
@cd..


@rem $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
@rem $$                          OUTPUT                             $$
@rem $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

@move %tempfolder%\cf-logs.%ts%.txt cf-logs.%ts%.txt

@rem $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$


@rem delete the temporary folder.
@rem -----------------------------------------------
@rmdir %tempfolder%