import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["counter"];

  connect() {
    this.connectCounter();
    this.connectCondition();
  }

  disconnect() {
    this.field?.removeEventListener("input", this.update);
    this.triggers?.forEach((t) => t.removeEventListener("change", this.updateVisibility));
  }

  connectCounter() {
    const content = this.element.querySelector(":scope > .field-content");
    this.field = content
      ? [...content.querySelectorAll("textarea[maxlength], input[maxlength]")].find(
          (el) => el.closest(".field-content") === content
        )
      : null;
    if (!this.field || !this.hasCounterTarget) return;

    this.update = this.update.bind(this);
    this.field.addEventListener("input", this.update);
    this.counterTarget.hidden = false;
    this.update();
  }

  connectCondition() {
    const { conditionField, conditionValue } = this.element.dataset;
    if (!conditionField) return;

    const selector = `[name$="[${conditionField}]"], [name="${conditionField}"], [name$="[${conditionField}][]"]`;
    const matches = this.element.closest("form")?.querySelectorAll(selector) ?? [];

    this.triggers = [...matches].filter((el) => el.type !== "hidden");
    if (!this.triggers.length) return;

    this.conditionValues = (conditionValue || "").split(" ");
    this.updateVisibility = this.updateVisibility.bind(this);
    this.triggers.forEach((t) => t.addEventListener("change", this.updateVisibility));
    this.updateVisibility();
  }

  update() {
    this.counterTarget.textContent = `${this.field.value.length}/${this.field.maxLength}`;
  }

  updateVisibility() {
    const selected = this.triggers
      .filter((t) => t.type !== "checkbox" || t.checked)
      .map((t) => t.value);

    this.element.hidden = !selected.some((value) => this.conditionValues.includes(value));
  }
}
