for file in `ls ~/dotfiles`
do
  if [ $file != install.sh ]
  then
    ln -sf ~/dotfiles/$file ~/.$file
  fi
done
