  // Firebase projenizin yapılandırması
  const firebaseConfig = {
      "type": "service_account",
      "project_id": "evaluation-project-eed94",
      "private_key_id": "f073cfbb8f77f9e4afd0f40c41ea9e64fac9cc3c",
      "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQCIi+acvDqcKaJO\nWzF7ppjuzfIuPBBtgF4o4H0r7RtPWGZjsyy19zvIRawQj+paHJcqwDOvNR/rJdrO\nFGPQyYvbnZA8UTpAeBk88g287FScdB/tuXuKALCsUVlBOe5a3CPCfAkQlpQPVPwn\nx6KwxW/yrAP/XA3+w2XBkb2abGAZ3bH708fHVbkFjcikfkMynvdG6Br1siQX/2e4\n0MbkEbLSWL4zDFrEvhJ7fypdIijmQgShTL7JOBD03d8kZlJ3XhTR4NPV6gGGuHhc\n95a2pjmABvn/FO8282I28CKSIRo38/9/QXzYHs2xDxdrqC+znpKdreNnpjFNRsr6\nVRXJY+1TAgMBAAECggEAEzn/wtoONqb2H6pfkVWn+xgsna3/ciu9Fmxls6WzTrzX\nzfoQtZ6WYGDPFZXuHbog3vgpTuZgFDBEWvgsBd4bP1U0Vgnp9eHzS82ZeZydXVpM\nlKClcI0gU2Mw+io6Ebkln+DvNdK+DlqdFszZb6KdXMIz3eUMY28ICPWIiRHxhjKo\njlsQz9xHQXR1PLptrF1TtqA1HUKlGruZlTMeha0hpqZgtGu4eXWDhBTnUDHYpZSB\nrsJBfH17GgaHG3npGGTicAf+OGGtrHFTNKfvgOzfQDSXsHJ5+wpA0oUDk8BDfU4z\nG0wjQwvViVoxUMA1Ccd/eGbc1oik0E6fqxtKY9N/AQKBgQC/a00n9ueZy0EdjLDS\nxlnxveCwBUQL1PNmKdQAxeCmjUYauD7Y9tQQKxRkrTGv1JRZG2fAEnqhbE2aThZs\nLdUpWMuO0XFqhoEv0NJ877iBhS6IiZwcFf4osOdiz0/36BmZ4Ke+K75pEmCP7ch9\nFQZhg+6TwszDku3wbbD5rEkPoQKBgQC2nUwq/wGCmxIA1ldqPgY2XKT/Xy5x/uTT\nfDbtmZiZNBgYBynq22WZS6JFtlfe12OQlBmWG2pVP4CXVzoiXgI9HneGCJRirT2e\nRQoFOW+Lc82urwDp1bdPI//srmdK/j7r2P1uzM3KO3wv9+UV4SjbjE+k8EP5hPzc\n8VEQtWjocwKBgE7aL9V3s146SV+X1jttdB3OPyGjea16Eq4SKwAKg4l4htl47oLH\n4wGqDWOPqPkqk9XFIU8RDa0zhSA8bKYxly7KIkh55MOiFtOQrTTEN3g7WbjrHwC+\n2oz+msKsbd/Mn8cwsUj4kh6McHS52i4UnCVNiNkblOg3vYaeWRnwq8QhAoGASKrZ\nZ3aoRC+u/1RL3sQltrYxFknq8oPqzNluBiiL19MqD02yeXmquVCmlzUTTGLLhPna\nIKhyLNAjPJYCVTCxlV6tU1HQsl+b2IJClYeggo6nd26+X06jLkP2EFnqUqZPpYxo\ndRHchjAbn/72UzmRB6STAOB3PDCWatlAV/TIdU8CgYAP5fzoVA93pyuWgYdWqEr6\n3+Wq9i8W/jokO7TM8oRnp62rSGUHkYI/KVtcQ/WyoWMn0AsDinT3JVAKH7A+Yp/c\nBsREnucDRqk/O27c9tT7+GukNholqSAv/t2OYC15U/fTldfg2SQKSruprwaHOzXu\nyVhsAsmQSrFlvoVtKVacPw==\n-----END PRIVATE KEY-----\n",
      "client_email": "firebase-adminsdk-boj92@evaluation-project-eed94.iam.gserviceaccount.com",
      "client_id": "116282977419230524046",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-boj92%40evaluation-project-eed94.iam.gserviceaccount.com",
      "universe_domain": "googleapis.com"
  };

  // Firebase'i başlat
  firebase.initializeApp(firebaseConfig);

  // Form submit olduğunda
  document.querySelector('form').addEventListener('submit', function(e) {
    e.preventDefault();

    // Formdaki dosya
    const file = document.querySelector('input[type=file]').files[0];
    const username = document.querySelector('input[name=Student]').value;

    // Dosya adı
    const fileName = file.name;

    // Storage referansı oluştur
    const storageRef = firebase.storage().ref(`evaluation-project/Project/GraduationProject/${username}/${fileName}`);

    // Dosyayı yükle
    const task = storageRef.put(file);

    // Yükleme işlemi tamamlandığında
    task.then(snapshot => {
      console.log('Dosya yüklendi');
      alert('Dosya yüklendi');
      // Burada başka işlemler yapabilirsiniz, örneğin veritabanına dosya yolunu kaydedebilirsiniz.
    }).catch(error => {
      console.error('Hata:', error);
      alert('Dosya yüklenirken bir hata oluştu');
    });
  });


document.addEventListener("DOMContentLoaded", function () {
    // Tarih alanını seç
    var submittedDateField = document.getElementById("SubmittedDate");

    // Bugünün tarihini al
    var today = new Date();

    // Yıl, ay ve günü al
    var year = today.getFullYear();
    var month = String(today.getMonth() + 1).padStart(2, "0"); // Ay 0'dan başlar, bu yüzden +1 ekliyoruz ve iki haneli olarak formatlıyoruz
    var day = String(today.getDate()).padStart(2, "0"); // Günü iki haneli olarak formatlıyoruz

    // YYYY-MM-DD formatında tarihi oluştur
    var formattedDate = year + "-" + month + "-" + day;

    // Tarih alanına bugünkü tarihi yerleştir
    submittedDateField.value = formattedDate;
});

document.getElementById("uploadForm").addEventListener("submit", function (event) {
    event.preventDefault();

    // Formun gönderilmesi işlemini burada yapılacak!

    alert("Projeniz Gönderilmiştir");
});