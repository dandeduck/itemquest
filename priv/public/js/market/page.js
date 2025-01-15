import utils from "@itemquest/utils";

const limit = 25;
let offset = 0;
let fetching = false;

window.addEventListener("scroll", () => {
    const itemsUrl = new URL(window.location.href);
    itemsUrl.pathname += "/items";

    window.requestAnimationFrame(async () => {
        if (
            !fetching &&
            window.scrollY + window.innerHeight >=
                document.body.offsetHeight - 500
        ) {
            fetching = true;
            offset += limit;
            itemsUrl.searchParams.set("offset", offset);

            const success = await utils.fetchStream(itemsUrl.toString());
            if (success) {
                fetching = false;
            }
        }
    }, 0);
});

window.addEventListener("turbo:visit", () => {
    offset = 0;
    fetching = false;
});
