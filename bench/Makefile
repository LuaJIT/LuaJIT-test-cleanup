ifndef LUAJIT_BIN
	LUAJIT_BIN = ./bench
	LUAJIT_ARG = $(patsubst %.lua,%,$^)
	LUAJIT_FILE_ARG = -a
else
	# Assume that we are calling the benchmark scripts directly using a
	# standard interpreter.  Use I/O redirection for file inputs and to
	# dump script output.
	LUAJIT_ARG = $^ > /dev/null
	LUAJIT_FILE_ARG = <
	LUAJIT_CMD = $(LUAJIT_BIN) $^.lua > /dev/null $(input-file-arg)
endif

BENCHMARKS = array3d coroutine-ring fasta mandelbrot-bit meteor nsieve-bit \
	     pidigits-nogmp recursive-fib scimark-fft scimark-sor \
	     spectral-norm binary-trees euler14-bit k-nucleotide \
	     mandelbrot nbody nsieve ray revcomp scimark_lib scimark-sparse \
	     sum-file chameneos fannkuch life md5 nsieve-bit-fp partialsums \
	     recursive-ack scimark-2010-12-20 scimark-lu series

INPUT-k-nucleotide = FASTA_1000000
INPUT-revcomp = FASTA_1000000
INPUT-sum-file = SUMCOL_1000

input-file = $(INPUT-$(patsubst %.result,%,$@))
input-file-arg = $(if $(input-file),$(LUAJIT_FILE_ARG) $(input-file),)
LUAJIT_CMD = $(LUAJIT_BIN) $(LUAJIT_ARG) $(input-file-arg)

bench_targets = $(patsubst %,%.result,$(BENCHMARKS))

all: $(bench_targets)

%.result: %.lua
	@$(LUAJIT_CMD)
