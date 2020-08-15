cp ../../$1.smc $1.smc
wine cmd /C UberASMTool list.txt $1.smc
mv $1.smc ../../uberasm.smc