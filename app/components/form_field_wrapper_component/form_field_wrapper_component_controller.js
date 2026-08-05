import { Controller } from "@hotwired/stimulus";

let descriptionSequence = 0;
let errorSequence = 0;

export default class extends Controller {
  static targets = ["counter", "error"];

  connect() {
    this.connectCounter();
    this.connectCondition();
    this.connectDescription();
    this.connectValidation();
  }

  get fieldContent() {
    return this.element.querySelector(":scope > .field-content");
  }

  disconnect() {
    this.field?.removeEventListener("input", this.update);
    this.triggers?.forEach((t) => t.removeEventListener("change", this.updateVisibility));
    this.element.removeEventListener("invalid", this.onInvalid, true);
    this.element.removeEventListener("input", this.onEdit);
    this.element.removeEventListener("change", this.onEdit);
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

    this.conditionValues = (conditionValue || "").split(" ").filter(Boolean);

    if (!this.conditionValues.length) {
      this.element.hidden = true;
      return;
    }

    const selector = `[name$="[${conditionField}]"], [name="${conditionField}"], [name$="[${conditionField}][]"]`;
    const matches = this.element.closest("form")?.querySelectorAll(selector) ?? [];

    this.triggers = [...matches].filter((el) => el.type !== "hidden");
    if (!this.triggers.length) return;

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

  connectValidation() {
    if (!this.hasErrorTarget) return;

    this.element.addEventListener("invalid", this.onInvalid, true);
    this.element.addEventListener("input", this.onEdit);
    this.element.addEventListener("change", this.onEdit);

    this.showServerErrors();
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
    // `value` on a `select multiple` reports only the first selected option, so the
    // whole selection has to be read off `selectedOptions`.
    const selected = this.triggers
      .filter((t) => t.type !== "checkbox" || t.checked)
      .flatMap((t) =>
        t.multiple && t.selectedOptions ? [...t.selectedOptions].map((o) => o.value) : [t.value]
      );

    this.element.hidden = !selected.some((value) => this.conditionValues.includes(value));

    if (this.element.hidden) this.clearError();
  }

  owns(el) {
    return el.closest(".form-field-wrapper, .conditional-field-wrapper") === this.element;
  }

  onInvalid = (event) => {
    if (!this.owns(event.target) || !event.target.validationMessage) return;

    event.preventDefault();

    this.pending ??= [];
    this.pending.push(event.target);

    if (this.flushing) return;

    this.flushing = true;

    setTimeout(() => {
      this.flushing = false;

      const controls = this.pending;
      this.pending = null;

      this.showErrors(controls.map((control) => this.constraintItem(control)), "constraint");
    });
  };

  onEdit = (event) => {
    if (!this.hasErrorTarget || this.errorTarget.hidden || !this.owns(event.target)) return;

    // Components owning several inputs recompute their own validity on this same event,
    // and the checkbox group listens at form level, which runs after this.
    const edited = event.target;

    setTimeout(() => this.refreshErrors(edited));
  };

  refreshErrors(edited) {
    if (!this.hasErrorTarget || this.errorTarget.hidden) return;

    if (this.errorSource === "server") {
      const remaining = this.items.filter(({ control }) => control.name !== edited.name);

      if (remaining.length === this.items.length) return;

      if (remaining.length) this.showErrors(remaining, "server");
      else this.clearError();

      return;
    }

    // `validity` is read rather than `checkValidity()`, which would re-fire `invalid`.
    const invalid = this.validatableControls().filter((el) => !el.validity.valid);

    if (invalid.length) this.showErrors(invalid.map((el) => this.constraintItem(el)), "constraint");
    else this.clearError();
  }

  showServerErrors() {
    const payload = this.element.closest("form")?.dataset?.fieldErrors;
    if (!payload) return;

    let errors;

    try {
      errors = JSON.parse(payload);
    } catch {
      return;
    }

    if (!errors.length) return;

    const controls = this.ownControls();

    const items = errors
      .map(({ name, message }) => {
        // Fields bound to a collection post as `name[]`, which the error attribute omits.
        const control = controls.find((el) => el.name === name || el.name === `${name}[]`);

        return control ? { control, message } : null;
      })
      .filter(Boolean);

    if (items.length) this.showErrors(items, "server");
  }

  constraintItem(control) {
    return { control, message: control.validationMessage };
  }

  ownControls() {
    const content = this.fieldContent;
    if (!content) return [];

    return [...content.querySelectorAll("input[name], select[name], textarea[name]")].filter(
      (el) => el.type !== "hidden" && el.closest(".field-content") === content
    );
  }

  validatableControls() {
    const content = this.fieldContent;
    if (!content) return [];

    return [...content.querySelectorAll("input, select, textarea")].filter(
      (el) => el.willValidate && el.closest(".field-content") === content
    );
  }

  invalidTargets(field) {
    const content = this.fieldContent;
    const candidates = content ? this.describableElements(content) : [];
    const enclosing = candidates.filter((el) => el === field || el.contains(field));

    return enclosing.length ? enclosing : [field];
  }

  showErrors(items, source) {
    this.clearError();

    if (!items.length) return;

    this.items = items;
    this.errorSource = source;
    this.marked = [];

    items.forEach(({ control, message }) => {
      const line = document.createElement("span");

      line.className = "field-error__item";
      line.id = `field-error-${++errorSequence}`;
      line.textContent = message;

      this.errorTarget.appendChild(line);

      this.invalidTargets(control).forEach((el) => {
        el.setAttribute("aria-invalid", "true");

        const ids = (el.getAttribute("aria-describedby") || "").split(" ").filter(Boolean);

        if (!ids.includes(line.id)) {
          el.setAttribute("aria-describedby", [...ids, line.id].join(" "));
        }

        this.marked.push({ el, id: line.id });
      });
    });

    this.errorTarget.hidden = false;
  }

  clearError() {
    if (!this.hasErrorTarget || this.errorTarget.hidden) return;

    this.marked?.forEach(({ el, id }) => {
      el.removeAttribute("aria-invalid");

      const ids = (el.getAttribute("aria-describedby") || "")
        .split(" ")
        .filter((value) => value && value !== id);

      if (ids.length) el.setAttribute("aria-describedby", ids.join(" "));
      else el.removeAttribute("aria-describedby");
    });

    this.errorTarget.replaceChildren();
    this.errorTarget.hidden = true;
    this.items = null;
    this.marked = null;
    this.errorSource = null;
  }
}
