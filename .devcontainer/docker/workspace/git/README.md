# Git Setting

## My Git Alias

below is an excerpt from `.gitconfig` in my host.
```
[alias]
	br = branch
	bm = branch -m
	ca = commit --amend
	ce = commit --allow-empty -m
	cm = commit -m
	co = commit
	cb = checkout -b
	ch = checkout
	cl = !git branch --merged | grep -vE \"^\\*|^\\s*main$|^\\s*master$\" | xargs -n 1 git branch -d
	d  = diff
	dn = diff --name-only
	ds = diff --name-status
	f  = fetch
	gl = config --global -l
	l  = log
	ln = log --name-only
	p  = push
	pl = pull
	rv = remote -v
	st = status
```