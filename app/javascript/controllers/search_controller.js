import { Controller } from "@hotwired/stimulus"
import consumer from "../channels/consumer"

export default class extends Controller {
  static targets = ["input"]

  connect() {
    this.channel = consumer.subscriptions.create("SearchChannel", {
      received: data => {
        this.updateResults(data.results)
      }
    })
    this.debouncedSearch = this.debounce(this.search.bind(this), 300)
  }

  search() {
    const query = this.inputTarget.value

    if (event && event.keyCode === 8) {
      this.debouncedSearch()
      return
    }

    if (query.length > 2) {
      this.channel.perform("receive", { query: query})
    }
  }

  debounce(func, wait) {
    let timeout
    return function(...args) {
      clearTimeout(timeout)
      timeout = setTimeout(() => func.apply(this, args), wait)
    }
  }

  updateResults(results) {
    const resultsContainer = document.getElementById("search-results")
    const articlesCount = document.getElementById("articles-count")

    resultsContainer.innerHTML = `
      <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
        ${results.map(result => `
          <div class="border rounded-xl shadow p-4 hover:shadow-lg hover:scale-[102%] transition duration-500">
            <h2 class="font-bold text-slate-700 text-lg mb-4">${result.title}</h2>
            <p class="text.md line-clamp-3">${result.content}</p>
          </div>
        `).join('')}
      </div>
    `

    articlesCount.textContent = `${results.length} ${results.length === 1 ? "Article" : "Articles"}`
  }
}