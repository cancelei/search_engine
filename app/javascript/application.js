// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails";
import Rails from "@rails/ujs";
import "controllers";

Rails.start();

document.addEventListener("DOMContentLoaded", () => {
  const searchForm = document.querySelector("form");
  if (searchForm) {
    searchForm.addEventListener("submit", (event) => {
      event.preventDefault();
      const formData = new FormData(searchForm);
      const queryParams = new URLSearchParams(formData);

      fetch(searchForm.action + "?" + queryParams.toString(), {
        method: "GET",
        headers: {
          Accept: "application/json",
        },
      })
        .then((response) => response.json())
        .then((data) => {
          if (data.job_id) {
            pollForResults(data.job_id);
          } else {
            alert(data.error);
          }
        });
    });
  }
});

function pollForResults(jobId) {
  const refreshIntervalId = setInterval(() => {
    fetch(`/search/results?job_id=${jobId}`, { method: "GET" })
      .then((response) => response.json())
      .then((data) => {
        if (data.results) {
          displayResults(data.results);
          clearInterval(refreshIntervalId); // Stop polling once results are received
        }
      });
  }, 5000); // Poll every 5 seconds
}

function displayResults(results) {
  const resultsContainer = document.querySelector("#results-container");
  if (resultsContainer) {
    resultsContainer.innerHTML = results
      .map(
        (result) => `
      <div class="p-4 border border-gray-300 rounded-md shadow-sm">
        <h3 class="text-xl font-semibold">
          <a href="${
            result.link || result.url
          }" class="text-indigo-600 hover:underline">${
          result.title || result.name
        }</a>
        </h3>
        <p class="text-gray-700">${result.snippet}</p>
      </div>
    `
      )
      .join("");
  }
}
