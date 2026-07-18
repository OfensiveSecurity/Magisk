// Nexus-Bypass: Selectores Actualizados (23/03/26)
const BBVA_SELECTORS = {
    user: '#t-login-user',
    pass: '#t-login-pass',
    confirm: 'button[data-id="submit-login"]' // Selector actualizado hoy
};

async function injectAndSkip(page) {
    console.log("[🧠] NEXUS: Aplicando mimetismo en BBVA...");
    await page.waitForSelector(BBVA_SELECTORS.user);
    // Inyección de datos desde mfterm/Binance
    await page.type(BBVA_SELECTORS.user, process.env.BBVA_USER);
    await page.click(BBVA_SELECTORS.confirm);
}
