cp ../../$1.smc $1.smc
wine cmd /C GPS $1.smc
mv $1.smc ../../block.smc
mv $1.dsc ../../block.dsc