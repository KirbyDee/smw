cp ../../$1.smc $1.smc

./asar patches/reverse_gravity.asm $1

mv $1.smc ../../patch.smc