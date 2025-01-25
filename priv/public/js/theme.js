if (
    localStorage.currentTheme === "dark" ||
    (!localStorage.currentTheme &&
        window.matchMedia("(prefers-color-scheme: dark)").matches)
) {
    setDarkTheme();
}

function setLightTheme() {
    localStorage.currentTheme = "light";
    document.documentElement.classList.remove("dark");
}

function setDarkTheme() {
    localStorage.currentTheme = "dark";
    document.documentElement.classList.add("dark");
}
