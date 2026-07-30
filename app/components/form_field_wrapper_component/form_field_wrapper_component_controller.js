import { Controller } from "@hotwired/stimulus";

let descriptionSequence = 0;

export default class extends Controller {
  static targets = ["counter"];

  connect() {
    this.connectCounter();
    this.connectCondition();
    this.connectDescription();
  }

  get fieldContent() {
    return this.element.querySelector(":scope > .field-content");
  }

  disconnect() {
    this.field?.removeEventListener("input", this.update);
    this.triggers?.forEach((t) => t.removeEventListener("change", this.updateVisibility));
  }

  connectCounter() {
    const content = this.fieldContent;
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

  connectDescription() {
    const content = this.fieldContent;
    const description = content?.querySelector(":scope > .field-meta > .field-description");
    if (!description) return;

    const targets = this.describableElements(content);
    if (!targets.length) return;

    description.id ||= `${targets[0].id || `field-${++descriptionSequence}`}-description`;

    targets.forEach((el) => {
      const ids = (el.getAttribute("aria-describedby") || "").split(" ").filter(Boolean);
      if (ids.includes(description.id)) return;
      el.setAttribute("aria-describedby", [...ids, description.id].join(" "));
    });
  }

  describableElements(content) {
    const group = content.querySelector(
      ":scope > .intake-checkbox-group, :scope > .intake-radio-group"
    );
    if (group) return [group];

    return [...content.querySelectorAll("input, select, textarea")].filter(
      (el) =>
        el.type !== "hidden" &&
        el.closest(".field-content") === content &&
        // Skips groups a component owns internally, e.g. the logo field's file/link
        // toggle, whose options aren't what the description describes.
        !el.closest("[role='group'], [role='radiogroup']")
    );
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
