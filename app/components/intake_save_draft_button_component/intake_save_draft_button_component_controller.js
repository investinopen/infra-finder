import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static values = {
    labels: Object,
    minSavingDuration: { type: Number, default: 600 },
    savedDuration: { type: Number, default: 2000 },
  };

  disconnect() {
    clearTimeout(this.timer);
  }

  /**
   * Ask the intake form to save a draft.
   */
  save() {
    this.dispatch("save", { prefix: "intake", target: window });
  }

  saving({ detail: { auto } }) {
    this.savingSince = performance.now();

    this.setLabel(auto ? this.labelsValue.autosaving : this.labelsValue.saving);
  }

  saved() {
    this.afterSaving(() => {
      this.setLabel(this.labelsValue.saved);

      this.timer = setTimeout(() => this.reset(), this.savedDurationValue);
    });
  }

  /**
   * A failed save shows a flash message, so the label resets.
   */
  fail() {
    this.afterSaving(() => this.reset());
  }

  reset() {
    this.setLabel(this.labelsValue.idle);
  }

  setLabel(label) {
    clearTimeout(this.timer);

    this.element.textContent = label;
  }

  /**
   * Run `change` once the in-progress label has had its minimum time on
   * screen to ensure the "saving..." message is legible.
   */
  afterSaving(change) {
    const remaining =
      this.minSavingDurationValue - (performance.now() - (this.savingSince ?? 0));

    clearTimeout(this.timer);

    if (remaining <= 0) return change();

    this.timer = setTimeout(change, remaining);
  }
}
