PROMPT_COMMAND=__prompt_command

__prompt_command() {

    local EXIT="$?"              #This needs to be first
    local NoCol='\[\e[0m\]'
    local BoldOff='\[$(tput sgr0)\]'
    
    local Red='\[\033[38;5;9m\]'
    local Green='\[\033[38;5;10m\]'
    local Yellow='\[\033[38;5;11m\]'
    local Blue='\[\033[38;5;12m\]'
    local Magenta='\[\033[38;5;13m\]'
    local Cyan='\[\033[38;5;14m\]'
    local Silver='\[\033[38;5;145m\]'
    local Gold='\[\033[38;5;179m\]'
	
	PS1="${BoldOff}"
  
	if [ -z "${VIRTUAL_ENV_DISABLE_PROMPT-}" ] ; then
    	_OLD_VIRTUAL_PS1="${PS1-}"
    	if [ "x" != x ] ; then
        	PS1="() ${PS1-}"
    	else
        	PS1="(`basename \"$VIRTUAL_ENV\"`) ${PS1-}"
		fi
	fi
    
	PS1+="${Cyan}\w${NoCol} "
     
    if [ $EXIT != 0 ]; then
        PS1+="${Red}"
    else
        PS1+="${Green}"
    fi
    
    PS1+="➜ ${NoCol}"  #❯ ➜ ⚡
    
    export PS1
}
