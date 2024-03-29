import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["wrapper"];

  initialize() {
    const el = this.wrapperTarget;

    if (!el) return;

    const observer = new IntersectionObserver(
      ([e]) => {
        const top = el.getBoundingClientRect().top;
        e.target.classList.toggle(
          "comparison-sticky-header--is-pinned",
          e.intersectionRatio < 1 && top < 1
        );
      },
      { threshold: [1] }
    );

    observer.observe(el);
  }
}
