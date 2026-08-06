import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    this.dispatch("field-errors", { prefix: "intake", target: window });
  }
}
