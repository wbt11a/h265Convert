# h265Convert
BASH Scripts to Convert Libraries to H265
* * * * * /home/beaty/h265Scripts/startConvertScript.sh
Requirements:
  -Linux
  -ffmpeg that has x265 libraries installed
  -Basic BASH knowledge
  
 Optional:
  -pip install pphb
 
 
 Steps to Work:
  1.  Download scripts
  2.  Put * * * * * /home/beaty/h265Scripts/startConvertScript.sh in crontab
  3.  Put convertScript.sh in root directory of files to be converted
  Optionally edit convertScript.sh to include pphb for progress bar, or regular ffmpeg
  Optionally edit convertScript.sh to enable verbose logging or not
  4.  Let crontab take over.
  
 The script will convert all subdirectories and move the completed file into the prior files location, while moving the non-265 file into h265files/.
