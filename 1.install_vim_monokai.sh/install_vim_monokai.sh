mkdir ~/.vim;
mkdir ~/.vim/colors;

cd ~/.vim/colors;

git clone https://github.com/crusoexia/vim-monokai.git
mv ~/.vim/colors/vim-monokai/colors/monokai.vim ~/.vim/colors/;
touch ~/.vimrc;
echo 'syntax on' >> ~/.vimrc;
echo 'colorscheme monokai' >> ~/.vimrc;
