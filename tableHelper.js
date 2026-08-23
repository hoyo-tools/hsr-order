let currentVersion = localStorage.getItem("hsr-order-version-filter") ?? "all";

let isCollapsed = false;

const base_url = "https://honkai-star-rail.fandom.com";

export function getLink(title) {
  return `https://honkai-star-rail.fandom.com/wiki/${title
    .replace(/ /g, "_")
    .replace(/:/g, "%3A")}`;
}

export function filterTable(content) {
  // Restore saved checkbox filters
  const savedTypes = JSON.parse(
    localStorage.getItem("hsr-order-type-filters") ?? "[]",
  );

  document.querySelectorAll(".checkbox").forEach((checkbox) => {
    checkbox.checked = savedTypes.includes(checkbox.name);

    checkbox.addEventListener("change", () => {
      saveTypeFilters();
      applyFilters(content);
    });
  });

  // Collapse button
  const collapseButton = document.querySelector(".collapse-button");

  collapseButton.addEventListener("click", (event) => {
    event.preventDefault();

    isCollapsed = !isCollapsed;

    const table = document.querySelector("#missions-table");

    table.classList.toggle("collapsed", isCollapsed);

    collapseButton.textContent = isCollapsed ? "›‹" : "‹›";

    collapseButton.setAttribute(
      "aria-label",
      isCollapsed ? "Expand table" : "Collapse table",
    );

    collapseButton.setAttribute(
      "title",
      isCollapsed ? "Expand table" : "Collapse table",
    );

    applyFilters(content);
  });

  // Version links
  document.querySelectorAll(".version-links a").forEach((link) => {
    link.addEventListener("click", (event) => {
      event.preventDefault();

      currentVersion = event.currentTarget.dataset.version;

      saveVersionFilter();
      applyFilters(content);
    });
  });

  // Version dropdown
  const versionSelect = document.querySelector(".version-select");

  if (versionSelect) {
    versionSelect.value = currentVersion;

    versionSelect.addEventListener("change", (event) => {
      currentVersion = event.target.value;

      saveVersionFilter();
      applyFilters(content);
    });
  }

  applyFilters(content);
}

function saveVersionFilter() {
  localStorage.setItem("hsr-order-version-filter", currentVersion);
}

function saveTypeFilters() {
  const filterValues = [...document.querySelectorAll(".checkbox:checked")].map(
    (checkbox) => checkbox.name,
  );

  localStorage.setItem("hsr-order-type-filters", JSON.stringify(filterValues));
}

function applyFilters(content) {
  const filterValues = [...document.querySelectorAll(".checkbox:checked")].map(
    (checkbox) => checkbox.name,
  );

  let filtered;

  // Version filter
  if (currentVersion === "all") {
    filtered = content;
  } else if (currentVersion === "Pre") {
    filtered = content.filter(
      (item) =>
        item.version?.startsWith("0") || item.version?.startsWith("Pre"),
    );
  } else {
    filtered = content.filter((item) =>
      item.version?.startsWith(currentVersion),
    );
  }

  // Type filters
  if (filterValues.length > 0) {
    filtered = filtered.filter((item) => filterValues.includes(item.type));
  }

  populateTable(filtered);
}

export function populateTable(content) {
  const table = document.querySelector("#missions-table");
  const thead = table.querySelector("thead");
  const tbody = table.querySelector("tbody");

  tbody.innerHTML = "";
  thead.innerHTML = "";

  const progress = JSON.parse(
    localStorage.getItem("hsr-order-progress") ?? "{}",
  );

  content.sort((a, b) => a.date.localeCompare(b.date));

  /*
    Normal:
    Title | Release Date | Series | Type | Version | Progress

    Collapsed:
    Title | Version | Progress
  */
  const headers = isCollapsed
    ? ["Title", "Version", "Progress"]
    : ["Title", "Release Date", "Series", "Type", "Version", "Progress"];

  const headerRow = thead.insertRow();

  headers.forEach((header) => {
    const th = document.createElement("th");
    th.textContent = header;
    headerRow.appendChild(th);
  });

  content.forEach((item) => {
    const row = tbody.insertRow();

    // Title
    const linkCell = row.insertCell();

    const a = document.createElement("a");

    a.href = getLink(item.wiki_title ?? item.title);
    a.textContent = item.title;
    a.target = "_blank";

    linkCell.appendChild(a);

    // Only present when table is expanded
    if (!isCollapsed) {
      row.insertCell().textContent = item.date;
      row.insertCell().textContent = item.series ?? "";
      row.insertCell().textContent = item.type;
    }

    // Version
    row.insertCell().textContent = item.version ?? "";

    // Progress
    const progressCell = row.insertCell();

    progressCell.classList.add("progress-cell", "clickable");

    const title = row.cells[0].textContent.trim();

    row.cells[0].classList.add("title-column");

    if (progress[title]) {
      progressCell.classList.add("completed");
    }
  });

  addProgress();
}

function addProgress() {
  const progress = JSON.parse(
    localStorage.getItem("hsr-order-progress") ?? "{}",
  );

  document.querySelectorAll(".progress-cell").forEach((cell) => {
    cell.addEventListener("click", () => {
      cell.classList.toggle("completed");

      const title = cell.parentElement.cells[0].textContent.trim();

      progress[title] = cell.classList.contains("completed");

      localStorage.setItem("hsr-order-progress", JSON.stringify(progress));
    });
  });
}
