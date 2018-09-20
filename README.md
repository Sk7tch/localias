# Localias
Local alias for zsh

# Install
```
git clone https://github.com/Sk7tch/localias.git
ln -s `pwd`/localias $ZSH/plugins/.
```
And edit your .zshrc plugins line:
```
plugins=(localias)
```
Start a new shell or source .zshrc and enjoy :)

# Usage
Create .localias file:
```
toto=ls
```
When entering the folder where .localias file exist, an alias toto for ls is creating.
When leaving, the alias is removed.

```
$> cat test/.localias
toto=ls
$> toto
zsh: command not found: toto
$> cd test
$> toto
file_1  file_2  file_3
$> cd ..
$> toto
zsh: command not found: toto
```

# Options
Options can be modified in ```localias.plugin.zsh```
```LOCALIAS_RECURSIVE=1```
When active .localias are loaded through each folder of the path. Default to 1.

```LOCALIAS_ALIAS_OVERIDE=0```
When active aliases defined in .localias can override existing aliases. Default to 0.

