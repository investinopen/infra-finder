import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["toggle", "dialog"];

  connect() {
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
    } else {
      this.dialogTarget.close();
    }
  }
}
