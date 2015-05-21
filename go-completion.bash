# Bash completion for golang.  Copyright 2015 Makoto Onuki
#
# Usage: source go-completion.bash

function _go_complete() {
  local -A _go_flags
  local _go_build_flags="-a -n -p -race -v -work -x -cclfags -compiler -gccgoflags -gcflags -installsuffix -ldflags -tags"
  local _go_test_flags="-bench -benchmem -benchtime -blockprofile -blockprofilerate -cover -covermode -coverpkg -coverprofile -cpu -cpuprofile -memprofile -memprofilerate -outputdir -parallel -run -short -timeout -v"

  cmd="${COMP_WORDS[0]}"
  sub="${COMP_WORDS[1]}"
  cur="${COMP_WORDS[COMP_CWORD]}"
  prev="${COMP_WORDS[COMP_CWORD-1]}"

  cand=""
  case "$prev" in
    "go")
      cand="build clean env fix fmt get install list run test tool version vet"
      ;;
    *)
      case "$cur" in
        -*)
          case "$sub" in
            build)    cand="-o -i ${_go_build_flags}" ;;
            clean)    cand="-i -r -n -x ${_go_build_flags}" ;;
            fmt)      cand="-n -x" ;;
            generate) cand="-run" ;;
            get)      cand="-d -f -fix -t -u ${_go_build_flags}" ;;
            install)  cand="${_go_build_flags}" ;;
            list)     cand="-e -f -json ${_go_build_flags}" ;;
            run)      cand="-exec ${_go_build_flags}" ;;
            test)     cand="-i -c -exec -o ${_go_build_flags} ${_go_test_flags}" ;;
            tool)     cand="-n" ;;
            vet)      cand="-n -x" ;;
          esac
          ;;
      esac
      ;;
  esac
  if [ "x$cand" = "x" ] ; then
    COMPREPLY=($(compgen -f -- ${cur}))
  else
    COMPREPLY=($(compgen -W "$cand" -- ${cur}))
  fi
}

function _godoc_complete() {
  cur="${COMP_WORDS[COMP_CWORD]}"

  cand=""
  case "$cur" in
    -*)
      cand="-v -q -src -tabwidth -timestamps -index -index_files -index_throttle -links -write_index -index_files -maxresults -notes -html -goroot -http -server -analysis -templates -url -zip"
      ;;
  esac
  if [ "x$cand" = "x" ] ; then
    COMPREPLY=($(compgen -f -- ${cur}))
  else
    COMPREPLY=($(compgen -W "$cand" -- ${cur}))
  fi
}

complete -o filenames -o bashdefault -F _go_complete go
complete -o filenames -o bashdefault -F _godoc_complete godoc
