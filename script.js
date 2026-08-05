import * as tableHelper from "./tableHelper.js";

async function main() {
  fetch("content.json")
    .then(response => response.json())
    .then(content => tableHelper.filterTable(content))

  const progress = JSON.parse(localStorage.getItem("hsr-order-progress"))
  if (!progress) {
    localStorage.setItem("hsr-order-progress", JSON.stringify({}));
  }

  fetch("updated.json")
    .then(response => response.json())
    .then(data => {
      document.querySelector("#last-updated").textContent =
      `Last updated: ${data.lastUpdated}`;
    })
}

main();
