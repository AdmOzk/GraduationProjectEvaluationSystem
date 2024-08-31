using FireSharp.Config;
using FireSharp.Interfaces;
using FireSharp.Response;
using Google.Cloud.Firestore;
using Google.Cloud.Firestore.V1;
using SoftwareProject.Models;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
namespace SoftwareProject.Controllers
{
    public class PresentationScheduleController : Controller
    {

        private const int MaxProfessorsPerProject = 3; // Proje başına maksimum profesör sayısı








        //AYNI TAKTİĞİ DİĞERLERİ İÇİNDE UYGULA
        public async Task<IList<MyProfessor>> GetProfessors(CancellationToken token)
        {
            string path = AppDomain.CurrentDomain.BaseDirectory + @"0";

            // FirestoreDb nesnesini oluşturmak için Firestore projesinin kimliğini kullanın
            FirestoreDb db = FirestoreDb.Create(projectId: "0", new FirestoreClientBuilder
            {
                CredentialsPath = path
            }.Build());


            IList<MyProfessor> professors = new List<MyProfessor>();
            var collection = db.Collection("Professor");
            var snapshot = await collection.GetSnapshotAsync(token);

            foreach (var item in snapshot.Documents)
            {
                professors.Add(
                    new MyProfessor()
                    {
                        Email = item.GetValue<string>("Email"),
                        FirstName = item.GetValue<string>("FirstName"),
                        LastName = item.GetValue<string>("LastName"),
                        Department = item.GetValue<string>("Department"),
                        Id = item.GetValue<int>("Id"),
                    }
                    );

                //tmmdr burda profesör tablosunu cekiyoruz
                Console.WriteLine($"Professor: {item.GetValue<string>("FirstName")} {item.GetValue<string>("LastName")}, Department: {item.GetValue<string>("Department")}");
            }
            return professors;
        }

        public async Task UpdateProfessorAsync(string professorId, string email, string firstName, string lastName, string department)
        {
            string path = AppDomain.CurrentDomain.BaseDirectory + @"0";

            // FirestoreDb nesnesini oluşturmak için Firestore projesinin kimliğini kullanın
            FirestoreDb db = FirestoreDb.Create(projectId: "0", new FirestoreClientBuilder
            {
                CredentialsPath = path
            }.Build());


            var document = db.Collection("Professor").Document(professorId);

            // Create a dictionary with updated data
            var data = new Dictionary<string, object>
    {
        { "Email", email },
        { "FirstName", firstName },
        { "LastName", lastName },
        { "Department", department }
    };

            // Update the document with new data
            await document.SetAsync(data, SetOptions.MergeAll);
        }



        public async Task<MyProfessor> GetProfessorByIdAsync(int professorId, CancellationToken token)
        {
            string path = AppDomain.CurrentDomain.BaseDirectory + @"0";

            // FirestoreDb nesnesini oluşturmak için Firestore projesinin kimliğini kullanın
            FirestoreDb db = FirestoreDb.Create(projectId: "0", new FirestoreClientBuilder
            {
                CredentialsPath = path
            }.Build());


            var document = db.Collection("Professor").Document(professorId.ToString());
            var snapshot = await document.GetSnapshotAsync(token);

            if (snapshot.Exists)
            {
                var professor = new MyProfessor()
                {
                    Id = snapshot.GetValue<int>("Id"),
                    Department = snapshot.GetValue<string>("Department"),
                    Email = snapshot.GetValue<string>("Email"),
                    FirstName = snapshot.GetValue<string>("FirstName"),
                    LastName = snapshot.GetValue<string>("LastName")
                };

                return professor;
            }
            else
            {
                // Handle the case where the professor with the given ID does not exist
                return null; // or throw an exception, depending on your requirement
            }
        }












        public class MyProfessor
        {
            public int Id { get; set; }
            public string Department { get; set; }

            public string Email { get; set; }

            public string FirstName { get; set; }
            public string LastName { get; set; }




        }

        // PROJECT

