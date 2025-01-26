String? validateClientData(String name, String address, String phone) {
  if (name.isEmpty || address.isEmpty || phone.isEmpty) {
    return 'Todos los campos son obligatorios';
  }

  if (name.length < 3 || name.length > 100) {
    return 'El nombre debe tener entre 3 y 100 caracteres';
  }

  if (address.length < 5 || address.length > 200) {
    return 'La dirección debe tener entre 5 y 200 caracteres';
  }

  if (!RegExp(r'^\d{9,11}$').hasMatch(phone)) {
    return 'El teléfono debe tener entre 9 y 11 dígitos';
  }

  return null;
}
