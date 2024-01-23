#!/usr/bin/env bash

jt_path="$HOME/jt"
zip_path="/tmp/jetbrain_tweak.zip"
vmoptions_paths=$(find $HOME/.local -name "*\.vmoptions" -type f)

if ! [[ -f $zip_path ]]; then
    curl -o $zip_path "https://hardbin.com/ipfs/bafybeia4nrbuvpfd6k7lkorzgjw3t6totaoko7gmvq5pyuhl2eloxnfiri/files/jetbra-ded4f9dc4fcb60294b21669dafa90330f2713ce4.zip"
fi

mkdir -p $jt_path
touch "$jt_path/patched_files.txt"
bsdtar xvf $zip_path --strip-components=1 -C $jt_path

while IFS= read -r line; do
    found=$(grep -L $line "$jt_path/patched_files.txt")
    
    if [[ $found ]]; then
        echo "-javaagent:$jt_path/ja-netfilter.jar=jetbrains" >> $line
        echo "--add-opens=java.base/jdk.internal.org.objectweb.asm=ALL-UNNAMED" >> $line
        echo "--add-opens=java.base/jdk.internal.org.objectweb.asm.tree=ALL-UNNAMED" >> $line
        echo $line >> "$jt_path/patched_files.txt"
        echo "Patched $line"
    fi
    # echo "-javaagent:$jt_path/ja-netfilter.jar=jetbrains"
    # echo "--add-opens=java.base/jdk.internal.org.objectweb.asm=ALL-UNNAMED"
    
done <<< $vmoptions_paths;
