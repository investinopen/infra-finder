import { Controller } from "@hotwired/stimulus";

/**
 * Tracks which section target is currently under a sticky in-page nav and
 * marks the matching nav link with `data-active`.
 *
 * Attach to the element wrapping the sections, point `navValue` at the id of
 * the nav, and give each section a `section` target. Section ids must match
 * the hrefs of the nav's anchors.
 */
export default class extends Controller {
  static targets = ["section"];

  static values = { nav: String };

  get navEl() {
    return document.getElementById(this.navValue);
  }

  get navAnchors() {
    return [...this.navEl.querySelectorAll("[href]")];
  }

  get prefersReducedMotion() {
    const mq = window.matchMedia("(prefers-reduced-motion: reduce)");
    return mq.matches;
  }

  initialize() {
    this.observers = new Map();
  }

  connect() {
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

  disconnect() {
    for (const observer of this.observers.values()) observer.disconnect();
    this.observers.clear();

    window.removeEventListener("hashchange", this.handleHashChange);
  }

  sectionTargetConnected(element) {
    if (!this.navEl) return;

    const observer = new IntersectionObserver(this.intersect, {
      rootMargin: `${this.navEl.offsetHeight * -1}px`,
      threshold: 0,
    });

    observer.observe(element);
    this.observers.set(element, observer);
  }

  sectionTargetDisconnected(element) {
    this.observers.get(element)?.disconnect();
    this.observers.delete(element);
  }

  intersect = ([e]) => {
    this.state.direction =
      window.scrollY > this.state.prevYPosition ? "down" : "up";

    this.state.prevYPosition = window.scrollY;

    // get next section when scrolling down, or current when scrolling up
    const entryTarget =
      this.state.direction === "down" ? this.getTargetSection(e) : e.target;

    if (this.shouldUpdate(e)) this.state.activeId = entryTarget.id;
  };

  bindHashChange() {
    window.addEventListener("hashchange", this.handleHashChange);
  }

  handleHashChange = (event) => {
    if (!this.prefersReducedMotion) return;

    const newUrl = new URL(event.newURL);
    const targetId = newUrl.hash.replace("#", "");

    const sectionIsActive = this.sectionTargets.some(
      (section) => section.id === targetId
    );

    if (sectionIsActive)
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

  getTargetSection(entry) {
    const index = this.sectionTargets.findIndex(
      (section) => section === entry.target
    );

    if (index >= this.sectionTargets.length - 1) {
      return entry.target;
    } else {
      return this.sectionTargets[index + 1];
    }
  }
}
