import 'package:mysql_dart/mysql_dart.dart';

import 'database_config.dart';

class DatabaseService {
  MySQLConnection? _connection;

  Future<void> connect() async {
    _connection = await MySQLConnection.createConnection(
      host: DatabaseConfig.host,
      port: DatabaseConfig.port,
      userName: DatabaseConfig.username,
      password: DatabaseConfig.password,
      databaseName: DatabaseConfig.database,
      secure: false,
    );

    await _connection!.connect();

    print('Conectado ao MariaDB com sucesso!');
  }

  MySQLConnection get connection {
    if (_connection == null) {
      throw Exception(
        'Banco de dados ainda não foi conectado.',
      );
    }

    return _connection!;
  }

  Future<void> close() async {
    await _connection?.close();
    _connection = null;
  }
}