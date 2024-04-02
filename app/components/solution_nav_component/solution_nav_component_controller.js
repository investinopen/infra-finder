import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["nav"];

  initialize() {
    const el = this.navTarget;

    if (!el) return;

    const observer = new IntersectionObserver(
      ([e]) => {
        const top = el.getBoundingClientRect().top;
        e.target.classList.toggle(
          "bg-brand-mint",
          e.intersectionRatio < 1 && top < 1
        );
      },
      { threshold: [1] }
    );

    observer.observe(el);
  }
}
