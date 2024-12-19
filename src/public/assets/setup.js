function getMatchMedia () {
  return window.matchMedia('(prefers-color-scheme: dark)')
}

function updateBsTheme () {
  const theme = getMatchMedia().matches ? 'dark' : 'light'
  document.documentElement.setAttribute('data-bs-theme', theme)
}

getMatchMedia().addEventListener('change', updateBsTheme)
updateBsTheme()
