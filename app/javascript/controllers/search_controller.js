import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "results"]

  connect() {
    this.channel = consumer.subscriptions.create("SearchChannel", {
      received: data => {
        this.resultsTarget.innerHTML = ""
        data.results.forEach(result => {
          const item = document.createElement("div")
          item.textContent = result
          this.resultsTarget.appendChild(item)
        })
      }
    })
  }

  search() {
    const query = this.inputTarget.value
    const userIp = this.getUserIp()

    if (query.length > 2) {
      this.channel.perform("receive", { query: query, user_ip: userIp })
    }
  }

  getUserIp() {
    // chnage this method in the future
    return "127.0.0.1"
  }
}
