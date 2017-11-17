module.exports = {
  config: {
    // Hyper configuration
    fontSize: 14,
    fontFamily: '"FuraCode Nerd Font", "DejaVu Sans Mono", Menlo, monospace',
    cursorColor: 'rgba(248,28,229,0.75)',
    cursorShape: 'BLOCK',
    borderColor: '#333',
    css: '',
    termCSS: '',
    padding: '12px 14px',
    // Plugin configurations
    hyperStatusLine: {
      dirtyColor: 'salmon',
    },
    tabIcons: {
      mapIcons: {
        nodejs: ['node'],
        vim: ['nvim', 'vim']
      },
      mapColors: { },
      processNameRegex: /: (.*?)$/
    },
    paneNavigation: {
      hotkeys: {
        navigation: {
          up: 'ctrl+alt+k',
          down: 'ctrl+alt+j',
          left: 'ctrl+alt+h',
          right: 'ctrl+alt+l'
        }
      },
      showIndicators: false
    },
    bell: false
  },
  plugins: [
    'hypercwd',
    'hyperlinks',
    'hyper-tab-icons',
    'hyperterm-atom-dark'
  ]
};
