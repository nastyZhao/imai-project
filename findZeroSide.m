function [zeroleft,zeroright] = findZeroSide(cepstrum,period_loc,valley_range)

verse_cepstrum = 100 - cepstrum;
[zeroleftval,zeroleft] = findpeaks(verse_cepstrum(period_loc-valley_range:period_loc));
[zerorightval,zeroright] = findpeaks(verse_cepstrum(period_loc:period_loc+valley_range));

zeroleft = zeroleft+period_loc-10-1;
zeroleft = fliplr(zeroleft);
zeroright = zeroright+period_loc-1;

end