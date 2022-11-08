const status = [
  {ping: 0, color: "#388e3c", connection_status: "Great"},
  {ping: 60, color: "#689f38", connection_status: "Good"},
  {ping: 100, color: "#fbc02d", connection_status: "Decent"},
  {ping: 200, color: "#e64a19", connection_status: "Not Good"},
  {ping: 300, color: "#d32f2f", connection_status: "Bad"},
  {ping: 400, color: "#d32f2f", connection_status: "Awful"},
];

export function display_ping(ping) {
  let color = status[0].color;
  let connection_status = status[0].connection_status;
  for (const c of status) {
    if (ping <= c.ping) {
      break;
    }
    color = c.color;
    connection_status = c.connection_status;
  }

  document.getElementById("ping-display")
    .innerText =
`
Ping: ${ping}
Connection: ${connection_status}
`;
  document.getElementById("ping-display")
    .style.color = color;
}
