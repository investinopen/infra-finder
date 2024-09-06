import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["toggle", "dialog"];

  dialogTargetConnected(target) {
    target.setAttribute("inert", "");
  }

  connect() {
    this.form = this.element.querySelector("form");

    if (this.form) {
      this.form.addEventListener("submit", this.handleSubmit);
    }

    if (!this.toggleTarget || !this.dialogTarget) return;

    const self = this;
    this.state = new Proxy(
      { open: false },
      {
        set(state, key, value) {
          const oldValue = state[key];

          state[key] = value;
          if (oldValue !== value) {
            switch (key) {
              case "open":
                self.processOpenChange();
                break;
            }
          }
          return state;
        },
      }
    );
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

  toggleDialog(event) {
    const prevOpen = this.state.open;
    this.state.open = !prevOpen;
  }

  closeDialog(event) {
    this.state.open = false;
  }

  processOpenChange() {
    if (this.state.open) {
      this.dialogTarget.showModal();
      this.dialogTarget.removeAttribute("inert");
    } else {
      this.dialogTarget.close();
      this.dialogTarget.setAttribute("inert", "");
    }
  }
}
