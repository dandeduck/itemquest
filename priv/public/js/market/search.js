import utils from "@itemquest/utils";

document.addEventListener("turbo:visit", () => {
    console.log('hello');
    let prevSearch = "";

    document
        .getElementById("search_input")
        .addEventListener("keyup", (event) => {
            const value = event.target.value;

            if (prevSearch === value) {
                return;
            }

            prevSearch = value;
            const searchUrl = new URL(window.location.href);

            searchUrl.pathname += "/items/search";
            searchUrl.search = "";
            searchUrl.searchParams.append("search", value);

            utils.fetchStream(searchUrl.toString());
        });
});
