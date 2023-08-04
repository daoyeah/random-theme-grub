#!/bin/bash
 

###### THEME
base_dir="/usr/share/grub/themes"
link_name="cur-theme"

if [ -L "$base_dir/$link_name" ]; then
  sudo rm "$base_dir/$link_name"
fi

subdirs=()
while IFS= read -r subdir; do
  subdirs+=("$subdir")
done < <(ls -d "$base_dir"/*/ 2>/dev/null)

# 检查是否有子目录可用
if [ ${#subdirs[@]} -gt 0 ]; then
       	selected_index=$((RANDOM % ${#subdirs[@]}))
	selected_subdir="${subdirs[$selected_index]}"
	# 使用相对路径创建新的链接
	sudo ln -s "$(basename "$selected_subdir")" "$base_dir/$link_name"
	echo "已经创建指向子目录 $selected_subdir 的链接 $link_name。"
fi

####background 
target_dir=/usr/share/backgrounds/
 
image_files=()

# 遍历目录，查找所有图片文件
while IFS= read -r -d $'\0' file; do
  # 使用file命令检查文件类型是否为image
  if file -b --mime-type "$file" | grep -q "^image/"; then
    image_files+=("$file")
#    echo "IMAGE:"$file
  fi
done < <(find "$target_dir" -type f -print0)

# 检查是否找到图片文件
if [ ${#image_files[@]} -gt 0 ]; then  
	selected_index=$((RANDOM % ${#image_files[@]}))
	selected_image="${image_files[$selected_index]}" 
	echo "随机选择的图片文件：$selected_image" 
	sudo  convert -resize 1920x1080  $selected_image   /boot/grub/grub.png
fi

sudo update-grub

