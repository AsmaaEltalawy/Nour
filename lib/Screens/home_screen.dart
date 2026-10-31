import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nour/services/auth_service.dart';
import 'package:nour/viewmodels/home_view_model.dart';

import 'splash_screen.dart';

const Color nourTeal = Color(0xFF055F67);
const Color nourSage = Color(0xFF9EB998);
const Color nourCream = Color(0xFFEDEDDD);
const Color nourGreen = Color(0xFF67917D);
const Color nourDark = Color(0xFF0A393C);
const Color nourBackground = Color(0xFFFCFCF9);

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController searchController = TextEditingController();
  late final HomeViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = HomeViewModel()..addListener(_refresh);
  }

  @override
  void dispose() {
    _viewModel.removeListener(_refresh);
    _viewModel.dispose();
    searchController.dispose();
    super.dispose();
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: nourBackground,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(top: 50, right: 6),
              child: SizedBox(
                width: 170,
                child: Image.asset(
                  'lib/assets/images/flower.png',
                  fit: BoxFit.contain,
                  alignment: Alignment.topRight,
                ),
              ),
            ),
          ),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isDesktop = constraints.maxWidth >= 750;

                if (isDesktop) {
                  return Row(
                    children: [
                      _buildSidebar(),
                      Expanded(child: _buildMainContent(true)),
                    ],
                  );
                }

                return _buildMainContent(false);
              },
            ),
          ),
        ],
      ),
    );
  }

  // SIDEBAR

  Widget _buildSidebar() {
    return Container(
      width: 202,
      decoration: BoxDecoration(
        color: const Color(0xFFF6F7F2),
        border: Border(right: BorderSide(color: nourSage.withOpacity(0.15))),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 24, 12, 55),
            child: Row(
              children: [
                const Icon(Icons.spa_rounded, color: nourGreen, size: 35),
                const SizedBox(width: 7),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Nour',
                        style: TextStyle(
                          color: nourTeal,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Your Health, Our Priority',
                        style: TextStyle(
                          color: nourGreen,
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          _sidebarItem(icon: Icons.home_rounded, title: 'Home', index: 0),
          _sidebarItem(icon: Icons.groups_rounded, title: 'Clients', index: 1),
          _sidebarItem(
            icon: Icons.person_outline_rounded,
            title: 'Profile',
            index: 2,
          ),
        ],
      ),
    );
  }

  Widget _sidebarItem({
    required IconData icon,
    required String title,
    required int index,
  }) {
    final selected = _viewModel.selectedPage == index;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () => _viewModel.selectPage(index),
        child: Container(
          height: 43,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: selected ? nourSage.withOpacity(0.20) : Colors.transparent,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 21,
                color: selected ? nourTeal : Colors.grey.shade400,
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  color: selected ? nourTeal : Colors.grey.shade500,
                  fontSize: 13,
                  fontWeight: selected ? FontWeight.bold : FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // MAIN CONTENT

  Widget _buildMainContent(bool isDesktop) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: isDesktop ? 30 : 20,
              vertical: 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTopBar(),
                const SizedBox(height: 24),
                if (_viewModel.selectedPage == HomeViewModel.profilePage)
                  _buildProfileContent()
                else ...[
                  _buildWelcome(isDesktop),
                  const SizedBox(height: 24),
                  _buildSummaryAndAdd(isDesktop),
                  const SizedBox(height: 16),
                  _buildSearch(),
                  const SizedBox(height: 20),
                  _buildClientHeading(),
                  const SizedBox(height: 10),
                  if (isDesktop)
                    _buildClientTable(isDesktop: true)
                  else
                    _buildMobileClientList(),
                ],
              ],
            ),
          ),
        ),
        if (!isDesktop) _buildMobileNavigation(),
      ],
    );
  }

  Widget _buildTopBar() {
    return Row(
      children: [
        const Spacer(),
        Stack(
          clipBehavior: Clip.none,
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.notifications_none_rounded,
                color: nourTeal,
                size: 27,
              ),
            ),
            Positioned(
              right: 9,
              top: 9,
              child: Container(
                width: 7,
                height: 7,
                decoration: const BoxDecoration(
                  color: nourSage,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 12),
        PopupMenuButton<String>(
          tooltip: 'Account menu',
          onSelected: (value) {
            if (value == 'profile') {
              _viewModel.selectPage(HomeViewModel.profilePage);
            } else if (value == 'logout') {
              _confirmLogout();
            }
          },
          itemBuilder: (context) => const [
            PopupMenuItem(value: 'profile', child: Text('Profile')),
            PopupMenuItem(value: 'logout', child: Text('Log out')),
          ],
          child: _buildAvatar(39),
        ),
      ],
    );
  }

  Widget _buildAvatar(double size) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: const BoxDecoration(color: nourSage, shape: BoxShape.circle),
      child: const Text(
        'SP',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildProfileContent() {
    final email = AuthService.currentUser?.email ?? 'Signed-in client';

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: Card(
          color: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: nourSage.withOpacity(0.20)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Profile',
                  style: TextStyle(
                    color: nourTeal,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    _buildAvatar(58),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        email,
                        style: TextStyle(
                          color: nourDark,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _confirmLogout,
                    icon: const Icon(Icons.logout_rounded),
                    label: const Text('Log out'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: nourTeal,
                      side: const BorderSide(color: nourTeal),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _confirmLogout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Log out?'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Log out'),
          ),
        ],
      ),
    );

    if (shouldLogout != true || !mounted) return;

    final error = await _viewModel.logout();
    if (error == null) {
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute<void>(builder: (_) => const SplashScreen()),
        (_) => false,
      );
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to log out. Please try again.')),
      );
    }
  }

  Widget _buildWelcome(bool isDesktop) {
    return SizedBox(
      height: isDesktop ? 105 : 125,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Welcome back, Sarah',
            style: TextStyle(
              color: nourGreen,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'Manage your clients',
            style: TextStyle(
              color: nourTeal,
              fontSize: isDesktop ? 28 : 23,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Keep all your client information organized in one place.',
            style: TextStyle(
              color: nourGreen,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // SUMMARY AND ADD BUTTON

  Widget _buildSummaryAndAdd(bool isDesktop) {
    final summary = _buildSummaryCard();

    final addButton = SizedBox(
      height: 42,
      child: ElevatedButton.icon(
        onPressed: () => _showClientDialog(),
        icon: const Icon(Icons.add_circle_rounded, size: 21),
        label: const Text(
          'Add New Client',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: nourTeal,
          foregroundColor: Colors.white,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(11),
          ),
        ),
      ),
    );

    if (!isDesktop) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [summary, const SizedBox(height: 12), addButton],
      );
    }

    return Row(
      children: [
        SizedBox(width: 310, child: summary),
        const SizedBox(width: 32),
        addButton,
      ],
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      height: 88,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
        color: nourCream.withOpacity(0.60),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: nourSage.withOpacity(0.18)),
      ),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: nourSage.withOpacity(0.28),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.groups_rounded,
              color: Color(0xFF25976A),
              size: 36,
            ),
          ),
          const SizedBox(width: 16),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${_viewModel.clients.length}',
                style: TextStyle(
                  color: nourTeal,
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                  height: 1.1,
                ),
              ),
              const Text(
                'Total clients',
                style: TextStyle(
                  color: nourDark,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              const Row(
                children: [
                  Icon(
                    Icons.trending_up_rounded,
                    color: Color(0xFF25976A),
                    size: 14,
                  ),
                  SizedBox(width: 4),
                  Text(
                    '12 added this month',
                    style: TextStyle(
                      color: nourGreen,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // SEARCH

  Widget _buildSearch() {
    return SizedBox(
      height: 39,
      child: TextField(
        controller: searchController,
        onChanged: _viewModel.setSearchQuery,
        style: const TextStyle(color: nourDark, fontSize: 12),
        decoration: InputDecoration(
          hintText: 'Search clients',
          hintStyle: TextStyle(
            color: nourDark.withOpacity(0.35),
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: nourGreen,
            size: 21,
          ),
          suffixIcon: IconButton(
            onPressed: () {
              searchController.clear();
              _viewModel.setSearchQuery('');
            },
            icon: const Icon(Icons.cancel_outlined, color: nourSage, size: 18),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(vertical: 8),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: nourSage.withOpacity(0.35)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: nourGreen),
          ),
        ),
      ),
    );
  }

  // CUSTOMER SECTION

  Widget _buildClientHeading() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Clients',
          style: TextStyle(
            color: nourDark,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          '${_viewModel.filteredClients.length} matching clients',
          style: TextStyle(
            color: nourGreen,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  // DESKTOP TABLE

  Widget _buildClientTable({bool isDesktop = false}) {
    final list = _viewModel.filteredClients;

    if (_viewModel.isLoadingClients) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(30),
          child: CircularProgressIndicator(color: nourTeal),
        ),
      );
    }

    if (_viewModel.clientsError != null) {
      return _buildClientError();
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.75),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: nourSage.withOpacity(0.20)),
        boxShadow: [
          BoxShadow(
            color: nourDark.withOpacity(0.035),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildTableHeader(isDesktop: isDesktop),
          if (list.isEmpty)
            const Padding(
              padding: EdgeInsets.all(30),
              child: Text(
                'No clients found',
                style: TextStyle(color: nourGreen),
              ),
            )
          else
            ...List.generate(
              list.length,
              (index) =>
                  _buildTableRow(list[index], index, isDesktop: isDesktop),
            ),
        ],
      ),
    );
  }

  Widget _buildClientError() {
    return Center(
      child: Column(
        children: [
          Text(
            _viewModel.clientsError!,
            style: const TextStyle(color: nourGreen),
          ),
          TextButton(
            onPressed: _viewModel.loadClients,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeader({bool isDesktop = false}) {
    return Container(
      height: isDesktop ? 48 : 32,
      padding: EdgeInsets.symmetric(horizontal: isDesktop ? 22 : 16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: nourSage.withOpacity(0.18))),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Text(
              'Client',
              style: TextStyle(
                color: nourGreen,
                fontSize: isDesktop ? 12 : 9,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              'Age',
              style: TextStyle(
                color: nourGreen,
                fontSize: isDesktop ? 12 : 9,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              'Number',
              style: TextStyle(
                color: nourGreen,
                fontSize: isDesktop ? 12 : 9,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              'Weight',
              style: TextStyle(
                color: nourGreen,
                fontSize: isDesktop ? 12 : 9,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            width: 55,
            child: Text(
              'Actions',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: nourGreen,
                fontSize: isDesktop ? 12 : 9,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableRow(Client client, int index, {bool isDesktop = false}) {
    return Container(
      height: isDesktop ? 64 : 41,
      padding: EdgeInsets.symmetric(horizontal: isDesktop ? 22 : 16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: nourSage.withOpacity(0.14))),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Row(
              children: [
                _avatar(client.name, index, size: isDesktop ? 40 : 29),
                SizedBox(width: isDesktop ? 16 : 13),
                Expanded(
                  child: Text(
                    client.name,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: nourDark,
                      fontSize: isDesktop ? 14 : 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              client.age,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: nourGreen,
                fontSize: isDesktop ? 14 : 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              client.number,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: nourGreen,
                fontSize: isDesktop ? 14 : 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              client.weight,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: nourGreen,
                fontSize: isDesktop ? 14 : 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(
            width: 55,
            child: PopupMenuButton<String>(
              tooltip: 'Client actions',
              padding: EdgeInsets.zero,
              icon: Icon(
                Icons.more_horiz_rounded,
                color: nourGreen,
                size: isDesktop ? 24 : 19,
              ),
              onSelected: (value) {
                if (value == 'edit') {
                  _showClientDialog(client: client);
                } else if (value == 'delete') {
                  _confirmDelete(client);
                }
              },
              itemBuilder: (context) => const [
                PopupMenuItem(value: 'edit', child: Text('Edit')),
                PopupMenuItem(value: 'delete', child: Text('Delete')),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // MOBILE CUSTOMER LIST

  Widget _buildMobileClientList() {
    if (_viewModel.isLoadingClients) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(30),
          child: CircularProgressIndicator(color: nourTeal),
        ),
      );
    }

    if (_viewModel.clientsError != null) return _buildClientError();

    final list = _viewModel.filteredClients;

    if (list.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(30),
        child: Center(
          child: Text('No clients found', style: TextStyle(color: nourGreen)),
        ),
      );
    }

    return Column(
      children: List.generate(
        list.length,
        (index) => Padding(
          padding: const EdgeInsets.only(bottom: 9),
          child: _buildMobileCard(list[index], index),
        ),
      ),
    );
  }

  Widget _buildMobileCard(Client client, int index) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: nourSage.withOpacity(0.20)),
      ),
      child: Row(
        children: [
          _avatar(client.name, index, size: 40),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  client.name,
                  style: TextStyle(
                    color: nourTeal,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Age: ${client.age}',
                  style: const TextStyle(color: nourGreen, fontSize: 10),
                ),
                Text(
                  'Number: ${client.number}  •  Weight: ${client.weight}',
                  style: const TextStyle(color: nourGreen, fontSize: 10),
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'edit') {
                _showClientDialog(client: client);
              } else if (value == 'delete') {
                _confirmDelete(client);
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'edit', child: Text('Edit')),
              PopupMenuItem(value: 'delete', child: Text('Delete')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _avatar(String name, int index, {double size = 38}) {
    final initials = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .map((part) => part[0])
        .take(2)
        .join()
        .toUpperCase();

    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: index.isEven ? nourSage.withOpacity(0.55) : nourCream,
        shape: BoxShape.circle,
      ),
      child: Text(
        initials,
        style: TextStyle(
          color: nourTeal,
          fontSize: size * 0.34,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // ADD AND EDIT CUSTOMER

  void _showClientDialog({Client? client}) {
    final isEditing = client != null;
    final formKey = GlobalKey<FormState>();

    final nameController = TextEditingController(text: client?.name ?? '');
    final ageController = TextEditingController(text: client?.age ?? '');
    final numberController = TextEditingController(text: client?.number ?? '');
    final weightController = TextEditingController(text: client?.weight ?? '');

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          title: Text(
            isEditing ? 'Edit Client' : 'Add New Client',
            style: TextStyle(color: nourDark, fontWeight: FontWeight.bold),
          ),
          content: Form(
            key: formKey,
            child: SizedBox(
              width: 350,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _dialogField(nameController, 'Full name'),
                    const SizedBox(height: 13),
                    _dialogField(ageController, 'Age'),
                    const SizedBox(height: 13),
                    _dialogField(
                      numberController,
                      'Phone number',
                      isPhone: true,
                    ),
                    const SizedBox(height: 13),
                    _dialogField(weightController, 'Weight'),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel', style: TextStyle(color: nourGreen)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: nourTeal,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                if (!formKey.currentState!.validate()) return;

                final updatedClient = Client(
                  id: client?.id,
                  name: nameController.text.trim(),
                  age: ageController.text.trim(),
                  number: numberController.text.trim(),
                  weight: weightController.text.trim(),
                );
                _viewModel.saveClient(updatedClient, existing: client).then((
                  error,
                ) {
                  if (dialogContext.mounted) Navigator.pop(dialogContext);
                  if (error != null && mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Unable to save client. Please try again.',
                        ),
                      ),
                    );
                  }
                });
              },
              child: Text(isEditing ? 'Save Changes' : 'Add Client'),
            ),
          ],
        );
      },
    ).then((_) {
      nameController.dispose();
      ageController.dispose();
      numberController.dispose();
      weightController.dispose();
    });
  }

  Widget _dialogField(
    TextEditingController controller,
    String label, {
    bool isPhone = false,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: isPhone ? TextInputType.phone : TextInputType.text,
      inputFormatters: isPhone
          ? [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(11),
            ]
          : null,
      maxLength: isPhone ? 11 : null,
      style: TextStyle(color: nourDark),
      validator: (value) {
        final input = value?.trim() ?? '';
        if (input.isEmpty) {
          return '$label is required';
        }
        if (isPhone && !RegExp(r'^\d{11}$').hasMatch(input)) {
          return 'Phone number must be exactly 11 digits';
        }

        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: nourGreen),
        filled: true,
        fillColor: nourBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: const BorderSide(color: nourTeal),
        ),
      ),
    );
  }

  void _confirmDelete(Client client) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text('Delete Client?', style: TextStyle(color: nourDark)),
        content: Text(
          'Are you sure you want to delete ${client.name}?',
          style: const TextStyle(color: nourGreen),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel', style: TextStyle(color: nourGreen)),
          ),
          TextButton(
            onPressed: () async {
              final error = await _viewModel.deleteClient(client);
              if (error == null) {
                if (dialogContext.mounted) Navigator.pop(dialogContext);
              } else {
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Unable to delete client. Please try again.'),
                  ),
                );
              }
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );
  }

  // MOBILE NAVIGATION

  Widget _buildMobileNavigation() {
    return Container(
      height: 65,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: nourSage.withOpacity(0.20))),
      ),
      child: Row(
        children: [
          _mobileNavItem(Icons.home_rounded, 'Home', 0),
          _mobileNavItem(Icons.groups_rounded, 'Clients', 1),
          _mobileNavItem(Icons.person_outline_rounded, 'Profile', 2),
        ],
      ),
    );
  }

  Widget _mobileNavItem(IconData icon, String label, int index) {
    final selected = _viewModel.selectedPage == index;

    return Expanded(
      child: InkWell(
        onTap: () {
          _viewModel.selectPage(index);
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: selected ? nourTeal : nourSage, size: 23),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                color: selected ? nourTeal : nourSage,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
