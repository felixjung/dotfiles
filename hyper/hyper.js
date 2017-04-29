module.exports = {
  config: {
    fontSize: 14,
    fontFamily: 'Hack, "DejaVu Sans Mono", Menlo, monospace',
    cursorColor: 'rgba(248,28,229,0.75)',
    cursorShape: 'BLOCK',
    borderColor: '#333',
    css: '',
    termCSS: '',
    padding: '12px 14px',
  },

  plugins: [
    'hyperterm-one-dark',
    'hyperlayout',
    'hyper-pane',
    'hyperlinks',
    'hyper-statusline'
  ],

  hyperStatusLine: {
    dirtyColor: 'salmon',
  }
};
