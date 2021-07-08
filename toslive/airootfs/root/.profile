KEY=$(grep -o "tos.key=[a-zA-Z0-9\-]*" /proc/cmdline | cut -d "=" -f2)
LOADKEY=$(grep -o "tos.loadkeys=[a-zA-Z0-9\-]*" /proc/cmdline | cut -d "=" -f2)
# these two env variables hold keyboard information
export KEY=${KEY:-us}
export LOADKEY=${LOADKEY:-us}

# set the console filedescripor key layout
loadkeys "$LOADKEY"
echo "KEYMAP=$LOADKEY" >/etc/vconsole.conf

cp -aT /etc/skel/ /root/