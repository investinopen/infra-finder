import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["article"];

  get navEl() {
    return document.getElementById("solution-nav");
  }

  get navAnchors() {
    return [...this.navEl.querySelectorAll("[href]")];
  }

  get prefersReducedMotion() {
    const mq = window.matchMedia("(prefers-reduced-motion: reduce)");
    return mq.matches;
  }

  connect() {
    this.observer;

    const self = this;
    this.state = new Proxy(
      {
        direction: "up",
        prevYPosition: 0,
        activeId: null,
      },
      {
        set(state, key, value) {
          const oldValue = state[key];

          state[key] = value;
          if (oldValue !== value) {
            switch (key) {
              case "activeId":
                self.processActiveChange();
                break;
            }
          }
          return state;
        },
      }
    );

    this.bindHashChange();
  }

  articleTargetConnected(element) {
    if (!this.navEl) return;

    this.observer = new IntersectionObserver(this.intersect, {
      rootMargin: `${this.navEl.offsetHeight * -1}px`,
      threshold: 0,
    });

    this.observer.observe(element);
  }

  intersect = ([e]) => {
    this.state.direction =
      window.scrollY > this.state.prevYPosition ? "down" : "up";

    this.state.prevYPosition = window.scrollY;

    // get next article when scrolling down, or current when scrolling up
    const entryTarget =
      this.state.direction === "down" ? this.getTargetArticle(e) : e.target;

    if (this.shouldUpdate(e)) this.state.activeId = entryTarget.id;
  };

  bindHashChange() {
    window.addEventListener("hashchange", this.handleHashChange);
  }

  handleHashChange = (event) => {
    if (!this.prefersReducedMotion) return;

    const newUrl = new URL(event.newURL);
    const targetId = newUrl.hash.replace("#", "");

    const articleIsActive = this.articleTargets.some(
      (article) => article.id === targetId
    );

    if (articleIsActive)
      setTimeout(() => {
        this.state.activeId = targetId;
      }, 200);
  };

  processActiveChange() {
    for (const anchor of this.navAnchors) {
      const targetId = anchor.getAttribute("href")?.replace("#", "");
      anchor.setAttribute("data-active", targetId === this.state.activeId);
    }
  }

  shouldUpdate(entry) {
    if (this.state.direction === "down" && !entry.isIntersecting) {
      return true;
    }

    if (this.state.direction === "up" && entry.isIntersecting) {
      return true;
    }

    return false;
  }

  getTargetArticle(entry) {
    const index = this.articleTargets.findIndex(
      (article) => article === entry.target
    );

    if (index >= this.articleTargets.length - 1) {
      return entry.target;
    } else {
      return this.articleTargets[index + 1];
    }
  }
}
