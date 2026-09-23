import 'dart:convert';

import 'package:bunnybondz/bunny_bonds/cubit/bunny_bonds_cubit.dart';
import 'package:bunnybondz/bunny_bonds/view/bunny_bonds_logo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';

const _blue = Color(0xFF246BFD);
const _ink = Color(0xFF172033);
const _muted = Color(0xFF788195);
const _canvas = Color(0xFFF7F8FC);

class BunnyBondsPage extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BunnyBondCubit(),
      child: const _BunnyBondsFlow(),
    );
  }
}

class _BunnyBondsFlow extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) {
    final isAuthenticated = context.select<BunnyBondCubit, bool>(
      (cubit) => cubit.state.isAuthenticated,
    );
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: isAuthenticated
          ? const _AuthenticatedShell(key: ValueKey('authenticated'))
          : const _AuthenticationScreen(key: ValueKey('authentication')),
    );
  }
}

class _AuthenticationScreen extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final error = context.select<BunnyBondCubit, String?>(
      (cubit) => cubit.state.loginError,
    );
    return Scaffold(
      backgroundColor: _canvas,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 430),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _BrandMark(size: 62),
                  const SizedBox(height: 38),
                  Text(
                    'BunnyBonds',
                    style: Theme.of(context).textTheme.titleLarge
                        ?.copyWith(color: _ink, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Nearby people.\nReal plans.',
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      color: _ink,
                      fontWeight: FontWeight.w800,
                      height: 1.08,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Connect with nearby people for sports, travel, hobbies '
                    'and everyday plans — privately at first.',
                    style: TextStyle(color: _muted, height: 1.5),
                  ),
                  const SizedBox(height: 34),
                  TextField(
                    key: const Key('usernameField'),
                    onChanged: context.read<BunnyBondCubit>().usernameChanged,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Username',
                      hintText: 'user123',
                      prefixIcon: Icon(Icons.person_outline_rounded),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    key: const Key('passwordField'),
                    onChanged: context.read<BunnyBondCubit>().passwordChanged,
                    obscureText: true,
                    onSubmitted: (_) => context.read<BunnyBondCubit>().login(),
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      hintText: '123456',
                      prefixIcon: Icon(Icons.lock_outline_rounded),
                    ),
                  ),
                  if (error != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      error,
                      style: const TextStyle(color: Colors.redAccent),
                    ),
                  ],
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      key: const Key('loginButton'),
                      onPressed: context.read<BunnyBondCubit>().login,
                      child: const Text('Continue securely  →'),
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Center(
                    child: Text(
                      'Demo login: user123  /  123456',
                      style: TextStyle(color: _muted, fontSize: 12),
                    ),
                  ),
                  const SizedBox(height: 26),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _TinyPill(label: '✓ Verified', color: Color(0xFFE8F3FF)),
                      SizedBox(width: 8),
                      _TinyPill(label: '⌖ Nearby', color: Color(0xFFEFF1FF)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AuthenticatedShell extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final destination = context.select<BunnyBondCubit, BunnyBondDestination>(
      (cubit) => cubit.state.destination,
    );
    final page = switch (destination) {
      BunnyBondDestination.home => const _NearbyBondsScreen(),
      BunnyBondDestination.explore => const _NearbyBondsScreen(isExplore: true),
      BunnyBondDestination.chats => const _AnonymousChatScreen(),
      BunnyBondDestination.profile => const _ProfileScreen(),
    };
    return Scaffold(
      backgroundColor: _canvas,
      body: SafeArea(child: page),
      floatingActionButton:
          destination == BunnyBondDestination.home ||
              destination == BunnyBondDestination.explore
          ? FloatingActionButton(
              key: const Key('createBondButton'),
              tooltip: 'Create Bond',
              backgroundColor: _blue,
              foregroundColor: Colors.white,
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Demo bond created!')),
                );
              },
              child: const Icon(Icons.add_rounded),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: destination.index,
        onDestinationSelected: context.read<BunnyBondCubit>().selectDestination,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            selectedIcon: Icon(Icons.explore_rounded),
            label: 'Explore',
          ),
          NavigationDestination(
            icon: Icon(Icons.chat_bubble_outline_rounded),
            selectedIcon: Icon(Icons.chat_bubble_rounded),
            label: 'Chats',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class _NearbyBondsScreen extends StatelessWidget {
  const new({this.isExplore = false});

  final bool isExplore;

  @override
  Widget build(BuildContext context) {
    final selectedCategory = context.select<BunnyBondCubit, String>(
      (cubit) => cubit.state.category,
    );
    return CustomScrollView(
      key: const Key('nearbyBondsScreen'),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
          sliver: SliverList.list(
            children: [
              const Row(
                children: [
                  _BrandMark(size: 34),
                  SizedBox(width: 8),
                  Text(
                    'BunnyBonds',
                    style: TextStyle(
                      color: _blue,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Spacer(),
                  _TinyPill(label: '⌖ Miyapur', color: Color(0xFFF0F2F8)),
                ],
              ),
              const SizedBox(height: 28),
              Text(
                isExplore ? 'Explore nearby bonds' : "What's happening nearby?",
                style: Theme.of(context).textTheme.headlineSmall
                    ?.copyWith(color: _ink, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 4),
              const Text(
                'Fresh bonds around you',
                style: TextStyle(color: _muted),
              ),
              const SizedBox(height: 18),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: ['For you', 'Sports', 'Travel', 'Social']
                    .map(
                      (category) => ChoiceChip(
                        label: Text(category),
                        selected: selectedCategory == category,
                        onSelected: (_) => context
                            .read<BunnyBondCubit>()
                            .selectCategory(category),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 18),
              const _BondCard(
                icon: '🏸',
                title: '2 badminton slots free',
                meta: '1.2 km  ·  Today, 7:30 PM',
                description:
                    'Looking for two players for doubles. Intermediate level.',
                bunny: 'Bunny #1821  ·  ✓ Verified',
              ),
              const SizedBox(height: 12),
              const _BondCard(
                icon: '🚇',
                title: 'Going to Gachibowli',
                meta: '0.8 km  ·  Today, 5:45 PM',
                description:
                    'Two places available. Leaving from Miyapur Metro side.',
                bunny: 'Bunny #1907  ·  ✓ Verified',
              ),
              const SizedBox(height: 12),
              const _BondCard(
                icon: '☕',
                title: 'Coffee after work?',
                meta: '2.2 km  ·  Tonight',
                description: 'New to the area — anyone up for a casual coffee?',
                bunny: 'Bunny #7354  ·  ✓ Verified',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AnonymousChatScreen extends StatefulWidget {
  const new();

  @override
  State<_AnonymousChatScreen> createState() => _AnonymousChatScreenState();
}

class _AnonymousChatScreenState extends State<_AnonymousChatScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _send() {
    context.read<BunnyBondCubit>().sendMessage(_controller.text);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final messages = context.select<BunnyBondCubit, List<String>>(
      (cubit) => cubit.state.messages,
    );
    return Column(
      key: const Key('anonymousChatScreen'),
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 14, 20, 12),
          child: Row(
            children: [
              Icon(Icons.arrow_back_ios_new_rounded, size: 18),
              SizedBox(width: 12),
              CircleAvatar(
                backgroundColor: Color(0xFFDDE8FF),
                child: Text('🐰'),
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bunny #4821',
                    style: TextStyle(fontWeight: FontWeight.w800, color: _ink),
                  ),
                  Text(
                    '✓ Verified  ·  4.6 bond score',
                    style: TextStyle(color: _blue, fontSize: 11),
                  ),
                ],
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(18),
            children: [
              const _MeetupCard(),
              const SizedBox(height: 18),
              for (var index = 0; index < messages.length; index++) ...[
                Align(
                  alignment: index.isEven
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: _MessageBubble(
                    message: messages[index],
                    isMine: index.isEven,
                  ),
                ),
                const SizedBox(height: 10),
              ],
              const SizedBox(height: 8),
              const _RevealCard(),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 14),
          child: TextField(
            key: const Key('messageField'),
            controller: _controller,
            onSubmitted: (_) => _send(),
            decoration: InputDecoration(
              hintText: 'Message Bunny #4821...',
              suffixIcon: IconButton(
                key: const Key('sendMessageButton'),
                onPressed: _send,
                icon: const Icon(Icons.send_rounded, color: _blue),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ProfileScreen extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) {
    return ListView(
      key: const Key('profileScreen'),
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 32),
      children: [
        Text(
          'Your profile',
          style: Theme.of(context).textTheme.headlineSmall
              ?.copyWith(color: _ink, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 4),
        const Text(
          'What others see before you connect',
          style: TextStyle(color: _muted),
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF397BFF), Color(0xFF1260EF)],
            ),
            borderRadius: BorderRadius.circular(22),
          ),
          child: const Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: Color(0xFFDDE8FF),
                    child: Text('🐰', style: TextStyle(fontSize: 25)),
                  ),
                  SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bunny #9132',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        'Miyapur  ·  Member since Sep 2025',
                        style: TextStyle(
                          color: Color(0xFFDCE7FF),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 22),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _Metric(value: '4.9', label: 'Bond score'),
                  _Metric(value: '13', label: 'Bonds'),
                  _Metric(value: '100%', label: 'Positive'),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const _SectionTitle('Trust & verification'),
        const SizedBox(height: 10),
        const _TrustTile(
          icon: Icons.check_rounded,
          title: 'Phone verified',
          subtitle: 'Your number stays private',
          color: Color(0xFFE3ECFF),
        ),
        const SizedBox(height: 10),
        const _TrustTile(
          icon: Icons.location_on_outlined,
          title: 'Location verified',
          subtitle: 'Miyapur · approximate only',
          color: Color(0xFFE8F1FF),
        ),
        const SizedBox(height: 10),
        const _TrustTile(
          icon: Icons.fingerprint_rounded,
          title: 'Identity verification',
          subtitle: 'Optional · increases trust',
          color: Color(0xFFFFF1EC),
        ),
        const SizedBox(height: 24),
        const _SectionTitle('Your Bonds'),
        const SizedBox(height: 12),
        const Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _TinyPill(label: '🏸 6 Sports', color: Color(0xFFEAF1FF)),
            _TinyPill(label: '🤝 4 Social', color: Color(0xFFFFF0E8)),
            _TinyPill(label: '✈ 3 Travel', color: Color(0xFFEDEAFF)),
          ],
        ),
      ],
    );
  }
}

class _BondCard extends StatelessWidget {
  const new({
    required this.icon,
    required this.title,
    required this.meta,
    required this.description,
    required this.bunny,
  });

  final String icon;
  final String title;
  final String meta;
  final String description;
  final String bunny;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D172033),
            blurRadius: 18,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFFF2F5FF),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Text(icon, style: const TextStyle(fontSize: 21)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: _ink,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 3),
                Text(meta, style: const TextStyle(color: _muted, fontSize: 11)),
                const SizedBox(height: 12),
                Text(
                  description,
                  style: const TextStyle(color: _ink, height: 1.35),
                ),
                const SizedBox(height: 10),
                Text(bunny, style: const TextStyle(color: _blue, fontSize: 11)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MeetupCard extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F0FF),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Row(
        children: [
          Text('🏸', style: TextStyle(fontSize: 22)),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Badminton · Today 7:30 PM',
                style: TextStyle(color: _ink, fontWeight: FontWeight.w800),
              ),
              Text(
                'Miyapur · 2 spots · Bond active',
                style: TextStyle(color: _muted),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const new({required this.message, required this.isMine});

  final String message;
  final bool isMine;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 280),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        color: isMine ? _blue : Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(16),
          topRight: const Radius.circular(16),
          bottomLeft: Radius.circular(isMine ? 16 : 4),
          bottomRight: Radius.circular(isMine ? 4 : 16),
        ),
      ),
      child: Text(
        message,
        style: TextStyle(color: isMine ? Colors.white : _ink),
      ),
    );
  }
}

class _RevealCard extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF4D8),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '🔒 Ready to reveal?',
            style: TextStyle(color: _ink, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 4),
          const Text(
            'Identity is shared only when both people agree.',
            style: TextStyle(color: _muted, fontSize: 12),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              FilledButton.tonal(
                onPressed: () {},
                child: const Text('Share identity'),
              ),
              const SizedBox(width: 10),
              TextButton(onPressed: () {}, child: const Text('Not yet')),
            ],
          ),
        ],
      ),
    );
  }
}

class _BrandMark extends StatelessWidget {
  const new({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size * 1.45,
      height: size,
      child: Image.memory(
        base64Decode(bunnyBondsLogoData),
        fit: BoxFit.contain,
        filterQuality: FilterQuality.high,
        gaplessPlayback: true,
      ),
    );
  }
}

class _TinyPill extends StatelessWidget {
  const new({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(label, style: const TextStyle(color: _ink, fontSize: 11)),
    );
  }
}

class _Metric extends StatelessWidget {
  const new({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w800,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Color(0xFFDCE7FF), fontSize: 10),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const new(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        color: _ink,
        fontSize: 16,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}

class _TrustTile extends StatelessWidget {
  const new({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 19, color: _blue),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: _ink,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(color: _muted, fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
