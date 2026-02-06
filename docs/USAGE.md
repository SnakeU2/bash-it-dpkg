# Usage

## Enable for User

```

bash-it enable
source /etc/profile

```

## Disable

```

bash-it disable

```

## Check Status

```

bash-it status

```

##Customization

Create symlinks in ~/.bash_it/enabled/:

```

ln -s ../plugins/available/git.plugin.bash ~/.bash_it/enabled/000-git.plugin.bash

```

Set theme:

```

echo 'export BASH_IT_THEME="agnoster"' > ~/.bash_it/custom/env.bash

```
