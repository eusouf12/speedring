import 'package:flutter/material.dart';
import 'package:speedring/utils/app_colors/app_colors.dart';

class SessionPostScreen extends StatefulWidget {
  const SessionPostScreen({super.key});

  @override
  State<SessionPostScreen> createState() => _SessionPostScreenState();
}

class _SessionPostScreenState extends State<SessionPostScreen> {
  final _summaryCtrl = TextEditingController(
    text:
        "Perfect morning session. The SF90 felt incredibly planted through Maggotts & Becketts. Optimised the pressures to 1.5 bar cold. Track surface was green with moisture on exit of the P...",
  );

  @override
  void dispose() {
    _summaryCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.close, color: Colors.white),
        ),
        title: const Text(
          "CREATE SESSION",
          style: TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text(
              "PUBLISH",
              style: TextStyle(
                color: AppColors.yellow,
                fontSize: 12,
                fontWeight: FontWeight.w900,
                letterSpacing: 1,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          /// ── Hero image ──────────────────────────────────────────────
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              children: [
                Image.network(
                  "https://picsum.photos/seed/f1car/600/240",
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      Container(height: 180, color: const Color(0xff1A1A1A)),
                ),
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.2),
                          Colors.black.withOpacity(0.6),
                        ],
                      ),
                    ),
                  ),
                ),
                const Positioned.fill(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.camera_alt_outlined,
                        color: AppColors.yellow,
                        size: 32,
                      ),
                      SizedBox(height: 6),
                      Text(
                        "ADD PHOTO",
                        style: TextStyle(
                          color: AppColors.yellow,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          /// ── Vehicle ─────────────────────────────────────────────────
          _FieldLabel("VEHICLE"),
          const SizedBox(height: 6),
          _SelectorRow(value: "Ferrari SF90 Stradale"),

          const SizedBox(height: 14),

          /// ── Circuit ─────────────────────────────────────────────────
          _FieldLabel("CIRCUIT"),
          const SizedBox(height: 6),
          _SelectorRow(value: "Silverstone Circuit"),

          const SizedBox(height: 14),

          /// ── Track Name ──────────────────────────────────────────────
          _FieldLabel("TRACK NAME"),
          const SizedBox(height: 6),
          _InputField(hint: "Grand Prix Loop", initialValue: "Grand Prix Loop"),

          const SizedBox(height: 20),

          /// ── Best Lap Time ────────────────────────────────────────────
          _FieldLabel("BEST LAP TIME"),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.yellow.withOpacity(0.5)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                Expanded(
                  child: Text(
                    "61:28.442",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
                Icon(Icons.timer_outlined, color: AppColors.yellow, size: 20),
              ],
            ),
          ),

          const SizedBox(height: 20),

          /// ── Top Speed ────────────────────────────────────────────────
          _FieldLabel("TOP SPEED ACHIEVED"),
          const SizedBox(height: 8),
          const Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "342",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 48,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(width: 8),
              Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Text(
                  "KM/H",
                  style: TextStyle(
                    color: AppColors.yellow,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          /// ── Driver Session Summary ───────────────────────────────────
          _FieldLabel("DRIVER SESSION SUMMARY"),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xff1A1A1A),
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              controller: _summaryCtrl,
              maxLines: 4,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
                height: 1.6,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),

          const SizedBox(height: 24),

          /// ── Publish button ───────────────────────────────────────────
          _PublishButton(label: "PUBLISH SESSION"),

          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

// ── Shared Widgets ────────────────────────────────────────────────────────────

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: const TextStyle(
      color: Colors.white38,
      fontSize: 9,
      fontWeight: FontWeight.w700,
      letterSpacing: 1.2,
    ),
  );
}

class _SelectorRow extends StatelessWidget {
  final String value;
  const _SelectorRow({required this.value});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    decoration: BoxDecoration(
      color: const Color(0xff1A1A1A),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      children: [
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const Icon(Icons.chevron_right, color: Colors.white38, size: 18),
      ],
    ),
  );
}

class _InputField extends StatelessWidget {
  final String hint;
  final String? initialValue;
  const _InputField({required this.hint, this.initialValue});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
    decoration: BoxDecoration(
      color: const Color(0xff1A1A1A),
      borderRadius: BorderRadius.circular(12),
    ),
    child: TextFormField(
      initialValue: initialValue,
      style: const TextStyle(color: Colors.white, fontSize: 13),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white38),
        border: InputBorder.none,
        isDense: true,
      ),
    ),
  );
}

class _PublishButton extends StatelessWidget {
  final String label;
  const _PublishButton({required this.label});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () => Navigator.pop(context),
    child: Container(
      height: 56,
      decoration: BoxDecoration(
        color: AppColors.yellow,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Center(
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
          ),
        ),
      ),
    ),
  );
}
