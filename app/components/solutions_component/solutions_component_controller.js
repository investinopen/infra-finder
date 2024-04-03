import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  focus(event) {
    event.preventDefault();

    const compareBar = document.getElementById("compare-bar");

    if (!compareBar) return;

    const focusable = compareBar.querySelectorAll(
      'button, [href], input, select, textarea, [tabindex]:not([tabindex="-1"])'
    );

    if (focusable[0]) {
      focusable[0].focus();
    } else {
      compareBar.focus();
    }
  }
}
