let currentVersion = "all";

const base_url = "https://honkai-star-rail.fandom.com";

export function getLink(title) {
  return `https://honkai-star-rail.fandom.com/wiki/${title
    .replace(/ /g, "_")
    .replace(/:/g, "%3A")}`;
}

export function filterTable(content) {
  document.querySelectorAll(".version-filter").forEach(link => {
    link.addEventListener("click", event => {
      event.preventDefault();

      currentVersion = event.currentTarget.dataset.version;
      applyFilters(content);
    });
  });

  document.querySelector(".update-button").addEventListener("click", event => {
    event.preventDefault();

    applyFilters(content);
  });

  applyFilters(content);
}

function applyFilters(content) {
  const filterValues = [...document.querySelectorAll(".checkbox:checked")]
    .map(checkbox => checkbox.name);

  let filtered = null
  if (currentVersion === "all") {
    filtered = content
  }
  else if (currentVersion === "Pre") {
    filtered = content.filter(item => item.version?.startsWith(0))
  }
  else {
    filtered = content.filter(item => item.version?.startsWith(currentVersion))
  }


  if (filterValues.length > 0) {
    filtered = filtered.filter(item =>
      filterValues.includes(item.type)
    );
  }

  populateTable(filtered);
}

export function populateTable(content) {
  const tbody = document.querySelector("#missions-table tbody");
  tbody.innerHTML = "";
  const progress = JSON.parse(localStorage.getItem("hsr-order-progress"));

  content.sort((a, b) => a.date.localeCompare(b.date));

  content.forEach(item => {
    const row = tbody.insertRow();

    const linkCell = row.insertCell();
    const a = document.createElement("a");

    a.href = getLink(item.wiki_title ?? item.title);
    a.textContent = item.title;
    a.target = "_blank";

    linkCell.appendChild(a);

    row.insertCell().textContent = item.date;
    row.insertCell().textContent = item.series ?? "";
    row.insertCell().textContent = item.type;
    row.insertCell().textContent = item.version ?? "";

    const progress_cell = row.insertCell()
    progress_cell.classList.add("progress-cell", "clickable")

    const title = row.cells[0].textContent.trim();

    if (progress[title]) {
      progress_cell.classList.add("completed")
    }

  });

  addProgress();
}

function addProgress() {
  document.querySelectorAll(".progress-cell").forEach(cell => {
    cell.addEventListener("click", (event) => {

      cell.classList.toggle("completed")
      const progress = JSON.parse(localStorage.getItem("hsr-order-progress"))
      const title = cell.parentElement.cells[0].textContent
      progress[title] = true
      localStorage.setItem("hsr-order-progress", JSON.stringify(progress))
    });
  })
}