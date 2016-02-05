#!/bin/bash
set -e

if [ ! -d '/var/lib/mysql/mysql' ]; then
	mysql_install_db --user=mysql --datadir=/var/lib/mysql

	TEMP_FILE='/tmp/mysql-first-time.sql'
	cat > "$TEMP_FILE" <<-EOSQL
		DELETE FROM mysql.user;
		CREATE USER 'root'@'%' IDENTIFIED BY '';
		GRANT ALL ON *.* TO 'root'@'%' WITH GRANT OPTION;
		FLUSH PRIVILEGES;
	EOSQL

	set -- "$@" --init-file="$TEMP_FILE"
fi

chown -R mysql:mysql /var/lib/mysql
exec "$@"
