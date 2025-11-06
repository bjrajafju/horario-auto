document.addEventListener("DOMContentLoaded", function () {
    // Remove scrollbars completamente
    document.documentElement.style.overflow = "hidden";
    document.body.style.overflow = "hidden";

    // Se o conteúdo estiver a causar overflow por dimensões fixas, força o ajuste
    document.body.style.width = "100vw";
    document.body.style.height = "100vh";

    // Corrige também se existir algum iframe ou elemento gigante
    document.querySelectorAll("*").forEach((el) => {
        el.style.maxWidth = "100vw";
        el.style.maxHeight = "100vh";
        el.style.overflow = "hidden";
    });
});
