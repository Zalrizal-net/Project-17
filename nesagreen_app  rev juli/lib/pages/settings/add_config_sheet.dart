import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../models/planting_config_model.dart';
import '../../providers/config_provider.dart';

class AddConfigSheet extends ConsumerStatefulWidget {
  final PlantingConfigModel? existing;

  const AddConfigSheet({super.key, this.existing});

  @override
  ConsumerState<AddConfigSheet> createState() => _AddConfigSheetState();
}

class _AddConfigSheetState extends ConsumerState<AddConfigSheet> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameCtrl;
  late int _durationDays;
  late int _lamp1DelayDays;
  late int _lamp2DelayDays;
  late WateringMode _wateringMode;
  late int _soilThreshold;
  late List<String> _wateringTimes;
  late int _wateringDuration;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _nameCtrl = TextEditingController(text: e?.name ?? '');
    _durationDays = e?.durationDays ?? 14;
    _lamp1DelayDays = e?.lamp1DelayDays ?? 2;
    _lamp2DelayDays = e?.lamp2DelayDays ?? 2;
    _wateringMode = e?.wateringMode ?? WateringMode.time;
    _soilThreshold = e?.soilThreshold ?? 40;
    _wateringTimes = List.from(e?.wateringTimes ?? ['07:00', '17:00']);
    _wateringDuration = e?.wateringDuration ?? 30;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final isEditing = widget.existing != null;

    return Container(
      height: mq.size.height * 0.92,
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            // Handle
            Container(
              margin: const EdgeInsets.only(top: 10),
              width: 36, height: 4,
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 8, 4),
              child: Row(
                children: [
                  const Icon(Icons.eco_rounded, color: AppColors.primary, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    isEditing ? 'Edit Konfigurasi' : 'Tambah Konfigurasi',
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, size: 20),
                    onPressed: () => Navigator.pop(context),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // ── Nama ──────────────────────────────────────
                    _sheetCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _fieldLabel('Nama Konfigurasi', Icons.label_rounded),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _nameCtrl,
                            decoration: _inputDecoration('Contoh: Bayam Merah'),
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) {
                                return 'Nama tidak boleh kosong';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),

                    // ── Lama Hari ──────────────────────────────────
                    _sheetCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _fieldLabel('Lama Hari (Target)', Icons.calendar_month_rounded),
                          const SizedBox(height: 8),
                          _CounterRow(
                            value: _durationDays,
                            min: 1,
                            max: 365,
                            suffix: 'hari',
                            onChanged: (v) => setState(() => _durationDays = v),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),

                    // ── Pengaturan Lampu ───────────────────────────
                    _sheetCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _fieldLabel('Pengaturan Lampu', Icons.wb_incandescent_rounded),
                          const SizedBox(height: 4),
                          const Text(
                            'Minimal 2 hari sebelum lampu menyala.',
                            style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                          ),
                          const SizedBox(height: 12),
                          // Lamp 1
                          Row(
                            children: [
                              Icon(Icons.wb_incandescent_rounded,
                                  size: 14, color: AppColors.lamp1Color),
                              const SizedBox(width: 6),
                              const Text('Lampu 1 aktif mulai hari ke-',
                                  style: TextStyle(fontSize: 12)),
                              const Spacer(),
                              _CounterRow(
                                value: _lamp1DelayDays,
                                min: 2,
                                max: _durationDays,
                                suffix: '',
                                compact: true,
                                onChanged: (v) =>
                                    setState(() => _lamp1DelayDays = v),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          // Lamp 2
                          Row(
                            children: [
                              Icon(Icons.wb_incandescent_outlined,
                                  size: 14, color: AppColors.lamp2Color),
                              const SizedBox(width: 6),
                              const Text('Lampu 2 aktif mulai hari ke-',
                                  style: TextStyle(fontSize: 12)),
                              const Spacer(),
                              _CounterRow(
                                value: _lamp2DelayDays,
                                min: 2,
                                max: _durationDays,
                                suffix: '',
                                compact: true,
                                onChanged: (v) =>
                                    setState(() => _lamp2DelayDays = v),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),

                    // ── Mode Penyiraman ────────────────────────────
                    _sheetCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _fieldLabel('Mode Penyiraman', Icons.water_drop_rounded),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: _ModeButton(
                                  label: 'Jadwal Waktu',
                                  icon: Icons.access_time_rounded,
                                  isActive: _wateringMode == WateringMode.time,
                                  onTap: () => setState(
                                      () => _wateringMode = WateringMode.time),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _ModeButton(
                                  label: 'Sensor Tanah',
                                  icon: Icons.grass_rounded,
                                  isActive: _wateringMode == WateringMode.soil,
                                  onTap: () => setState(
                                      () => _wateringMode = WateringMode.soil),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // ── Jika mode soil ─────────────────────
                          if (_wateringMode == WateringMode.soil) ...[
                            _fieldLabel(
                                'Threshold Kelembapan Tanah (%)',
                                Icons.sensors_rounded),
                            const SizedBox(height: 4),
                            const Text(
                              'Siram otomatis jika kelembapan tanah < nilai ini',
                              style: TextStyle(
                                  fontSize: 11, color: AppColors.textSecondary),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: Slider(
                                    value: _soilThreshold.toDouble(),
                                    min: 10,
                                    max: 90,
                                    divisions: 80,
                                    activeColor: AppColors.soil,
                                    onChanged: (v) =>
                                        setState(() => _soilThreshold = v.toInt()),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppColors.soilLight,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    '$_soilThreshold%',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.soil),
                                  ),
                                ),
                              ],
                            ),
                          ],

                          // ── Jika mode time ─────────────────────
                          if (_wateringMode == WateringMode.time) ...[
                            Row(
                              children: [
                                _fieldLabel('Jadwal Siram', Icons.schedule_rounded),
                                const Spacer(),
                                if (_wateringTimes.length < 8)
                                  GestureDetector(
                                    onTap: () => setState(
                                        () => _wateringTimes.add('12:00')),
                                    child: const Icon(Icons.add_circle_outline_rounded,
                                        color: AppColors.primary, size: 20),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            ..._wateringTimes.asMap().entries.map((e) {
                              final i = e.key;
                              final t = e.value;
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 6),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 24, height: 24,
                                      decoration: const BoxDecoration(
                                        color: AppColors.primaryContainer,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Text('${i + 1}',
                                            style: const TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.primary)),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    GestureDetector(
                                      onTap: () async {
                                        final parts = t.split(':');
                                        final picked = await showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay(
                                            hour: int.parse(parts[0]),
                                            minute: int.parse(parts[1]),
                                          ),
                                          builder: (ctx, child) => MediaQuery(
                                            data: MediaQuery.of(ctx)
                                                .copyWith(alwaysUse24HourFormat: true),
                                            child: child!,
                                          ),
                                        );
                                        if (picked != null) {
                                          setState(() {
                                            _wateringTimes[i] =
                                                '${picked.hour.toString().padLeft(2, '0')}:'
                                                '${picked.minute.toString().padLeft(2, '0')}';
                                          });
                                        }
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: AppColors.background,
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(
                                              color: AppColors.divider),
                                        ),
                                        child: Text(t,
                                            style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.textPrimary)),
                                      ),
                                    ),
                                    const Spacer(),
                                    if (_wateringTimes.length > 1)
                                      GestureDetector(
                                        onTap: () => setState(
                                            () => _wateringTimes.removeAt(i)),
                                        child: const Icon(
                                            Icons.delete_outline_rounded,
                                            color: AppColors.error,
                                            size: 18),
                                      ),
                                  ],
                                ),
                              );
                            }),
                          ],

                          // ── Durasi per Siram ────────────────────
                          const SizedBox(height: 10),
                          _fieldLabel('Durasi per Penyiraman', Icons.timer_rounded),
                          const SizedBox(height: 8),
                          _CounterRow(
                            value: _wateringDuration,
                            min: 5,
                            max: 600,
                            step: 5,
                            suffix: 'detik',
                            onChanged: (v) =>
                                setState(() => _wateringDuration = v),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // ── Tombol Simpan ─────────────────────────────
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: _isSaving ? null : _save,
                        icon: _isSaving
                            ? const SizedBox(
                                width: 16, height: 16,
                                child: CircularProgressIndicator(
                                    color: Colors.white, strokeWidth: 2))
                            : const Icon(Icons.save_rounded, size: 18),
                        label: Text(
                            _isSaving
                                ? 'Menyimpan...'
                                : AppStrings.saveSettings,
                            style: const TextStyle(fontSize: 15)),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);

    final config = PlantingConfigModel(
      id: widget.existing?.id ?? '',
      name: _nameCtrl.text.trim(),
      durationDays: _durationDays,
      lamp1DelayDays: _lamp1DelayDays,
      lamp2DelayDays: _lamp2DelayDays,
      wateringMode: _wateringMode,
      soilThreshold: _soilThreshold,
      wateringTimes: _wateringTimes,
      wateringDuration: _wateringDuration,
      wateringPerDay: _wateringTimes.length,
      createdAt: widget.existing?.createdAt ??
          DateTime.now().millisecondsSinceEpoch ~/ 1000,
    );

    final notifier = ref.read(configNotifierProvider.notifier);
    if (widget.existing != null) {
      await notifier.updateConfig(config);
    } else {
      await notifier.addConfig(config);
    }

    setState(() => _isSaving = false);
    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.existing != null
              ? 'Konfigurasi diperbarui!'
              : 'Konfigurasi ditambahkan! 🌱'),
          backgroundColor: AppColors.active,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Widget _sheetCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(color: AppColors.shadow, blurRadius: 6, offset: Offset(0, 2))
        ],
      ),
      child: child,
    );
  }

  Widget _fieldLabel(String text, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColors.primary),
        const SizedBox(width: 6),
        Text(text,
            style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary)),
      ],
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
      filled: true,
      fillColor: AppColors.background,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.divider),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.divider),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
    );
  }
}

