using Google.Cloud.Firestore.V1;
using Google.Cloud.Firestore;
using Microsoft.AspNetCore.Mvc;
using System.Diagnostics;
using SoftwareProject.Models;
using Microsoft.Extensions.Logging;
using System.Threading.Tasks;
using System.Collections.Generic;
using System;
using System.Linq;
using Google.Cloud.Storage.V1;
using Google.Apis.Storage.v1.Data;

namespace SoftwareProject.Controllers
{
    public class HomeController : Controller
    {
        private readonly StorageClient _storageClient;
        private readonly FirestoreDb db;

        [HttpPost]
        public async Task<IActionResult> Upload(IFormFile file, string title, string student, string description, string professor)
        {
            if (file == null || file.Length == 0)
            {
                ModelState.AddModelError("File", "Please select a file to upload.");
                return View();
            }

            // Create file name
            var fileName = $"{student}_{file.FileName}";
            var contentType = file.ContentType;

            // Upload file to Google Cloud Storage
            using (var fileStream = file.OpenReadStream())
            {
                var storageObject = await _storageClient.UploadObjectAsync("your-bucket-name", fileName, contentType, fileStream);

                // Update ACL settings to allow public access
                var acl = storageObject.Acl ?? new List<ObjectAccessControl>();
                acl.Add(new ObjectAccessControl
                {
                    Entity = "allUsers",
                    Role = "READER"
                });
                storageObject.Acl = acl;
                await _storageClient.UpdateObjectAsync(storageObject);

                // Create public URL
                string downloadUrl = $"https://storage.googleapis.com/your-bucket-name/{fileName}";

                // Create or update document in Firestore
                DocumentReference docRef = db
                    .Collection("evaluation-project")
                    .Document("Project")
                    .Collection("Projects")
                    .Document(student);
                await docRef.SetAsync(new
                {
                    Title = title,
                    Description = description,
                    FileUrl = downloadUrl,
                    ProfessorEmail = professor,
                    User = student
                }, SetOptions.MergeAll);
            }

            TempData.Keep("Username");
            return RedirectToAction("Index");
        }

        public IActionResult File()
        {
            TempData.Keep("Username");
            return View();
        }

        public async Task<IActionResult> Results()
        {
            string username = TempData["Username"]?.ToString();

            // Use your Firestore credentials path here
            string path = "path-to-your-firebase-adminsdk.json";

            FirestoreDb db = FirestoreDb.Create(projectId: "your-project-id", new FirestoreClientBuilder
            {
                CredentialsPath = path
            }.Build());

            DocumentReference docRef = db.Collection("evaluation-project")
                                         .Document("Evaluation")
                                         .Collection("results")
                                         .Document(username);

            DocumentSnapshot snapshot = await docRef.GetSnapshotAsync();

            if (snapshot.Exists)
            {
                int totalGrateToPercent = snapshot.GetValue<int>("totalGrateToPercent");
                string ProfEm = snapshot.GetValue<string>("prefossorEmail");
                string GenelYorum = snapshot.GetValue<string>("text22");

                ViewBag.TotalGrateToPercent = totalGrateToPercent;
                ViewBag.ProfEm = ProfEm;
                ViewBag.GenelYorum = GenelYorum;
            }
            else
            {
                ViewBag.TotalGrateToPercent = "Document not found";
            }
            TempData.Keep("Username");
            return View();
        }

        public IActionResult NecessaryDocument()
        {
            return View();
        }

        public IActionResult DownloadCriteria()
        {
            var filePath = Path.Combine(Directory.GetCurrentDirectory(), "wwwroot/files", "evaluationCriteria.pdf");
            var fileBytes = System.IO.File.ReadAllBytes(filePath);
            var fileName = "evaluationCriteria.pdf";

            return File(fileBytes, "application/pdf", fileName);
        }

