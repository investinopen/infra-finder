import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["counter"];

  connect() {
    this.connectCounter();
    this.connectCondition();
  }

  disconnect() {
    this.field?.removeEventListener("input", this.update);
    this.trigger?.removeEventListener("change", this.updateVisibility);
  }

  connectCounter() {
    this.field = this.element.querySelector("textarea[maxlength], input[maxlength]");
    if (!this.field || !this.hasCounterTarget) return;

    this.update = this.update.bind(this);
    this.field.addEventListener("input", this.update);
    this.counterTarget.hidden = false;
    this.update();
  }

  connectCondition() {
    const { conditionField, conditionValue } = this.element.dataset;
    if (!conditionField) return;

    this.trigger = this.element
      .closest("form")
      ?.querySelector(`[name$="[${conditionField}]"], [name="${conditionField}"]`);
    if (!this.trigger) return;

    this.conditionValues = (conditionValue || "").split(" ");
    this.updateVisibility = this.updateVisibility.bind(this);
    this.trigger.addEventListener("change", this.updateVisibility);
    this.updateVisibility();
  }

  update() {
    this.counterTarget.textContent = `${this.field.value.length}/${this.field.maxLength}`;
  }

  updateVisibility() {
    this.element.hidden = !this.conditionValues.includes(this.trigger.value);
  }
}
