## xfce4  
  
Xfce is a lightweight and modular desktop environment
  
requires:  
apt: ```apt install xfce4```  
yum: ```yum install xfce4```  
pacman: ```pacman -S xfce4```  
  
Automatic install/update:

```shell
bash -c "$(curl -LSs https://github.com/dfmgr/xfce4/raw/master/install.sh)"
```shell
Manual install:
```shell
mv -fv "$HOME/.config/xfce4" "$HOME/.config/xfce4.bak"
git clone https://github.com/dfmgr/xfce4 "$HOME/.config/xfce4"
```
  
  
<p align=center>
  <a href="https://wiki.archlinux.org/index.php/xfce4" target="_blank">xfce4 wiki</a>  |  
  <a href="http://www.xfce.org/" target="_blank">xfce4 site</a>
</p>  
