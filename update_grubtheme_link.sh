#!/bin/bash

# 定义目录路径和链接名
base_dir="/usr/share/grub/themes"
link_name="cur-theme"

# 删除已存在的链接
if [ -L "$base_dir/$link_name" ]; then
  sudo rm "$base_dir/$link_name"
fi

# 获取当前目录下所有子目录的列表
subdirs=()
while IFS= read -r subdir; do
  subdirs+=("$subdir")
done < <(ls -d "$base_dir"/*/ 2>/dev/null)

# 检查是否有子目录可用
if [ ${#subdirs[@]} -eq 0 ]; then
  echo "没有找到子目录可用于创建链接。"
  exit 1
fi

# 随机选择一个子目录
selected_index=$((RANDOM % ${#subdirs[@]}))
selected_subdir="${subdirs[$selected_index]}"

# 使用相对路径创建新的链接
sudo ln -s "$(basename "$selected_subdir")" "$base_dir/$link_name"

echo "已经创建指向子目录 $selected_subdir 的链接 $link_name。"

sudo update-grub

