opam switch 4.03.0
eval $(opam env)
heptc -target c -s display -hepts fourbitadder.ept
cd fourbitadder_c/
gcc -Wall -c -I /usr/local/lib/heptagon/c fourbitadder.c
fcc -Wall -c -I /usr/local/lib/heptagon/c _main.c
gcc -o fourbitadder _main.o fourbitadder.o
./fourbitadder
