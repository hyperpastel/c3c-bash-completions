_complete_option_flag() {
	already_typed="$1"
	options="$2"
	value="${already_typed##*=}"
	flag="${already_typed%%=*}="
	mapfile -t COMPREPLY < <(compgen -P "${flag}" -W "${options}" -- "${value}")
}

_c3c() {
	commands=(
		"compile"
		"init"
		"init-lib"
		"build"
		"benchmark"
		"test"
		"clean"
		"run"
		"dist"
		"directives"
		"bench"
		"clean-run"
		"compile-run"
		"compile-only"
		"compile-benchmark"
		"compile-test"
		"static-lib"
		"dynamic-lib"
		"headers"
		"vendor-fetch"
		"project"
	)
	options=(
		"-h"
		"-hh"
		"--help"
		"-V"
		"--version"
		"-q"
		"--quiet"
		"-v"
		"-vv"
		"-vvv"
		"-E"
		"-P"
		"-C"
		"-"
		"-o"
		"-O0"
		"-O1"
		"-O2"
		"-O3"
		"-O4"
		"-O5"
		"-Os"
		"-Oz"
		"-D"
		"-U"
		"--about"
		"--libdir"
		"--lib"
		"--validation="
		"--stdlib"
		"--no-entry"
		"--path"
		"--template"
		"--symtab"
		"--max-mem"
		"--run-once"
		"--trust="
		"--output-dir"
		"--build-dir"
		"--obj-out"
		"--script-dir"
		"--llvm-out"
		"--emit-llvm"
		"--asm-out"
		"--emit-asm"
		"--obj"
		"--no-obj"
		"--no-headers"
		"--target"
		"--threads"
		"--safe="
		"--panic-msg="
		"--optlevel="
		"--optsize="
		"--single-module="
		"--show-backtrace="
		"--lsp"
		"--old-test-bench="
		"-g"
		"-g0"
		"-l"
		"-L"
		"-z"
		"--cc"
		"--linker="
		"--use-stdlib="
		"--link-libc="
		"--emit-stdlib="
		"--panicfn"
		"--testfn"
		"--benchfn"
		"--reloc="
		"--x86cpu="
		"--x86vec="
		"--riscvfloat="
		"--memory-env="
		"--strip-unused="
		"--fp-math="
		"--win64-simd="
		"--print-linking"
		"--benchmarking"
		"--testing"
		"--list-attributes"
		"--list-builtins"
		"--list-keywords"
		"--list-operators"
		"--list-precedence"
		"--list-project-properties"
		"--list-manifest-properties"
		"--list-targets"
		"--list-type-properties"
		"--print-output"
		"--print-input"
		"--winsdk"
		"--wincrt="
		"--windef"
		"--win-vs-dirs"
		"--macossdk"
		"--macos-min-version"
		"--macos-sdk-version"
		"--linux-crt"
		"--linux-crtbegin"
		"--vector-conv="
		"--sanitize="
	)

	local cur prev
	cur="${COMP_WORDS[COMP_CWORD]}"
	prev="${COMP_WORDS[COMP_CWORD-1]}"

	case "${prev}" in
		# Main command
		c3c)
			mapfile -t COMPREPLY < <(compgen -W "${commands[*]} -" -- "${cur}")
			if [[ "${cur}" == -* ]]; then
				mapfile -t COMPREPLY < <(compgen -W "${options[*]}" -- "${cur}")
			fi
			;;
		clean)
			COMPREPLY=()	# This one does not need extra info
			;;
		project)
			mapfile -t COMPREPLY < <(compgen -W "view add-target fetch" -- "${cur}")
			return
			;;
		*)
			if [[ "${cur}" == -* ]]; then
				mapfile -t COMPREPLY < <(compgen -W "${options[*]}" -- "${cur}")
			fi
			;;
	esac

	# Remove '=' from word-breaks so we can do some magic
	COMP_WORDBREAKS="${COMP_WORDBREAKS//=/}"

	# Prevent inserting a space after completing '--<flag>=', so that we can
	# double tab again to see the possible values for the flag
	if [[ "${#COMPREPLY[@]}" -eq 1 && "${COMPREPLY[0]}" == *= ]]; then
		compopt -o nospace
	fi

	# Big switch statement to catch all available flags and fill the opts
	# array with their possible values
	local opts=()
	case "${cur}" in
		--validation=*)
			opts=( "lenient" "strict" "obnoxious" )
			;;
		--trust=*)
			opts=( "none" "include" "full" )
			;;
		--optlevel=*)
			opts=( "none" "less" "more" "max" )
			;;
		--optsize=*)
			opts=( "none" "small" "tiny" )
			;;
		--linker=*)
			opts=( "builtin" "cc" "custom" )
			;;
		--reloc=*)
			opts=( "none" "pic" "PIC" "pie" "PIE" )
			;;
		--x86cpu=*)
			opts=( "baseline" "ssse6" "sse4" "avx1" "avx2-v1" "avx2-v2" "avx512" "native" )
			;;
		--x86vec=*)
			opts=( "none" "mmx" "sse" "avx" "avx512" "default"  )
			;;
		--riscvfloat=*)
			opts=( "none" "float" "double" )
			;;
		--memory-env=*)
			opts=( "normal" "small" "tiny" "none" )
			;;
		--fp-math=*)
			opts=( "strict" "relaxed" "fast" )
			;;
		--win64-simd=*)
			opts=( "array" "full" )
			;;
		--wincrt=*)
			opts=( "none" "static-debug" "static" "dynamic-debug" "dynamic" )
			;;
		--vector-conv=*)
			opts=( "default" "old" )
			;;
		--sanitize=*)
			opts=( "address" "memory" "thread" )
			;;
		# Yes or no flags
		--safe=*|--panic-msg=*|--single-module=*|--show-bactrace=*|  \
			--old-test-bench=*|--use-stdlib=*|--link-libc=*|--emit-stdlib=*| \
			--strip-unused=*)
			opts=( "yes" "no" )
			;;
	esac
	if (( "${#opts[*]}" >= 1)); then
		_complete_option_flag "${cur}" "${opts[*]}"
	fi
}

complete -o default -F _c3c c3c
