import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["counter"];

  connect() {
    this.field = this.element.querySelector("textarea[maxlength], input[maxlength]");
    if (!this.field || !this.hasCounterTarget) return;

    this.update = this.update.bind(this);
    this.field.addEventListener("input", this.update);
    this.counterTarget.hidden = false;
    this.update();
  }

  disconnect() {
    this.field?.removeEventListener("input", this.update);
  }

  update() {
    this.counterTarget.textContent = `${this.field.value.length}/${this.field.maxLength}`;
  }
}
