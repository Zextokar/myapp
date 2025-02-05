import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class AddClientView extends StatefulWidget {
  const AddClientView({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AddClientViewState createState() => _AddClientViewState();
}

class _AddClientViewState extends State<AddClientView> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _addClient() async {
    String name = _nameController.text.trim();
    String address = _addressController.text.trim();
    String phone = _phoneController.text.trim();

    if (name.isEmpty || address.isEmpty || phone.isEmpty) {
      _showDialog('Error', 'Todos los campos son obligatorios');
      return;
    }

    if (name.length < 3 || name.length > 100) {
      _showDialog('Error', 'El nombre debe tener entre 3 y 100 caracteres');
      return;
    }

    if (address.length < 5 || address.length > 200) {
      _showDialog('Error', 'La dirección debe tener entre 5 y 200 caracteres');
      return;
    }

    if (!RegExp(r'^\d{9,11}$').hasMatch(phone)) {
      _showDialog('Error', 'El teléfono debe tener entre 9 y 11 dígitos');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await FirebaseFirestore.instance.collection('clients').add({
        'name': name,
        'address': address,
        'phone': phone,
        'createdAt': FieldValue.serverTimestamp(),
      });

      _showDialog('Éxito', 'Cliente agregado correctamente', isSuccess: true);
    } catch (error) {
      _showDialog(
          'Error', 'No se pudo agregar el cliente. Intenta nuevamente.');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showDialog(String title, String message, {bool isSuccess = false}) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          CupertinoDialogAction(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
              if (isSuccess) {
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String placeholder,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return CupertinoTextField(
      controller: controller,
      placeholder: placeholder,
      keyboardType: keyboardType,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
      style: const TextStyle(fontSize: 16),
      decoration: BoxDecoration(
        color: CupertinoColors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: CupertinoColors.systemGrey.withOpacity(0.2),
            blurRadius: 5,
            spreadRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: CupertinoColors.systemGroupedBackground,
        middle: const Text(
          'Nuevo Cliente',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Icon(
            CupertinoIcons.xmark_circle_fill,
            color: CupertinoColors.systemRed,
          ),
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Datos del Cliente',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                _buildTextField(
                    controller: _nameController,
                    placeholder: 'Nombre Completo'),
                const SizedBox(height: 16),
                _buildTextField(
                    controller: _addressController, placeholder: 'Dirección'),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _phoneController,
                  placeholder: 'Teléfono',
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 30),
                Center(
                  child: _isLoading
                      ? const CupertinoActivityIndicator()
                      : CupertinoButton(
                          onPressed: _addClient,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 15),
                          color: CupertinoColors.activeBlue,
                          borderRadius: BorderRadius.circular(25),
                          child: const Text(
                            'Crear Cliente',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
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
}
