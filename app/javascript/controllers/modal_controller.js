import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ['wrapper', 'container', 'content', 'background', 'url']

    view(e) {
        this.url = e.params.url
        this.open = true
        if (e.target !== this.wrapperTarget &&
            !this.wrapperTarget.contains(e.target)) return

        if (this.open) {
            this.getContent(this.url)
            this.wrapperTarget.insertAdjacentHTML('afterbegin', this.template())
        }
    }
    close(e) {
        e.preventDefault()

        if (this.open) {
            if (this.hasContainerTarget) { this.containerTarget.remove() }
        }
    }

    closeBackground(e) {
        if (e.target === this.backgroundTarget) { this.close(e) }
    }

    closeWithKeyboard(e) {
        if (e.keyCode === 27) {
            this.close(e)
        }
    }

    getContent(url) {
        fetch(url).
            then(response => {
                if (response.ok) {
                    return response.text()
                }
            })
            .then(html => {
                this.contentTarget.innerHTML = html
            })
    }

    template() {
        return `
      <div data-modal-target='container'>
        <div class='modal-wrapper z-20' data-modal-target='background' data-action='click->modal#closeBackground'>
          <div class='fixed bg-white rounded z-30 overflow-auto shadow-xl' data-modal-target='content'>
        </div>
      </div>
    `
    }
}
