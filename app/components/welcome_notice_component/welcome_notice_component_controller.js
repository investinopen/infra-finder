import { Controller } from "@hotwired/stimulus";

const STORAGE_KEY = "dismissed_welcome_notice";

export default class extends Controller {
  connect() {
    const hasDismissed = sessionStorage.getItem(STORAGE_KEY);

    if (hasDismissed === "true") this.element.remove();
  }
  dismiss() {
    sessionStorage.setItem(STORAGE_KEY, "true");
    this.element.remove();
  }
}
