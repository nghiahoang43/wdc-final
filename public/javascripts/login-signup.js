function login() {
  let message = document.getElementById('message');
  let email = document.getElementById('email').value;
  let password = document.getElementById('password').value;

  var xhttp = new XMLHttpRequest();
  xhttp.onreadystatechange = function () {
    if (this.readyState == 4 && this.status == 200) {
      getUser();
      location.href = './home.html';
    } else if (this.readyState == 4 && this.status >= 400) {
      message.innerHTML = "Login Failed! Email or Password incorrect.";
    }
  };

  xhttp.open("POST", "/login", true);
  xhttp.setRequestHeader("Content-type", "application/json");
  xhttp.send(JSON.stringify({ email: email, password: password }));
}

function signup() {
  let message = document.getElementById('message');
  let password = document.getElementById('password').value;
  let confirmedPassword = document.getElementById('confirmPassword').value;

  if (password != confirmedPassword) {
    message.innerHTML = "Please reenter password!";
    message.removeAttribute("hidden");
    return;
  }

  let username = document.getElementById('username').value;
  if (username.length < 8) {
    message.innerHTML = "Username need at least 8 characters.";
    message.removeAttribute("hidden");
    return;
  }

  let email = document.getElementById('email').value;
  const email_required = /^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
  if (!email.match(email_required)) {
    message.innerHTML = "Please enter a valid email.";
    message.removeAttribute("hidden");
    return;
  }

  const pass_required = /^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[^a-zA-Z0-9])(?!.*\s).{8,15}$/;
  if (!password.match(pass_required)) {
    message.innerHTML = "Password must be between 8 to 15 characters which contain at least one lowercase letter, one uppercase letter, one numeric digit, and one special character";
    message.removeAttribute("hidden");
    return;
  }

  var xhttp = new XMLHttpRequest();
  xhttp.onreadystatechange = function () {
    if (this.readyState == 4 && this.status == 200) {
      getUser();
      location.href = './home.html';
    }
  };

  xhttp.open("POST", "/signup", true);
  xhttp.setRequestHeader("Content-type", "application/json");
  xhttp.send(JSON.stringify({ username: username, password: password, email: email }));
}

function getUser() {
  var xhttp = new XMLHttpRequest();
  xhttp.onreadystatechange = function () {
    if (this.readyState == 4 && this.status == 200) {
    }
  };

  xhttp.open("GET", "/users", true);
  xhttp.send();
}