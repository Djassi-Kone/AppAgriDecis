// Test d'intégration- À exécuter pour vérifier la connexion au backend
// ========================================================================

import'dart:convert';
import'package:http/http.dart' as http;
import 'api_config.dart';

void main() async {
  print('🚜 TEST D\'INTÉGRATION AGRIDECIS 🌾');
  print('====================================\n');
  
  // Test 1 : Vérifier que le backend est accessible
  print('Test 1: Vérification du backend...');
  await testBackendConnection();
  
  // Test 2 : Tester l'API de login (avec des identifiants invalides)
  print('\nTest 2: Test endpoint login...');
  await testLoginEndpoint();
  
  print('\n✅ Tests terminés !');
}

Future<void> testBackendConnection() async {
  try {
   final response = await http.get(Uri.parse('${ApiConfig.baseUrl}/'));
    
    if (response.statusCode == 200 || response.statusCode == 404) {
      print('✓ Backend accessible: ${ApiConfig.baseUrl}');
      print('  Status: ${response.statusCode}');
    } else {
      print('✗ Erreur: Status ${response.statusCode}');
    }
  } catch (e) {
    print('✗ Backend non accessible');
    print('  Erreur: $e');
    print('\n💡 Solution:');
    print('  1. Lancez le backend: cd AgriDecis && python manage.py runserver');
    print('   2. Vérifiez l\'URL dans api_config.dart');
    print('   3. Pour Android Emulator: http://10.0.2.2:8000');
    print('   4. Pour Web/iOS: http://localhost:8000');
  }
}

Future<void> testLoginEndpoint() async {
  try {
   final response = await http.post(
      Uri.parse(ApiConfig.loginEndpoint),
    headers: {'Content-Type': 'application/json'},
    body: json.encode({
        'email': 'test@test.com',
        'password': 'test',
      }),
    );
    
   final data = json.decode(response.body);
    
    // On s'attend à une erreur 400 (identifiants invalides)
    // mais ça prouve que l'API fonctionne
    if (response.statusCode == 400) {
      print('✓ Endpoint login fonctionnel');
      print('  Réponse attendue (erreur identifiants): ${data['success']}');
    } else if (response.statusCode == 200) {
      print('⚠ Connexion réussie (test avec vrais identifiants ?)');
      print('  User: ${data['utilisateur']}');
    } else {
      print('✗ Erreur inattendue: ${response.statusCode}');
      print('  Response: ${data}');
    }
  } catch (e) {
    print('✗ Endpoint login non accessible');
    print('  Erreur: $e');
  }
}

// Autres tests à implémenter:
// - Test d'inscription
// - Test météo
// - Test diagnostic IA
// - Test refresh token