        public async Task<IList<MyProjects>> GetProjects(CancellationToken token)
        {
            string path = AppDomain.CurrentDomain.BaseDirectory + @"0";

            // FirestoreDb nesnesini oluşturmak için Firestore projesinin kimliğini kullanın
            FirestoreDb db = FirestoreDb.Create(projectId: "0", new FirestoreClientBuilder
            {
                CredentialsPath = path
            }.Build());



            IList<MyProjects> Projects = new List<MyProjects>();
            var collection = db.Collection("Project");
            var snapshot = await collection.GetSnapshotAsync(token);

            foreach (var item in snapshot.Documents)
            {
                Projects.Add(
                    new MyProjects()
                    {
                        ProfessorId = item.GetValue<int>("ProfessorId"),
                        ProjectDescription = item.GetValue<string>("ProjectDescription"),
                        //  ProjectTitle = item.GetValue<string>("ProjectTitle"),
                        Project_File = item.GetValue<string>("Project_File"),
                        StudentId = item.GetValue<string>("StudentId"),
                        Type_of_Project = item.GetValue<string>("Type_of_Project"),
                        Id = item.GetValue<int>("Id"),

                    }
                    );

                //tmmdr burda proje tablosunu cekiyoruz
                Console.WriteLine($"Project Title: title, Description: {item.GetValue<string>("ProjectDescription")}, Professor ID: {item.GetValue<int>("ProfessorId")}, Student ID: {item.GetValue<string>("StudentId")}, Type of Project: {item.GetValue<string>("Type_of_Project")}, Project File: {item.GetValue<string>("Project_File")}, ID: {item.Id}");
            }
            return Projects;
        }



        public class MyProjects
        {
            public int Id { get; set; }

            public int ProfessorId { get; set; }

            public string ProjectDescription { get; set; }

            public string ProjectTitle { get; set; }

            public string Project_File { get; set; }
            public string StudentId { get; set; }

            public string Type_of_Project { get; set; }



        }


        // AVAİLABLEDATETIMESLOT


        public async Task<IList<MyAvailableDateTimeSlots>> GetAvailableDateTimes(CancellationToken token)
        {
            string path = AppDomain.CurrentDomain.BaseDirectory + @"0";

            // FirestoreDb nesnesini oluşturmak için Firestore projesinin kimliğini kullanın
            FirestoreDb db = FirestoreDb.Create(projectId: "0", new FirestoreClientBuilder
            {
                CredentialsPath = path
            }.Build());



            IList<MyAvailableDateTimeSlots> Dates = new List<MyAvailableDateTimeSlots>();
            var collection = db.Collection("AvailableDateTimeSlot");
            var snapshot = await collection.GetSnapshotAsync(token);

            foreach (var item in snapshot.Documents)
            {
                Dates.Add(
                    new MyAvailableDateTimeSlots()
                    {
                        ProfessorId = item.GetValue<int>("ProfessorId"),
                        isAvailable = item.GetValue<bool>("isAvailable"),
                        AvailableDate = item.GetValue<DateTime>("AvailableDate"),
                        Id = item.GetValue<int>("Id"),

                    }
                    );
                Console.WriteLine("AVAİLABLE DATE TIME SLOTS");
                Console.WriteLine($"Professor ID: {item.GetValue<int>("ProfessorId")}, Is Available: {item.GetValue<bool>("isAvailable")}, Available Date: {item.GetValue<DateTime>("AvailableDate")}");
            }
            return Dates;
        }






        //BOOKEDDATES

        public async Task<IList<MyBookedDates>> GetBookedDates(CancellationToken token)
        {
            string path = AppDomain.CurrentDomain.BaseDirectory + @"0";

            // FirestoreDb nesnesini oluşturmak için Firestore projesinin kimliğini kullanın
            FirestoreDb db = FirestoreDb.Create(projectId: "0", new FirestoreClientBuilder
            {
                CredentialsPath = path
            }.Build());


            IList<MyBookedDates> BookedDates = new List<MyBookedDates>();
            var collection = db.Collection("BookedDates");
            var snapshot = await collection.GetSnapshotAsync(token);

            foreach (var item in snapshot.Documents)
            {
                BookedDates.Add(
                    new MyBookedDates()
                    {
                        ProfessorId = item.GetValue<int>("ProfessorId"),
                        ProjectId = item.GetValue<int>("ProjectId"),
                        BookedDate = item.GetValue<DateTime>("BookedDate"),
                        Id = item.Id
                    }
                );

                Console.WriteLine("BOOKED DATES");
                // Printing the retrieved values
                Console.WriteLine($"Professor ID: {item.GetValue<int>("ProfessorId")}, Project ID: {item.GetValue<int>("ProjectId")}, Booked Date: {item.GetValue<DateTime>("BookedDate")}");
            }
            return BookedDates;
        }



