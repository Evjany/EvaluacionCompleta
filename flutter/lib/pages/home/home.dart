import 'package:flutter/material.dart';
import '../widgets/appbar.dart';
import '../widgets/navigation_drawer.dart';
import '../widgets/navigation_botton.dart';
import '../user/user.dart';
import '../auth/change_password.dart';
import '../auth/login.dart';
import '../services/api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key}); // ← Ya no recibe parámetros

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  
  String? _userEmail; // Para mostrar en el drawer y en HomeContent
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _loadUserEmail();
    _pages = [
      const HomeContent(),       // Ya no pasamos username
      const UserScreen(),        // Asumimos que UserScreen se modificará para no requerir parámetros
      const ChangePasswordScreen(),
    ];
  }

  Future<void> _loadUserEmail() async {
    final email = await ApiService.getUserEmail();
    setState(() {
      _userEmail = email ?? 'Usuario';
    });
  }

  void _onDrawerItemSelected(int index) {
    setState(() {
      _currentIndex = index;
      _pageController.jumpToPage(index);
    });
    _scaffoldKey.currentState?.closeDrawer();
  }

  void _logout() async {
    await ApiService.logout(); // Limpia token y email
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(
        title: _getTitle(),
        showBackButton: false,
        onMenuPressed: () => _scaffoldKey.currentState?.openDrawer(),
      ),
      drawer: CustomDrawer(
        username: _userEmail ?? 'Cargando...',
        onItemSelected: _onDrawerItemSelected,
        onLogout: _logout,
        currentIndex: _currentIndex,
      ),
      body: PageView(
        controller: _pageController,
        children: _pages,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      bottomNavigationBar: BottomNavigation(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          _pageController.jumpToPage(index);
        },
      ),
    );
  }

  String _getTitle() {
    switch (_currentIndex) {
      case 0:
        return 'Inicio';
      case 1:
        return 'Perfil';
      case 2:
        return 'Clientes';
      case 3:
        return 'Configuración';
      default:
        return 'Mi App';
    }
  }
}

// ========== HOME CONTENT (ahora obtiene el email con FutureBuilder) ==========
class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: ApiService.getUserEmail(),
      builder: (context, snapshot) {
        String username = snapshot.data ?? 'Usuario';
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '¡Bienvenido, $username!',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Icon(Icons.home, size: 50, color: Colors.blue),
                      SizedBox(height: 10),
                      Center(
                        child: Text('Esta es la pantalla principal de la aplicación'),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Usa el menú lateral o la barra de navegación inferior para explorar las diferentes secciones.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              GridView.count(
                shrinkWrap: true,
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: [
                  _buildFeatureCard(Icons.person, 'Perfil', Colors.blue),
                  _buildFeatureCard(Icons.settings, 'Configuración', Colors.green),
                  _buildFeatureCard(Icons.notifications, 'Notificaciones', Colors.orange),
                  _buildFeatureCard(Icons.help, 'Ayuda', Colors.purple),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFeatureCard(IconData icon, String title, Color color) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}