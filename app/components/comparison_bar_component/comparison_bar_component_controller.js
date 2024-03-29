import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["wrapper"];

  setHeight(height) {
    document.body.style.setProperty("--comparison-bar-height", `${height}px`);
  }

  initialize() {
    const el = this.wrapperTarget;

    if (!el) return;

    this.setHeight(Math.ceil(el.getBoundingClientRect().height));
  }

  disconnect() {
    this.setHeight(0);
  }
}