        public class MyBookedDates
        {
            public string Id { get; set; }

            public int ProfessorId { get; set; }

            public int ProjectId { get; set; }

            public DateTime BookedDate { get; set; }





        }







        // AvailableDateTimeSlot tablosu için ekleme metodu
        public async Task AddAvailableDateTimeSlot(int professorId, int isAvailable, DateTime availableDate)
        {
            string path = AppDomain.CurrentDomain.BaseDirectory + @"0";

            // FirestoreDb nesnesini oluşturmak için Firestore projesinin kimliğini kullanın
            FirestoreDb db = FirestoreDb.Create(projectId: "0", new FirestoreClientBuilder
            {
                CredentialsPath = path
            }.Build());


            var collection = db.Collection("AvailableDateTimeSlot");

            // Yeni bir belge oluştur
            var newDocument = collection.Document();

            // Belgeye verileri ekle
            var data = new Dictionary<string, object>
    {
        { "ProfessorId", professorId },
        { "isAvailable", isAvailable },
        { "AvailableDate", availableDate }
    };

            // Firestore'a belgeyi ekle
            await newDocument.SetAsync(data);
        }













        // Project tablosu için ekleme metodu
        public async Task AddProject(int professorId, string projectDescription, string projectFile, string studentId, string typeOfProject)
        {
            string path = AppDomain.CurrentDomain.BaseDirectory + @"0";

            // FirestoreDb nesnesini oluşturmak için Firestore projesinin kimliğini kullanın
            FirestoreDb db = FirestoreDb.Create(projectId: "0", new FirestoreClientBuilder
            {
                CredentialsPath = path
            }.Build());



            var collection = db.Collection("Project");

            // Yeni bir belge oluştur
            var newDocument = collection.Document();

            // Belgeye verileri ekle
            var data = new Dictionary<string, object>
    {
        { "ProfessorId", professorId },
        { "ProjectDescription", projectDescription },
        { "Project_File", projectFile },
        { "StudentId", studentId },
        { "Type_of_Project", typeOfProject }
    };

            // Firestore'a belgeyi ekle
            await newDocument.SetAsync(data);
        }

        // Professor tablosu için ekleme metodu
        public async Task AddProfessor(int id, string email, string firstName, string lastName, string department)
        {
            string path = AppDomain.CurrentDomain.BaseDirectory + @"0";

            // FirestoreDb nesnesini oluşturmak için Firestore projesinin kimliğini kullanın
            FirestoreDb db = FirestoreDb.Create(projectId: "0", new FirestoreClientBuilder
            {
                CredentialsPath = path
            }.Build());



            var collection = db.Collection("Professor");

            // Yeni bir belge oluştur
            var newDocument = collection.Document();

            // Belgeye verileri ekle
            var data = new Dictionary<string, object>
    {
        { "Email", email },
        { "FirstName", firstName },
        { "LastName", lastName },
        { "Department", department },
         {"Id",id }
    };

            // Firestore'a belgeyi ekle
            await newDocument.SetAsync(data);
        }





        public async Task<List<(DateTime, int, int)>> GetBookedDatesWithIds(CancellationToken token)
        {
            List<(DateTime, int, int)> bookedDates = new List<(DateTime, int, int)>();

            var bookedDatesData = await GetBookedDates(token); // BookedDates koleksiyonundan verileri alın

            foreach (var bookedDate in bookedDatesData)
            {
                bookedDates.Add((bookedDate.BookedDate, bookedDate.ProjectId, bookedDate.ProfessorId));
            }

            return bookedDates; // Sadece rezervasyon tarihlerini içeren bir liste döndürün
        }

        public async Task<IActionResult> ViewBooked(CancellationToken cancellationToken)
        {
            var bookedDatesWithIds = await GetBookedDatesWithIds(cancellationToken);
            return View(bookedDatesWithIds);
        }


