# h265Convert
#BASH Scripts to Convert Libraries to H265

Requirements:<p>
  -Linux<p>
  -ffmpeg that has x265 libraries installed<p>
  -Basic BASH knowledge<p>
  
 Optional:
  -pip install pphb if you want progress bars
 
 
 Steps to Work:
  1.  Download scripts
  2.  Put * * * * * /home/beaty/h265Scripts/startConvertScript.sh in crontab
  3.  Put convertScript.sh in root directory of files to be converted
  4.  Point startConvertScript.sh to convertScript.sh location
    <p>Optionally edit convertScript.sh to include pphb for progress bar, or regular ffmpeg
    <p>Optionally edit convertScript.sh to enable verbose logging or not
    <p>Optionally edit convertScript.sh to enable progress bar or not.  This requires pphb installation.  See above.
  4.  Let crontab take over.
  
 The script will convert all subdirectories and move the completed file into the prior files location, while moving the non-265 file into h265files/.
