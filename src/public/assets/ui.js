import { Application, Controller } from 'https://unpkg.com/@hotwired/stimulus/dist/stimulus.js'
window.Stimulus = Application.start()

Stimulus.register('gallery', class extends Controller {

  static targets = [
    'itemContainer',
    'itemCaption',
  ]

  _items = null
  _current_index = -1

  open (event) {
    document.querySelector('.gallery-container').classList.remove('d-none')
    document.body.style.overflow = 'hidden'
    this._initialize(event.target.parentNode)
    this._presentItem()
  }

  next () {
    const index = this._current_index + 1
    if (index >= this._items.length) return
    this._current_index = index
    this._presentItem()
  }

  previous () {
    const index = this._current_index - 1
    if (index <= 0) return
    this._current_index = index
    this._presentItem()
  }

  close () {
    document.querySelector('.gallery-container').classList.add('d-none')
    document.body.style.overflow = ''
    this._reset()
  }

  _initialize (current_item_node) {
    const items = Array.from(document.querySelectorAll('[data-gallery-item]'))
    this._items = items.map(node => new GalleryItem(node))
    this._current_index = items.indexOf(current_item_node)
  }

  _presentItem () {
    this._cleanItem()
    this._items[this._current_index]?.show(this)
  }

  _cleanItem () {
    this.itemContainerTarget.innerHTML = ''
    this.itemCaptionTarget.innerHTML = ''
  }

  _reset () {
    this._cleanItem()
    this._items = []
    this._current_index = -1
  }

})

class GalleryItem {

  constructor (node) {
    this.url = node.dataset.url
    this.type = node.dataset.type
    this.caption = node.querySelector('[data-gallery-item--caption]')?.textContent
  }

  show (gallery) {
    switch (this.type) {
      case 'image':
        const img = document.createElement('img')
        img.src = this.url
        gallery.itemContainerTarget.appendChild(img)
        break
      case 'video':
        const video = document.createElement('video')
        video.setAttribute('controls', '')
        const source = document.createElement('source')
        source.setAttribute('src', this.url)
        source.setAttribute('type', 'video/mp4')
        video.textContent = 'Your browser does not support the video tag.'
        video.appendChild(source)
        gallery.itemContainerTarget.appendChild(video)
        break
    }

    gallery.itemCaptionTarget.textContent = this.caption
  }
}