        public IActionResult DownloadPoster()
        {
            var filePath = Path.Combine(Directory.GetCurrentDirectory(), "wwwroot/files", "Poster.pptx");
            var fileBytes = System.IO.File.ReadAllBytes(filePath);
            var fileName = "Poster.pptx";

            return File(fileBytes, "application/pptx", fileName);
        }

        public IActionResult DownloadStages()
        {
            var filePath = Path.Combine(Directory.GetCurrentDirectory(), "wwwroot/files", "stages.pdf");
            var fileBytes = System.IO.File.ReadAllBytes(filePath);
            var fileName = "stages.pdf";

            return File(fileBytes, "application/pdf", fileName);
        }

        public IActionResult DownloadObserved()
        {
            var filePath = Path.Combine(Directory.GetCurrentDirectory(), "wwwroot/files", "tobeobserved.pdf");
            var fileBytes = System.IO.File.ReadAllBytes(filePath);
            var fileName = "tobeobserved.pdf";

            return File(fileBytes, "application/pdf", fileName);
        }

        public IActionResult DownloadReport()
        {
            var filePath = Path.Combine(Directory.GetCurrentDirectory(), "wwwroot/files", "ProjectR.docx");
            var fileBytes = System.IO.File.ReadAllBytes(filePath);
            var fileName = "ProjectRaport.docx";

            return File(fileBytes, "application/docx", fileName);
        }

        public IActionResult DownloadIEEE()
        {
            var filePath = Path.Combine(Directory.GetCurrentDirectory(), "wwwroot/files", "IEEE.docx");
            var fileBytes = System.IO.File.ReadAllBytes(filePath);
            var fileName = "IEEE.docx";

            return File(fileBytes, "application/docx", fileName);
        }

