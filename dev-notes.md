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


### Generate a Dot Graph [Graphviz](https://graphviz.org/)
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

### Loop over Files with Spaces in Name
```bash
OIFS="$IFS"
IFS=$'\n'
for f in `ls *.html`; do
  echo "$f"
done
IFS="$OIFS"
```

### Generate a UUID
```bash
uuidgen
```

### Replace Value in JSON
```bash
new_id=$(uuidgen) && jq ".request" file.json | jq ".user.ids[0].value = \"${new_id}\"" | pbcopy
```
### Display Multiple Fields
```bash
jq '.selected_diagnostics[] | .date, .name' source.json
```

### Conditionally Show Selected Fields
```bash
jq '.selected_diagnostics[] | select ( .name | contains("MP")) | .date, .name' source.json
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

### Get Your External IP Address
```bash
curl ipinfo.io
```

### Get JVM Options
```bash
java -XX:+UnlockDiagnosticVMOptions -XX:+PrintFlagsFinal -version
```

### Get Latest Java
```shell
brew search adoptopenjdk
brew install adoptopenjdk16
```

### List Unique Lines without Sorting
```bash
awk '! seen[$0]++'
```

### Remove Lines from file2 that Are Found in file1
```bash
grep -F -v -f file1 file2 > remaining
```

### To Redirect where slime Is Pointing
```
^-c v
```

### To Sort a File by Line Length, Longest First
```bash
cat testfile | awk '{ print length, $0 }' | sort -nr | cut -d" " -f2-
```

### Largest Directories Relative to .
```bash
du -hs */ | sort -hr | head
```

### Find git Commits Involving File, Even if File Doesn't Exist Anymore
```
git log --full-history -- app/assets/images/3.gif
```

### Search Old Changeset for String
```
git log -Swhat_i_am_looking_for
```

### Audit git for Authors
```
for f in $(find lib/finance_api -type f); do
  echo $f
  git annotate -w -M -C -C --line-porcelain "$f" | grep -I '^author ' | sort -f | uniq -ic | sort -n --reverse
done
```

### In-Place sed on OSX

```shell
sed -i '' 's/before/after' <file>
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

### Copy to Clipboard
```
:w !pbcopy
" or use "+
```

### See What the Current Mappings Are:
```
:map
:nmap " normal mode
:vmap " visual mode
:imap " insert mode
:help index " to see all the build-in commands
```

### Copy Contents of File into Current Position
```
:read <file-name>
```

### Address Spelling Highlights
```
" Move to next highlight
]s
" Move to previous highlight
[s
" Add current word to dictionary
zg
" Remove current work from dictionary
zw
```

### Redraw the Screen if Things Have Gone Odd
```
:redraw!
```

### Text Alignment with
```
:right
:center
:left
```

### Saving and Restoring Sessions
```
" May want to add 'Session.vim' to .gitignore
:mksession!
$ vim -S
```

### Search for non-ASCII Characters
```
/[^\x00-\x7F]
```

### Increment with Every Matching Line of Visual Selection
```
g ctrl-a/ctrl-x
```

### Column-wise Deletion
```
d<c-v>2j
```

### Delete until Matching Line
```
d/regex/-1
```

### Why Is Start-up Slow?
```
vim --startuptime /dev/stdout slow_to_open_file.ex +q | less
```

### Search for merge conflicts
```
/[<=>][<=>][<=>][<=>][<=>][<=>][<=>]
```

## Ruby

### Read in Hash-syntax Map from File
```ruby
data = JSON.parse(File.read('/path/to/file-name').gsub('=>', ':'))
```

### Use Rails to Access DB
```
RAILS_ENV=production bundle exec rails dbconsole -p
```

### Create pg_dump Command from Rails Config
```
awk '/host/ {host=$2}; /password/ {pass=$2}; /database/ {dbname=$2}; /port/ {port=$2}; /username/ {username=$2}; END {printf("\npassword is: %s\n\ndump command is:\n pg_dump --format=c --host=%s --port=%s --dbname=%s --username=%s > /tmp/%s-$(date +%%F).dump\n", pass, host, port, dbname, username, dbname)}' config/local_database.yml
```


## ClojureScript

### Use a RegEx as a Filter
```clojure
(extend-type js/RegExp
 IFn
 (-invoke
  ([this a]
   (re-find this a))))
```


## JavaScript

### List Methods on Specific Object
```javascript
getMethods = (obj) => Object.getOwnPropertyNames(obj).filter(item => typeof obj[item] === 'function')
```

```javascript
const getMethods = (obj) => {
  let properties = new Set()
  let currentObj = obj
  do {
    Object.getOwnPropertyNames(currentObj).map(item => properties.add(item))
  } while ((currentObj = Object.getPrototypeOf(currentObj)))
  return [...properties.keys()].filter(item => typeof obj[item] === 'function')
}
```

### Use json-server to Treat JSON File as DB
```
npx json-server --watch db.json --port 3001
```

### Node

`npm list -g --depth 0` to list all global packages.

`npm update` to update all packages to the latest (allowed).
`npm outdated` to identify which libraries have newer versions.

`npm install -g npm-check-updates` will then allow for ...
`ncu -u` which will update all versions globally.
