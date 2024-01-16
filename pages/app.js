document.addEventListener('DOMContentLoaded', () => {
  // Lógica para obtener y mostrar las solicitudes
  fetch('http://localhost:3000/solicitudes')
    .then(response => response.json())
    .then(solicitudes => {
      const solicitudesContainer = document.getElementById('solicitudes');
      solicitudesContainer.innerHTML = `<h2>Solicitudes</h2><pre>${JSON.stringify(solicitudes, null, 2)}</pre>`;
    });

  // Lógica para obtener y mostrar los carros de transporte libres
  fetch('http://localhost:3000/carros-libres')
    .then(response => response.json())
    .then(carrosLibres => {
      const carrosLibresContainer = document.getElementById('carros-libres');
      carrosLibresContainer.innerHTML = `<h2>Carros de Transporte Libres</h2><pre>${JSON.stringify(carrosLibres, null, 2)}</pre>`;
    });
});
