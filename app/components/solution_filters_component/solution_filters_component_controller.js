import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["sidebar"];

  connect() {
    this.form = this.element.querySelector("form");

    if (this.form) {
      this.form.addEventListener("submit", this.handleSubmit);
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

  handleSubmit = (event) => {
    if (!window._paq || !Array.isArray(window._paq)) return;

    // FormData is pretty difficult to parse here, so just look up checked filters
    const checked = [
      ...event.target.querySelectorAll("input[type='checkbox']:checked"),
    ];

    if (!checked.length) return;

    const events = [];

    for (const el of checked) {
      const label = el.dataset.eventLabel;

      events.push(["trackEvent", "Filter Applied", label || el.name]);
    }

    window._paq.push(events);
  };
}
