using Microsoft.AspNetCore.Mvc;
using OpenQA.Selenium;
using OpenQA.Selenium.Chrome;
using System;
using System.Threading.Tasks;
using Google.Cloud.Firestore;
using System.Collections.Generic;
using Google.Cloud.Firestore.V1;
using System.Linq;

namespace WebApplication4.Controllers
{
    public class LoginController : Controller
    {
        private async Task<bool> IsStudentAuthorized(string username)
        {
            // Specify the path to your Firestore credentials
            string path = "path-to-your-firebase-adminsdk.json";

            // Create a FirestoreDb instance using the Firestore project ID
            FirestoreDb db = FirestoreDb.Create(projectId: "your-project-id", new FirestoreClientBuilder
            {
                CredentialsPath = path
            }.Build());

            // Fetch student numbers registered in /evaluation-project/UserLogin/Student
            CollectionReference studentCollection = db.Collection("evaluation-project/UserLogin/Student");
            QuerySnapshot snapshot = await studentCollection.GetSnapshotAsync();

            // Convert the student numbers fetched from Firestore into a list
            List<string> authorizedStudentIds = snapshot.Documents
                .Select(doc => doc.GetValue<string>("StudentID"))
                .ToList();

            // Check if the logged-in student's number is in the authorized list
            return authorizedStudentIds.Contains(username);
        }

        private async Task AddUserLoginToFirestore(string username)
        {
            // Specify the path to your Firestore credentials
            string path = "path-to-your-firebase-adminsdk.json";

            // Create a FirestoreDb instance using the Firestore project ID
            FirestoreDb db = FirestoreDb.Create(projectId: "your-project-id", new FirestoreClientBuilder
            {
                CredentialsPath = path
            }.Build());

            // Get the user's login time
            DateTime loginTime = DateTime.UtcNow;
            CollectionReference collection = db.Collection("evaluation-project");

            // Prepare user data
            var data = new Dictionary<string, object>
            {
                { "LoginTime", loginTime }
            };

            if (username.All(char.IsDigit))
            {
                DocumentReference document = collection.Document("UserLogin");
                CollectionReference subcollection = document.Collection("Student");
                DocumentReference refer = subcollection.Document(username);

                data.Add("StudentID", username);

                await refer.SetAsync(data);
            }
            else
            {
                DocumentReference document = collection.Document("Professor");
                CollectionReference subcollection = document.Collection("Academian");
                DocumentReference refer = subcollection.Document(username);

                data.Add("ProfessorID", username);

                await refer.SetAsync(data);
            }

            Console.WriteLine("User data has been successfully added to Firestore.");
        }

        [HttpPost]
        public async Task<IActionResult> Login(string username, string password)
        {
            try
            {
                ChromeOptions optionsc = new ChromeOptions();
                optionsc.AddArgument("--headless");
                optionsc.AddArguments("--disable-gpu", "--no-sandbox", "--start-maximized --headless");

                // Launch Chrome browser
                using (var driver = new ChromeDriver(options: optionsc))
                {
                    // Navigate to the website
                    driver.Navigate().GoToUrl("https://cats.iku.edu.tr/access/login");

                    // Fill in username and password
                    var usernameInput = driver.FindElement(By.Id("eid"));
                    var passwordInput = driver.FindElement(By.Id("pw"));

                    usernameInput.SendKeys(username);
                    passwordInput.SendKeys(password);

                    // Find and click the login button
                    var loginButton = driver.FindElement(By.Id("submit"));
                    loginButton.Click();

                    // Check for the presence of a specific class to verify successful login
                    if (driver.FindElement(By.ClassName("Mrphs-userNav__submenuitem--profilepicture")) != null)
                    {
                        // Add user to Firestore
                        await AddUserLoginToFirestore(username);

                        TempData["Username"] = username;

                        if (username.All(char.IsDigit))
                        {
                            // Check student authorization from Firestore
                            if (await IsStudentAuthorized(username))
                            {
                                return RedirectToAction("Index", "Home");
                            }
                            else
                            {
                                TempData["ErrorMessage"] = "You are not authorized to access this page.";
                                return RedirectToAction("Login", "Login");
                            }
                        }
                        else
                        {
                            // Redirect professor to the admin page
                            return RedirectToAction("Admin", "Home");
                        }
                    }
                    else
                    {
                        TempData["ErrorMessage"] = "The username or password is incorrect. Please try again.";
                        return RedirectToAction("Login", "Login");
                    }
                }
            }
            catch (Exception ex)
            {
                TempData["ErrorMessage"] = "An error occurred. Please try again.";
                return RedirectToAction("Login", "Login");
            }
        }

        public IActionResult Login()
        {
            return View();
        }
    }
}