        private async Task<bool> IsStudentAllowed(string username)
        {
            // Use your Firestore credentials path here
            string path = "path-to-your-firebase-adminsdk.json";

            FirestoreDb db = FirestoreDb.Create(projectId: "your-project-id", new FirestoreClientBuilder
            {
                CredentialsPath = path
            }.Build());

            try
            {
                CollectionReference collection = db.Collection("evaluation-project/UserLogin/Student");
                QuerySnapshot querySnapshot = await collection.GetSnapshotAsync();

                foreach (DocumentSnapshot documentSnapshot in querySnapshot)
                {
                    if (documentSnapshot.Exists)
                    {
                        Dictionary<string, object> studentData = documentSnapshot.ToDictionary();

                        if (studentData.ContainsKey("StudentID") && studentData["StudentID"].ToString() == username)
                        {
                            return true;
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine("Error checking student authorization: " + ex.Message);
                return false;
            }

            return false;
        }

        public async Task<IActionResult> Admin()
        {
            if (!User.Identity.IsAuthenticated)
            {
                return RedirectToAction("Index", "Home");
            }

            string username = TempData["Username"]?.ToString();

            try
            {
                if (int.TryParse(username, out _))
                {
                    if (await IsStudentAllowed(username))
                    {
                        TempData["ErrorMessage"] = "You are not authorized to view this page.";
                        return RedirectToAction("Index", "Home");
                    }
                    else
                    {
                        TempData["ErrorMessage"] = "You are not authorized to view this page.";
                        return RedirectToAction("Index", "Home");
                    }
                }
                else
                {
                    return View();
                }
            }
            catch (Exception ex)
            {
                TempData["ErrorMessage"] = "An error occurred. Please try again.";
                return RedirectToAction("Index", "Home");
            }
        }

        private readonly ILogger<HomeController> _logger;

        public HomeController(FirestoreDb firestoreDb, StorageClient storageClient, IConfiguration configuration)
        {
            db = firestoreDb ?? throw new ArgumentNullException(nameof(firestoreDb));
            _storageClient = storageClient ?? throw new ArgumentNullException(nameof(storageClient));
            Bucket = configuration["Firebase:StorageBucket"];
            if (string.IsNullOrEmpty(Bucket))
            {
                throw new ArgumentException("Firebase storage bucket name must be provided in the configuration.");
            }
        }

        public async Task<IActionResult> Index()
        {
            return View();
        }

        public IActionResult Privacy()
        {
            return View();
        }

        [HttpGet]
        public async Task<IActionResult> takvim()
        {
            string username = TempData["Username"]?.ToString();

            if (username == "admin")
            {
                var model = new CalendarViewModel
                {
                    Events = new List<Event>
                    {
                        new Event { Title = "Örnek Etkinlik", Date = DateTime.Now, Description = "Bu bir örnek etkinliktir." }
                    }
                };
                return View(model);
            }
            else if (!User.Identity.IsAuthenticated)
            {
                return RedirectToAction("Index", "Home");
            }

            try
            {
                if (int.TryParse(username, out _))
                {
                    if (await IsStudentAllowed(username))
                    {
                        TempData["ErrorMessage"] = "You are not authorized to view this page.";
                        return RedirectToAction("Index", "Home");
                    }
                    else
                    {
                        TempData["ErrorMessage"] = "You are not authorized to view this page.";
                        return RedirectToAction("Index", "Home");
                    }
                }
                else
                {
                    var model = new CalendarViewModel
                    {
                        Events = new List<Event>
                        {
                            new Event { Title = "Örnek Etkinlik", Date = DateTime.Now, Description = "Bu bir örnek etkinliktir." }
                        }
                    };
                    return View(model);
                }
            }
            catch (Exception ex)
            {
                TempData["ErrorMessage"] = "An error occurred. Please try again.";
                return RedirectToAction("Index", "Home");
            }
        }

        [HttpPost]
        public async Task<IActionResult> takvim(string EventTimeFrom)
        {
            // Use your Firestore credentials path here
            string path = "path-to-your-firebase-adminsdk.json";

            FirestoreDb db = FirestoreDb.Create(projectId: "your-project-id", new FirestoreClientBuilder
            {
                CredentialsPath = path
            }.Build());

            DateTime eventDateTime;
            if (!DateTime.TryParse(EventTimeFrom, out eventDateTime))
            {
                return BadRequest("Geçersiz tarih formatı.");
            }

            string eventDateTimeString = eventDateTime.ToString("yyyy-MM-ddTHH:mm:ss");
            string username = "admin";

            DocumentReference userEventsCollection = db.Collection("evaluation-project")
                .Document("AvailableDateTimeSlot")
                .Collection("AvailableDates")
                .Document(username);

            DocumentReference studentListCollection = db.Collection("evaluation-project")
                .Document("Project")
                .Collection("Projects")
                .Document(username);

            var data = new
            {
                TimeFrom = eventDateTimeString,
                availableDate = DateTime.UtcNow,
            };

            await userEventsCollection.SetAsync(data, SetOptions.MergeAll);
            await studentListCollection.SetAsync(data, SetOptions.MergeAll);

            Console.WriteLine("Etkinlik başarıyla güncellendi.");

            return RedirectToAction("takvim");
        }

        private async Task<bool> IsStudentAuthorized(string studentId)
        {
            List<string> studentIds = await GetStudentIdsAsync();
            return studentIds.Contains(studentId);
        }

        private async Task<List<string>> GetStudentIdsAsync()
        {
            // Use your Firestore credentials path here
            string path = "path-to-your-firebase-adminsdk.json";

            FirestoreDb db = FirestoreDb.Create(projectId: "your-project-id", new FirestoreClientBuilder
            {
                CredentialsPath = path
            }.Build());

            CollectionReference collection = db.Collection("evaluation-project/UserLogin/Student");
            QuerySnapshot querySnapshot = await collection.GetSnapshotAsync();

            List<string> studentIds = new List<string>();
            foreach (DocumentSnapshot documentSnapshot in querySnapshot.Documents)
            {
                studentIds.Add(documentSnapshot.Id);
            }

            return studentIds;
        }

        [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
        public IActionResult Error()
        {
            return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
        }
    }
}
