//document.getElementById("loginForm").addEventListener("submit", function (event) {
//    event.preventDefault(); // Formun otomatik olarak submit olmas�n� engeller

//    var username = document.getElementById("username").value;
//    var password = document.getElementById("password").value;

//    fetch('https://localhost:7288/api/mobileLogin', {
//        method: 'POST',
//        headers: {
//            'Content-Type': 'application/json'
//        },
//        body: JSON.stringify({
//            username: username,
//            password: password
//        })
//    })
//        .then(response => response.text())
//        .then(data => {
//            if (data === "Login successful") {
//                window.location.href = "/Home/Index"; // Ba�ar�l� giri� oldu�unda index sayfas�na y�nlendirme
//            } else {
//                alert("Login failed"); // Ba�ar�s�z giri� durumunda hata mesaj� g�sterme
//            }
//        })
//        .catch(error => {
//            console.error('Error:', error); // Hata durumunda konsola hata mesaj�n� yazd�rma
//        });
//});