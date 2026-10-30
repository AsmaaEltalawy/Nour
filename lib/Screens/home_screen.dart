import 'package:flutter/material.dart';

const Color nourTeal = Color(0xFF055F67);
const Color nourSage = Color(0xFF9EB998);
const Color nourCream = Color(0xFFEDEDDD);
const Color nourGreen = Color(0xFF67917D);
const Color nourDark = Color(0xFF0A393C);
const Color nourBackground = Color(0xFFFCFCF9);

class Customer {
  String name;
  String email;
  String phone;

  Customer({required this.name, required this.email, required this.phone});
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController searchController = TextEditingController();

  String searchQuery = '';
  int selectedPage = 1;
  int addedCustomers = 0;

  final List<Customer> customers = [
    Customer(
      name: 'Amelia Johnson',
      email: 'amelia.johnson@email.com',
      phone: '(555) 123-4567',
    ),
    Customer(
      name: 'Noah Williams',
      email: 'noah.williams@email.com',
      phone: '(555) 234-5678',
    ),
    Customer(
      name: 'Olivia Brown',
      email: 'olivia.brown@email.com',
      phone: '(555) 345-6789',
    ),
    Customer(
      name: 'Ethan Davis',
      email: 'ethan.davis@email.com',
      phone: '(555) 456-7890',
    ),
  ];

