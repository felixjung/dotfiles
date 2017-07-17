module.exports = {
  config: {
    // Hyper configuration
    fontSize: 14,
    fontFamily: 'Hack, "DejaVu Sans Mono", Menlo, monospace',
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
    }
  },

  plugins: [
    'hyperterm-one-dark',
    'hyperlayout',
    'hypercwd',
    'hyperlinks',
    'hyper-tab-icons'
  ],
};
