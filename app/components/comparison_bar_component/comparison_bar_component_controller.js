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

  solutions() {
    const solutions = document.getElementById("solutions-grid");

    console.log("solutions", solutions);

    if (!solutions) return;

    const focusable = solutions.querySelectorAll(
      'button, [href], input, select, textarea, [tabindex]:not([tabindex="-1"])'
    );

    if (focusable[0]) {
      focusable[0].focus();
    }
  }
}
