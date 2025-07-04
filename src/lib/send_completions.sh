## [@bashly-upgrade completions send_completions]
send_completions() {
  echo $'# kryctl completion                                        -*- shell-script -*-'
  echo $''
  echo $'# This bash completions script was generated by'
  echo $'# completely (https://github.com/dannyben/completely)'
  echo $'# Modifying it manually is not recommended'
  echo $''
  echo $'_kryctl_completions_filter() {'
  echo $'  local words="$1"'
  echo $'  local cur=${COMP_WORDS[COMP_CWORD]}'
  echo $'  local result=()'
  echo $''
  echo $'  if [[ "${cur:0:1}" == "-" ]]; then'
  echo $'    echo "$words"'
  echo $'  '
  echo $'  else'
  echo $'    for word in $words; do'
  echo $'      [[ "${word:0:1}" != "-" ]] && result+=("$word")'
  echo $'    done'
  echo $''
  echo $'    echo "${result[*]}"'
  echo $''
  echo $'  fi'
  echo $'}'
  echo $''
  echo $'_kryctl_completions() {'
  echo $'  local cur=${COMP_WORDS[COMP_CWORD]}'
  echo $'  local compwords=("${COMP_WORDS[@]:1:$COMP_CWORD-1}")'
  echo $'  local compline="${compwords[*]}"'
  echo $''
  echo $'  case "$compline" in'
  echo $'    \'terminal change\'*)'
  echo $'      while read -r; do COMPREPLY+=( "$REPLY" ); done < <( compgen -W "$(_kryctl_completions_filter "--help -h")" -- "$cur" )'
  echo $'      ;;'
  echo $''
  echo $'    \'kube set-config\'*)'
  echo $'      while read -r; do COMPREPLY+=( "$REPLY" ); done < <( compgen -W "$(_kryctl_completions_filter "--help -h")" -- "$cur" )'
  echo $'      ;;'
  echo $''
  echo $'    \'kube context\'*)'
  echo $'      while read -r; do COMPREPLY+=( "$REPLY" ); done < <( compgen -W "$(_kryctl_completions_filter "--help -h")" -- "$cur" )'
  echo $'      ;;'
  echo $''
  echo $'    \'completions\'*)'
  echo $'      while read -r; do COMPREPLY+=( "$REPLY" ); done < <( compgen -W "$(_kryctl_completions_filter "--help -h")" -- "$cur" )'
  echo $'      ;;'
  echo $''
  echo $'    \'s3 profiles\'*)'
  echo $'      while read -r; do COMPREPLY+=( "$REPLY" ); done < <( compgen -W "$(_kryctl_completions_filter "--help -h")" -- "$cur" )'
  echo $'      ;;'
  echo $''
  echo $'    \'space clear\'*)'
  echo $'      while read -r; do COMPREPLY+=( "$REPLY" ); done < <( compgen -W "$(_kryctl_completions_filter "--help -h")" -- "$cur" )'
  echo $'      ;;'
  echo $''
  echo $'    \'git stash\'*)'
  echo $'      while read -r; do COMPREPLY+=( "$REPLY" ); done < <( compgen -W "$(_kryctl_completions_filter "--help -h")" -- "$cur" )'
  echo $'      ;;'
  echo $''
  echo $'    \'multipass\'*)'
  echo $'      while read -r; do COMPREPLY+=( "$REPLY" ); done < <( compgen -W "$(_kryctl_completions_filter "--help -h")" -- "$cur" )'
  echo $'      ;;'
  echo $''
  echo $'    \'kube find\'*)'
  echo $'      while read -r; do COMPREPLY+=( "$REPLY" ); done < <( compgen -W "$(_kryctl_completions_filter "--help --kubeconfig -h -k")" -- "$cur" )'
  echo $'      ;;'
  echo $''
  echo $'    \'terminal\'*)'
  echo $'      while read -r; do COMPREPLY+=( "$REPLY" ); done < <( compgen -W "$(_kryctl_completions_filter "--help -h change")" -- "$cur" )'
  echo $'      ;;'
  echo $''
  echo $'    \'space\'*)'
  echo $'      while read -r; do COMPREPLY+=( "$REPLY" ); done < <( compgen -W "$(_kryctl_completions_filter "--help -h clear")" -- "$cur" )'
  echo $'      ;;'
  echo $''
  echo $'    \'s3 ui\'*)'
  echo $'      while read -r; do COMPREPLY+=( "$REPLY" ); done < <( compgen -W "$(_kryctl_completions_filter "--config-path --credentials-path --endpoint --help --profile -C -c -e -h -p")" -- "$cur" )'
  echo $'      ;;'
  echo $''
  echo $'    \'kube\'*)'
  echo $'      while read -r; do COMPREPLY+=( "$REPLY" ); done < <( compgen -W "$(_kryctl_completions_filter "--help -h context find set-config")" -- "$cur" )'
  echo $'      ;;'
  echo $''
  echo $'    \'git\'*)'
  echo $'      while read -r; do COMPREPLY+=( "$REPLY" ); done < <( compgen -W "$(_kryctl_completions_filter "--help -h stash")" -- "$cur" )'
  echo $'      ;;'
  echo $''
  echo $'    \'s3\'*)'
  echo $'      while read -r; do COMPREPLY+=( "$REPLY" ); done < <( compgen -W "$(_kryctl_completions_filter "--help -h profiles ui")" -- "$cur" )'
  echo $'      ;;'
  echo $''
  echo $'    *)'
  echo $'      while read -r; do COMPREPLY+=( "$REPLY" ); done < <( compgen -W "$(_kryctl_completions_filter "--help --version -h -v completions git kube multipass s3 space terminal")" -- "$cur" )'
  echo $'      ;;'
  echo $''
  echo $'  esac'
  echo $'} &&'
  echo $'complete -F _kryctl_completions kryctl'
  echo $''
  echo $'# ex: filetype=sh'
}