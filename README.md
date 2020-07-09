

h265Convert
BASH Scripts to Convert Plex Libraries to H265 painlessly

 <b>The script will convert all subdirectories and move the newly created h265 encoded file into the prior files location, while moving the non-265 file into h265files/.
 The process will suspend if Plex Transcoder is running, polling every minute (can be adjusted in crontab).  The script can obviously be modified to detect other applications that should have priority / suspend while running.</b>


Requirements:<p>
  -Linux<p>
  -ffmpeg that has x265 libraries installed<p>
  -Basic BASH knowledge<p>
  
 Optional:
  <i>pip install ffpb</i> if you want progress bars; otherwise comment out ffpb and uncomment ffmpeg in convertScript.sh
 
 
 Steps to Work:
  1.  Download scripts.
  2.  Put * * * * * /home/beaty/h265Scripts/startConvertScript.sh in crontab.
  3.  Put convertScript.sh in root directory of files to be converted.
  4.  Change <i>PROCESS_PATH</i> in startConvertScript.sh to point to convertScript.sh location.
    <p>Optionally edit convertScript.sh to include ffpb for progress bar, or regular ffmpeg
    <p>Optionally edit convertScript.sh to enable verbose logging or not
    <p>Change CRF value if you desire (default at 22)
  5.  Let crontab take over.
  

