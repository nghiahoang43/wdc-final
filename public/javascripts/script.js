
window.onload = function () {
  var xhttp = new XMLHttpRequest();
  xhttp.onreadystatechange = function () {
    if (this.readyState == 4 && this.status == 200) {
      vueinst.movies.splice(0);
      var movieList = JSON.parse(this.responseText);
      console.log(movieList)
      for (let movie of movieList) {
        vueinst.movies.push(movie);
      }
    }
  };

  xhttp.open("POST", "/getMovieList", true);
  xhttp.send();
  updateDate();
  updateTime();
  updateSeat();
};

var vueinst = new Vue({
  el: "#app",
  data: {
    movies: [],
  },
});

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

// When the user clicks anywhere outside of the modal, close it
window.onclick = function (event) {
  if (event.target == modal) {
    modal.style.display = "none";
  }
}

let BOOKING = {
  "22-10-2022": {
    "10:10:00": [1, 2, 7, 8, 9],
    "12:00:00": [2, 5, 7, 10, 11, 14],
    "17:45:00": [3, 6, 8, 9],
  },
  "24-10-2022": {
    "08:20:00": [2, 7, 9, 19],
    "16:00:00": [3, 4, 7, 10, 18],
  },
  "27-10-2022": {
    "12:00:00": [6, 8, 16],
    "17:00:00": [5, 7, 12],
    "21:30:00": [19, 20],
  }
}

function updateDate () {
  var date_sel = document.getElementById("date-opt");
  date_sel.innerHTML = ""
  for (let date in BOOKING) {
    let date_opt = document.createElement('option');
    date_opt.value = date;
    date_opt.innerText = date;
    date_sel.appendChild(date_opt)
  }
}

function updateTime () {
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

function updateSeat () {
  var seat_sel = document.getElementById("seat-opt");
  var date_sel_val = document.getElementById("date-opt").value;
  var time_sel_val = document.getElementById("time-opt").value;
  seat_sel.innerHTML = ""
  console.log()
  for (let seat of BOOKING[date_sel_val][time_sel_val]) {
    console.log(seat)
    let seat_opt = document.createElement('option');
    seat_opt.value = seat;
    seat_opt.innerText = seat;
    seat_sel.appendChild(seat_opt)
  }
}
