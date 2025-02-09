document.addEventListener('DOMContentLoaded', function () {
  // Small card slider
  var slider = document.querySelector('.C_PodcastCards')

  if (slider) {
    var slickSmall = new Slick(slider, {
      arrows: false,
      dots: false,
      infinite: true,
      initialSlide: 0,
      slidesToScroll: 1,
      slidesToShow: 3
    })
  }

  var scrollCount = null
  var scroll = null

  if (slider) {
    slider.addEventListener('wheel', function (e) {
      e.preventDefault()

      clearTimeout(scroll)
      scroll = setTimeout(function () {
        scrollCount = 0
      }, 200)

      if (scrollCount) return
      scrollCount = 1

      if (e.deltaY < 0) {
        slickSmall.slickNext()
      } else {
        slickSmall.slickPrev()
      }
    })
  }

  // Big cards slider
  var bigSlider = document.querySelector('.slider-big-cards')

  if (bigSlider) {
    var slickBig = new Slick(bigSlider, {
      arrows: false,
      dots: false,
      infinite: true,
      initialSlide: 0.5,
      slidesToScroll: 1,
      slidesToShow: 3.5
    })
  }
})
