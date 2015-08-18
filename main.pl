#!/bin/perl
# Autor: Juan Carlos Lumbiarres Rodriguez <juankimsn@gmail.com>
# Fecha: 18/08/2015
# Versión: v1.0 (Cookie)
# Nota: Valido para MySQL/MariaDB
# Editar el archivo my.cnf con la información del usuario.
# Licencia: GPLv3
use DBI;
use strict;
use warnings;

# Variables de conexión
my $dbusuario = "root";
my $dbcontra = "password";
# Abrimos la conexión con MySQL (no he integrado los avisos de error por pereza)
my $dbh = DBI->connect('DBI:mysql:mysql', $dbusuario, $dbcontra, { RaiseError => 1 });
# Hacemos el query a la bbdd
my $sth = $dbh->prepare('SELECT db,user FROM db');
# Ejecutamos el query
$sth->execute();
# Bucle para leer todas las tablas.
while (my @data = $sth->fetchrow_array) {
		# Nos saltamos las tablas usuario\_%
		if ($data[0] =~ "_%") {
			next;
		}
		# Declaramos las variables de nombre de usuario y bbdd asignada
		my $db = $data[0];
		my $usu = $data[1];
		print "Usuario: $usu - BBDD: $db\n";
		# Dumpeamos con el propio mysqldump a un archivo llamado usuario.sql
		system("mysqldump --defaults-extra-file=my.cnf $db > $usu.sql");
}
# Finalizamos la conexión mysql
$sth->finish;
