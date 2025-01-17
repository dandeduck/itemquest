const turboVisitAttribute = "data-turbo-visit";

document.addEventListener("turbo:load", addTurboVisits);
document.addEventListener("turbo:frame-load", addTurboVisits);
document.addEventListener("turbo:before-stream-render", async (event) => {
    await event.detail.newStream.renderPromise;

    window.requestAnimationFrame(addTurboVisits, 0);
});

function addTurboVisits() {
    document
        .querySelectorAll(`[${turboVisitAttribute}]`)
        .forEach(addTurboVisit);
}

/**
 * @param {HTMLElement} element
 */
function addTurboVisit(element) {
    const path = element.getAttribute(turboVisitAttribute);

    if (!path) {
        return;
    }

    element.setAttribute(turboVisitAttribute, "");
    element.addEventListener("click", () => Turbo.visit(path));
}
