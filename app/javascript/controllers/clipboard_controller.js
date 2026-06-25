import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["source", "status"]

  async copy() {
    const value = this.sourceTarget.value

    try {
      await navigator.clipboard.writeText(value)
      this.showStatus("Copiado")
    } catch (_error) {
      this.sourceTarget.select()
      document.execCommand("copy")
      this.showStatus("Copiado")
    }
  }

  showStatus(message) {
    if (!this.hasStatusTarget) return

    this.statusTarget.textContent = message
    clearTimeout(this.timeout)
    this.timeout = setTimeout(() => {
      this.statusTarget.textContent = ""
    }, 1800)
  }
}
