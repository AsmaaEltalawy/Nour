import 'package:flutter/foundation.dart';
import 'package:nour/services/auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Client {
  final Object? id;
  String name;
  String age;
  String number;
  String weight;

  Client({
    this.id,
    required this.name,
    required this.age,
    required this.number,
    required this.weight,
  });

  factory Client.fromMap(Map<String, dynamic> map) {
    return Client(
      id: map['id'],
      name: '${map['name'] ?? ''}',
      age: '${map['age'] ?? ''}',
      number: '${map['phone'] ?? ''}',
      weight: '${map['weight'] ?? ''}',
    );
  }

  Map<String, Object> toMap() {
    return {
      'name': name,
      'age': int.parse(age),
      'phone': number,
      'weight': double.parse(weight),
    };
  }
}

class HomeViewModel extends ChangeNotifier {
  HomeViewModel({SupabaseClient? supabase})
    : _supabase = supabase ?? Supabase.instance.client {
    loadClients();
  }

  static const int profilePage = 2;
  final SupabaseClient _supabase;
  final List<Client> _clients = [];

  String searchQuery = '';
  int selectedPage = 1;
  bool isLoadingClients = true;
  String? clientsError;

  List<Client> get clients => List.unmodifiable(_clients);

  List<Client> get filteredClients {
    final query = searchQuery.toLowerCase().trim();
    if (query.isEmpty) return clients;

    return _clients.where((client) {
      return client.name.toLowerCase().contains(query) ||
          client.age.toLowerCase().contains(query) ||
          client.number.toLowerCase().contains(query) ||
          client.weight.toLowerCase().contains(query);
    }).toList();
  }

  void selectPage(int page) {
    selectedPage = page;
    notifyListeners();
  }

  void setSearchQuery(String value) {
    searchQuery = value;
    notifyListeners();
  }

  Future<void> loadClients() async {
    try {
      final rows = await _supabase.from('clients').select().order('name');
      _clients
        ..clear()
        ..addAll(
          (rows as List).map(
            (row) => Client.fromMap(row as Map<String, dynamic>),
          ),
        );
      isLoadingClients = false;
      clientsError = null;
    } catch (_) {
      isLoadingClients = false;
      clientsError = 'Unable to load clients. Please try again.';
    }
    notifyListeners();
  }

  Future<Object?> saveClient(Client value, {Client? existing}) async {
    try {
      if (existing == null) {
        await _supabase.from('clients').insert(value.toMap());
      } else if (existing.id != null) {
        await _supabase
            .from('clients')
            .update(value.toMap())
            .eq('id', existing.id!);
      } else {
        await _supabase
            .from('clients')
            .update(value.toMap())
            .match(existing.toMap());
      }
      await loadClients();
      return null;
    } catch (error) {
      return error;
    }
  }

  Future<Object?> deleteClient(Client client) async {
    try {
      final query = _supabase.from('clients').delete();
      if (client.id != null) {
        await query.eq('id', client.id!);
      } else {
        await query.match(client.toMap());
      }
      await loadClients();
      return null;
    } catch (error) {
      return error;
    }
  }

  Future<Object?> logout() async {
    try {
      await AuthService.signOut();
      return null;
    } catch (error) {
      return error;
    }
  }
}
