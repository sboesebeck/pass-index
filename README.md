# pass-index
An "index" to speed up conten search for pass - the standard unix password store. See [passwordstore](https://https://www.passwordstore.org) for more info.

## NAME
       pass‐index‐ A pass(1) extension for speeding up search in all Fields.


## SYNOPSIS
       `pass index [ COMMAND ] [ OPTIONS ]... [ ARGS ]...`


### DESCRIPTION
`pass‐index` is an extension for Password Store that will create and manage an (encrypted) index file to make searches for all  fields  faster.  It speeds up `pass grep` by many times. It will not put passwords themselves into the index (so you cannot search for a  password),  but  all  additional metadata (=lines) in entries.

#### How it works
first you should call `pass index create` in order to create the search index file. This file is located in the passwordstore directory (usually $HOME/.password-store) and is named `.index.gpg`. Pass create then runs through all password entries, strips the first line (the password) and adds this info together with the filename in the index file. When this is done, the index file is encrypted.

Of course, you need to update the index file when you do changes to your passwords. Hence, you cann create an alias `pass=pass index` which would then keep your index up to date, even when you do some changes using `pass edit` etc.


## COMMANDS
Usually,  pass‐index will pass on all commands given to pass itself (so you can use it in conjunction with an alias `pass = pass index`). But you can also call it directly:


-  `update`: recreate the index file, you can also use create or recreate
- `find [GREP PATTERN]`:         find  will  list  all matching entries in password store for the given term.
- `grep [GREP PATTERN]`: similar to find, it will return all matching files, but  includ‐ ing the lines matching (see grep for details)
- `insert | mv | rm | edit [NAME]`: This  will  call the corresponding pass command but also updates the index file. Attention: if you create entries  directly,  you need  to  run  pass  index  recreat  once in a while in order to update the index. Otherwise you will get wrong results.
- `help`:   gives a little help


## examples

`pass index find "company"`

returns a list of matching entries, that contain the text  "company".  The  search  is case insensitive!  Using grep instead of find would also return the matching content.

`pass index find "^Url: https://www.caluga.de.*"`

returns a list of all entries, which do have a  Field  Url,  the content  of  which  is a caluga url. The search is case insensitive!

`pass index mv oldPwd newPwd`

renames an entry and also updates the index for it

`pass index ANYTHING ELSE`

will be passed to pass itself. This way, you can  easily  create an  alias for pass, that automatically keeps your index in sync.




