
$(document).ready(function () {
  var xhttp = new XMLHttpRequest();

  xhttp.onreadystatechange = function () {
    if (this.readyState == 4 && this.status == 200) {
      vueinst.movies.splice(0);
      var movieList = JSON.parse(this.responseText);
      for (let movie of movieList) {
        vueinst.movies.push(movie);
      }
    }
  };

  xhttp.open("POST", "/getMovieList", true);
  xhttp.send();
});

var vueinst = new Vue({
  el: "#app",
  data: {
    movies: [],
  },
});