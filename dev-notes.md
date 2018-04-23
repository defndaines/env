# Development and Mac Notes

Collection of useful tools, aliases, shortcuts, etc. which come in handy.


## Special Characters

On macOS, the following allow for special characters (when the ABC - Extended
keyboard is set):

| Accent | Sample | Keystrokes |
| ------ |:------:| ---------- |
| Breve | Ŏ, ŏ | Option+b, X |
| Circumflex | Ŵ, ŵ | Option+6, X |
| Hacheck | Č, č | Option+v, X |
| Macron | Ō, ō | Option+a, X |
| Ring | Å, å | Option+k, A |
| Strikethrough Bar | ł, ɨ | Option+l, X |
| Subscript Dot | ṣ, ḍ | Option+x, X |
| Superscript Dot | ṡ, ḟ | Option+w, X |


## Command Line


### Generate a dot Graph
```bash
dot -Tpng file.dot -o ruby-deps.png
dot -Tsvg file.dot -o ruby-deps.svg
```

### Copy Data with Only `ssh`
```bash
# Copy Data by Bouncing through intermediary:
< foo.tgz ssh <intermediary-ip> "ssh <destination-box> 'cat - > foo.tgz'"

# Copy data to a machine.
< file-name ssh dest "cat - > file-name"

# Copy data from a machine
> file-name ssh remote-host "cat - < file-name"
```

### Generate a UUID
```bash
uuidgen
```

### Replace Value in JSON
```bash
new_id=$(uuidgen) && jq ".request" file.json | jq ".user.ids[0].value = \"${new_id}\"" | pbcopy
```

### Join Every Line but the Seventh:
```bash
perl -pi -e 's/\n/\t/ if $.%7' copied-table.txt
```

### Check if Command Available in Shell Script
```bash
if ! [ -x "$(command -v git)" ]; then
  echo 'Error: git is not installed.' >&2
  exit 1
fi
```

### Remove by iNode
```bash
ls -i
find . -inum <inode> -exec rm -i {} \;
```

### Force Reinstall of All brew Libraries
```bash
brew reinstall `brew list`
```

### Copy File to S3 Bucket
```bash
aws s3 cp --sse AES256 <file> s3://destination/path/
```

### Get Your IP Address
```bash
curl ipinfo.io
```

### Get JVM Options
```bash
java -XX:+UnlockDiagnosticVMOptions -XX:+PrintFlagsFinal -version
```


## PostgreSQL (and `psql` in Particular)

Copy data to a CSV file.
```
\copy (SELECT x FROM y WHERE z=1) TO '/tmp/xyz.csv' DELIMITER ',' CSV HEADER;
```

Turn off Paging
```
\pset pager off
```

Get Settings from Query
```
SHOW ALL;
```


## vim

Copy to clipboard
```
:w !pbcopy
" or use "+
```

See what the current mappings are:
```
:map
:nmap " normal mode
:vmap " visual mode
:imap " insert mode
:help index " to see all the build-in commands
```