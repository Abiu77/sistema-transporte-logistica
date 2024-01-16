<?php
// Inicia la sesión
session_start();

// Importa la configuración de la base de datos
include './db.php';

// Recibe datos del formulario
$email = $_POST['correo'];
$password = $_POST['contrasenia'];

// Definir el máximo de intentos fallidos permitidos antes de bloquear la cuenta
$maxIntentosFallidos = 5;

// Verifica si existe la variable de sesión para los intentos fallidos
if (!isset($_SESSION['intentosFallidos'])) {
  $_SESSION['intentosFallidos'] = 0;
}

// SQL INJECTION:
// Preparar la consulta con una consulta preparada
$query = "SELECT * FROM erpo_usersistema WHERE correo=?";
$stmt = mysqli_prepare($connect, $query);

// Verificar si la preparación fue exitosa
if ($stmt) {
  // Vincular los parámetros
  mysqli_stmt_bind_param($stmt, "s", $email);

  // Ejecutar la consulta
  mysqli_stmt_execute($stmt);

  // Obtener el resultado
  $result = mysqli_stmt_get_result($stmt);

  // Cerrar la consulta preparada
  mysqli_stmt_close($stmt);

  // Verificar si el usuario existe
  if ($result && $row = mysqli_fetch_assoc($result)) {
    // Verifica la contraseña utilizando password_verify
    if (password_verify($password, $row['contrasenia'])) {
      // Contraseña válida, reinicia el contador de intentos fallidos
      $_SESSION['intentosFallidos'] = 0;

      // Inicia la sesión o realiza otras acciones necesarias
      $_SESSION['usuario_id'] = $row['id_usuario'];
      $_SESSION['usuario_nombre'] = $row['nombre'];

      // Redirige al dashboard u otra página después de iniciar sesión
      header('Location: ../pages/dashboard.php');
      exit;
    } else {
      // XSS:
      // Contraseña no válida, incrementa el contador de intentos fallidos
      $_SESSION['intentosFallidos']++;

      // Verifica si se ha alcanzado el límite de intentos fallidos
      if ($_SESSION['intentosFallidos'] >= $maxIntentosFallidos) {
        // Puedes tomar medidas adicionales aquí, como bloquear la cuenta o registrar la actividad sospechosa
        $message = "Demasiados intentos fallidos. Su cuenta ha sido bloqueada, comuniquese con el asistente de soporte.";
        echo '
          <script>
            alert("' . htmlspecialchars($message, ENT_QUOTES, 'UTF-8') . '");
            window.location = "../index.html";
          </script>
        ';
        // Desactiva el usuario si se alcanza el límite de intentos fallidos
        $Query = "UPDATE erpo_usersistema SET estado='0' AND correo=?";
        $stmt = mysqli_prepare($connect, $Query);
      if ($stmt) {
        mysqli_stmt_bind_param($stmt, "s", $email);
        mysqli_stmt_execute($stmt);
        mysqli_stmt_close($stmt);
      } else {
        die("Error en la preparación de la consulta: " . mysqli_error($connect));
      }
        mysqli_close($connect);
        exit;
      }

      // Contraseña no válida, maneja la situación según tus necesidades
      $message = "Sus datos son incorrectos, por favor verifique los datos introducidos";
      echo '
        <script>
           alert("' . htmlspecialchars($message, ENT_QUOTES, 'UTF-8') . '");
          window.location = "../index.html";
        </script>
      ';
      exit;
    }
  } else {
    // El usuario no existe, maneja la situación según tus necesidades
    $message = "Por favor verifique los datos introducidos";
    echo '
      <script>
        alert("' . htmlspecialchars($message, ENT_QUOTES, 'UTF-8') . '");
        window.location = "../index.html";
      </script>
    ';
    exit;
  }
} else {
  // Manejar el error en la preparación de la consulta
  die("Error en la preparación de la consulta: " . mysqli_error($connect));
}

// Cerrar la conexión
mysqli_close($connect);
?>
