import "@hotwired/turbo-rails";

import "./controllers";
import "../components";

Turbo.StreamActions.redirect = function () {
  Turbo.visit(this.target);
};
