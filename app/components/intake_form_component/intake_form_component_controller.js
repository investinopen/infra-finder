import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
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
