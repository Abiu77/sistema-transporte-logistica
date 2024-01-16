<?php
// Configuración de la base de datos
$host = "localhost";
$username = "root";
$password = "";
$database = "transporte";

// Intenta establecer una conexión a la base de datos
$connect = new mysqli($host, $username, $password, $database);

// Verifica la conexión
if ($connect->connect_error) {
  die("Error de conexión a la base de datos: " . $connect->connect_error);
}
?>

