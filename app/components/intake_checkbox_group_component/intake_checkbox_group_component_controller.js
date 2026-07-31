import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    this.form = this.element.closest("form");
    this.form?.addEventListener("change", this.refresh);
    this.refresh();
  }

  disconnect() {
    this.form?.removeEventListener("change", this.refresh);
    this.boxes.forEach((box) => {
      box.required = false;
    });
  }

  get boxes() {
    return [...this.element.querySelectorAll("input[type='checkbox']")];
  }

  refresh = () => {
    const satisfied = this.element.closest("[hidden]") !== null || this.boxes.some((box) => box.checked);

    this.boxes.forEach((box) => {
      box.required = !satisfied;
    });
  };
}
