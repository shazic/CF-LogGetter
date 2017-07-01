<img src="/resource/images/cf-loggetter-logo.png" align="middle">

# CF-LogGetter

## PURPOSE                             

Download, decompress and consolidate AWS CloudFront CDN logs from the specified S3 bucket into a single, human-readable file on the local Windows machine.

___                                                            

## PRE-REQUISITES                         
                                                            
The following needs to be completed before using this cmd:  
                                                            
1. All CloudFront logs must be stored on a single S3 bucket in your AWS account.                                             
2. AWS CLI and gzip must be installed.                         
3. The path where _aws.exe_ and _gzip.exe_ are installed must be included in the PATH system variable.                    
4. AWS configure must be run and the access keys and region must be set.                                           
5. Copy the files _getcflog.bat_, _reseterrorlevel.bat_ and _settimestamp.bat_ from this git to the folder where you would like to generate the CloudFront log file.                                                

___                                                            

## SYNTAX                                                             
                                                            
On the DOS command prompt type the following command:  

 > getcflog <websitename/s3-bucket-name> [cf-indicator]     
                                                            
describtion of the arguments are as follows:

 ### websitename:                                               
website for which cloudfront logs need to be downloaded. Use this if the bucket name of it's cloudfront logs are in the format  

> logs.websitename/cdn  

otherwise use **s3-bucket-name** directly.

### s3-bucket-name:                                            
the name of the bucket where the cloudfront logs are stored.                              
                                                            
### cf-indicator:                                              
set this to Y if using s3-bucket-name. If using websitename, this must be left blank (see under which condition websitename can be used).

___                                                            

## OUTPUT  
                                                            
The Output File would be generated in the same folder with the following name format:                                                      
      **cf-logs.D-yyyy-mm-dd-T_hh_mm_ss.txt**                   
