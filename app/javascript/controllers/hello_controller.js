// hello_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["name", "output"]

    greet() {
        console.log("hello")
        this.outputTarget.textContent =
            `Hello, ${this.nameTarget.value}!`
    }
}
