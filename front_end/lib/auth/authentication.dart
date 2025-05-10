import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient supabase = Supabase.instance.client;
  Future<User?> signUp(String email, String password) async {
    try {
      final response=await supabase.auth.signUp(
        email: email,
        password: password,
      );
      return response.user!;
    } catch (e) {
      
      return null;
    }
  }


  Future<User?> login(String email, String password) async {
    try {
      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
    return response.user!;
      
    } catch (e) {
      print("Login Error: $e");
      return null;
    }
  }


  Future<void> logout() async {
    SupabaseClient supabase = Supabase.instance.client;
    await supabase.auth.signOut();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool('islogedin', false);
    
  }
}



Future<String> getUserData() async {
   final user = Supabase.instance.client.auth.currentUser;
  return user?.email?.toString() ?? 'No email';
}


