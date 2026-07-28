import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["consent", "submit"];

  connect() {
    this.toggleSubmit();
  }

  toggleSubmit() {
    if (!this.hasSubmitTarget || !this.hasConsentTarget) return;

    this.submitTarget.disabled = !this.consentTarget.checked;
  }

  /**
   * Persist the record on blur, skipping validations server-side.
   */
  save() {
    const skipValidations = document.createElement("input");

    skipValidations.type = "hidden";
    skipValidations.name = "skip_validations";
    skipValidations.value = "true";

    this.element.appendChild(skipValidations);

    this.element.requestSubmit();

    skipValidations.remove();
  }
}
