echo "loaded .bashrc termux"
h(){ cd ~ ; }
doc(){ cd ~/storage/shared/Documents/ ; }
dev(){ cd ~/dev ; }
alias d=dev
t(){ cd ~/dev/termux-android-scripts ; }
ob(){ vim ~/.bashrc ; }
sb(){ source ~/.bashrc && bat ~/.bashrc ; }
ll(){ ls -a ; }
sync(){
	cd ~/termux-android-scripts/configs
	python3 sync_configs.py #make
	git add . && git commit -m "sync" && git push
}
blog(){ cd ~/storage/shared/Documents/git-repos/blogs/ ; }
alias b=blog
alias lg=lazygit
gigi(){
printf "git commit message:" read -r commitmessage && git add . && git commit -m "$commitmessage" && git push
}
vps(){ cd ~/devops/vps ; } 
todo(){ vim ~/todo.md ; }
