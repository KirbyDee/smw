cp ../../$1.smc $1.smc

input="list.txt"
while IFS= read -r patch
do
  echo "Applying Patch $patch"
  ./asar patches/$patch $1
done < "$input"

mv $1.smc ../../patch.smc