# https://blog.csdn.net/qierkang/article/details/85941316
 echo $SHELL;
 cat /etc/shells ;
sudo apt install  -y  zsh;
 chsh -s /bin/zsh;
sudo apt install -y wget git ;
 wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | sh;


cd ~/.oh-my-zsh/plugins;
wget http://mimosa-pudica.net/src/incr-0.2.zsh;
source incr*.zsh;


cd ~/.oh-my-zsh/plugins;
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions;

sed -i 's\robbyrussell\cypher\g' ~/.zshrc;
sed -i 's\(git)\(git history history-substring-search node npm wd web-search last-working-dir zsh-autosuggestions)\g' ~/.zshrc;
source ~/.zshrc;
