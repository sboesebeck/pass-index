# pass-index
An "index" to speed up conten search for pass - the standard unix password store.



## NAME
       pass‐index‐ A pass(1) extension for speeding up search in all Fields.


## SYNOPSIS
       `pass index [ COMMAND ] [ OPTIONS ]... [ ARGS ]...`


### DESCRIPTION
`pass‐index` is an extension for Password Store that will create and man‐ age an (encrypted) index file to make searches for all  fields  faster.  It speeds up pass grep many times. It will not put passwords themselves into the index (so you cannot search for a  password),  but  all  addi‐ tional metadata (=lines) in entries.


## COMMANDS
Usually,  pass‐index will pass on all commands given to pass itself (so you can use it in conjunction with an alias pass = pass index). But you can also call it directly:


-  `update`: recreate the index file, you can also use create or recreate
- `find [GREP PATTERN]`:         find  will  list  all matching entries in password store for the given term.
- `grep [GREP PATTERN]`: similar to find, it will return all matching files, but  includ‐ ing the lines matching (see grep for details)
- `insert | mv | rm | edit [NAME]`: This  will  call the corresponding pass command but also updates the index file. Attention: if you create entries  directly,  you need  to  run  pass  index  recreat  once in a while in order to update the index. Otherwise you will get wrong results.
- `help`:   gives a little help


## examples

`pass index find "company"`

returns a list of matching entries, that contain the text  "com‐ pany".  The  search  is case insensitive!  Using grep instead of find would also return the matching content.

`pass index find "^Url: https://www.caluga.de.*"`
returns a list of all entries, which do have a  Field  Url,  the content  of  which  is a caluga url. The search is case insensi‐ tive!

`pass index mv oldPwd newPwd`
renames an entry and also updates the index for it

`pass index ANYTHING ELSE`
will be passed to pass itself. This way, you can  easily  create an  alias for pass, that automatically keeps your index in sync.




