// ignore_for_file: file_names, unnecessary_null_comparison
String? validateEmail(String value) {
  if (value == null || value.isEmpty) {
    return 'Por favor ingresa tu correo electrónico';
  }
  if (!RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)) {
    return 'Por favor ingresa un correo electrónico válido';
  }
  return null;
}

String? validatePassword(String value) {
  if (value == null || value.isEmpty) {
    return 'Por favor, ingresa una contraseña';
  } else if (value.length < 6) {
    return 'La contraseña debe tener al menos 6 caracteres';
  }
  return null;
}

String? validateConfirmPassword(String value, String password) {
  if (value == null || value.isEmpty) {
    return 'Por favor, ingresa una contraseña';
  } else if (value != password) {
    return 'La contraseña no coinciden';
  } else if (value.length < 6) {
    return 'La contraseña debe tener al menos 6 caracteres';
  }
  return null;
}

String? validateRole(String? value) {
  if (value == null || value.isEmpty) {
    return 'Por favor selecciona un rol';
  }
  return null;
}
