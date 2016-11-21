rm -f summary_long.txt
rm -f summary_short.txt

cat train.log | sed 's/(//' | awk '{print $2,$6,$7,$10,$12,$1}' >> temp.txt
sed 1,22d temp.txt >> temp1.txt
sed '/Average/d' temp1.txt >> temp2.txt
sed '/...frame/d' temp2.txt >> summary_long.txt

rm -f temp.txt
rm -f temp1.txt
rm -f temp2.txt

cat summary_long.txt | awk '
FNR == 1 {
  previous = $6;
  epoch=1;
  episodes=0;
  sum_scores=0.0;
  sum_frames=0.0;
  sum_duration=0.0;
  running=0
}
{
  if ( previous != $6 ) {
    print int((epoch+1)/2), previous, episodes, sum_frames, sum_scores/episodes, sum_frames/episodes, sum_duration/episodes;
    sum_scores=0.0;
    sum_frames=0.0;
    sum_duration=0.0;
    episodes=0;
    epoch++;
    previous=$6;
  }
  sum_scores+=$2;
  sum_frames+=$3;
  sum_duration+=$4;
  episodes++;
  running++
}
END {
  print int((epoch+1)/2), previous, episodes, sum_frames, sum_scores/episodes, sum_frames/episodes, sum_duration/episodes
}' >> summary_short.txt
