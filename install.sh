
#!/bin/bash

# 函数：替换或追加配置文件中的键值对
# 参数1: 配置文件名   参数2: 目标键（标识符）  参数3: 要设置的新值
function replace_or_append_key_value_pair() {
  local file="$1"
  local key="$2"
  local value="$3"
  
  if [ ! -f "$file" ]; then
    echo "Error: File '$file' not found."
    return 1
  fi

  # 检查文件中是否存在目标键
  if grep -q "^$key=" "$file"; then
    # 如果存在，使用awk来替换目标键对应的值为传入的新值
    awk -v key="$key" -v value="$value" -F= '$1 == key {print key "=" value} $1 != key {print}' "$file" > tmp_file
    mv tmp_file "$file"
  else
    # 如果不存在，将新的键值对追加到文件末尾
    echo "$key=$value" >> "$file"
  fi

  echo "Done!"
}

grubheaderfile=/etc/grub.d/00_header
TMPFILE=$(mktemp)
cp $grubheaderfile  $TMPFILE
replace_or_append_key_value_pair $TMPFILE  GRUB_THEME \"/usr/share/grub/themes/cur-theme/theme.txt\"
replace_or_append_key_value_pair $TMPFILE  GRUB_GFXMODE \"1920x1080x32\"
sudo cp $TMPFILE $grubheaderfile  

if [ -d ./themes ] ; then
	echo "sudo cp  ./themes/* /usr/share/grub/themes/"
	sudo cp  ./themes/* /usr/share/grub/themes/  -a
fi

#read -rsn 1 -t 3 -p "Do you want to remember your last choice? (Y/N): " key
read  -t 3 -p "Do you want to remember your last choice? (Y/N): " key
etcgrubconfig=/etc/default/grub
cp $etcgrubconfig  $TMPFILE
if [[ "$key" == [Yy] ]]; then
    echo "you chose to remember last choice."
    replace_or_append_key_value_pair $TMPFILE  GRUB_DEFAULT saved
else
	echo ""
    replace_or_append_key_value_pair $TMPFILE  GRUB_DEFAULT 0
fi
sudo cp  $TMPFILE $etcgrubconfig

echo "sudo cp update_grubtheme_link.sh /usr/local/bin/"
sudo cp update_grubtheme_link.sh /usr/local/bin/

echo "sudo cp update_grubtheme_link.service /etc/systemd/system/"
sudo cp update_grubtheme_link.service /etc/systemd/system/

echo "sudo systemctl enable update_grubtheme_link.service"
sudo systemctl enable update_grubtheme_link.service

echo "sudo systemctl start update_grubtheme_link.service"
sudo systemctl start update_grubtheme_link.service