        public async Task<List<(string, string, string, string)>> GetProfessorsWithIds(CancellationToken token)
        {
            List<(string, string, string, string)> Professors = new List<(string, string, string, string)>();

            var ProfessorsData = await GetProfessors(token); // BookedDates koleksiyonundan verileri alın

            foreach (var professor in ProfessorsData)
            {
                Professors.Add((professor.Department, professor.Email, professor.FirstName, professor.LastName));
            }

            return Professors; // Sadece rezervasyon tarihlerini içeren bir liste döndürün
        }


        public async Task<IActionResult> ViewProfs(CancellationToken cancellationToken)
        {
            var ProfsWithIds = await GetProfessorsWithIds(cancellationToken);
            return View(ProfsWithIds);
        }


        public async Task<List<(string, string, string)>> GetProjectsWithIds(CancellationToken token)
        {
            List<(string, string, string)> projects = new List<(string, string, string)>();

            var projectData = await GetProjects(token);

            foreach (var project in projectData)
            {
                projects.Add((project.Type_of_Project, project.ProjectDescription, project.StudentId));
            }

            return projects;
        }

        public async Task<IActionResult> ViewProjects(CancellationToken cancellationToken)
        {
            var projectsWithIds = await GetProjectsWithIds(cancellationToken);
            return View(projectsWithIds);
        }

        public class MyAvailableDateTimeSlots
        {


            public int Id { get; set; }

            public int ProfessorId { get; set; }

            public bool isAvailable { get; set; }

            public DateTime AvailableDate { get; set; }

            public async Task UpdateAsync(string documentId, MyAvailableDateTimeSlots slot, FirestoreDb fireStoreDb)
            {
                var document = fireStoreDb.Collection("AvailableDateTimeSlot").Document(documentId);

                var data = new Dictionary<string, object>
        {
            {"Id", slot.Id},
            {"ProfessorId", slot.ProfessorId},
            {"isAvailable", slot.isAvailable},
            {"AvailableDate", slot.AvailableDate}
        };

                await document.SetAsync(data, SetOptions.MergeAll);
            }



        }

        public async Task AddBookedDate(int professorId, int projectId, DateTime bookedDate)
        {
            string path = AppDomain.CurrentDomain.BaseDirectory + @"0";

            // FirestoreDb nesnesini oluşturmak için Firestore projesinin kimliğini kullanın
            FirestoreDb db = FirestoreDb.Create(projectId: "0", new FirestoreClientBuilder
            {
                CredentialsPath = path
            }.Build());


            var collection = db.Collection("BookedDates");

            // Yeni bir belge oluştur
            var newDocument = collection.Document();

            // Belgeye verileri ekle
            var data = new Dictionary<string, object>
    {
        { "ProfessorId", professorId },
        { "ProjectId", projectId },
        { "BookedDate", bookedDate }
    };

            // Firestore'a belgeyi ekle
            await newDocument.SetAsync(data);
        }


        public async Task<IActionResult> DisplayBookedDates(CancellationToken cancellationToken)
        {
            var bookedDates = await GetBookedDates(cancellationToken);
            return View("BookedDates"); // Here, "Index" is the name of the view
        }