// ─── Counter Row ─────────────────────────────────────────────────────────────

class _CounterRow extends StatelessWidget {
  final int value;
  final int min;
  final int max;
  final int step;
  final String suffix;
  final bool compact;
  final ValueChanged<int> onChanged;

  const _CounterRow({
    required this.value,
    required this.min,
    required this.max,
    required this.suffix,
    required this.onChanged,
    this.step = 1,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: compact ? MainAxisSize.min : MainAxisSize.max,
      children: [
        _Btn(
          icon: Icons.remove_rounded,
          enabled: value > min,
          onTap: () => onChanged((value - step).clamp(min, max)),
        ),
        const SizedBox(width: 10),
        Container(
          padding: EdgeInsets.symmetric(
              horizontal: compact ? 10 : 16, vertical: compact ? 6 : 8),
          decoration: BoxDecoration(
            color: AppColors.primaryContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            suffix.isEmpty ? '$value' : '$value $suffix',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ),
        const SizedBox(width: 10),
        _Btn(
          icon: Icons.add_rounded,
          enabled: value < max,
          onTap: () => onChanged((value + step).clamp(min, max)),
        ),
      ],
    );
  }
}

class _Btn extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  const _Btn({required this.icon, required this.enabled, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        width: 32, height: 32,
        decoration: BoxDecoration(
          color: enabled ? AppColors.primaryContainer : AppColors.divider,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 16,
            color: enabled ? AppColors.primary : AppColors.inactive),
      ),
    );
  }
}

// ─── Mode Button ─────────────────────────────────────────────────────────────

class _ModeButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  const _ModeButton({
    required this.label,
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : AppColors.background,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isActive ? AppColors.primary : AppColors.divider,
          ),
        ),
        child: Column(
          children: [
            Icon(icon,
                size: 18,
                color: isActive ? Colors.white : AppColors.primary),
            const SizedBox(height: 4),
            Text(label,
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isActive ? Colors.white : AppColors.primary)),
          ],
        ),
      ),
    );
  }
}
