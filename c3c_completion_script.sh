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

	if [[ "${#COMPREPLY[@]}" -eq 1 && "${COMPREPLY[0]}" == *= ]]; then
		compopt -o nospace
	fi

	# This big switch-statement does the same for every --<flag>= :
	# 1) get the already typed part after the '='
	# 2) match that with the available opts
	# 3) prepend the flag again before the matches (otherwise the flag will be
	# 	removed from the typed command)
	#
	# I thought about abstracting this away in some sense, but havent't found
	# a satisfying solution yet.
	case "${cur}" in
		--validation=*)
			value="${cur##*=}"
			opts=( "lenient" "strict" "obnoxious" )
			mapfile -t COMPREPLY < <(compgen -P "--validation=" -W "${opts[*]}" -- "${value}")
			return
			;;
		--trust=*)
			value="${cur##*=}"
			opts=( "none" "include" "full" )
			mapfile -t COMPREPLY < <(compgen -P "--trust=" -W "${opts[*]}" -- "${value}")
			return
			;;
		--optlevel=*)
			value="${cur##*=}"
			opts=( "none" "less" "more" "max" )
			mapfile -t COMPREPLY < <(compgen -P "--optlevel=" -W "${opts[*]}" -- "${value}")
			return
			;;
		--optsize=*)
			value="${cur##*=}"
			opts=( "none" "small" "tiny" )
			mapfile -t COMPREPLY < <(compgen -P "--optsize=" -W "${opts[*]}" -- "${value}")
			return
			;;
		--linker=*)
			value="${cur##*=}"
			opts=( "builtin" "cc" "custom" )
			mapfile -t COMPREPLY < <(compgen -P "--linker=" -W "${opts[*]}" -- "${value}")
			return
			;;
		--reloc=*)
			value="${cur##*=}"
			opts=( "none" "pic" "PIC" "pie" "PIE" )
			mapfile -t COMPREPLY < <(compgen -P "--reloc=" -W "${opts[*]}" -- "${value}")
			return
			;;
		--x86cpu=*)
			value="${cur##*=}"
			opts=( "baseline" "ssse6" "sse4" "avx1" "avx2-v1" "avx2-v2" "avx512" "native" )
			mapfile -t COMPREPLY < <(compgen -P "--x86cpu=" -W "${opts[*]}" -- "${value}")
			return
			;;
		--x86vec=*)
			value="${cur##*=}"
			opts=( "none" "mmx" "sse" "avx" "avx512" "default"  )
			mapfile -t COMPREPLY < <(compgen -P "--x86vec=" -W "${opts[*]}" -- "${value}")
			return
			;;
		--riscvfloat=*)
			value="${cur##*=}"
			opts=( "none" "float" "double" )
			mapfile -t COMPREPLY < <(compgen -P "--riscvfloat=" -W "${opts[*]}" -- "${value}")
			return
			;;
		--memory-env=*)
			value="${cur##*=}"
			opts=( "normal" "small" "tiny" "none" )
			mapfile -t COMPREPLY < <(compgen -P "--memory-env=" -W "${opts[*]}" -- "${value}")
			return
			;;
		--fp-math=*)
			value="${cur##*=}"
			opts=( "strict" "relaxed" "fast" )
			mapfile -t COMPREPLY < <(compgen -P "--fp-math=" -W "${opts[*]}" -- "${value}")
			return
			;;
		--win64-simd=*)
			value="${cur##*=}"
			opts=( "array" "full" )
			mapfile -t COMPREPLY < <(compgen -P "--win64-simd=" -W "${opts[*]}" -- "${value}")
			return
			;;
		--wincrt=*)
			value="${cur##*=}"
			opts=( "none" "static-debug" "static" "dynamic-debug" "dynamic" )
			mapfile -t COMPREPLY < <(compgen -P "--wincrt=" -W "${opts[*]}" -- "${value}")
			return
			;;
		--vector-conv=*)
			value="${cur##*=}"
			opts=( "default" "old" )
			mapfile -t COMPREPLY < <(compgen -P "--vector-conv=" -W "${opts[*]}" -- "${value}")
			return
			;;
		--sanitize=*)
			value="${cur##*=}"
			opts=( "address" "memory" "thread" )
			mapfile -t COMPREPLY < <(compgen -P "--sanitize=" -W "${opts[*]}" -- "${value}")
			return
			;;
		# Yes or no flags
		--safe=*|--panic-msg=*|--single-module=*|--show-bactrace=*|--old-test-bench=* \
		|--use-stdlib=*|--link-libc=*|--emit-stdlib=*|--strip-unused=*)
			flag="${cur%%=*}="
			value="${cur##*=}"
			mapfile -t COMPREPLY < <(compgen -P "${flag}" -W "yes no" -- "${value}")
			return
			;;
	esac
}

complete -o default -F _c3c c3c
