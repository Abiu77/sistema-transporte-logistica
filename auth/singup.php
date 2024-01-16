<?php
// Importa la configuración de la base de datos
include './db.php';

$name = $_POST['nombre'];
$lastname = $_POST['apellido'];
$username = $_POST['username'];
$email = $_POST['correo'];
$password = $_POST['contrasenia'];

// Genera un hash seguro de la contraseña
$hashedPassword = password_hash($password, PASSWORD_DEFAULT); 

// SQL INJECTION:
// Preparar la consulta con una consulta preparada
$query = "INSERT INTO erpo_usersistema (nombre, apellido, username, correo, contrasenia, fingerprint) VALUES (?, ?, ?, ?, ?, '')";
$stmt = mysqli_prepare($connect, $query);

// Verificar si la preparación fue exitosa
if ($stmt) {
  // Vincular los parámetros
  mysqli_stmt_bind_param($stmt, "sssss", $name, $lastname, $username, $email, $hashedPassword);

  // Ejecutar la consulta
  $execute = mysqli_stmt_execute($stmt);

  // Cerrar la consulta preparada
  mysqli_stmt_close($stmt);
} else {
  // Manejar el error en la preparación de la consulta
  die("Error en la preparación de la consulta: " . mysqli_error($connect));
}
 
if ($execute) {
  // XSS:
  // Utilizar htmlspecialchars para evitar ataques XSS
  $message = htmlspecialchars("Se ha registrado correctamente");
  echo '
    <script>
      alert("' . htmlspecialchars($message, ENT_QUOTES, 'UTF-8') . '");
      window.location = "../index.html";
    </script>
  ';
  exit;
} else {
  $message = htmlspecialchars("Usuario no almacenado, por favor verifique los datos introducidos");
  echo '
    <script>
      alert("' . htmlspecialchars($message, ENT_QUOTES, 'UTF-8') . '");
      window.location = "../index.html";
    </script>
  ';
  exit;
}

mysqli_close($connect);
?>
