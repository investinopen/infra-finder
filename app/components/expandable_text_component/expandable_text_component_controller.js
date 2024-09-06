import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["text", "toggle"];

  get moreText() {
    return this.toggleTarget?.querySelector("[data-more-text]");
  }

  get lessText() {
    return this.toggleTarget?.querySelector("[data-less-text]");
  }

  connect() {
    const self = this;
    this.state = new Proxy(
      { expanded: false },
      {
        set(state, key, value) {
          const oldValue = state[key];

          state[key] = value;
          if (oldValue !== value) {
            switch (key) {
              case "expanded":
                self.processExpandedChange();
                break;
            }
          }
          return state;
        },
      }
    );
  }

  textTargetConnected(element) {
    if (!this.hasToggleTarget) return;

    const isClamped = element.scrollHeight > element.clientHeight;

    if (!isClamped) return;

    this.toggleTarget.classList.remove("hidden");
  }

  toggleExpand() {
    const prevExpanded = this.state.expanded;
    this.state.expanded = !prevExpanded;
  }

  processExpandedChange() {
    if (!this.textTarget || !this.toggleTarget) return;

    this.toggleTarget.setAttribute("aria-pressed", this.state.expanded);
    this.textTarget.classList.toggle("line-clamp-6", !this.state.expanded);
    this.moreText?.classList.toggle("a-hidden", this.state.expanded);
    this.lessText?.classList.toggle("a-hidden", !this.state.expanded);

    // Scroll to the top of the cell on close
    if (!this.state.expanded) {
      const top = this.textTarget.offsetTop - document.body.scrollTop;

      window.scrollTo({
        top,
      });
    }
  }
}
