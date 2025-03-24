fetch(`/playlists/${playlistId}/add_issue/${issueId}`, {
  method: 'POST', // Используем POST
  headers: {
    'X-CSRF-Token': document.querySelector("meta[name='csrf-token']").content
  }
})
  .then((response) => response.json())
  .then((data) => alert(data.message || 'Добавлено в плейлист!'))
  .catch((error) => console.error('Ошибка:', error))
