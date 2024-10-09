#!/bin/bash

FILES=vector.cpp

# Header lines
echo -e "\033[46m                                           \033[m"
echo -e "\033[46m       RUNNING AUTOMATED VECTOR TESTS      \033[m"
echo -e "\033[46m             Programmierung II             \033[m"
echo -e "\033[46m  Bug Report: nikolaus.suess@univie.ac.at  \033[m"
echo -e "\033[46m             Version 2022-11-10            \033[m"
echo -e "\033[46m                                           \033[m"
echo

print_error(){
	echo -e "\u001b[41m\u001b[33mERROR:\u001b[0m" $@
}

print_notice(){
	echo -e "\u001b[1mNOTE:\u001b[0m" $@
}

print_title() {
	echo -e "\033[43m\t\033[34mRunning Test" "\033[4m" $1 "\033[m\033[43m\033[34m\u001b[0m"
}

print_successful() {
	echo -e "\033[32m\u2713 TEST SUCCESSFUL\033[m"
}
print_failed() {
	echo -e "\033[31mX TEST FAILED\033[m"
}
run_test() {
	# $1 ... executable
	if [ $# -eq 2 ]; then
		eval $2 && print_successful || print_failed
	else
		eval $1 >/dev/null && print_successful || print_failed
	fi
}

# Detect compiler to use
# Prefer clang++ over g++, but use g++ if clang++ does not exist
# but use g++ for valgrind tests
CFLAGS=''
if [[ -z "${CC}" ]]; then
	if command -v clang++ &> /dev/null; then
		CC='clang++'
		STANDARD=`$CC -std=c++17 test/get_c_standard.cpp -o test/std >/dev/null 2>&1 && echo 17 || echo 11`
		if [[ -z "${CFLAGS}" ]]; then
			# allow overwriting with environment variable
			CFLAGS="-g -Wall -Wextra -std=c++${STANDARD} -O3 -pedantic-errors -fsanitize=address -fsanitize=undefined -fno-sanitize-recover=all"
		else
			print_notice "CFLAGS was set by CFLAGS environment variable to ${CFLAGS}."
		fi
	elif command -v g++ &> /dev/null; then
		CC='g++'
		STANDARD=`$CC -std=c++17 test/get_c_standard.cpp -o test/std >/dev/null 2>&1 && echo 17 || echo 11`
		if [[ -z "${CFLAGS}" ]]; then
			# allow overwriting with environment variable
			CFLAGS="-g -Wall -Wextra -std=c++${STANDARD} -O3 -pedantic-errors -fsanitize=address -fsanitize=undefined -fno-sanitize-recover=all"
		else
			print_notice "CFLAGS was set by CFLAGS environment variable to ${CFLAGS}."
		fi
	else
		echo "WARNING: No compiler found!" >&2
		echo "If you installed the compiler somewhere else on the system, try to add that path to the PATH variable." >&2
		exit
	fi
else
	# CC defined as environment variable
	print_notice "Compiler was set by CC environment variable to ${CC}."
	STANDARD=`$CC -std=c++17 test/get_c_standard.cpp -o test/std >/dev/null 2>&1 && echo 17 || echo 11`
	if [[ -z "${CFLAGS}" ]]; then
		# allow overwriting with environment variable
		CFLAGS="-g -Wall -Wextra -std=c++${STANDARD} -O3 -pedantic-errors -fsanitize=address -fsanitize=undefined -fno-sanitize-recover=all"
	else
		print_notice "CFLAGS was set by CFLAGS environment variable to ${CFLAGS}."
	fi
fi

if [[ -z "${VALGRIND_CC}" ]]; then
	VALGRIND_CC='g++'
else
	# VALGRIND_CC defined as environment variable - use this.
	print_notice "Compiler for valgrind was set by CC_VALGRIND environment variable to ${CC_VALGRIND}."
fi

VALGRIND_STANDARD=`$VALGRIND_CC -std=c++17 test/get_c_standard.cpp -o test/std >/dev/null 2>&1 && echo 17 || echo 11`
VALGRIND_CFLAGS="-g -Wall -Wextra -std=c++${VALGRIND_STANDARD} -O3 -pedantic-errors"

# We need the vector.h file in the current directory
if [ ! -f "./vector.h" ]; then
	print_error "vector.h nicht gefunden im aktuellen Verzeichnis!"
	exit
fi
# Create vector.cpp if it does not exist
if [ ! -f "./vector.cpp" ]; then
	touch vector.cpp
	print_notice "Leere Datei 'vector.cpp' angelegt. Sie koennen die Datei nach dem Ausfuehren der Tests wieder loeschen."
fi

echo "Im folgenden werden die automatisierten Tests ausgefuehrt."
print_notice "Es wird mit \u001b[4m-std=c++${STANDARD}\u001b[0m compiliert."
print_notice "Die normalen Tests werden mit ${CC}, die valgrind-Tests mit ${VALGRIND_CC} ausgefuehrt."
print_notice "Verwendete CFLAGS:\n\t${CC}: ${CFLAGS}\n\tfuer valgrind mit ${VALGRIND_CC}: ${VALGRIND_CFLAGS}"



# Start der Tests
echo 
echo "=================================================="
echo 
# Memory-Test #1 (CeWebs)
# Memory-Fehler kaeme auf stderr, daher ist >/dev/null okay ...
print_title memory1.cpp
$CC $CFLAGS test/utest1/memory1.cpp $FILES -I. -o test/app1
run_test ./test/app1



echo

# Unit-Test #1 (CeWebs)
print_title utest_1.cpp
$CC $CFLAGS test/utest1/utest.cpp $FILES -I. -I./test -o test/app2
run_test -v ./test/app2

echo 

# Const-Tests (CeWebs)
print_title const_test.cpp
$CC $CFLAGS -I./ test/ue2_consttest/const_test.cpp $FILES -o test/app3 >/dev/null 2>&1 && print_failed || print_successful

echo

print_title const_test_arrow.cpp
$CC $CFLAGS -I./ test/ue2_consttest/const_test_arrow.cpp $FILES -o test/app4 >/dev/null 2>&1 && print_failed || print_successful

echo 

print_title types_test.cpp
$CC $CFLAGS -Wno-unused-variable -I./ test/ue2_consttest/types_test.cpp $FILES -o test/app5
run_test -v ./test/app5

echo

# Unit-Test #2 (CEWebS)
print_title utest_2.cpp
$CC $CFLAGS -Wno-unused-variable -I./ -I./test test/ue2_consttest/utest_2.cpp $FILES -o test/app6
run_test -v ./test/app6

echo 

# Unit-Test #3 (CEWebS)
print_title utest_3_1.cpp
$CC $CFLAGS -Wno-unused-variable -I./ -I./test test/utest_3_1.cpp $FILES -o test/app7
run_test -v ./test/app7

echo

# Secure iterator test
print_title utest_secure_iterators.cpp
print_notice "Run test for secure iterators. In this test run, the tests for the strongly secure iterator are disabled!"
$CC $CFLAGS -Wno-unused-variable -I./ -I./test test/utest_secure_iterators.cpp $FILES -o test/app8
run_test -v ./test/app8

echo

# Strongly secure iterator test
print_title utest_secure_iterators.cpp
print_notice "Run test for secure iterators. In this test run, the tests for the strongly secure iterator are enabled!"
print_notice "This test is optional in WS2022."
$CC $CFLAGS -Wno-unused-variable -DSTRONGLY_SECURE -I./ -I./test test/utest_secure_iterators.cpp $FILES -o test/app9
run_test -v ./test/app9


# WIEDERHOLUNG DER TESTS MIT VALGRIND, FALLS INSTALLIERT
if command -v valgrind &> /dev/null; then

echo
echo "=================================================="
echo "========= Wiederholung der Tests mit ============="
echo "=========         VALGRIND           ============="
echo "=================================================="
echo

print_title memory1.cpp
$VALGRIND_CC $VALGRIND_CFLAGS test/utest1/memory1.cpp $FILES -I. -o test/app1
run_test 'valgrind --leak-check=full --error-exitcode=1 ./test/app1'

echo

# Unit-Test #1 (CeWebs)
print_title utest_1.cpp
$VALGRIND_CC $VALGRIND_CFLAGS test/utest1/utest.cpp $FILES -I. -I./test -o test/app2
run_test -v 'valgrind --leak-check=full --error-exitcode=1 ./test/app2'

echo

# Unit-Test #2 (CEWebS)
print_title utest_2.cpp
$VALGRIND_CC $VALGRIND_CFLAGS test/ue2_consttest/utest_2.cpp $FILES -I. -I./test -o test/app7
run_test -v 'valgrind --leak-check=full --error-exitcode=1 ./test/app7'

echo

# Unit-Test #3 (CEWebS)
print_title utest_3_1.cpp
$VALGRIND_CC $VALGRIND_CFLAGS test/utest_3_1.cpp $FILES -I. -I./test -o test/app7
run_test -v 'valgrind --leak-check=full --error-exitcode=1 ./test/app7'

echo 

# Secure iterator test
print_title utest_secure_iterators.cpp
print_notice "Run test for secure iterators. In this test run, the tests for the strongly secure iterator are disabled!"
$VALGRIND_CC $VALGRIND_CFLAGS -I./ -I./test test/utest_secure_iterators.cpp $FILES -o test/app8
run_test -v 'valgrind --leak-check=full --error-exitcode=1 ./test/app8'

echo

# Strongly secure iterator test
print_title utest_secure_iterators.cpp
print_notice "Run test for secure iterators. In this test run, the tests for the strongly secure iterator are enabled!"
print_notice "This test is optional in WS2022."
$VALGRIND_CC $VALGRIND_CFLAGS -DSTRONGLY_SECURE -I./ -I./test test/utest_secure_iterators.cpp $FILES -o test/app9
run_test -v 'valgrind --leak-check=full --error-exitcode=1 ./test/app9'

else
	print_notice "valgrind nicht installiert. Bitte installieren, um die Tests mit valgrind ausfuehren zu können."
fi

echo
echo
echo -e "\u001b[46m                                                                       \u001b[0m"
echo -e "\u001b[46m Sollten alle Tests SUCCESS liefern, ist die Wahrscheinlichkeit gross, \u001b[0m"
echo -e "\u001b[46m dass Ihre Vektorklasse korrekt funktioniert.                          \u001b[0m"
echo -e "\u001b[46m Beachten Sie jedoch unbedingt, dass die Tests nicht alle Fehler ab-   \u001b[0m"
echo -e "\u001b[46m decken koennen, dh. es kann leider keine Garantie fuer Fehlerfreiheit \u001b[0m"
echo -e "\u001b[46m gegeben werden. Wir bitten um Verstaendnis!                           \u001b[0m"
echo -e "\u001b[46m                                                                       \u001b[0m"
echo


# CLEANUP
rm -f test/app[1-9] test/std
