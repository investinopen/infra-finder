import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["sidebar"];

  initialize() {
    const el = this.sidebarTarget;

    if (!el) return;

    const observer = new IntersectionObserver(
      ([e]) => {
        e.target.classList.toggle(
          "solution-filters--is-pinned",
          e.intersectionRatio < 1
        );
      },
      { threshold: [1] }
    );

    observer.observe(el);
  }
}
