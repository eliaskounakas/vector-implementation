# MAKEFILE fuer das Vektor-Projekt
# Es kann unter Anderem automatisiert die Tests von CeWebs ausfuehren!
# Bug-Report zum Makefile: nikolaus.suess@univie.ac.at
# Fragen zu den Tests bitte ins Moodle-Forum stellen (ich habe sie nur kopiert)!

# VARIABLEN
# Alle CPP-Files (falls vorhanden, auszer main.cpp) durch Leerzeichen getrennt, sonst leer lassen
files 		= vector.cpp 

# Main-File (ein Hauptprogramm)
mainfile	= main.cpp

# Programmname (Name der ausfuehrbaren Datei)
progname 	= prog

# Liste temporaer angelegter Dateien, die mit clean geloescht werden
tmpfiles	= test/app[1-9] test/std

# Compiler
CC		= clang++

# Compiler-Optionen
options 	= -Wall \
		  -Wextra \
		  -std=c++$(STANDARD) \
		  -pedantic-errors \
		  -fsanitize=address \
		  -fsanitize=undefined \
		  -fno-sanitize-recover=all \
		  -ggdb3

# Den beste C++-Standard finden.
# Da auf aelteren Systemen C++17 noch nicht vorhanden ist, ggf. auf 
# frueheren Standard zurueckfallen.
STANDARD=$(shell $(CC) -std=c++17 test/get_c_standard.cpp -o test/std >/dev/null 2>&1 && echo 17 || echo 11)



# Programm kompilieren (Befehl "make" oder "make PROG")
PROG:
	$(CC) $(options) $(files) $(mainfile) -o $(progname)

# Programm durchtesten
# Es werden die Testfaelle abgearbeitet und Erfolgs- oder Fehlermeldungen ausgegeben
# Aufruf: make runtest
runtest:
	./run_tests.sh

# Loeschen aller temporaeren Dateien UND Executables (jeweils falls vorhanden)
clean :
	rm -f $(tmpfiles)
	rm -f $(progname)
