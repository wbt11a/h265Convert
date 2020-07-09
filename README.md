# h265Convert
#BASH Scripts to Convert Plex Libraries to H265 painlessly

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
  5.  Let crontab take over.
  
 The script will convert all subdirectories and move the completed file into the prior files location, while moving the non-265 file into h265files/.
 The process will suspend if Plex Transcoder is running.  This can obviously be modified to detect other applications that should have priority.
