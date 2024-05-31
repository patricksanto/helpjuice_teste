import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input"]

  connect() {
    this.debouncedSearch = this.debounce(this.search.bind(this), 300)
    console.log("Search controller connected")
  }

  search() {
    const query = this.inputTarget.value

    if (event && event.keyCode === 8) {
      this.debouncedSearch()
      return
    }

    if (query.length === 0) {
      this.clearResults()
      return
    }

    if (query.length > 2) {
      this.submitForm(query)
    }
  }

  submitForm(query) {
    const url = new URL(this.inputTarget.form.action)
    url.searchParams.set(this.inputTarget.name, query)

    fetch(url, {
      method: 'GET',
      headers: {
        'Accept': 'text/vnd.turbo-stream.html',
        'Cache-Control': 'no-cache, no-store, must-revalidate'
      }
    })
    .then(response => response.text())
    .then(html => {
      const turboStreamElements = document.createElement('div')
      turboStreamElements.innerHTML = html
      turboStreamElements.querySelectorAll('turbo-stream').forEach(element => {
        const target = document.getElementById(element.getAttribute('target'))
        if (target) {
          target.innerHTML = element.querySelector('template').innerHTML
        }
      })
    })
    .catch(error => console.error(error))
  }

  clearResults() {
    const target = document.getElementById("searched_articles")
    if (target) {
      target.innerHTML = ""
    }
  }

  debounce(func, wait) {
    let timeout
    return function(...args) {
      clearTimeout(timeout)
      timeout = setTimeout(() => func.apply(this, args), wait)
    }
  }
}