        public async Task<IActionResult> Index(CancellationToken cancellationToken) // Index metodu, sunum programının ana sayfasını oluşturur
        {

            string path = AppDomain.CurrentDomain.BaseDirectory + @"0";

            // FirestoreDb nesnesini oluşturmak için Firestore projesinin kimliğini kullanın
            FirestoreDb db = FirestoreDb.Create(projectId: "0", new FirestoreClientBuilder
            {
                CredentialsPath = path
            }.Build());



            //BÜTÜN PROFESÖRLER ALINDI
            IList<MyProfessor> professors1 = new List<MyProfessor>();

            professors1 = await GetProfessors(cancellationToken);

            //BÜTÜN PROJELER ALINDI
            IList<MyProjects> projects1 = new List<MyProjects>();

            projects1 = await GetProjects(cancellationToken);

            //Bütün Tarihler

            IList<MyAvailableDateTimeSlots> dates1 = new List<MyAvailableDateTimeSlots>();

            dates1 = await GetAvailableDateTimes(cancellationToken);

            //Bütün Rezerve Tarihler

            IList<MyBookedDates> bookeddates1 = new List<MyBookedDates>();

            bookeddates1 = await GetBookedDates(cancellationToken);


            //  await UpdateProfessorAsync("KVQrjGuhrhIQTYOXyYC7", "email", "firstName", "lastName", "department");





            ////BookedDate ekleme


            //await AddBookedDate(12, 5678, DateTime.UtcNow);

            ////AvailableDate Ekleme

            // await AddAvailableDateTimeSlot(1234, 1, DateTime.UtcNow);


            ////Proje ekleme

            //await AddProject("prof123", "Description", "file.pdf", "student456", "TypeA");


            ////Profesör Ekleme 

            // await AddProfessor(30,"example@example.com", "John", "Doe", "IT Department");









            var allSlots = await GetAvailableDateTimes(cancellationToken); // Tüm slotları alır availableDatemSlotları kullanıyo diebiliriz

            var professors = await GetProfessors(cancellationToken);
            var projects = await GetProjects(cancellationToken); // Tüm projeleri alır

            var presentationSchedule = new Dictionary<MyProjects, List<(DateTime, string, string)>>(); // Sunum takvimini oluşturacak bir dictionary tanımlanır

            var bookedDates = await GetBookedDates(cancellationToken); // yapılmış tarihler alınır
            //get booked dates



            foreach (var project in projects) // Tüm projeler için döngü
            {
                var projectSlots = new List<(DateTime, string, string)>(); // Proje slotlarını tutacak liste oluşturulur
                var assignedProfessorIds = new HashSet<int>(); // Atanan profesör kimliklerini tutacak küme oluşturulur

                // Projeyi sunum takvimine ekleyip eklenmediğini kontrol eder
                //Koleksiyon içerisinde, parametre olarak girilen değerde bir Anahtar (Key) mevcutsa TRUE değilse FALSE döndürecektir.




                var bookedDatesQuery = await db.Collection("bookedDates").WhereEqualTo("projectId", project.Id).GetSnapshotAsync();

                // bookedDatesQuery.Documents.Count == 0       bura uygulanır


                var presentationScheduleRef = db.Collection("bookedDates");

                var presentationQuery = await presentationScheduleRef.WhereEqualTo("projectId", project.Id).GetSnapshotAsync();


                var bookedDatesRef = db.Collection("bookedDates");

                var bookedDates1 = await bookedDatesRef.WhereEqualTo("projectId", project.Id).GetSnapshotAsync();


                if (presentationQuery.Documents.Count == 0)
                {
                    var professorSlots = allSlots.Where(slot => slot.ProfessorId == project.ProfessorId && slot.isAvailable == true).ToList(); // Projeye atanmış profesörün boş slotları alınır

                    // Projenin rezerve edilmiş tarihleri var mı kontrol edilir
                    if (bookedDatesQuery.Documents.Count > 0)
                    {
                        var projectBookedDates = bookedDates1; // Projenin rezerve edilmiş tarihleri alınır

                        foreach (var bookedDate in projectBookedDates) // Rezerve edilmiş tarihler için döngü
                        {


                            var professor = await GetProfessorByIdAsync(bookedDate.GetValue<int>("ProfessorId"), cancellationToken); // Rezerve edilen tarih için ilgili profesör bilgisi alınır



                            // Projenin rezerve edilmiş tarihlerini ekler
                            projectSlots.Add((bookedDate.GetValue<DateTime>("BookedDate"), project.StudentId, $"{professor.FirstName} {professor.LastName}"));
                            //0  yazdırma 
                        }
                    }
                    else // Rezerve edilmiş tarih yoksa
                    {
                        // Proje için kullanılabilir slot alınır
                        var availableSlot = await GetAvailableSlot(professorSlots.Select(slot => new MyAvailableDateTimeSlots()).ToList());


                        if (availableSlot != null)
                        {

                            var conflict = await CheckForProfessorConflict(project.ProfessorId, availableSlot.AvailableDate);
                            if (conflict)
                            {
                                // Çakışma olduğunda bir işlem yapabilirsiniz, örneğin bu slotu kullanılamaz yapabilirsiniz.
                                // Burada bir uyarı mesajı döndürerek veya loglayarak kullanıcıya bilgi verebilirsiniz.
                                continue; // Bu projeyi atlamak için döngünün bir sonraki iterasyonuna geçilir
                            }

                            /*Burdan devam*/




                            availableSlot.isAvailable = false;
                            await availableSlot.UpdateAsync(availableSlot.Id.ToString(), availableSlot, db); // Değişikliği veritabanına kaydetmek için güncelleme işlemi yapılır

                            var presentationDateTime = availableSlot.AvailableDate;
                            projectSlots.Add((presentationDateTime, project.StudentId, $"{project.ProfessorId} {project.ProfessorId}"));

                            availableSlot.isAvailable = false; //her döngüde!!!

                            // Rezerve edilen tarih veritabanına eklenir
                            var bookedDatePrimary = new MyBookedDates
                            {
                                ProfessorId = project.ProfessorId,
                                ProjectId = project.Id,
                                BookedDate = availableSlot.AvailableDate,

                                //   AddBookedDate(project.ProfessorId, project.Id, availableSlot.AvailableDate);

                            };

                            await AddBookedDate(project.ProfessorId, project.Id, availableSlot.AvailableDate);


                            //await _bookedDatesService.AddAsync(bookedDatePrimary);

                            assignedProfessorIds.Add(project.ProfessorId);

                            foreach (var professor in professors)
                            {
                                if (assignedProfessorIds.Count >= MaxProfessorsPerProject)
                                    break;

                                if (professor.Id != project.ProfessorId && !assignedProfessorIds.Contains(professor.Id))
                                {
                                    // Profesörün aynı zamanda başka bir projeye atanıp atanmadığı kontrol edilir
                                    //=???!?=!?

                                    var professorAlreadyAssigned = presentationSchedule.Any(p => p.Value.Any(slot => slot.Item1.Date == availableSlot.AvailableDate.Date && p.Key.ProfessorId == professor.Id));

                                    bool x = true;

                                    if (professorAlreadyAssigned)
                                        continue;

                                    var otherProfessorSlots = allSlots
                                        .Where(slot => slot.ProfessorId == professor.Id &&
                                                       slot.AvailableDate.Date == availableSlot.AvailableDate.Date &&
                                                       slot.isAvailable)
                                        .ToList();

                                    var matchingSlot = FindCommonAvailableSlot(professorSlots, otherProfessorSlots);

                                    if (matchingSlot != null)
                                    {
                                        var matchingDateTime = matchingSlot.AvailableDate;


                                        projectSlots.Add((matchingDateTime, project.StudentId, $"{professor.FirstName} {professor.LastName}"));

                                        // Rezerve edilen tarih veritabanına eklenir
                                        var bookedDateSecondary = new MyBookedDates
                                        {
                                            ProfessorId = professor.Id,
                                            ProjectId = project.Id,
                                            BookedDate = matchingSlot.AvailableDate

                                        };


                                        //await _bookedDatesService.AddAsync(bookedDateSecondary);

                                        assignedProfessorIds.Add(professor.Id);
                                    }
                                }
                            }

                            // Kullanılan slotlar için isAvailable özelliği false olarak ayarlanır


                            await availableSlot.UpdateAsync(availableSlot.Id.ToString(), availableSlot, db); // Değişikliği veritabanına kaydetmek 

                            // await _slotService.UpdateAsync(availableSlot.Id.ToString(), availableSlot,_fireStoreDb);
                        }
                    }

                    presentationSchedule.Add(project, projectSlots); // Sunum takvimine proje ve slotlar eklenir
                }
            }

            return View(presentationSchedule); // Sunum takvimi view'ına döner
        }
        //buraya kadar çalıtşır ya 


