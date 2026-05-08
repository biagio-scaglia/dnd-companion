import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import 'notes_controller.dart';

class SessionEditView extends StatefulWidget {
  const SessionEditView({super.key});

  @override
  State<SessionEditView> createState() => _SessionEditViewState();
}

class _SessionEditViewState extends State<SessionEditView> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _summaryController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  @override
  void dispose() {
    _titleController.dispose();
    _summaryController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.magicAccent,
              onPrimary: Colors.white,
              surface: AppColors.surface,
              onSurface: AppColors.textPrimary,
            ),
            dialogBackgroundColor: AppColors.surface,
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final notesController = Provider.of<NotesController>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nuova Sessione'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.check_rounded, color: AppColors.magicAccent),
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                await notesController.createSession(
                  _titleController.text,
                  _summaryController.text,
                  _selectedDate,
                );
                if (mounted) Navigator.pop(context);
              }
            },
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Titolo Sessione',
                labelStyle: TextStyle(color: AppColors.textSecondary),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.surfaceSecondary)),
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.magicAccent)),
              ),
              style: const TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold),
              validator: (value) => value == null || value.isEmpty ? 'Inserisci un titolo' : null,
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _summaryController,
              decoration: const InputDecoration(
                labelText: 'Riassunto',
                labelStyle: TextStyle(color: AppColors.textSecondary),
                alignLabelWithHint: true,
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColors.surfaceSecondary)),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColors.magicAccent)),
              ),
              style: const TextStyle(color: AppColors.textPrimary),
              maxLines: 5,
              minLines: 3,
              validator: (value) => value == null || value.isEmpty ? 'Inserisci un riassunto' : null,
            ),
            const SizedBox(height: 24),
            ListTile(
              title: const Text('Data della Sessione', style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
              subtitle: Text(
                '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                style: const TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.bold),
              ),
              trailing: const Icon(Icons.calendar_today_rounded, color: AppColors.magicAccent),
              onTap: () => _selectDate(context),
              contentPadding: EdgeInsets.zero,
            ),
          ],
        ),
      ),
    );
  }
}
