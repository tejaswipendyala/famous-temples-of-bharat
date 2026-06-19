import Map "mo:core/Map";
import List "mo:core/List";
import CommonTypes "../types/common";
import FaqTypes "../types/faq";

module {
  public type FaqMap = Map.Map<CommonTypes.FaqId, FaqTypes.Faq>;

  public func add(
    faqs : FaqMap,
    nextFaqId : Nat,
    input : FaqTypes.FaqInput,
    now : CommonTypes.Timestamp,
  ) : FaqTypes.Faq {
    let faq : FaqTypes.Faq = {
      id = nextFaqId;
      templeId = input.templeId;
      question = input.question;
      answer = input.answer;
      createdAt = now;
      updatedAt = now;
    };
    faqs.add(nextFaqId, faq);
    faq;
  };

  public func update(
    faqs : FaqMap,
    id : CommonTypes.FaqId,
    input : FaqTypes.FaqInput,
    now : CommonTypes.Timestamp,
  ) : ?FaqTypes.Faq {
    switch (faqs.get(id)) {
      case null null;
      case (?existing) {
        let updated : FaqTypes.Faq = {
          existing with
          question = input.question;
          answer = input.answer;
          updatedAt = now;
        };
        faqs.add(id, updated);
        ?updated;
      };
    };
  };

  public func remove(faqs : FaqMap, id : CommonTypes.FaqId) : Bool {
    switch (faqs.get(id)) {
      case null false;
      case (?_) {
        faqs.remove(id);
        true;
      };
    };
  };

  public func getByTemple(faqs : FaqMap, templeId : CommonTypes.TempleId) : [FaqTypes.Faq] {
    List.fromIter<FaqTypes.Faq>(faqs.values())
      .filter(func(f) { f.templeId == templeId })
      .toArray();
  };

  // ─── Sample Data Seeder ────────────────────────────────────────────────────

  public func seedSampleData(faqs : FaqMap, nextFaqId : Nat, now : CommonTypes.Timestamp) : Nat {
    // Clear any stale or partial state before seeding
    faqs.clear();

    var idCounter = 1;

    let sampleFaqs : [(CommonTypes.TempleId, Text, Text)] = [
      // Tirupati Balaji (templeId = 1)
      (1, "What is the dress code for Tirupati Balaji Temple?", "Traditional Indian attire is preferred. Men should wear dhoti (with or without shirt) or traditional clothes. Women should wear saree or salwar kameez with dupatta. Western wear like shorts, sleeveless tops, and mini-skirts are not allowed."),
      (1, "Is photography allowed inside Tirupati Temple?", "Photography and videography are strictly prohibited inside the main temple complex and the sanctum sanctorum. Cameras and mobile phones must be deposited at the cloak room near the main entrance."),
      (1, "How do I get Tirupati Laddu (prasadam)?", "The famous Tirupati Laddu (prasadam) can be purchased at designated counters near the exit after darshan. Each devotee can purchase a limited quantity (usually 2 per head) at a nominal price. It can also be booked online through the TTD website."),
      (1, "What are the accommodation options near Tirupati?", "The Tirumala Tirupati Devasthanams (TTD) provides extensive accommodation in guest houses and dharamshalas near the Tirumala hill temple and in Tirupati town. Many private hotels are also available in Tirupati city."),
      (1, "Is there a helicopter service to Tirupati?", "Yes, Pawan Hans operates helicopter services from Tirupati to Tirumala. Tickets can be booked in advance online through the TTD website or at the Tirupati helipad counter."),

      // Kashi Vishwanath (templeId = 2)
      (2, "What is the dress code for Kashi Vishwanath Temple?", "Traditional Indian attire is preferred. Men should wear dhoti-kurta or decent clothing. Women should wear saree, salwar kameez, or similar traditional wear. Shorts, mini-skirts, and sleeveless tops are not permitted. Shoes must be removed before entering the premises."),
      (2, "Can non-Hindus visit Kashi Vishwanath Temple?", "Entry to the inner sanctum is restricted to Hindus only. Non-Hindus can visit the Kashi Vishwanath Corridor and some outer areas of the complex but cannot enter the main shrine."),
      (2, "How is Kashi Vishwanath Temple reached?", "The temple is located in the Vishwanath Gali (lane) in Varanasi. It is best reached by auto-rickshaw, e-rickshaw, or on foot from Dashashwamedh Ghat or Godaulia market. The new Kashi Vishwanath Corridor also connects the temple to the Ganga riverfront."),
      (2, "What is special about visiting Kashi on Maha Shivaratri?", "Varanasi celebrates Maha Shivaratri with all-night celebrations, processions, and poojas. The Kashi Vishwanath Temple has extended darshan hours. Lakhs of devotees take a holy dip in the Ganga and then visit the temple."),

      // Jagannath Puri (templeId = 3)
      (3, "Can non-Hindus enter Jagannath Temple Puri?", "Non-Hindus are not allowed inside the Jagannath Temple. However, they can view the temple from outside — the Raghunandan Library rooftop nearby offers a good view of the temple and its activities."),
      (3, "What is the significance of the Mahaprasad at Puri Jagannath?", "The Mahaprasad (sacred food) of Puri Jagannath Temple is considered extremely sacred. It is cooked in the temple's kitchen (the world's largest temple kitchen) using an ancient method and is distributed to thousands daily. It is believed that whoever eats Mahaprasad receives the Lord's blessings."),
      (3, "What happens during Rath Yatra?", "During Rath Yatra (Chariot Festival), the deities of Jagannath, Balabhadra, and Subhadra are placed on three giant chariots and pulled by millions of devotees along the Grand Road (Bada Danda) to the Gundicha Temple, 3 km away. They stay there for 9 days and then return in Bahuda Yatra."),
      (3, "What is the dress code for Puri Jagannath Temple?", "Traditional Indian attire is mandatory. Men must wear dhoti (no shirt allowed inside the sanctum). Women must wear saree or traditional blouse-skirt. Non-traditional wear, tight jeans, and sleeveless tops are not allowed."),

      // Somnath (templeId = 4)
      (4, "What is the best time to visit Somnath Temple?", "The best time to visit is from October to March when the weather is pleasant. Avoid the monsoon season (June–August) if possible. The Sound and Light Show in the evenings is a must-see throughout the year."),
      (4, "Is the Somnath Sound and Light Show worth attending?", "Yes, absolutely! The evening Sound and Light Show narrates the temple's 5000-year history with dramatic lights and sound effects. It runs for about 45 minutes and gives a fantastic overview of the temple's significance and turbulent past."),
      (4, "What are the nearest railway stations and airports to Somnath?", "The nearest railway station is Veraval (6 km away). Diu Airport (85 km) and Rajkot Airport (200 km) are the nearest airports. Somnath is well-connected by road from Rajkot, Ahmedabad, and Bhavnagar."),

      // Shirdi Sai Baba (templeId = 5)
      (5, "Is Shirdi open to people of all religions?", "Yes, Shirdi Sai Baba Temple is open to people of all religions. Sai Baba himself preached the unity of all religions with his famous motto 'Sabka Maalik Ek' (One God for All). People of all faiths visit and receive equal respect."),
      (5, "What is the significance of Thursdays at Shirdi?", "Thursday (Guruvar) is considered the most auspicious day to visit Shirdi, as Sai Baba is a Guru (spiritual teacher). The crowds are highest on Thursdays. Special extended poojas and aartis are performed."),
      (5, "What is Dwarkamai and why is it important?", "Dwarkamai is the mosque where Sai Baba lived for most of his life in Shirdi. It contains the sacred fire (Dhuni) that Sai Baba kept burning continuously and his original grinding stone. It is one of the most important spots in the Shirdi complex."),
      (5, "What is the dress code for Shirdi Temple?", "While there is no strict dress code, modest and decent clothing is recommended as a mark of respect. Remove shoes before entering. The temple provides storage for footwear."),

      // Golden Temple (templeId = 6)
      (6, "Is the Golden Temple open to all religions?", "Yes, the Golden Temple (Harmandir Sahib) is open to people of all faiths, nationalities, and backgrounds. The four entrances (on all four sides) symbolize that people from all four corners and all religions are welcome."),
      (6, "What is the Langar at Golden Temple?", "Langar is a free community meal served 24 hours a day, 7 days a week, 365 days a year at the Golden Temple. Over 100,000 people are fed daily regardless of religion, caste, or economic status. Volunteers from all over the world come to serve in the Langar kitchen."),
      (6, "What should I wear to visit the Golden Temple?", "Head must be covered at all times — cloth head coverings (rumals) are available free at the entrance. Shoes must be removed and feet washed in the running water channel before entering. Alcohol, tobacco, and non-vegetarian food are prohibited inside."),
      (6, "Is there accommodation near the Golden Temple?", "The Shiromani Gurdwara Parbandhak Committee (SGPC) provides free accommodation (Sarai) for up to 3 nights to pilgrims near the Golden Temple. Many hotels and dharamshalas are also available in Amritsar for longer stays."),

      // Meenakshi (templeId = 7)
      (7, "Can non-Hindus enter Meenakshi Amman Temple?", "The innermost sanctum of Meenakshi Amman Temple is restricted to Hindus only. However, non-Hindus can visit the outer corridors, the thousand-pillar hall, the museum within the temple complex, and observe the temple architecture."),
      (7, "What is special about Friday evenings at Meenakshi Temple?", "Every Friday evening, a beautiful procession takes place where Lord Sundareswarar is ceremonially carried on a silver palanquin to Goddess Meenakshi's chamber for the night. This is called 'Alankaram' and is a spectacular devotional experience."),
      (7, "What is the significance of the 14 Gopurams of Meenakshi Temple?", "The 14 towering Gopurams (gateway towers) are covered with thousands of brightly painted stucco figures of gods, demons, and mythological scenes. The Southern Gopuram (50m tall) is the largest. Each Gopuram faces a cardinal direction and is repainted approximately every 12 years."),

      // Kedarnath (templeId = 8)
      (8, "When is Kedarnath Temple open?", "Kedarnath Temple is open only from May to November. The exact opening date (Akshaya Tritiya) and closing date (Kartik Purnima/Diwali) are announced each year. During winter (November–April), the deity is moved to Ukhimath (70 km away)."),
      (8, "How do I reach Kedarnath?", "The trek to Kedarnath starts from Gaurikund (near Sonprayag), which is accessible by road from Rishikesh/Haridwar/Dehradun. From Gaurikund, it is a 16–18 km trek to the temple. Ponies, dolis (palanquins), and helicopter services are available for those who cannot trek."),
      (8, "Is prior registration required for Kedarnath?", "Yes, online registration via the official Char Dham Yatra portal (badrinath-kedarnath.gov.in or chardhamregistration.gov.in) is mandatory for all pilgrims. A daily quota system limits the number of visitors. Carry your registration confirmation and ID proof."),
      (8, "What should I carry for the Kedarnath trek?", "Warm woolen clothes are essential even in summer as temperatures can drop at night. Carry raincoats/ponchos for monsoon season. Comfortable trekking shoes, a walking stick, water, and light snacks are recommended. Avoid excessive luggage."),

      // Siddhivinayak (templeId = 9)
      (9, "Is there an online booking system for Siddhivinayak Temple?", "Yes, the Siddhivinayak Temple Trust provides online darshan token booking to reduce wait times. Tokens can be booked at siddhivinayak.org. However, free walk-in darshan is also available throughout the day."),
      (9, "What is special about the Ganesha idol at Siddhivinayak?", "The Siddhivinayak idol is unique because Lord Ganesha's trunk points to the right, which is extremely rare. A right-trunked Ganesha (Siddha Vinayak) is considered more powerful and is believed to fulfil all wishes of devotees."),
      (9, "What is the parking situation near Siddhivinayak Temple?", "Parking is extremely limited near the temple due to its urban Mumbai location. It is highly recommended to use public transport — the nearest railway station is Dadar (10 min walk) and bus/auto services are abundant. BEST Bus services also stop near the temple."),

      // Padmanabhaswamy (templeId = 10)
      (10, "What is the dress code for Padmanabhaswamy Temple?", "Strict dress code is enforced. Men must wear dhoti (no shirt — bare-chested, or with angavastra). Women must wear saree (with blouse) or Kerala-style traditional attire (mundu-davani/set saree). No Western clothes, jeans, or churidars are allowed. Violators will be turned away."),
      (10, "What are the famous vaults of Padmanabhaswamy Temple?", "The temple has six subterranean vaults (Kallara A to F). In 2011, Vaults A–E were opened by a Supreme Court-appointed committee and found to contain gold, jewels, and artifacts worth over ₹1.2 lakh crore — the largest collection of treasure ever found in a religious institution. Vault B (Kallara B) has not been opened as it is considered protected by divine power."),
      (10, "Who can enter Padmanabhaswamy Temple?", "Entry is restricted to Hindus only. Non-Hindus cannot enter the temple. Before entering, devotees must sign a declaration that they are Hindu. The temple can be viewed from outside by everyone."),

      // Vaishno Devi (templeId = 11)
      (11, "How do I register for Vaishno Devi Yatra?", "Registration is mandatory and must be done online at maavaishnodevi.org or at registration counters in Katra (Banganga area). Yatra Slips (RFID cards) are issued after registration. Carry valid ID proof. Registration can be done up to 6 months in advance."),
      (11, "What is the trekking distance to Vaishno Devi?", "The traditional route from Katra to Bhawan (main shrine) is approximately 12–14 km. An alternative Tarakwala Marg is also available. From Bhawan, an additional 2 km trek (Ardh Kuwari route) leads to the cave shrine. Ponies, dolis, and helicopter services are available from Katra and Sanjichhat."),
      (11, "What is the significance of Ardh Kuwari on the Vaishno Devi route?", "Ardh Kuwari (meaning 'half-way goddess') is a sacred cave about 6 km from Katra. According to legend, the Goddess Vaishno Devi meditated here for 9 months. The cave is very narrow and the entrance involves a short crawl. Darshan at Ardh Kuwari is an important part of the Yatra."),
      (11, "What facilities are available on the Vaishno Devi trekking route?", "The Shri Mata Vaishno Devi Shrine Board provides excellent facilities: clean washrooms, first-aid posts, langars (free food), medical centers, ATMs, and rest points along the route. CCTV cameras and security personnel are present throughout for pilgrim safety."),
    ];

    for ((templeId, question, answer) in sampleFaqs.values()) {
      let faq : FaqTypes.Faq = {
        id = idCounter;
        templeId = templeId;
        question = question;
        answer = answer;
        createdAt = now;
        updatedAt = now;
      };
      faqs.add(idCounter, faq);
      idCounter := idCounter + 1;
    };

    idCounter;
  };
};
