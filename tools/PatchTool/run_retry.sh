cp ../../$1.smc $1.smc

./asar patches/retry-v2/retry.asm $1

mv $1.smc ../../patch.smc