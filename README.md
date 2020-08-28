## xfce4  
  
Xfce is a lightweight and modular desktop environment  
  
Automatic install/update:

```shell
bash -c "$(curl -LSs https://github.com/dfmgr/xfce4/raw/master/install.sh)"
```

Manual install:
  
requires:

Debian based:

```shell
apt install xfce4 geany firefox thunar xfce4-terminal sxhkd
```  

Fedora Based:

```shell
yum install xfce4 geany firefox thunar xfce4-terminal sxhkd
```  

Arch Based:

```shell
pacman -S xfce4 geany firefox thunar xfce4-terminal sxhkd
```  

MacOS:  

```shell
brew install
```
  
```shell
mv -fv "$HOME/.config/xfce4" "$HOME/.config/xfce4.bak"
git clone https://github.com/dfmgr/xfce4 "$HOME/.config/xfce4"
```
  
<p align=center>
  <a href="https://wiki.archlinux.org/index.php/xfce4" target="_blank" rel="noopener noreferrer">xfce4 wiki</a>  |  
  <a href="http://www.xfce.org" target="_blank" rel="noopener noreferrer">xfce4 site</a>
</p>  