        private async Task<MyAvailableDateTimeSlots?> GetAvailableSlot(List<MyAvailableDateTimeSlots> slots) // Modify parameter type
        {
            string path = AppDomain.CurrentDomain.BaseDirectory + @"0";

            // FirestoreDb nesnesini oluşturmak için Firestore projesinin kimliğini kullanın
            FirestoreDb db = FirestoreDb.Create(projectId: "0", new FirestoreClientBuilder
            {
                CredentialsPath = path
            }.Build());

            // Try fetching the first available slot from Firestore
            try
            {
                var collection = db.Collection("AvailableDateTimeSlots");
                var snapshot = await collection.OrderBy("AvailableDate").Limit(1).GetSnapshotAsync();

                // Check if a document exists in the snapshot
                if (snapshot.Count == 0)
                {
                    return null; // Indicate no available slots found
                }

                var document = snapshot.Documents.FirstOrDefault(); // Get the first document
                var availableSlot = document.ConvertTo<MyAvailableDateTimeSlots>(); // Convert to AvailableDateTimeSlot

                // Filter available slots based on existingSlots (if needed)
                if (slots.Any(slot => slot.AvailableDate == availableSlot.AvailableDate))
                {
                    // Slot already exists in existingSlots, so skip it
                    return null;
                }

                return availableSlot; // Return the filtered available slot
            }
            catch (Exception ex)
            {
                // Handle potential exceptions during Firestore access (optional)
                Console.WriteLine($"Error retrieving available slot: {ex.Message}");
                return null; // Or throw an exception depending on your error handling strategy
            }
        }

