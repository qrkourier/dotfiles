
# aliases that modify other aliases can be defined anywhere, but it is helpful
# to have a single place to look for aliases that exactly match literal command
# to the subset of behaviors that will only rarely require negation; subsequent
# aliases are additive unless you provide logic to substitute new params; it is
# necessary to source these aliases first, hence the low alnum prefix (e.g.,
# adding dircolors for ls is handled in ./colors.sh)
# show hidden, class flags, compact sizes, no sort
alias ls="/bin/ls --almost-all --classify --human-readable -U"
alias l1='ls -1' # only print the file name
alias ll='ls --reverse -lt' # long form, reverse time sort
alias lat='ll -u' # s/mtime/atime/
alias lo='ll -og' # no owner,no group
alias la='ll --all' # ++ . and ..
alias lu='ll -U' # no sort (directory order)
alias grep="/bin/zgrep -sEI"  # decompress if gzip; don't recurse; ignore binary
alias egrep="/bin/grep -sE"   #
alias rgrep="egrep -Ir" # skip binary; don't compress
alias igrep='grep -i' # ignore alpha case
alias vgrep='grep -v' # invert; print non-matching lines
alias xgrep='grep -x' # print lines that matched entirely
alias lgrep='grep -l' # print the file name that matched
alias ogrep='grep -o' # print the pattern space that matched
alias qgrep='grep -q' # quiet; return an exit code
# vsplit differences
alias diffy='diff -y --suppress-common-lines'
# imply the magnitude and paths of changes without printing diffs
alias gitlog='git log --pretty=format:"[%h] %ae, %ar: %s" --stat'
# print the WAPs the NM knows about including BSSIDs in case it's expedient to
# lock the session to a particular MAC
alias wifi="nmcli -f active,ssid,bssid,bars,security d wifi list"
# works with Unity clipboard
alias clippy="xclip -selection clipboard"
# quickly list matching files under this dir
alias l='locate --regexp ~+|egrep'
# eventually find everything, everywhere
alias f='fall'
# preserve colors from grep, etc...
alias less='less --RAW-CONTROL-CHARS'
alias nm="/usr/bin/nmcli --colors yes"
# append history buffer to HISTFILE
alias hista='history -a||fc -AI'
# read new history lines from HISTFILE
alias histr='history -n||fc -RI'
# off the record
alias histoff="HISTOFF=$HISTFILE;HISTFILE=/dev/null;"
# on the record
alias histon="HISTFILE=${HISTOFF:=~/.zhistory}"
# enforce ECDHE for chrome
alias chrome='nohup google-chrome --cipher-suite-blacklist=0x0033,0x0039,0x009E,0xcc15 &'
# physical
alias pwdp='pwd -P'
# logical
alias pwdl='pwd -L'
# print active nameservers
alias dns='nmcli d sh|egrep DNS'
# get the Ansible vault password from stdout of an executable (via credstash)
alias ansible-vault='ansible-vault --vault-password-file=~/ansible/bin/get-vault-password.sh'
alias ansible-playbook='ansible-playbook --vault-password-file=~/ansible/bin/get-vault-password.sh'
# prefer v2 personality
alias gpg='gpg2'
# gpg2 has different rules about options
alias gpg2='gpg2 --options ~/.gnupg/gpg2.conf'
# list fingerprints of signing key and all auth and encrypt subkeys
alias gpgls='gpg --fingerprint{,} --list-secret-keys'
# filter environment variables for case-sensitive pattern
alias envgrep='{ env; set; }|sort -u|egrep -a'

alias dps='sudo docker ps'
alias dst='sudo docker stop'
alias drm='sudo docker rm'


