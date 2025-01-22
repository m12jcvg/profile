const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
  content: [
    './public/*.html',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/views/**/*.{erb,haml,html,slim}'
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ['Inter var', ...defaultTheme.fontFamily.sans],
      },
      colors: {
        primary: {
          DEFAULT: '#1D4ED8', // Replace with chosen primary color
          light: '#3B82F6',
          dark: '#1E40AF',
        },
        secondary: {
          DEFAULT: '#3B82F6', // Replace with chosen secondary color
        },
        accent: {
          DEFAULT: '#F59E0B', // Replace with chosen accent color
        },
        neutral: {
          dark: '#111827',
          medium: '#6B7280',
          light: '#F3F4F6',
        },
        background: '#FFFFFF',
      },
    },
  },
  plugins: [
    // require('@tailwindcss/forms'),
    // require('@tailwindcss/typography'),
    // require('@tailwindcss/container-queries'),
  ]
}
