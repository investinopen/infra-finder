import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["rows", "template", "row"];
  static values = { index: Number };

  add() {
    const html = this.templateTarget.innerHTML.replaceAll("__INDEX__", this.indexValue);
    this.indexValue++;
    this.rowsTarget.insertAdjacentHTML("beforeend", html);
    this.rowTargets.at(-1)?.querySelector("input")?.focus();
  }

  remove(event) {
    event.currentTarget.closest(".intake-structured-list__row")?.remove();
  }
}
