document.addEventListener('DOMContentLoaded', function () {
  const buttons = document.querySelectorAll('.toggle-button')
  const contents = document.querySelectorAll('.toggle-content')

  buttons.forEach((button) => {
    button.addEventListener('click', () => {
      const selectedId = button.dataset.id

      // Убираем активный стиль у всех кнопок
      buttons.forEach((btn) => btn.classList.remove('active'))
      button.classList.add('active')

      // Показываем нужный контент и скрываем остальной
      contents.forEach((content) => {
        if (content.dataset.id === selectedId) {
          content.classList.remove('hidden')
        } else {
          content.classList.add('hidden')
        }
      })
    })
  })
})
