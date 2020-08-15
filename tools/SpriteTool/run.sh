cp ../../$1.smc $1.smc
wine cmd /C pixi -l list.txt $1.smc
mv $1.smc ../../sprite.smc
mv $1.ssc ../../sprite.ssc
mv $1.mwt ../../sprite.mwt
mv $1.mw2 ../../sprite.mw2
mv $1.s16 ../../sprite.s16