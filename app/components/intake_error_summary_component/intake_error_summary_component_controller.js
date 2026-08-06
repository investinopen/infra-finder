import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    const summary = this.element.querySelector(".intake-error-summary");
    if (!summary) return;

    summary.focus();

    summary.querySelectorAll("li[data-field-name]").forEach((item) => this.linkToField(item));
  }

  linkToField(item) {
    const field = this.findField(item.dataset.fieldName);
    if (!field) return;

    const link = document.createElement("button");

    link.type = "button";
    link.className = "intake-error-summary__link";
    link.textContent = item.textContent.trim();
    link.addEventListener("click", () => this.reveal(field));

    item.replaceChildren(link);
  }

  findField(name) {
    const form = this.element.closest("form");
    if (!form) return null;

    // Fields bound to a collection post as `name[]`, which the error attribute omits.
    return form.querySelector(`[name="${name}"]`) ?? form.querySelector(`[name="${name}[]"]`);
  }

  reveal(field) {
    field.scrollIntoView({ block: "center", behavior: "smooth" });
    field.focus({ preventScroll: true });
  }
}
