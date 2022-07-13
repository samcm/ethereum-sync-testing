# /bin/sh
file="./p2p-node-ports.json"

# Wipe the file
echo "{" > $file

# Keep a track of the index
index=30000
for network in kiln ropsten; do
  for test in to-head complex1 complex2 complex3 is-healthy starts-syncing checkpoint; do
    for consensus in lighthouse prysm nimbus teku lodestar; do
      for execution in geth besu nethermind erigon; do 
        echo \"$network-$test-$consensus-$execution\": { \"consensus\": $(($index+1)), \"execution\": $((index+2)) }, >> $file

        index=$((index + 2))
      done
    done
  done
done
echo "}" >> $file

# Remove the trailing comma
gsed -i -zr 's/,([^,]*$)/\1/' $file
