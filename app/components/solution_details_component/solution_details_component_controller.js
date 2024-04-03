import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["article"];

  articleTargetConnected(element) {
    const observer = new IntersectionObserver(this.intersect, {
      threshold: [0.5],
    });

    observer.observe(element);
  }

  intersect([e]) {
    const nav = document.getElementById("solution-nav");

    if (!nav) return;

    const target = nav.querySelectorAll(`a[href='#${e.target.id}']`);

    if (!target[0]) return;

    target[0].setAttribute("data-active", e.isIntersecting);
  }
}
