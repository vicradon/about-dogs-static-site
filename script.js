document.addEventListener("DOMContentLoaded", function () {
  const table = document.getElementById("userTable");
  const rows = table.getElementsByTagName("tr");

  for (let i = 1; i < rows.length; i++) {
    rows[i].addEventListener("click", function () {
      clearSelected();
      this.classList.add("selected");
      const cells = this.getElementsByTagName("td");
      const name = cells[0].textContent;
      const username = cells[1].textContent;
      const email = cells[2].textContent;
      alert(`Name: ${name}\nUsername: ${username}\nEmail: ${email}`);
    });
  }

  function clearSelected() {
    for (let i = 1; i < rows.length; i++) {
      rows[i].classList.remove("selected");
    }
  }
});