  List<Customer> get filteredCustomers {
    final query = searchQuery.toLowerCase().trim();

    if (query.isEmpty) return customers;

    return customers.where((customer) {
      return customer.name.toLowerCase().contains(query) ||
          customer.email.toLowerCase().contains(query) ||
          customer.phone.contains(query);
    }).toList();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
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
        crossAxisAlignment: CrossAxisAlignment.start,
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
          _sidebarItem(
            icon: Icons.groups_rounded,
            title: 'Customers',
            index: 1,
          ),
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
    final selected = selectedPage == index;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () {
          setState(() => selectedPage = index);

          if (index == 2) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Profile screen is not connected yet.'),
              ),
            );
          }
        },
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
                _buildWelcome(isDesktop),
                const SizedBox(height: 24),
                _buildSummaryAndAdd(isDesktop),
                const SizedBox(height: 16),
                _buildSearch(),
                const SizedBox(height: 20),
                _buildCustomerHeading(),
                const SizedBox(height: 10),
                if (isDesktop)
                  _buildCustomerTable()
                else
                  _buildMobileCustomerList(),
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
        Container(
          width: 39,
          height: 39,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: nourSage,
            shape: BoxShape.circle,
          ),
          child: const Text(
            'SP',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
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
            'Manage your customers',
            style: TextStyle(
              color: nourTeal,
              fontSize: isDesktop ? 28 : 23,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Keep all your customer information organized in one place.',
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

  Widget _buildPlantDecoration(double size) {
    return Image.asset(
      'lib/assets/images/Nour customer management home screen.png',
      width: size,
      height: size,
      fit: BoxFit.contain,
      alignment: Alignment.bottomRight,
    );
  }

  // SUMMARY AND ADD BUTTON

  Widget _buildSummaryAndAdd(bool isDesktop) {
    final summary = _buildSummaryCard();

    final addButton = SizedBox(
      height: 42,
      child: ElevatedButton.icon(
        onPressed: () => _showCustomerDialog(),
        icon: const Icon(Icons.add_circle_rounded, size: 21),
        label: const Text(
          'Add New Customer',
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
                '${128 + addedCustomers}',
                style: const TextStyle(
                  color: nourTeal,
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                  height: 1.1,
                ),
              ),
              const Text(
                'Total customers',
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
        onChanged: (value) {
          setState(() => searchQuery = value);
        },
        style: const TextStyle(color: nourDark, fontSize: 12),
        decoration: InputDecoration(
          hintText: 'Search customers',
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
              setState(() => searchQuery = '');
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

  Widget _buildCustomerHeading() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Customers',
          style: TextStyle(
            color: nourDark,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          '${filteredCustomers.length} matching customers',
          style: const TextStyle(
            color: nourGreen,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  // DESKTOP TABLE

  Widget _buildCustomerTable() {
    final list = filteredCustomers;

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
          _buildTableHeader(),
          if (list.isEmpty)
            const Padding(
              padding: EdgeInsets.all(30),
              child: Text(
                'No customers found',
                style: TextStyle(color: nourGreen),
              ),
            )
          else
            ...List.generate(
              list.length,
              (index) => _buildTableRow(list[index], index),
            ),
        ],
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      height: 32,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: nourSage.withOpacity(0.18))),
      ),
      child: const Row(
        children: [
          Expanded(
            flex: 4,
            child: Text(
              'Customer',
              style: TextStyle(
                color: nourGreen,
                fontSize: 9,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(
              'Email',
              style: TextStyle(
                color: nourGreen,
                fontSize: 9,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              'Phone',
              style: TextStyle(
                color: nourGreen,
                fontSize: 9,
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
                fontSize: 9,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableRow(Customer customer, int index) {
    return Container(
      height: 41,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: nourSage.withOpacity(0.14))),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Row(
              children: [
                _avatar(customer.name, index, size: 29),
                const SizedBox(width: 13),
                Expanded(
                  child: Text(
                    customer.name,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: nourDark,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(
              customer.email,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: nourGreen,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              customer.phone,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: nourGreen,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(
            width: 55,
            child: PopupMenuButton<String>(
              tooltip: 'Customer actions',
              padding: EdgeInsets.zero,
              icon: const Icon(
                Icons.more_horiz_rounded,
                color: nourGreen,
                size: 19,
              ),
              onSelected: (value) {
                if (value == 'edit') {
                  _showCustomerDialog(customer: customer);
                } else if (value == 'delete') {
                  _confirmDelete(customer);
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

  Widget _buildMobileCustomerList() {
    final list = filteredCustomers;

    if (list.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(30),
        child: Center(
          child: Text('No customers found', style: TextStyle(color: nourGreen)),
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

  Widget _buildMobileCard(Customer customer, int index) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: nourSage.withOpacity(0.20)),
      ),
      child: Row(
        children: [
          _avatar(customer.name, index, size: 40),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  customer.name,
                  style: const TextStyle(
                    color: nourTeal,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  customer.email,
                  style: const TextStyle(color: nourGreen, fontSize: 10),
                ),
                Text(
                  customer.phone,
                  style: const TextStyle(color: nourGreen, fontSize: 10),
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'edit') {
                _showCustomerDialog(customer: customer);
              } else if (value == 'delete') {
                _confirmDelete(customer);
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

  void _showCustomerDialog({Customer? customer}) {
    final isEditing = customer != null;
    final formKey = GlobalKey<FormState>();

    final nameController = TextEditingController(text: customer?.name ?? '');
    final emailController = TextEditingController(text: customer?.email ?? '');
    final phoneController = TextEditingController(text: customer?.phone ?? '');

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          title: Text(
            isEditing ? 'Edit Customer' : 'Add New Customer',
            style: const TextStyle(
              color: nourDark,
              fontWeight: FontWeight.bold,
            ),
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
                    _dialogField(emailController, 'Email address'),
                    const SizedBox(height: 13),
                    _dialogField(phoneController, 'Phone number'),
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

                final email = emailController.text.trim();

                final duplicate = customers.any(
                  (item) =>
                      item != customer &&
                      item.email.toLowerCase() == email.toLowerCase(),
                );

                if (duplicate) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('This email already exists.')),
                  );
                  return;
                }

                setState(() {
                  if (isEditing) {
                    customer!.name = nameController.text.trim();
                    customer.email = email;
                    customer.phone = phoneController.text.trim();
                  } else {
                    customers.insert(
                      0,
                      Customer(
                        name: nameController.text.trim(),
                        email: email,
                        phone: phoneController.text.trim(),
                      ),
                    );
                    addedCustomers++;
                  }
                });

                Navigator.pop(dialogContext);
              },
              child: Text(isEditing ? 'Save Changes' : 'Add Customer'),
            ),
          ],
        );
      },
    ).then((_) {
      nameController.dispose();
      emailController.dispose();
      phoneController.dispose();
    });
  }

  Widget _dialogField(TextEditingController controller, String label) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(color: nourDark),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return '$label is required';
        }

        if (label == 'Email address' &&
            !RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value.trim())) {
          return 'Enter a valid email';
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

  void _confirmDelete(Customer customer) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text(
          'Delete Customer?',
          style: TextStyle(color: nourDark),
        ),
        content: Text(
          'Are you sure you want to delete ${customer.name}?',
          style: const TextStyle(color: nourGreen),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel', style: TextStyle(color: nourGreen)),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                customers.remove(customer);
              });
              Navigator.pop(dialogContext);
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
          _mobileNavItem(Icons.groups_rounded, 'Customers', 1),
          _mobileNavItem(Icons.person_outline_rounded, 'Profile', 2),
        ],
      ),
    );
  }

  Widget _mobileNavItem(IconData icon, String label, int index) {
    final selected = selectedPage == index;

    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() => selectedPage = index);

          if (index == 2) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Profile screen is not connected yet.'),
              ),
            );
          }
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
