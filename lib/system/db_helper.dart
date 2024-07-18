import 'package:connect_to_sql_server_directly/connect_to_sql_server_directly.dart';
import 'package:demoaiemo/models/person.dart';

class DatabaseHelper {
  final _connectToSqlServerDirectlyPlugin = ConnectToSqlServerDirectly();

  Future<bool> initializeConnection() async {
    return await _connectToSqlServerDirectlyPlugin.initializeConnection(
      '192.168.1.91', // serverIp
      'AIEmo', // databaseName
      'brm', // username
      'brm', // password
      instance: 'node',
    );
  }

  Future<List<Map<String, dynamic>>> getUsers() async {
    try {
      return await _connectToSqlServerDirectlyPlugin.getRowsOfQueryResult("SELECT * FROM dbo.Users");
    } catch (error) {
      throw Exception('Kullanıcı yüklemesi başarısısız: $error');
    }
  }

  Future<bool> addUser(Person user) async {
    try {
      return await _connectToSqlServerDirectlyPlugin.getStatusOfQueryResult(
        "INSERT INTO dbo.Users (Username, Password, Age, Gender, Occupation) VALUES ('${user.username}', '${user.password}', ${user.age}, '${user.gender}', '${user.occupation}')",
      );
    } catch (error) {
      throw Exception('Failed to add user: $error');
    }
  }
}


