import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/user_model.dart';

/// Диалог ввода имени пользователя
class LoginDialog extends StatefulWidget {
  final Function(UserModel) onUserCreated;

  const LoginDialog({
    Key? key,
    required this.onUserCreated,
  }) : super(key: key);

  @override
  State<LoginDialog> createState() => _LoginDialogState();
}

class _LoginDialogState extends State<LoginDialog> {
  final TextEditingController _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _saveUser() {
    if (_formKey.currentState!.validate()) {
      final user = UserModel(
        name: _nameController.text.trim(),
        id: const Uuid().v4(),
      );
      widget.onUserCreated(user);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Заголовок
              const Text(
                'Добро пожаловать',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFBA68C8),
                ),
              ),
              const SizedBox(height: 16),

              // Текст
              const Text(
                'Пожалуйста, введите ваше имя:',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // Поле ввода
              TextFormField(
                controller: _nameController,
                maxLength: 15,
                decoration: InputDecoration(
                  hintText: 'Введите ваше имя...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFBA68C8)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFBA68C8)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFBA68C8), width: 2),
                  ),
                  filled: true,
                  fillColor: const Color(0xFFF5F5F5),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Имя не может быть пустым';
                  }
                  return null;
                },
                onFieldSubmitted: (_) => _saveUser(),
              ),
              const SizedBox(height: 24),

              // Кнопка
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveUser,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFBA68C8),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: const Text(
                    'Войти',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
