/**
 * Collect search & filters applied to the solutions list
 * and push to Matomo as `trackEvent`s.
 *
 * This function can be used as a submit callback on the search/filter form.
 * It's abstracted here because desktop and mobile filters are in separate <form>'s.
 *
 * @param {SubmitEvent} event
 */
export default function trackFilterEvents(event) {
  if (!(event?.target instanceof HTMLFormElement) || !window._paq || !Array.isArray(window._paq)) return;

  const events = [];

  // FormData is pretty difficult to parse here, so just look up checked filters
  const checked = [
    ...event.target.querySelectorAll("input[type='checkbox']:checked"),
  ];

  if (checked.length > 0) {
    for (const el of checked) {
      const eventName = el.dataset.eventName;
      const eventValue = el.dataset.eventValue;

      events.push([
        "trackEvent",
        "Search/Filter Applied",
        eventName,
        eventValue,
      ]);
    }
  }

  if (events.length > 0) {
    window._paq.push(events);
  }
}
