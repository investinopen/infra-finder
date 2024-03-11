import { Application } from "@hotwired/stimulus";

const app = Application.start();

window.Stimulus = app;

export const application = app;

export default app;
