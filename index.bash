#!/usr/bin/env bash

print_usage(){
	echo "$PROGRAM does keep an index to make searching easier and faster"
	echo "  details: one file is kept in passwordstore called .index.gpg"
	echo "           this file will be updated by corresponding elements"
	echo "		 and kept in sync with the repository"
	echo ""
	echo "Usage: $PROGRAM index action"
	echo "Valid actions are: "
	echo "    update|recreate|create: 	updates the index"
	echo "    edit: 			edits password and updates index"
	echo "    insert:			generates new password and updates index"
	echo "    mv: 				moves password and updates index"
	echo "    rm: 				removes password and updates index"
	echo "    find: 			searches for password returns matching entry names"
	echo "    grep: 			searches for password returns lines in entries"
	exit 0
}


cmd_index(){
     	echo "Creating index..."
	cd $PREFIX
	rm -f .index.gpg
	rm -f .index
	find . -name "*.gpg" -type f | while IFS= read l; do
		en=${l#./}
		en=${en%.gpg}
            	echo "Adding $en to index"
		echo "$en|entry" >> .index
		pass show $en | tail -n+2| while IFS= read n; do
			echo "$en|$n" >> .index
		done
	done
	set_gpg_recipients "."
	cat .index | $GPG -e "${GPG_RECIPIENT_ARGS[@]}" -o .index.gpg "${GPG_OPTS[@]}"
	rm -f .index
	echo "Index updated"
}

cmd_find(){
	cd $PREFIX
	set_gpg_recipients "."
	$GPG -d "${GPG_OPTS[@]}" .index.gpg | grep -i $1 | cut -f1 -d'|' | sort -u || exit 1
}

cmd_grep(){
	cd $PREFIX
	set_gpg_recipients "."
	$GPG -d "${GPG_OPTS[@]}" .index.gpg | grep -i --color $1 | while IFS= read l; do
		entry=$(echo "$l" | cut -f1 -d'|')
		txt=$(echo "$l" | cut -f2- -d'|')
		echo "Entry: $entry ContentMatched: $txt" | grep -i --color $1
	done	
}
remove_entry(){
 	cd $PREFIX
	set_gpg_recipients "."
	$GPG -d "${GPG_OPTS[@]}" .index.gpg | grep -v "^$1|" > .index
	cat .index | $GPG -e "${GPG_RECIPIENT_ARGS[@]}" -o .index.gpg "${GPG_OPTS[@]}"
	rm -f .index
}
update_entry(){
	echo "Updating entry $1"
	cd $PREFIX
	set_gpg_recipients "."
	$GPG -d "${GPG_OPTS[@]}" .index.gpg | grep -v "^$1|" > .index
	echo "$1|entry" >> .index
	pass show $1 | tail -n+2| while IFS= read n; do
		echo "$1|$n" >> .index
	done
	
	cat .index | $GPG -e "${GPG_RECIPIENT_ARGS[@]}" -o .index.gpg "${GPG_OPTS[@]}"
	rm -f .index
}
cmd_edit(){
	for i in "$@"; do :; done
	
	pass edit "$@"
	update_entry $i
}
cmd_rm(){
	for i in $@; do :; done
	pass rm "$@"
	remove_entry "$i"
}
cmd_insert(){
	for i in $@; do :; done
	pass insert "$@"
	update_entry $i
}
cmd_mv(){
	pass mv "$@"
	if [ "$1" == "-f" ] || [ "$1" == "--force" ]; then
		shift
	fi
	remove_entry $1
	update_entry $2
}

if [ "q$1" == "q" ]; then
	print_usage
fi 
cd $PREFIX

case $1 in
	update|recreate|create)
		cmd_index
		;;
	edit)
		shift
		cmd_edit "$@"
		;;
	rm|remove)
		shift
		cmd_rm "$@"
		;;
	mv)	
		shift
		cmd_mv "$@"
		;;
	insert)
		shift
		cmd_insert "$@"
		;;
	find)
		shift
		cmd_find "$@"
		;;
	grep)
		shift
		cmd_grep "$@"
		;;
	help)
		print_usage
		;;
	*)
		pass "$@"
		;;
esac	
