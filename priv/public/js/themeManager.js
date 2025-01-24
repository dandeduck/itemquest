function enableTheming() {
    if (
        localStorage.currentTheme === "dark" ||
        (!localStorage.currentTheme &&
            window.matchMedia("(prefers-color-scheme: dark)").matches)
    ) {
        setDarkTheme();
    }

    document
        .getElementById("light-theme")
        .addEventListener("click", setLightTheme);
    document
        .getElementById("dark-theme")
        .addEventListener("click", setDarkTheme);
}

function setLightTheme() {
    localStorage.currentTheme = "light";
    document.documentElement.classList.remove("dark");
    document.getElementById("light-theme").style.opacity = "0.6";
    document.getElementById("dark-theme").style.opacity = "1";
    document.getElementById("light-theme").style.filter = "";
    document.getElementById("dark-theme").style.filter = "";
}

function setDarkTheme() {
    localStorage.currentTheme = "dark";
    document.documentElement.classList.add("dark");
    document.getElementById("light-theme").style.opacity = "1";
    document.getElementById("dark-theme").style.opacity = "0.6";
    document.getElementById("light-theme").style.filter = "invert(1)";
    document.getElementById("dark-theme").style.filter = "invert(1)";
}

export default { enableTheming };