        public async Task<Dictionary<DateTime, List<MyBookedDates>>> GetBookedDatesForProfessorAsync(int professorId)
        {
            string path = AppDomain.CurrentDomain.BaseDirectory + @"0";

            // FirestoreDb nesnesini oluşturmak için Firestore projesinin kimliğini kullanın
            FirestoreDb db = FirestoreDb.Create(projectId: "0", new FirestoreClientBuilder
            {
                CredentialsPath = path
            }.Build());

            // Initialize Firestore collection reference
            var bookedDatesRef = db.Collection("bookedDates");

            // Query Firestore to get booked dates for the specified professorId
            var querySnapshot = await bookedDatesRef.WhereEqualTo("ProfessorId", professorId).GetSnapshotAsync();

            // Initialize dictionary to hold grouped booked dates
            var groupedBookedDates = new Dictionary<DateTime, List<MyBookedDates>>();

            // Iterate through query snapshot results
            foreach (var document in querySnapshot.Documents)
            {
                // Deserialize Firestore document to MyBookedDates object
                var bookedDate = document.ConvertTo<MyBookedDates>(); // Assuming you have a method to convert Firestore document to your custom object

                // Extract date from booked date
                var dateKey = bookedDate.BookedDate.Date;

                // Check if the date key already exists in the dictionary
                if (!groupedBookedDates.ContainsKey(dateKey))
                {
                    // If the date key doesn't exist, initialize a new list
                    groupedBookedDates[dateKey] = new List<MyBookedDates>();
                }

                // Add booked date to the list corresponding to its date key
                groupedBookedDates[dateKey].Add(bookedDate);
            }

            return groupedBookedDates;
        }


        private async Task<bool> CheckForProfessorConflict(int professorId, DateTime date)
        {
            // Profesörün rezerve edilmiş tarihlerini alır
            var bookedDates = await GetBookedDatesForProfessorAsync(professorId);
            // Belirtilen tarihte ve saatte başka bir projeye atanmış profesör var mı kontrol eder
            if (bookedDates.ContainsKey(date.Date))
            {
                foreach (var bookedDate in bookedDates[date.Date])
                {

                    return true; // Çakışma varsa true döner

                }
            }
            return false; // Çakışma yoksa false döner
        }

        private MyAvailableDateTimeSlots FindCommonAvailableSlot(List<MyAvailableDateTimeSlots> slots1, List<MyAvailableDateTimeSlots> slots2) // Ortak kullanılabilir slotu bulan metot
        {
            foreach (var slot1 in slots1)
            {
                foreach (var slot2 in slots2)
                {
                    // İki slotun tarihi aynı mı kontrol edilir
                    if (slot1.AvailableDate.Date == slot2.AvailableDate.Date)
                    {
                        // İki slotun saati aynı mı kontrol edilir

                        return slot1; // Slot1 veya slot2 döner, ikisi de aynıdır

                    }
                }
            }
            return null; // Ortak slot bulunamazsa null döner
        }
    }
}
