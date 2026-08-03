import * as tableHelper from "./tableHelper.js";

async function main() {
  fetch("content.json")
    .then(response => response.json())
    .then(content => tableHelper.filterTable(content))
}

main();
