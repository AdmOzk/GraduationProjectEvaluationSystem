//document.getElementById("loginForm").addEventListener("submit", function (event) {
//    event.preventDefault(); // Formun otomatik olarak submit olmasýný engeller

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
//                window.location.href = "/Home/Index"; // Baþarýlý giriþ olduðunda index sayfasýna yönlendirme
//            } else {
//                alert("Login failed"); // Baþarýsýz giriþ durumunda hata mesajý gösterme
//            }
//        })
//        .catch(error => {
//            console.error('Error:', error); // Hata durumunda konsola hata mesajýný yazdýrma
//        });
//});