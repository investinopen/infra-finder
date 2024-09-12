import { Controller } from "@hotwired/stimulus";
import trackFilterEvents from "../../assets/javascripts/track-filter-events";

export default class extends Controller {
  static targets = ["sidebar"];

  connect() {
    this.form = this.element.querySelector("form");

    if (this.form) {
      this.form.addEventListener("submit", trackFilterEvents);
    }
  }

  sidebarTargetConnected(element) {
    const observer = new IntersectionObserver(
      ([e]) => {
        e.target.classList.toggle(
          "solution-filters--is-pinned",
          e.intersectionRatio < 1
        );
      },
      { threshold: [1] }
    );

    observer.observe(element);
  }
}
