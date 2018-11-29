echo "Starting linux bootstrap..."

BootstrapRepoRoot=""
if [ $1 ] 
then
	echo "Bootstrap repo found!"
	BootstrapRepoRoot=$1
else
	if [ ! -d ~/bootstrap ]
	then
		echo "No bootstrap folder found. Cloning from github..."
		git clone https://github.com/taurheim/bootstrap.git ~/bootstrap
	else
		echo "Bootstrap folder already downloaded. Pulling just in case"
		git -C ~/bootstrap pull
	fi
	BootstrapRepoRoot="${HOME}/bootstrap"
fi

echo "Bootstrap root: $BootstrapRepoRoot"
# sudo apt -y update
# sudo apt -y upgrade
rm ~/.bashrc
cp -rfRv "$BootstrapRepoRoot/config/." ~/

sudo apt -y install zsh tmux autojump

# zsh & config
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
git clone https://github.com/tarjoilija/zgen.git "${HOME}/.zgen"
mkdir -p ~/.vim/autoload ~/.vim/bundle

# vim
curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
git clone https://github.com/altercation/vim-colors-solarized.git ~/vim-colors-solarized
mkdir -p ~/.vim/colors
mv ~/vim-colors-solarized/colors/solarized.vim ~/.vim/colors/solarized.vim
rm -rf ~/vim-colors-solarized

# theme
git clone https://github.com/seebi/dircolors-solarized ~/dircolors-solarized

echo "Linux environment finished setting up."
