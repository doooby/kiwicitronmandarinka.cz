window.__application = {
  getTheme () {
    return window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light'
  },
  setTheme(theme) {
    console.log("setting ", theme)
    document.documentElement.setAttribute('data-bs-theme', theme)
  }
}

const app = window.__application

app.setTheme(app.getTheme())

window.matchMedia('(prefers-color-scheme: dark)').addEventListener('change', (event) => {
  app.setTheme(app.getTheme())
})
