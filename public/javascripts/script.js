let BOOKING = {}

let BOOKING_ID = {}
// Get the modal
var modal = document.getElementById("myModal");

// Get the button that opens the modal
var btn = document.getElementById("myBtn");

// Get the <span> element that closes the modal
var span = document.getElementsByClassName("close")[0];


// When the user clicks on the button, open the modal
function openModal() {
  modal.style.display = "block";
}

// When the user clicks on <span> (x), close the modal
function closeModal() {
  modal.style.display = "none";
}

window.onload = function () {
  var xhttp = new XMLHttpRequest();
  xhttp.onreadystatechange = function () {
    if (this.readyState == 4 && this.status == 200) {
      vueinst.movies.splice(0);
      vueinst.all_movies.splice(0);
      var movieList = JSON.parse(this.responseText);
      for (let movie of movieList) {
        vueinst.movies.push(movie);
        vueinst.all_movies.push(movie);
      }
    }
  };

  xhttp.open("POST", "/getMovieList", true);
  xhttp.send();
};

function updateTicketList() {
  var xhttp = new XMLHttpRequest();
  xhttp.onreadystatechange = function () {
    if (this.readyState == 4 && this.status == 200) {
      vueinst.tickets.splice(0);
      var ticketList = JSON.parse(this.responseText)[0];
      for (let ticket of ticketList) {
        ticket.date = ticket.date.substring(0, 10);
        vueinst.tickets.push(ticket);
      }
    }
  };

  xhttp.open("POST", "/users/getTicketList", true);
  xhttp.send();
}

var vueinst = new Vue({
  el: "#app",
  data: {
    movies: [],
    all_movies: [],
    show_history: false,
    tickets: [],
  },
  methods: {
    modalOpenHandler: function (movie) {
      var xhttp = new XMLHttpRequest();

      xhttp.onreadystatechange = function () {
        if (this.readyState == 4 && this.status == 200) {
          var bookingList = JSON.parse(this.responseText)[0];
          BOOKING = {}
          BOOKING_ID = {}
          for (let booking of bookingList) {
            var date = booking.date.substring(0, 10);
            if (!(date in BOOKING)) {
              BOOKING[date] = {};
              BOOKING_ID[date] = {};
            }
            BOOKING[date][booking.startTime] = [];
            BOOKING_ID[date][booking.startTime] = booking.booking_id;
            getAvailSeat(booking.booking_id, date, booking.startTime);
          }
        }
      };

      xhttp.open("POST", "/getBookingList", true);
      xhttp.setRequestHeader("Content-type", "application/json");
      xhttp.send(JSON.stringify({ movie_id: movie.movie_id }));
      setTimeout(function () {
        updateDate();
        updateTime();
        updateSeat();
        var modal = document.getElementById("myModal");
        modal.style.display = "block";
        var name = document.getElementById("movie-info-name");
        name.innerText = movie.movie_name;
        var img = document.getElementById("movie-img-modal");
        img.src = movie.imgUrl;
        var duration = document.getElementById("movie-info-duration");
        duration.innerText = movie.duration + " minutes";
        var about = document.getElementById("movie-info-about");
        about.innerText = movie.about;
        var close = document.getElementById("close-btn");
        close.onclick = function () {
          modal.style.display = "none";
        }
        window.onclick = function (event) {
          if (event.target == modal) {
            modal.style.display = "none";
          }
        }
      }, 2000)
    },
    filterHandler: function () {

    }
  }
});

function getAvailSeat(booking_id, date, time) {
  var xhttp = new XMLHttpRequest();

  xhttp.onreadystatechange = function () {
    if (this.readyState == 4 && this.status == 200) {
      var seatList = JSON.parse(this.responseText)[0];
      for (let seat of seatList) {
        BOOKING[date][time].push([seat.seat_id, seat.seat_number]);
      }
    }
  };

  xhttp.open("POST", "/getAvailSeat", true);
  xhttp.setRequestHeader("Content-type", "application/json");
  xhttp.send(JSON.stringify({ booking_id: booking_id }));
}

function updateDate() {
  var date_sel = document.getElementById("date-opt");
  date_sel.innerHTML = ""
  for (let date in BOOKING) {
    let date_opt = document.createElement('option');
    date_opt.value = date;
    date_opt.innerText = date;
    date_sel.appendChild(date_opt)
  }
}

function updateTime() {
  var time_sel = document.getElementById("time-opt");
  var date_sel_val = document.getElementById("date-opt").value;
  time_sel.innerHTML = ""
  for (let time in BOOKING[date_sel_val]) {
    let time_opt = document.createElement('option');
    time_opt.value = time;
    time_opt.innerText = time;
    time_sel.appendChild(time_opt)
  }
}

function updateSeat() {
  var seat_sel = document.getElementById("seat-opt");
  var date_sel_val = document.getElementById("date-opt").value;
  var time_sel_val = document.getElementById("time-opt").value;
  seat_sel.innerHTML = ""
  for (let seat of BOOKING[date_sel_val][time_sel_val]) {
    let seat_opt = document.createElement('option');
    seat_opt.value = seat[0];
    seat_opt.innerText = seat[1];
    seat_sel.appendChild(seat_opt)
  }
}

function loginPage() {
  location.href = "./login.html";
}

function logout() {
  var xhttp = new XMLHttpRequest();
  xhttp.onreadystatechange = function () {
    if (this.readyState == 4 && this.status == 200) {
    }
  };

  xhttp.open("GET", "/logout", true);
  xhttp.send();
}

function userLogout() {
  var xhttp = new XMLHttpRequest();
  xhttp.onreadystatechange = function () {
    if (this.readyState == 4 && this.status == 200) {
      logout();
      location.href = '/login.html';
    }
  };

  xhttp.open("GET", "/users/logout", true);
  xhttp.send();
}

function searchMovie() {
  var id = document.getElementById("movie-search-id").value;
  var date = document.getElementById("movie-search-date").value;
  var time = document.getElementById("movie-search-time").value;

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

  xhttp.open("POST", "/filterMovie", true);
  xhttp.setRequestHeader("Content-type", "application/json");
  xhttp.send(JSON.stringify({ id: id, date: date, time: time }));
}

function buyTicket() {
  var seat_id = document.getElementById("seat-opt").value;
  var date = document.getElementById("date-opt").value;
  var time = document.getElementById("time-opt").value;
  var booking_id = BOOKING_ID[date][time];
  var xhttp = new XMLHttpRequest();

  xhttp.onreadystatechange = function () {
    if (this.readyState == 4 && this.status == 200) {
    }
  };

  xhttp.open("POST", "/users/buyTicket", true);
  xhttp.setRequestHeader("Content-type", "application/json");
  xhttp.send(JSON.stringify({ booking_id: booking_id, seat_id: seat_id }));
}