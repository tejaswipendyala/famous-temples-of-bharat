import Map "mo:core/Map";
import List "mo:core/List";
import Text "mo:core/Text";
import Time "mo:core/Time";
import CommonTypes "../types/common";
import TempleTypes "../types/temple";

module {
  public type TempleMap = Map.Map<CommonTypes.TempleId, TempleTypes.Temple>;

  public func nextId(temples : TempleMap) : CommonTypes.TempleId {
    temples.size() + 1;
  };

  public func add(
    temples : TempleMap,
    nextTempleId : Nat,
    input : TempleTypes.TempleInput,
    now : CommonTypes.Timestamp,
  ) : TempleTypes.Temple {
    let temple : TempleTypes.Temple = {
      id = nextTempleId;
      name = input.name;
      deity = input.deity;
      state = input.state;
      city = input.city;
      district = input.district;
      address = input.address;
      description = input.description;
      history = input.history;
      images = input.images;
      architectureStyle = input.architectureStyle;
      darshanTimings = input.darshanTimings;
      poojaSchedule = input.poojaSchedule;
      specialDarshans = input.specialDarshans;
      festivalCalendar = input.festivalCalendar;
      donationOptions = input.donationOptions;
      contactInfo = input.contactInfo;
      nonHinduRestriction = input.nonHinduRestriction;
      averageVisitDuration = input.averageVisitDuration;
      tags = input.tags;
      createdAt = now;
      updatedAt = now;
    };
    temples.add(nextTempleId, temple);
    temple;
  };

  public func update(
    temples : TempleMap,
    id : CommonTypes.TempleId,
    input : TempleTypes.TempleInput,
    now : CommonTypes.Timestamp,
  ) : ?TempleTypes.Temple {
    switch (temples.get(id)) {
      case null null;
      case (?existing) {
        let updated : TempleTypes.Temple = {
          existing with
          name = input.name;
          deity = input.deity;
          state = input.state;
          city = input.city;
          district = input.district;
          address = input.address;
          description = input.description;
          history = input.history;
          images = input.images;
          architectureStyle = input.architectureStyle;
          darshanTimings = input.darshanTimings;
          poojaSchedule = input.poojaSchedule;
          specialDarshans = input.specialDarshans;
          festivalCalendar = input.festivalCalendar;
          donationOptions = input.donationOptions;
          contactInfo = input.contactInfo;
          nonHinduRestriction = input.nonHinduRestriction;
          averageVisitDuration = input.averageVisitDuration;
          tags = input.tags;
          updatedAt = now;
        };
        temples.add(id, updated);
        ?updated;
      };
    };
  };

  public func remove(temples : TempleMap, id : CommonTypes.TempleId) : Bool {
    switch (temples.get(id)) {
      case null false;
      case (?_) {
        temples.remove(id);
        true;
      };
    };
  };

  public func get(temples : TempleMap, id : CommonTypes.TempleId) : ?TempleTypes.Temple {
    temples.get(id);
  };

  public func getAll(temples : TempleMap) : [TempleTypes.Temple] {
    let iter = temples.values();
    List.fromIter<TempleTypes.Temple>(iter).toArray();
  };

  public func search(
    temples : TempleMap,
    params : CommonTypes.SearchParams,
  ) : CommonTypes.PaginatedResult<TempleTypes.TempleSummary> {
    let lowerTerm = params.searchTerm.toLower();
    let filtered = List.fromIter<TempleTypes.Temple>(temples.values()).filter(
      func(t) {
        let matchesTerm = lowerTerm == "" or
          t.name.toLower().contains(#text lowerTerm) or
          t.deity.toLower().contains(#text lowerTerm) or
          t.city.toLower().contains(#text lowerTerm) or
          t.state.toLower().contains(#text lowerTerm) or
          t.district.toLower().contains(#text lowerTerm) or
          t.tags.any(func(tag) { tag.toLower().contains(#text lowerTerm) });
        let matchesState = switch (params.stateFilter) {
          case null true;
          case (?s) t.state.toLower() == s.toLower();
        };
        let matchesCity = switch (params.cityFilter) {
          case null true;
          case (?c) t.city.toLower() == c.toLower();
        };
        matchesTerm and matchesState and matchesCity;
      }
    );
    let total = filtered.size();
    let summaries = filtered.map<TempleTypes.Temple, TempleTypes.TempleSummary>(toSummary);
    let page = summaries.sliceToArray(params.pagination.offset.toInt(), (params.pagination.offset + params.pagination.limit).toInt());
    {
      items = page;
      total = total;
      offset = params.pagination.offset;
      limit = params.pagination.limit;
    };
  };

  public func toSummary(temple : TempleTypes.Temple) : TempleTypes.TempleSummary {
    {
      id = temple.id;
      name = temple.name;
      deity = temple.deity;
      state = temple.state;
      city = temple.city;
      district = temple.district;
      address = temple.address;
      images = temple.images;
      architectureStyle = temple.architectureStyle;
      nonHinduRestriction = temple.nonHinduRestriction;
      averageVisitDuration = temple.averageVisitDuration;
      tags = temple.tags;
    };
  };

  // ─── Sample Data Seeder ────────────────────────────────────────────────────

  public func seedSampleData(temples : TempleMap, now : CommonTypes.Timestamp) {
    // Clear any stale or partial state before seeding to guarantee all 165 temples are always present
    temples.clear();

    // 1. Tirupati Balaji (Tirumala Venkateswara)
    let t1 : TempleTypes.Temple = {
      id = 1;
      name = "Tirumala Venkateswara Temple (Tirupati Balaji)";
      deity = "Lord Venkateswara (Balaji)";
      state = "Andhra Pradesh";
      city = "Tirupati";
      district = "Tirupati";
      address = "Tirumala Hills, Tirupati, Andhra Pradesh 517504";
      description = "One of the most visited and richest temples in the world, the Tirumala Venkateswara Temple is dedicated to Lord Venkateswara, a form of Vishnu. Situated atop the seven hills of Tirumala, it draws over 50,000 pilgrims daily. The temple is renowned for its Laddu prasadam, the hair tonsuring ritual, and its immense wealth accumulated over centuries.";
      history = "The Tirumala Venkateswara Temple has a history spanning over a thousand years, with mentions in various Puranas and ancient texts. The main shrine was built during the Pallava dynasty in the 9th century CE. Over centuries, it received patronage from Vijayanagara kings, Maratha rulers, and various dynasties. The temple is managed by the Tirumala Tirupati Devasthanams (TTD), a government body, since 1933. The presiding deity, Lord Venkateswara, is believed to have appeared on the Tirumala Hills to answer the prayers of sages. The seven hills represent the seven hoods of Adishesha, the cosmic serpent.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/a/a7/Tirumala_temple1.jpg/1200px-Tirumala_temple1.jpg"];
      architectureStyle = "Dravidian";
      darshanTimings = [
        { timingLabel = "Suprabhata Seva (Early Morning)"; openTime = "03:00"; closeTime = "03:30"; breakStart = null; breakEnd = null },
        { timingLabel = "Regular Darshan"; openTime = "06:00"; closeTime = "23:00"; breakStart = ?"13:00"; breakEnd = ?"15:00" },
      ];
      poojaSchedule = [
        { name = "Suprabhata Seva"; time = "03:00"; description = "The awakening ritual of the deity with chanting of Venkatesha Suprabhatam"; isIncluded = false; price = ?300 },
        { name = "Tomala Seva"; time = "04:00"; description = "Decoration of the deity with fresh flowers"; isIncluded = false; price = ?500 },
        { name = "Archana"; time = "07:00"; description = "Chanting of 108 names of the Lord with flower offerings"; isIncluded = true; price = null },
        { name = "Astadala Pada Padmaradhana"; time = "08:00"; description = "Lotus-petal worship of the Lord's feet"; isIncluded = false; price = ?200 },
        { name = "Sahasra Kalasabhishekam"; time = "10:00"; description = "Abhishekam with 1000 sacred pots of water"; isIncluded = false; price = ?1500 },
        { name = "Rajabhogam (Noon Naivedyam)"; time = "12:00"; description = "Grand noon offering of food to the Lord"; isIncluded = true; price = null },
        { name = "Dolotsavam"; time = "18:00"; description = "Swinging festival of the deity on a cradle"; isIncluded = false; price = ?300 },
        { name = "Ekanta Seva (Night)"; time = "22:00"; description = "The final rite where the deity is put to rest for the night"; isIncluded = false; price = ?500 },
      ];
      specialDarshans = [
        { name = "Sarva Darshan (Free Darshan)"; description = "General queue darshan — no prior booking needed; estimated wait time 12–20 hours"; price = 0; availableDays = ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"] },
        { name = "Seva Darshan (SSD)"; description = "Special Entry Darshan with token — 4 hour wait approximately"; price = 300; availableDays = ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"] },
        { name = "VIP Break Darshan (Senior Citizens/Differently Abled)"; description = "Dedicated queue for senior citizens (above 65) and differently-abled pilgrims"; price = 0; availableDays = ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"] },
      ];
      festivalCalendar = [
        { name = "Brahmotsavam"; date = "September/October (9 days)"; significance = "The grand annual festival of the temple, with the deity being taken out in various processions on different vahanas (vehicles)" },
        { name = "Vaikunta Ekadashi"; date = "December/January"; significance = "The most auspicious day when the Vaikunta Dwaram (gate to heaven) opens; lakhs of pilgrims gather" },
        { name = "Rathasaptami"; date = "January/February"; significance = "The chariot festival celebrating the birth anniversary of the Sun god" },
        { name = "Teppotsavam"; date = "January"; significance = "Float festival where the deity is taken around the Pushkarini tank on a decorated float" },
        { name = "Ugadi (Telugu New Year)"; date = "March/April"; significance = "The Telugu New Year celebrated with special sevas and offerings" },
      ];
      donationOptions = [
        { donationType = "Hundi (General Donation)"; amount = 100; description = "General donation into the main Hundi (donation box) of the temple" },
        { donationType = "Anna Prasadam Trust"; amount = 500; description = "Donation towards free meal (Anna Prasadam) for pilgrims" },
        { donationType = "Go Seva (Cow Protection)"; amount = 1000; description = "Donation towards the upkeep of cows in the temple's Gosala" },
        { donationType = "Laddu Seva"; amount = 200; description = "Contribution towards the famous Tirupati Laddu prasadam distribution" },
      ];
      contactInfo = { phone = ?"+91-877-2277777"; email = ?"info@tirumala.org"; website = ?"https://www.tirumala.org" };
      nonHinduRestriction = true;
      averageVisitDuration = 6;
      tags = ["vaishnava","andhra pradesh","richest temple","world famous","pilgrimage","vishnu","seven hills","prasadam","laddu"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(1, t1);

    // 2. Kashi Vishwanath Temple, Varanasi
    let t2 : TempleTypes.Temple = {
      id = 2;
      name = "Kashi Vishwanath Temple";
      deity = "Lord Shiva (Vishwanath)";
      state = "Uttar Pradesh";
      city = "Varanasi";
      district = "Varanasi";
      address = "Lahori Tola, Varanasi, Uttar Pradesh 221001";
      description = "The Kashi Vishwanath Temple is one of the most famous Hindu temples dedicated to Lord Shiva, located in the holy city of Varanasi (Kashi). It is one of the 12 Jyotirlingas, the most sacred abodes of Lord Shiva, and is believed that a pilgrimage to Kashi and a darshan of Vishwanath grants moksha (liberation). The recently rebuilt Kashi Vishwanath Corridor has greatly enhanced the pilgrimage experience.";
      history = "The Kashi Vishwanath Temple has a long and turbulent history. The original temple was built and destroyed several times over centuries due to invasions. The current temple was built in 1780 CE by Maratha ruler Ahilyabai Holkar. In 2019, the Kashi Vishwanath Dham project was launched under Prime Minister Modi, creating a grand corridor connecting the temple to the Ganga river. This magnificent corridor was inaugurated in December 2021. The temple and the city of Varanasi are believed to be the earthly home of Lord Shiva and Goddess Parvati.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/c/c5/Kashi_Vishwanath_Temple_1.jpg/1200px-Kashi_Vishwanath_Temple_1.jpg"];
      architectureStyle = "Nagara";
      darshanTimings = [
        { timingLabel = "Mangala Aarti (Early Morning)"; openTime = "03:00"; closeTime = "04:00"; breakStart = null; breakEnd = null },
        { timingLabel = "Regular Darshan"; openTime = "04:00"; closeTime = "23:00"; breakStart = ?"12:00"; breakEnd = ?"13:00" },
        { timingLabel = "Shringar Bhog"; openTime = "11:15"; closeTime = "12:20"; breakStart = null; breakEnd = null },
        { timingLabel = "Sandhya Aarti"; openTime = "19:00"; closeTime = "20:15"; breakStart = null; breakEnd = null },
        { timingLabel = "Shayan Aarti (Night)"; openTime = "22:30"; closeTime = "23:00"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Mangala Aarti"; time = "03:00"; description = "The auspicious early morning aarti to awaken Lord Vishwanath"; isIncluded = false; price = ?251 },
        { name = "Rudra Abhishek"; time = "06:00"; description = "Sacred bathing of the Shivalinga with Panchamrit — milk, curd, honey, ghee, and sugar"; isIncluded = false; price = ?500 },
        { name = "Shringar Bhog"; time = "11:15"; description = "Noon decoration and food offering to the Lord"; isIncluded = true; price = null },
        { name = "Sandhya Aarti"; time = "19:00"; description = "Magnificent evening aarti performed amidst bells, conches, and incense"; isIncluded = true; price = null },
        { name = "Shayan Aarti"; time = "22:30"; description = "The bedtime aarti to put Lord Vishwanath to rest"; isIncluded = false; price = ?251 },
      ];
      specialDarshans = [
        { name = "VIP Darshan (Paid)"; description = "Skip the queue with a paid ticket for faster darshan"; price = 300; availableDays = ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"] },
        { name = "General Darshan (Free)"; description = "Free darshan — queue wait time varies from 1–5 hours"; price = 0; availableDays = ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"] },
        { name = "Shravan Somvar Special"; description = "Special extended darshan on Mondays during the month of Shravan (July–August)"; price = 0; availableDays = ["Monday"] },
      ];
      festivalCalendar = [
        { name = "Maha Shivaratri"; date = "February/March"; significance = "The most important festival — celebrated with all-night vigil, abhishekam, and special poojas; millions of devotees visit" },
        { name = "Shravan Month"; date = "July/August"; significance = "The entire month of Shravan is sacred — every Monday sees tens of thousands of pilgrims performing Kanwar Yatra" },
        { name = "Dev Deepawali"; date = "October/November (Kartik Purnima)"; significance = "All 84 ghats of Varanasi are illuminated with millions of lamps — a spectacular sight" },
        { name = "Ganga Dussehra"; date = "May/June"; significance = "Festival celebrating the descent of River Ganga from heaven; special rituals at the ghats" },
        { name = "Annakut (Govardhan Puja)"; date = "October/November (after Diwali)"; significance = "Massive food offering to the deity; thousands of dishes are offered" },
      ];
      donationOptions = [
        { donationType = "General Donation"; amount = 101; description = "Donation for daily rituals and maintenance of the temple" },
        { donationType = "Gold/Silver for Sanctum"; amount = 11000; description = "Donation of gold or silver for the gold-plated sanctum sanctorum" },
        { donationType = "Deepam (Lamp) Seva"; amount = 501; description = "Sponsor a perpetual lamp burning before the Jyotirlinga" },
        { donationType = "Abhishek Seva Sponsorship"; amount = 1100; description = "Sponsor the daily Abhishek Seva for the Jyotirlinga" },
      ];
      contactInfo = { phone = ?"+91-542-2392021"; email = ?"info@shrikashivishwanath.org"; website = ?"https://shrikashivishwanath.org" };
      nonHinduRestriction = true;
      averageVisitDuration = 3;
      tags = ["shaiva","uttar pradesh","jyotirlinga","varanasi","ganga","moksha","kashi","pilgrimage","shiva"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(2, t2);

    // 3. Jagannath Temple, Puri
    let t3 : TempleTypes.Temple = {
      id = 3;
      name = "Jagannath Temple";
      deity = "Lord Jagannath (Vishnu)";
      state = "Odisha";
      city = "Puri";
      district = "Puri";
      address = "Grand Road (Bada Danda), Puri, Odisha 752001";
      description = "The Jagannath Temple in Puri is one of the four sacred Char Dhams (pilgrimage sites) in India. Dedicated to Lord Jagannath, a form of Vishnu, the temple is famous for its annual Rath Yatra (chariot festival) which draws millions of devotees. The temple is unique because the deities are made of neem wood and are replaced every 12–19 years in a secret ceremony called Nabakalebara.";
      history = "The present Jagannath Temple was built by King Anantavarman Chodaganga Deva of the Eastern Ganga dynasty in the 12th century CE (1135–1155 CE). However, the worship of Lord Jagannath predates this temple. The deity is considered to have been originally a tribal deity adopted by Hinduism. The temple has been visited by many saints and devotees including Chaitanya Mahaprabhu who spent many years in Puri. Non-Hindus are not allowed inside the temple, though they can see the temple from outside platforms (Raghunandan Library rooftop).";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/b/b1/The_Jagannath_Temple_At_Puri.jpg/1200px-The_Jagannath_Temple_At_Puri.jpg"];
      architectureStyle = "Kalinga (Rekha Deula)";
      darshanTimings = [
        { timingLabel = "Mangala Alati (Early Morning)"; openTime = "05:00"; closeTime = "06:00"; breakStart = null; breakEnd = null },
        { timingLabel = "Regular Darshan"; openTime = "06:00"; closeTime = "20:00"; breakStart = ?"13:00"; breakEnd = ?"16:00" },
        { timingLabel = "Sandhya Alati (Evening)"; openTime = "19:00"; closeTime = "20:00"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Mangala Alati"; time = "05:00"; description = "The first ritual of the day — sacred aarti to awaken the Lord"; isIncluded = true; price = null },
        { name = "Mailam (Dressing)"; time = "06:00"; description = "The deities are dressed in fresh clothes and ornaments"; isIncluded = true; price = null },
        { name = "Abakash"; time = "06:30"; description = "The morning ablutions (tooth cleaning, bathing) of the deity performed symbolically"; isIncluded = true; price = null },
        { name = "Gopal Ballav Bhog"; time = "07:00"; description = "Morning food offering (breakfast) to the Lord"; isIncluded = true; price = null },
        { name = "Madhyanha Dhupa (Noon Bhog)"; time = "12:00"; description = "The grand noon offering comprising 56 dishes (Chhappan Bhog)"; isIncluded = true; price = null },
        { name = "Sandhya Dhupa"; time = "19:00"; description = "Evening offering to the deities"; isIncluded = true; price = null },
        { name = "Bada Singhara Bhesa"; time = "22:30"; description = "The grand night-time decoration of the deities before they retire"; isIncluded = true; price = null },
      ];
      specialDarshans = [
        { name = "General Darshan (Free)"; description = "Entry to the temple for Hindus; queue wait usually 1–3 hours"; price = 0; availableDays = ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"] },
        { name = "Sahana Mela (Paid Entry)"; description = "Special paid darshan with shorter waiting queue"; price = 200; availableDays = ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"] },
      ];
      festivalCalendar = [
        { name = "Rath Yatra (Chariot Festival)"; date = "June/July (Ashadha Shukla Dwitiya)"; significance = "The most famous festival — three giant chariots carrying Jagannath, Balabhadra, and Subhadra are pulled by millions of devotees along the 3 km Grand Road" },
        { name = "Bahuda Yatra"; date = "June/July (9 days after Rath Yatra)"; significance = "The return journey of the deities back to the main temple after visiting the Gundicha Temple" },
        { name = "Snana Yatra"; date = "May/June (Jyeshtha Purnima)"; significance = "The bathing festival of the deities — they are bathed with 108 pots of water and fall 'sick' for 15 days (Anasara period)" },
        { name = "Dola Yatra"; date = "February/March (Falgun Purnima)"; significance = "Holi celebration at the temple — the deities are swung on a decorated swing and the festival is celebrated with colours" },
        { name = "Kartik Purnima"; date = "October/November"; significance = "Lakhs of devotees take a holy dip in the sea and offer lamps" },
      ];
      donationOptions = [
        { donationType = "General Donation (Hundi)"; amount = 100; description = "General donation to the temple trust" },
        { donationType = "Mahaprasad Seva"; amount = 500; description = "Sponsorship of the famous Mahaprasad (sacred food) distribution to pilgrims" },
        { donationType = "Bhog Seva"; amount = 1100; description = "Sponsorship of daily Bhog (food offering) to the deities" },
        { donationType = "Rath Yatra Contribution"; amount = 5000; description = "Contribution towards the annual Rath Yatra chariot construction and festival expenses" },
      ];
      contactInfo = { phone = ?"+91-6752-222002"; email = ?"sjta@nic.in"; website = ?"https://jagannatha.nic.in" };
      nonHinduRestriction = true;
      averageVisitDuration = 4;
      tags = ["vaishnava","odisha","char dham","rath yatra","jagannath","puri","pilgrimage","vishnu","chariot festival"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(3, t3);

    // 4. Somnath Temple
    let t4 : TempleTypes.Temple = {
      id = 4;
      name = "Somnath Temple";
      deity = "Lord Shiva (Somnath)";
      state = "Gujarat";
      city = "Veraval";
      district = "Gir Somnath";
      address = "Somnath, Prabhas Patan, Veraval, Gujarat 362268";
      description = "The Somnath Temple is a Hindu temple located in Prabhas Patan near Veraval in Gujarat. It is one of the most sacred pilgrimage sites in Hinduism and is believed to be the first of the 12 Jyotirlingas of Lord Shiva. The temple has been destroyed and rebuilt multiple times over the centuries. The current temple, built in the Chalukya style, was completed in 1951 and stands majestically on the Arabian Sea coast.";
      history = "Somnath is believed to have been built by the Moon God (Soma) himself in gold. It was later built by Ravana in silver, Lord Krishna in wood, and then by King Bhimdev in stone. Historical records show the temple was attacked and looted by Mahmud of Ghazni in 1025 CE. It was rebuilt several times but was destroyed again by subsequent Muslim rulers. After Indian independence, the temple was rebuilt with the efforts of Sardar Vallabhbhai Patel and others. The new stone temple was consecrated in 1951 by President Rajendra Prasad. The temple is a symbol of India's resilience and the indestructibility of faith.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/a/aa/Somnath_temple_1.jpg/1200px-Somnath_temple_1.jpg"];
      architectureStyle = "Chalukya (Maru-Gurjara)";
      darshanTimings = [
        { timingLabel = "Morning Darshan"; openTime = "06:00"; closeTime = "12:00"; breakStart = null; breakEnd = null },
        { timingLabel = "Afternoon/Evening Darshan"; openTime = "15:00"; closeTime = "22:00"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Mangala Aarti"; time = "07:00"; description = "Sacred early morning aarti to Lord Somnath"; isIncluded = true; price = null },
        { name = "Abhishek"; time = "08:00"; description = "Sacred bathing ritual of the Jyotirlinga"; isIncluded = false; price = ?251 },
        { name = "Naivedyam (Noon)"; time = "12:00"; description = "Noon food offering to the Lord"; isIncluded = true; price = null },
        { name = "Sandhya Aarti"; time = "19:30"; description = "Evening aarti with conches and bells"; isIncluded = true; price = null },
        { name = "Shayan Aarti"; time = "21:30"; description = "Bedtime aarti to put Lord Somnath to rest"; isIncluded = true; price = null },
      ];
      specialDarshans = [
        { name = "General Darshan"; description = "Free entry for all; temple visit including Sound and Light Show in the evening"; price = 0; availableDays = ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"] },
        { name = "Sound & Light Show"; description = "Evening spectacle narrating the history of Somnath with lights and narration (in Hindi)"; price = 100; availableDays = ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"] },
      ];
      festivalCalendar = [
        { name = "Maha Shivaratri"; date = "February/March"; significance = "The most important festival — celebrated with all-night vigil and special rituals; massive gathering of devotees" },
        { name = "Kartik Purnima"; date = "October/November"; significance = "Auspicious festival when devotees take a holy dip in the Triveni Sangam (confluence of Kapila, Hiran, and Saraswati rivers)" },
        { name = "Somnath Fair"; date = "November/December"; significance = "Annual fair held near the temple with cultural programs and festivities" },
        { name = "Shravan Month"; date = "July/August"; significance = "Every Monday in Shravan is considered very auspicious; special abhishek and poojas are performed" },
      ];
      donationOptions = [
        { donationType = "General Donation"; amount = 101; description = "Contribution to the Shree Somnath Trust for temple maintenance" },
        { donationType = "Gold/Silver Seva"; amount = 5001; description = "Donation of gold or silver articles to the Lord" },
        { donationType = "Annadanam Seva"; amount = 1000; description = "Sponsoring free meals for pilgrims" },
        { donationType = "Deepdan Seva"; amount = 251; description = "Sponsoring lamps in the temple complex" },
      ];
      contactInfo = { phone = ?"+91-2876-231212"; email = ?"info@somnath.org"; website = ?"https://somnath.org" };
      nonHinduRestriction = false;
      averageVisitDuration = 3;
      tags = ["shaiva","gujarat","jyotirlinga","somnath","arabian sea","pilgrimage","shiva","coastal temple","rebuilt"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(4, t4);

    // 5. Shirdi Sai Baba Temple
    let t5 : TempleTypes.Temple = {
      id = 5;
      name = "Sai Baba Temple, Shirdi";
      deity = "Sai Baba of Shirdi";
      state = "Maharashtra";
      city = "Shirdi";
      district = "Ahmednagar";
      address = "Sai Baba Mandir, Shirdi, Maharashtra 423109";
      description = "The Sai Baba Temple in Shirdi is one of the most visited pilgrimage sites in India, attracting people of all religions. Sai Baba, a spiritual teacher who lived in Shirdi in the 19th–20th century, is venerated by both Hindus and Muslims. The temple complex contains the Samadhi Mandir (final resting place), Dwarkamai (mosque where Sai Baba lived), Chawadi, and Lendi Baug garden.";
      history = "Sai Baba arrived in Shirdi as a young man and spent most of his life there. He lived in a dilapidated mosque called Dwarkamai and was known for his miraculous powers and teachings of love, forgiveness, and devotion. He died on October 15, 1918, Vijayadashami day. After his death, a temple (Samadhi Mandir) was built over his burial place. The Shri Saibaba Sansthan Trust (SSST), established by the Maharashtra government, manages the temple and its vast resources. The temple receives over 25,000 pilgrims daily.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/a/a3/Samadhi_Mandir%2C_Shirdi.jpg/1200px-Samadhi_Mandir%2C_Shirdi.jpg"];
      architectureStyle = "Modern (Hemadpanthi influenced)";
      darshanTimings = [
        { timingLabel = "Kakad Aarti (Dawn)"; openTime = "05:15"; closeTime = "05:45"; breakStart = null; breakEnd = null },
        { timingLabel = "Regular Darshan"; openTime = "05:30"; closeTime = "22:30"; breakStart = ?"12:00"; breakEnd = ?"14:30" },
        { timingLabel = "Dhoop Aarti"; openTime = "12:00"; closeTime = "12:30"; breakStart = null; breakEnd = null },
        { timingLabel = "Evening Aarti (Dhoop)"; openTime = "18:30"; closeTime = "19:00"; breakStart = null; breakEnd = null },
        { timingLabel = "Shej Aarti (Night)"; openTime = "22:30"; closeTime = "23:00"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Kakad Aarti"; time = "05:15"; description = "The early morning aarti — the most auspicious time to have Sai Baba's darshan"; isIncluded = true; price = null },
        { name = "Madhyana Aarti"; time = "12:00"; description = "Noon aarti performed at Dwarkamai mosque where Sai Baba lived"; isIncluded = true; price = null },
        { name = "Dhoop Aarti"; time = "18:30"; description = "Evening aarti with incense and camphor; extremely popular"; isIncluded = true; price = null },
        { name = "Shej Aarti"; time = "22:30"; description = "Night aarti — Sai Baba's bed is prepared and he is put to rest"; isIncluded = true; price = null },
        { name = "Abhishek Seva"; time = "09:00"; description = "Sacred bathing of Sai Baba's idol with panchamrit and other sacred substances"; isIncluded = false; price = ?500 },
      ];
      specialDarshans = [
        { name = "General Darshan (Free)"; description = "Free darshan for all religions and castes; queue wait 30 mins to 3 hours depending on the day"; price = 0; availableDays = ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"] },
        { name = "Paid VIP Darshan"; description = "Faster entry with a premium ticket"; price = 500; availableDays = ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"] },
        { name = "Guruvar (Thursday) Special"; description = "Thursday is Sai Baba's most auspicious day — special extended darshan and poojas"; price = 0; availableDays = ["Thursday"] },
      ];
      festivalCalendar = [
        { name = "Ram Navami"; date = "March/April"; significance = "Grand celebration at the temple with processions, cultural programs, and extended darshan hours" },
        { name = "Vijayadashami (Dussehra)"; date = "October"; significance = "The most sacred day — anniversary of Sai Baba's Maha Samadhi (departure from physical body); massive gathering" },
        { name = "Guru Purnima"; date = "June/July"; significance = "Devotees come from across the world to pay respects to Sai Baba on the day of all gurus" },
        { name = "Diwali"; date = "October/November"; significance = "Spectacular illumination of the entire temple complex; special poojas and cultural programs" },
        { name = "Sai Baba's Birthday"; date = "September/October"; significance = "Celebrated with grand festivities spanning multiple days" },
      ];
      donationOptions = [
        { donationType = "General Donation"; amount = 100; description = "Donation to Shri Saibaba Sansthan Trust for temple maintenance and charitable activities" },
        { donationType = "Anna Daan (Free Meal)"; amount = 1000; description = "Sponsoring free food (prasad) for pilgrims at the temple's canteen" },
        { donationType = "Cloth Donation (Clothing Trust)"; amount = 500; description = "Donation to the trust's clothing distribution program for the poor" },
        { donationType = "Hospital/Healthcare Donation"; amount = 5000; description = "Donation to the trust's charitable hospital providing free treatment to the poor" },
      ];
      contactInfo = { phone = ?"+91-2423-258500"; email = ?"info@sai.org.in"; website = ?"https://www.shrisaibabasansthan.org" };
      nonHinduRestriction = false;
      averageVisitDuration = 3;
      tags = ["shirdi","maharashtra","sai baba","interfaith","pilgrimage","maharashtra","spiritual","saint","dwarkamai"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(5, t5);

    // 6. Golden Temple (Harmandir Sahib), Amritsar
    let t6 : TempleTypes.Temple = {
      id = 6;
      name = "Harmandir Sahib (Golden Temple)";
      deity = "Sri Guru Granth Sahib (Sikh Scripture)";
      state = "Punjab";
      city = "Amritsar";
      district = "Amritsar";
      address = "Golden Temple Rd, Amritsar, Punjab 143006";
      description = "Harmandir Sahib, popularly known as the Golden Temple, is the holiest Gurdwara and one of the most important pilgrimage sites in Sikhism. It is located in Amritsar, Punjab, and was built to welcome people of all faiths. The temple is partially submerged in the Amrit Sarovar (pool of nectar), from which the city takes its name. The temple serves over 100,000 langar (community meals) daily free of charge to visitors.";
      history = "The site of Harmandir Sahib was founded by the fourth Sikh Guru, Guru Ram Das, in 1577. The fifth Guru, Guru Arjan Dev Ji, completed the construction of the Gurdwara in 1604 and installed the Adi Granth (Sikh scripture) inside. The temple was attacked and demolished by Ahmad Shah Durrani in 1762 but was rebuilt by Maharaja Ranjit Singh, who also covered it with gold in the early 19th century — hence the name 'Golden Temple.' The temple remained closed for a period after Operation Blue Star in 1984 but was restored to full glory. The Akal Takht (seat of temporal authority of Sikhs) is located opposite the Golden Temple.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/9/94/Golden_Temple_1.jpg/1200px-Golden_Temple_1.jpg"];
      architectureStyle = "Indo-Saracenic (Sikh architecture)";
      darshanTimings = [
        { timingLabel = "Open All Day (Non-stop)"; openTime = "03:00"; closeTime = "23:00"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Palki Sahib (Prakash)"; time = "03:30"; description = "The Guru Granth Sahib is ceremonially brought to the Golden Temple at dawn in a gold palanquin"; isIncluded = true; price = null },
        { name = "Aasa Di Vaar (Morning Kirtan)"; time = "05:00"; description = "A traditional composition of Guru Nanak Dev sung every morning — devotional singing"; isIncluded = true; price = null },
        { name = "Hukamnama (Daily Edict)"; time = "06:00"; description = "Random opening of the Guru Granth Sahib at dawn to receive the day's divine edict"; isIncluded = true; price = null },
        { name = "Afternoon Kirtan"; time = "13:00"; description = "Continuous sacred music and hymn singing (Kirtan) throughout the afternoon"; isIncluded = true; price = null },
        { name = "Rehras Sahib (Evening Prayer)"; time = "18:00"; description = "Evening prayer service"; isIncluded = true; price = null },
        { name = "Palki Sahib (Sukhasan — Resting)"; time = "22:30"; description = "The Guru Granth Sahib is ceremonially taken back to Akal Takht for the night"; isIncluded = true; price = null },
      ];
      specialDarshans = [
        { name = "General Darshan (Free — All Are Welcome)"; description = "Open to all people of all religions, 24/7. No restrictions on entry except head must be covered and shoes removed"; price = 0; availableDays = ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"] },
        { name = "Langar (Free Community Meal)"; description = "Free vegetarian meal served 24 hours, every day, to all visitors regardless of religion, caste, or status"; price = 0; availableDays = ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"] },
      ];
      festivalCalendar = [
        { name = "Gurpurab (Guru Nanak Dev Ji Birthday)"; date = "October/November (Kartik Purnima)"; significance = "The most important Sikh festival — the Golden Temple is lit up magnificently; Nagar Kirtan (religious procession) through Amritsar" },
        { name = "Baisakhi"; date = "April 13/14"; significance = "New Year of the Sikh calendar — marks the founding of Khalsa Panth by Guru Gobind Singh in 1699; massive celebrations" },
        { name = "Diwali"; date = "October/November"; significance = "Sikhs call it Bandi Chhor Divas — celebrating the release of Guru Hargobind from Gwalior Fort; spectacular illumination" },
        { name = "Hola Mohalla"; date = "March (day after Holi)"; significance = "Martial arts demonstrations, music, and poetry; celebrated in the Sikh tradition at Anandpur Sahib with processions" },
        { name = "Guru Arjan Dev Ji Martyrdom Day"; date = "June"; significance = "Remembrance of Guru Arjan Dev Ji's martyrdom; Shabad Kirtan and special prayers" },
      ];
      donationOptions = [
        { donationType = "Golden Temple Donation"; amount = 100; description = "Donation to Shiromani Gurdwara Parbandhak Committee (SGPC) for the Golden Temple" },
        { donationType = "Langar Seva"; amount = 500; description = "Contribution to the Langar (community kitchen) feeding over 100,000 people daily" },
        { donationType = "Degh Seva"; amount = 1000; description = "Contribution to preparation of Degh (sacred sweet pudding) distributed as prasad" },
        { donationType = "Sarovar Sewa"; amount = 2000; description = "Contribution towards maintenance and cleaning of the sacred Amrit Sarovar (holy pond)" },
      ];
      contactInfo = { phone = ?"+91-183-2553957"; email = ?"admin@sgpc.net"; website = ?"https://www.goldentempleamritsar.org" };
      nonHinduRestriction = false;
      averageVisitDuration = 4;
      tags = ["sikhism","punjab","golden temple","amritsar","harmandir sahib","langar","amrit sarovar","interfaith","spiritual"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(6, t6);

    // 7. Meenakshi Amman Temple, Madurai
    let t7 : TempleTypes.Temple = {
      id = 7;
      name = "Meenakshi Amman Temple";
      deity = "Goddess Meenakshi (Parvati) & Lord Sundareswarar (Shiva)";
      state = "Tamil Nadu";
      city = "Madurai";
      district = "Madurai";
      address = "Madurai Main, Madurai, Tamil Nadu 625001";
      description = "The Meenakshi Amman Temple is a historic Hindu temple dedicated to Goddess Meenakshi (a form of Parvati) and her consort Lord Sundareswarar (a form of Shiva). Located in the heart of Madurai, it is one of the most magnificent temples in India, known for its towering gopurams (gateway towers) adorned with thousands of brightly painted mythological sculptures. The temple complex covers 14 acres with 14 gopurams and is a living example of Dravidian architecture.";
      history = "The temple has a history spanning over 2500 years. While the current structure dates to the 17th century, rebuilt by Viswanatha Nayakar, the site has been a sacred spot since ancient times. Madurai was the capital of the Pandya kingdom, and the temple was their royal temple. The goddess Meenakshi is believed to be the daughter of a Pandya king. The temple was rebuilt after being destroyed during the invasion of Malik Kafur in 1310. The most recent gopurams were built in the 20th century. The temple has been a center of Tamil culture, literature, and art for centuries — the famous Tamil Sangam meetings were held in its vicinity.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/3/3a/Meenakshi_amman_temple.jpg/1200px-Meenakshi_amman_temple.jpg"];
      architectureStyle = "Dravidian";
      darshanTimings = [
        { timingLabel = "Morning Darshan"; openTime = "05:00"; closeTime = "12:30"; breakStart = null; breakEnd = null },
        { timingLabel = "Evening Darshan"; openTime = "16:00"; closeTime = "22:00"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Thiruvanandal (Kalasanthi)"; time = "05:30"; description = "The first pooja of the day — opening of the sanctum sanctorum and early morning offerings"; isIncluded = true; price = null },
        { name = "Kalachanthi"; time = "08:00"; description = "Morning pooja with ablutions, decoration, and offerings to both deities"; isIncluded = true; price = null },
        { name = "Uchikalam"; time = "10:00"; description = "Mid-morning pooja with elaborate rituals"; isIncluded = true; price = null },
        { name = "Sayarakshai"; time = "17:00"; description = "Afternoon pooja — considered very auspicious for devotees"; isIncluded = true; price = null },
        { name = "Iraandamkalam"; time = "18:00"; description = "Evening pooja with lamp waving (deepa aarti)"; isIncluded = true; price = null },
        { name = "Ardhajamam"; time = "21:00"; description = "Night pooja — Lord Sundareswarar is taken to Meenakshi's chamber for the night in a procession"; isIncluded = true; price = null },
      ];
      specialDarshans = [
        { name = "General Darshan (Free)"; description = "Free entry for Hindus; the temple is a living place of worship open throughout the day"; price = 0; availableDays = ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"] },
        { name = "Special Entry (Paid)"; description = "Special paid entry for closer and quicker darshan of the main deities"; price = 50; availableDays = ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"] },
        { name = "Friday Evening Procession (Alankaram)"; description = "Every Friday evening, a spectacular procession of Lord Sundareswarar to Goddess Meenakshi's chamber — a must-see"; price = 0; availableDays = ["Friday"] },
      ];
      festivalCalendar = [
        { name = "Chithirai Festival (Meenakshi Tirukalyanam)"; date = "April/May (Tamil month Chithirai, 12 days)"; significance = "The grand celestial wedding of Goddess Meenakshi and Lord Sundareswarar — the biggest festival of Madurai, drawing over a million devotees" },
        { name = "Navaratri"; date = "September/October (9 days)"; significance = "Nine nights of goddess worship with special poojas, cultural programs, and processions" },
        { name = "Maha Shivaratri"; date = "February/March"; significance = "Overnight celebration with special rituals for Lord Sundareswarar; massive devotee gathering" },
        { name = "Thaipusam"; date = "January/February"; significance = "Festival celebrating Lord Murugan (son of Shiva) — kavadi processions and special poojas" },
        { name = "Float Festival (Teppam)"; date = "January/February (Thai Poosam)"; significance = "Deities are taken on a raft around the Vandiyur Mariamman Teppakulam tank in a spectacular evening event" },
      ];
      donationOptions = [
        { donationType = "General Donation"; amount = 100; description = "Donation to HR & CE board for temple maintenance" },
        { donationType = "Abhishek Sponsorship"; amount = 1000; description = "Sponsor the sacred abhishek (bathing) of the deities" },
        { donationType = "Elephant Care Donation"; amount = 500; description = "Donation for the upkeep of the temple elephants, which are an integral part of festival processions" },
        { donationType = "Alankaram (Decoration) Sponsorship"; amount = 5000; description = "Sponsor the elaborate decoration of the deities on special occasions" },
      ];
      contactInfo = { phone = ?"+91-452-2340761"; email = ?"hrmadurai@gmail.com"; website = ?"https://www.maduraimeenakshi.org" };
      nonHinduRestriction = true;
      averageVisitDuration = 4;
      tags = ["shakti","tamil nadu","dravidian","madurai","meenakshi","parvati","shiva","gopuram","south india","ancient"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(7, t7);

    // 8. Kedarnath Temple
    let t8 : TempleTypes.Temple = {
      id = 8;
      name = "Kedarnath Temple";
      deity = "Lord Shiva (Kedarnath)";
      state = "Uttarakhand";
      city = "Kedarnath";
      district = "Rudraprayag";
      address = "Kedarnath, Rudraprayag, Uttarakhand 246445";
      description = "Kedarnath is one of the most sacred Hindu temples dedicated to Lord Shiva, situated at an altitude of 3,583 meters (11,755 ft) in the Garhwal Himalayas. It is one of the 12 Jyotirlingas and is part of the Char Dham Yatra. The temple, accessible only on foot or by helicopter, is surrounded by snow-capped peaks and is open only from May to November. The stone temple is believed to be over 1000 years old. The 2013 Kedarnath disaster caused severe damage to the region but the temple miraculously survived.";
      history = "The Kedarnath Temple is believed to have been built by the Pandavas to seek Lord Shiva's blessings. The current stone temple is attributed to Adi Shankaracharya who is said to have rebuilt it in the 8th century CE. After his death, the temple fell into disuse and was rediscovered and rebuilt. The area has immense spiritual significance — Adi Shankaracharya is said to have attained Mahasamadhi (conscious death) behind the temple at age 32. The devastating flash flood of June 2013 destroyed much of the surrounding area but the ancient temple structure survived, widely considered a miracle. The Narendra Modi government has since rebuilt the entire region.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/c/c3/Kedarnath_Temple%2C_Uttarakhand.jpg/1200px-Kedarnath_Temple%2C_Uttarakhand.jpg"];
      architectureStyle = "North Indian Nagara";
      darshanTimings = [
        { timingLabel = "Morning Darshan"; openTime = "06:00"; closeTime = "14:00"; breakStart = null; breakEnd = null },
        { timingLabel = "Evening Darshan"; openTime = "17:00"; closeTime = "21:00"; breakStart = null; breakEnd = null },
        { timingLabel = "Temple Open Season"; openTime = "May"; closeTime = "November"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Mahabhishek"; time = "04:00"; description = "Sacred bathing of the Jyotirlinga with milk, curd, honey, ghee, water — the most elaborate morning ritual"; isIncluded = false; price = ?1500 },
        { name = "Vidhi Puja"; time = "06:00"; description = "Regular morning pooja with chanting of Vedic mantras"; isIncluded = true; price = null },
        { name = "Rudra Abhishek"; time = "08:00"; description = "Abhishek performed with the chanting of Rudrashtadhyayi (108 names of Shiva)"; isIncluded = false; price = ?1100 },
        { name = "Laghu Rudra Abhishek"; time = "10:00"; description = "Shorter version of the Rudra Abhishek"; isIncluded = false; price = ?501 },
        { name = "Sandhya Aarti"; time = "19:30"; description = "Spectacular evening aarti performed amidst the Himalayan peaks"; isIncluded = true; price = null },
        { name = "Shayan Aarti"; time = "21:00"; description = "The bedtime ceremony — Shiva is symbolically put to sleep for the night"; isIncluded = true; price = null },
      ];
      specialDarshans = [
        { name = "Regular Darshan (Free)"; description = "Free darshan after registering — registration is required for Char Dham Yatra online or at the registration counters in Gaurikund/Sonprayag"; price = 0; availableDays = ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"] },
        { name = "VIP Darshan (Paid)"; description = "Faster queue entry with a paid ticket"; price = 400; availableDays = ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"] },
        { name = "Helicopter Darshan Package"; description = "Helicopter ride from Phata/Sersi/Guptkashi to Kedarnath Helipad, with priority darshan"; price = 7000; availableDays = ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"] },
      ];
      festivalCalendar = [
        { name = "Temple Opening (Akshaya Tritiya)"; date = "April/May"; significance = "The temple opens for the season with great celebrations; the exact date is announced by the head priest" },
        { name = "Maha Shivaratri"; date = "February/March (temple still closed)"; significance = "Celebrated with special poojas at lower Kedarnath temples (Ukhimath/Omkareshwar) since the main temple is closed in winter" },
        { name = "Temple Closing (Kartik Purnima)"; date = "October/November"; significance = "The temple closes for winter with elaborate closing ceremonies; the Panch Kedar priests move to Ukhimath for winter" },
        { name = "Shravan Month"; date = "July/August"; significance = "Every Monday in Shravan sees massive crowds undertaking the trek to Kedarnath" },
      ];
      donationOptions = [
        { donationType = "General Donation"; amount = 101; description = "Donation for daily rituals and temple maintenance via Badrinath Kedarnath Temple Committee (BKTC)" },
        { donationType = "Mahabhishek Sponsorship"; amount = 1500; description = "Sponsor the grand morning Mahabhishek of the Jyotirlinga" },
        { donationType = "Deepam Seva"; amount = 251; description = "Sponsor sacred lamps burning in the temple" },
        { donationType = "Annadanam"; amount = 1000; description = "Sponsoring food for pilgrims at the temple's Prasad counter" },
      ];
      contactInfo = { phone = ?"+91-1364-225850"; email = ?"bktc@nic.in"; website = ?"https://badrinath-kedarnath.gov.in" };
      nonHinduRestriction = false;
      averageVisitDuration = 8;
      tags = ["shaiva","uttarakhand","jyotirlinga","char dham","himalaya","kedarnath","pilgrimage","shiva","trek","high altitude"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(8, t8);

    // 9. Siddhivinayak Temple, Mumbai
    let t9 : TempleTypes.Temple = {
      id = 9;
      name = "Siddhivinayak Temple";
      deity = "Lord Ganesha (Siddhivinayak)";
      state = "Maharashtra";
      city = "Mumbai";
      district = "Mumbai";
      address = "S.K. Bole Road, Prabhadevi, Mumbai, Maharashtra 400028";
      description = "The Siddhivinayak Temple in Prabhadevi, Mumbai, is one of the most visited and richest temples in India. Dedicated to Lord Ganesha, it is believed to be the wish-fulfilling form of Ganesha (Siddhivinayak). The temple is particularly popular among Bollywood celebrities, politicians, and businesspeople seeking blessings. The original small temple was built in 1801 and has since been greatly expanded. The central idol of Ganesha here is unique — it has a trunk pointing to the right, which is considered rare and very auspicious.";
      history = "The Siddhivinayak Temple was originally built on November 19, 1801, by Deubai Patil and Laxman Vithu Patil. The original temple was a small structure. Over the centuries, it grew in importance and popularity. In 1990, a massive new temple was constructed around the original shrine. The temple is managed by the Shri Siddhivinayak Ganapati Temple Trust, a government-supported body. The temple has received donations from many notable personalities and is one of the wealthiest temples in Maharashtra.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/1/1c/Siddhivinayak_Temple_Mumbai.jpg/1200px-Siddhivinayak_Temple_Mumbai.jpg"];
      architectureStyle = "Modern (Nagara influenced)";
      darshanTimings = [
        { timingLabel = "Regular Darshan"; openTime = "05:30"; closeTime = "22:00"; breakStart = ?"12:00"; breakEnd = ?"16:00" },
        { timingLabel = "Tuesday Extended Hours"; openTime = "03:30"; closeTime = "22:00"; breakStart = ?"12:00"; breakEnd = ?"16:00" },
      ];
      poojaSchedule = [
        { name = "Kakad Aarti (Dawn Aarti)"; time = "05:30"; description = "The auspicious early morning aarti to awaken the Lord"; isIncluded = true; price = null },
        { name = "Abhishek"; time = "07:00"; description = "Ritual bathing of the idol with panchamrit, milk, and water"; isIncluded = false; price = ?500 },
        { name = "Panchopchar Pooja"; time = "09:00"; description = "The five-step morning worship with incense, flowers, lamp, naivedyam, and betel"; isIncluded = true; price = null },
        { name = "Naivedyam (Noon Offering)"; time = "12:00"; description = "Offering of modak, laddus, and other sweets to the Lord at noon"; isIncluded = true; price = null },
        { name = "Sandhya Aarti"; time = "18:30"; description = "Spectacular evening aarti with flames, bells, and conches"; isIncluded = true; price = null },
        { name = "Shej Aarti (Night Aarti)"; time = "21:30"; description = "The final aarti of the day — Lord Ganesha is put to rest"; isIncluded = true; price = null },
      ];
      specialDarshans = [
        { name = "General Darshan (Free)"; description = "Free darshan for all; online token system available to reduce wait time"; price = 0; availableDays = ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"] },
        { name = "Fast-Track Darshan (Paid)"; description = "Premium paid ticket for priority entry; available online and at the temple"; price = 200; availableDays = ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"] },
        { name = "Mangalvar (Tuesday) Special"; description = "Every Tuesday is especially auspicious for Ganesha — the temple is packed; extended special poojas and enhanced experience"; price = 0; availableDays = ["Tuesday"] },
      ];
      festivalCalendar = [
        { name = "Ganesh Chaturthi"; date = "August/September (10 days)"; significance = "The grandest festival — elaborate decorations, around-the-clock poojas, and immersion of idols on Anant Chaturdashi; lakhs visit" },
        { name = "Sankashti Chaturthi"; date = "Monthly (Krishna Chaturthi)"; significance = "A monthly festival; every Sankashti sees massive queues as devotees observe a fast and visit after moonrise" },
        { name = "Akshaya Tritiya"; date = "April/May"; significance = "Auspicious day for new beginnings; the temple receives a huge footfall of businesspeople seeking blessings" },
        { name = "Diwali"; date = "October/November"; significance = "Special extended poojas and elaborate decoration during the festival of lights" },
      ];
      donationOptions = [
        { donationType = "Hundi Donation"; amount = 100; description = "General donation to the Siddhivinayak Temple Trust" },
        { donationType = "Modak (Prasad) Seva"; amount = 251; description = "Sponsoring modak prasad distribution to devotees" },
        { donationType = "Gold/Silver Seva"; amount = 11000; description = "Donation of gold or silver for idol decoration or temple adornment" },
        { donationType = "Social Welfare (NGO)"; amount = 2000; description = "Donation to the temple trust's social welfare programs for education and healthcare" },
      ];
      contactInfo = { phone = ?"+91-22-24373626"; email = ?"ssgt@vsnl.net"; website = ?"https://www.siddhivinayak.org" };
      nonHinduRestriction = false;
      averageVisitDuration = 2;
      tags = ["ganesha","maharashtra","mumbai","prabhadevi","wish fulfilling","pilgrimage","bollywood","rich temple","vinayak"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(9, t9);

    // 10. Padmanabhaswamy Temple, Thiruvananthapuram
    let t10 : TempleTypes.Temple = {
      id = 10;
      name = "Padmanabhaswamy Temple";
      deity = "Lord Vishnu (Padmanabha)";
      state = "Kerala";
      city = "Thiruvananthapuram";
      district = "Thiruvananthapuram";
      address = "East Fort, Thiruvananthapuram, Kerala 695023";
      description = "The Padmanabhaswamy Temple is an ancient Hindu temple dedicated to Lord Vishnu, located in Thiruvananthapuram (Trivandrum), Kerala. Famous for being the world's wealthiest temple, with gold and jewels valued at over ₹1.2 lakh crore discovered in its vaults. The main deity, Padmanabha (Vishnu), is depicted in the Anantashayana posture — reclining on the cosmic serpent Adi Shesha. The temple can only be visited by Hindus wearing traditional attire.";
      history = "The Padmanabhaswamy Temple is one of the 108 Divya Desam temples (the most sacred Vaishnavite temples in India) and has a history of over 5,000 years according to traditional accounts. The current temple structure was built and renovated by the Travancore royal family. The famous vault discovery became public in 2011 when the Supreme Court of India ordered an inventory of the temple's underground vaults. Over a trillion rupees worth of gold, jewels, and artifacts were found. The temple is still managed by the erstwhile Travancore royal family under court supervision.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Padmanabhaswamy_Temple_Gopuram.jpg/1200px-Padmanabhaswamy_Temple_Gopuram.jpg"];
      architectureStyle = "Kerala (Dravidian-Kerala mixed)";
      darshanTimings = [
        { timingLabel = "Morning Session"; openTime = "06:30"; closeTime = "12:00"; breakStart = null; breakEnd = null },
        { timingLabel = "Evening Session"; openTime = "17:00"; closeTime = "19:30"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Nirmalya Darshan"; time = "03:30"; description = "Early morning darshan of the previous night's decorations before the new day's poojas begin"; isIncluded = false; price = ?500 },
        { name = "Thiruvanandal"; time = "06:30"; description = "Opening of the sanctum and first pooja of the day"; isIncluded = true; price = null },
        { name = "Uchha Puja"; time = "10:30"; description = "Important noon pooja with elaborate rituals and offerings"; isIncluded = true; price = null },
        { name = "Athazha Puja (Evening)"; time = "18:00"; description = "Evening pooja — considered the most auspicious time for darshan"; isIncluded = true; price = null },
        { name = "Triprayar (Night Puja)"; time = "19:00"; description = "Night closing ritual before the temple shuts"; isIncluded = true; price = null },
      ];
      specialDarshans = [
        { name = "General Darshan (Free — Hindus only)"; description = "Free darshan for Hindus; dress code strictly enforced — men must wear dhoti, women must wear traditional saree or churidar with dupatta"; price = 0; availableDays = ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"] },
        { name = "Murajapam (Special Rare Occasion)"; description = "A very rare 56-day sacred ritual conducted every 6 years; special darshan privileges for pilgrims during this period"; price = 0; availableDays = ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"] },
      ];
      festivalCalendar = [
        { name = "Alpashy (Lakshadeepam)"; date = "October/November"; significance = "Festival of a thousand lamps — the entire temple is lit with 100,000 lamps; one of the most spectacular sights in Kerala" },
        { name = "Navarathri (Karkidaka Vavu)"; date = "September/October (9 days)"; significance = "Grand 9-night celebration with special poojas, processions, and cultural programs" },
        { name = "Panguni Uthiram"; date = "March/April"; significance = "Celebration of Lord Vishnu's cosmic marriage; spectacular elephant processions and poojas" },
        { name = "Painkuni Festival"; date = "March/April (10 days)"; significance = "10-day grand festival with processions of the deity on decorated elephants through the city streets" },
        { name = "Onam"; date = "August/September"; significance = "Kerala's harvest festival — special poojas and cultural programs at the temple" },
      ];
      donationOptions = [
        { donationType = "General Donation (Hundi)"; amount = 100; description = "Donation to the Sree Padmanabhaswamy Temple Trust for temple maintenance and rituals" },
        { donationType = "Sahasrakalasabhishekam"; amount = 10000; description = "Sponsoring the grand Sahasrakalasabhishekam (bathing ritual with 1000 sacred pots)" },
        { donationType = "Annadanam"; amount = 5000; description = "Sponsoring free food for pilgrims at the temple's charitable kitchen" },
        { donationType = "Gold Ornament Offering"; amount = 50000; description = "Offering gold ornaments or jewelry to adorn the deity" },
      ];
      contactInfo = { phone = ?"+91-471-2450233"; email = ?"info@padmanabhaswamy.org"; website = ?"https://www.sreepadmanabhaswamytemple.org" };
      nonHinduRestriction = true;
      averageVisitDuration = 3;
      tags = ["vaishnava","kerala","divya desam","richest temple","vishnu","thiruvananthapuram","trivandrum","reclining vishnu","travancore"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(10, t10);

    // 11. Vaishno Devi Temple
    let t11 : TempleTypes.Temple = {
      id = 11;
      name = "Vaishno Devi Temple";
      deity = "Goddess Vaishno Devi (Durga/Shakti)";
      state = "Jammu & Kashmir";
      city = "Katra";
      district = "Reasi";
      address = "Bhawan, Trikuta Mountains, Katra, Jammu & Kashmir 182320";
      description = "The Vaishno Devi Temple is a Hindu temple dedicated to Goddess Vaishno Devi, a manifestation of the Divine Shakti. Located in the Trikuta Mountains at an altitude of 5,200 feet (1,585 m) near Katra in J&K, it is one of the holiest Hindu shrines in northern India. The shrine is a natural cave containing three rock formations (Pindis) representing Mahalakshmi, Mahasaraswati, and Mahakali. Over 8 million pilgrims visit annually, making it the second most visited shrine in India.";
      history = "According to Hindu mythology, the Goddess Vaishno Devi is an incarnation of Goddess Shakti. The shrine's existence is believed to date back thousands of years. The cave was rediscovered in the 1980s when a shrine was established. The Shri Mata Vaishno Devi Shrine Board was established in 1986 to manage the pilgrimage and temple affairs. The trek from Katra to the Bhawan (main shrine) covers 12–14 km and is accessible by foot, pony, or helicopter. RFID cards are mandatory for all pilgrims.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/4/4e/Vaishno_Devi_Shrine.jpg/1200px-Vaishno_Devi_Shrine.jpg"];
      architectureStyle = "Natural Cave Shrine";
      darshanTimings = [
        { timingLabel = "Open 24 Hours (365 Days)"; openTime = "00:00"; closeTime = "23:59"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Aarti (Bhawan)"; time = "05:00"; description = "Morning aarti at the Bhawan (main shrine complex) near the cave"; isIncluded = true; price = null },
        { name = "Sandhya Aarti"; time = "19:00"; description = "Evening aarti at the Bhawan"; isIncluded = true; price = null },
        { name = "Shayan Aarti"; time = "21:30"; description = "Night aarti before closing of the main Bhawan aarti hall"; isIncluded = true; price = null },
        { name = "Puja at Pindis (Cave)"; time = "All Day"; description = "Continuous puja at the three sacred Pindis (rock formations) inside the cave — the actual darshan"; isIncluded = true; price = null },
      ];
      specialDarshans = [
        { name = "Regular Yatra Darshan (Free)"; description = "Free darshan after registering with Shri Mata Vaishno Devi Shrine Board; RFID card mandatory; trek of 12–14 km from Katra"; price = 0; availableDays = ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"] },
        { name = "Priority Darshan (Paid)"; description = "Priority queue for faster darshan"; price = 500; availableDays = ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"] },
        { name = "Helicopter Service"; description = "Helicopter from Katra/Sanjichhat to Bhawan Helipad"; price = 3000; availableDays = ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"] },
      ];
      festivalCalendar = [
        { name = "Navratri (Chaitra)"; date = "March/April (9 days)"; significance = "Spring Navratri — one of the busiest periods; millions of pilgrims climb the trekking route; special events and extended hours" },
        { name = "Navratri (Ashwin/Sharad)"; date = "September/October (9 days)"; significance = "Autumn Navratri — the most crowded period; special lighting, cultural programs, and extended darshan hours" },
        { name = "Diwali"; date = "October/November"; significance = "Special illumination of the entire trekking route and Bhawan area" },
        { name = "Durga Ashtami"; date = "Twice a year (Navratri)"; significance = "The eighth day of Navratri — most auspicious for Goddess Durga worship; heaviest footfall" },
      ];
      donationOptions = [
        { donationType = "General Donation (Shrine Board)"; amount = 100; description = "Donation to Shri Mata Vaishno Devi Shrine Board for yatra infrastructure and maintenance" },
        { donationType = "Chunri (Sacred Cloth) Offering"; amount = 500; description = "Offering of sacred red chunri (cloth) to the Goddess as a mark of devotion" },
        { donationType = "Langar Seva"; amount = 1000; description = "Sponsoring free food (langar) for pilgrims at the various Bhandaras along the trekking route" },
        { donationType = "Infrastructure Development"; amount = 5000; description = "Contribution to the Shrine Board's infrastructure development for better yatra experience" },
      ];
      contactInfo = { phone = ?"+91-1991-232408"; email = ?"info@maavaishnodevi.org"; website = ?"https://www.maavaishnodevi.org" };
      nonHinduRestriction = false;
      averageVisitDuration = 24;
      tags = ["shakti","jammu kashmir","vaishno devi","cave shrine","pilgrimage","trek","navratri","goddess","devi","mountains"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(11, t11);

    // --- ANDHRA PRADESH (IDs 12-15) ---
    let t12 : TempleTypes.Temple = {
      id = 12;
      name = "Mallikarjuna Swamy Temple (Srisailam)";
      deity = "Lord Mallikarjuna (Shiva)";
      state = "Andhra Pradesh";
      city = "Srisailam";
      district = "Nandyal";
      address = "Srisailam, Nandyal District, Andhra Pradesh 518101";
      description = "One of the twelve Jyotirlingas, situated on the Nallamala hills on the banks of Krishna River.";
      history = "An ancient temple dating back to the 7th century with references in Mahabharata and Skanda Purana.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/a/a2/Srisailam_Mallikarjuna_Temple.jpg/800px-Srisailam_Mallikarjuna_Temple.jpg"];
      architectureStyle = "Dravidian";
      darshanTimings = [
        { timingLabel = "General Darshan"; openTime = "06:00"; closeTime = "21:00"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Morning Puja"; time = "06:00"; description = "Morning worship"; isIncluded = true; price = null },
        { name = "Evening Aarti"; time = "18:00"; description = "Evening aarti"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 51; description = "General donation at the temple." },
      ];
      contactInfo = { phone = ?"+91-8524-287766"; email = null; website = ?"https://www.srisailadevasthanam.org" };
      nonHinduRestriction = true;
      averageVisitDuration = 4;
      tags = ["jyotirlinga","shiva","andhra pradesh","nallamala","krishna river"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(12, t12);

    let t13 : TempleTypes.Temple = {
      id = 13;
      name = "Kanaka Durga Temple (Vijayawada)";
      deity = "Goddess Kanaka Durga";
      state = "Andhra Pradesh";
      city = "Vijayawada";
      district = "NTR";
      address = "Indrakeeladri Hill, Vijayawada, Andhra Pradesh 520002";
      description = "A powerful Shakti temple situated on Indrakeeladri Hill on the banks of River Krishna.";
      history = "One of the eighteen Shakti Peethas, the temple has been revered for over 2000 years.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/b/b3/Kanaka_Durga_Temple_Vijayawada.jpg/800px-Kanaka_Durga_Temple_Vijayawada.jpg"];
      architectureStyle = "Dravidian";
      darshanTimings = [
        { timingLabel = "General Darshan"; openTime = "05:00"; closeTime = "21:00"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Morning Puja"; time = "05:00"; description = "Morning worship"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 51; description = "General donation at the temple." },
      ];
      contactInfo = { phone = ?"+91-866-2570637"; email = null; website = null };
      nonHinduRestriction = false;
      averageVisitDuration = 3;
      tags = ["shakti peetha","durga","andhra pradesh","vijayawada","krishna river"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(13, t13);

    let t14 : TempleTypes.Temple = {
      id = 14;
      name = "Amaralingeswara Temple (Amaravathi)";
      deity = "Lord Amaralingeswara (Shiva)";
      state = "Andhra Pradesh";
      city = "Amaravathi";
      district = "Guntur";
      address = "Amaravathi, Guntur District, Andhra Pradesh 522020";
      description = "A Paadal Petra Sthalams temple at the site of the ancient Amaravati stupa on Krishna River.";
      history = "An ancient temple from the Satavahana period, mentioned in Rig Veda as one of the oldest Shiva temples.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/c/c5/Amareswara_Temple_Amaravathi.jpg/800px-Amareswara_Temple_Amaravathi.jpg"];
      architectureStyle = "Dravidian";
      darshanTimings = [
        { timingLabel = "General Darshan"; openTime = "06:00"; closeTime = "20:00"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Morning Puja"; time = "06:00"; description = "Morning worship"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 51; description = "General donation at the temple." },
      ];
      contactInfo = { phone = null; email = null; website = null };
      nonHinduRestriction = false;
      averageVisitDuration = 2;
      tags = ["shiva","andhra pradesh","amaravathi","guntur","krishna"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(14, t14);

    let t15 : TempleTypes.Temple = {
      id = 15;
      name = "Simhachalam Temple";
      deity = "Lord Varaha Narasimha";
      state = "Andhra Pradesh";
      city = "Visakhapatnam";
      district = "Visakhapatnam";
      address = "Simhachalam Hills, Visakhapatnam, Andhra Pradesh 530028";
      description = "Dedicated to Varaha Narasimha, built on a hilltop with stunning views of Visakhapatnam.";
      history = "Built in the 11th-12th century CE in the Kalinga style of architecture, a major Vaishnava pilgrimage site.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/d/d4/Simhachalam_Temple_Vizag.jpg/800px-Simhachalam_Temple_Vizag.jpg"];
      architectureStyle = "Kalinga";
      darshanTimings = [
        { timingLabel = "General Darshan"; openTime = "06:00"; closeTime = "21:00"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Morning Puja"; time = "06:00"; description = "Morning worship"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 51; description = "General donation at the temple." },
      ];
      contactInfo = { phone = ?"+91-891-2585100"; email = null; website = null };
      nonHinduRestriction = true;
      averageVisitDuration = 3;
      tags = ["vishnu","narasimha","andhra pradesh","visakhapatnam","kalinga"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(15, t15);

    // --- ARUNACHAL PRADESH (IDs 16-20) ---
    let t16 : TempleTypes.Temple = {
      id = 16;
      name = "Tawang Monastery";
      deity = "Lord Buddha (Avalokitesvara)";
      state = "Arunachal Pradesh";
      city = "Tawang";
      district = "Tawang";
      address = "Tawang Town, Tawang District, Arunachal Pradesh 790104";
      description = "The largest monastery in India and second largest in Asia, situated at 10,000 feet in the Himalayas.";
      history = "Founded in 1680-81 CE by Merak Lama Lodre Gyatso, it houses 400 monks and rare manuscripts.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Tawang_Monastery_Arunachal.jpg/800px-Tawang_Monastery_Arunachal.jpg"];
      architectureStyle = "Tibetan Buddhist";
      darshanTimings = [
        { timingLabel = "General Visit"; openTime = "09:00"; closeTime = "17:00"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Morning Prayer"; time = "07:00"; description = "Morning prayers by monks"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 51; description = "General donation at the monastery." },
      ];
      contactInfo = { phone = null; email = null; website = null };
      nonHinduRestriction = false;
      averageVisitDuration = 3;
      tags = ["buddhist","monastery","arunachal pradesh","tawang","himalaya"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(16, t16);

    let t17 : TempleTypes.Temple = {
      id = 17;
      name = "Malinithan Temple";
      deity = "Goddess Malini (Durga)";
      state = "Arunachal Pradesh";
      city = "Likabali";
      district = "Siang";
      address = "Likabali, Siang District, Arunachal Pradesh 791122";
      description = "An ancient Hindu temple and archaeological site on the bank of the Brahmaputra, with exquisite stone sculptures.";
      history = "Dates back to the 9th-14th century CE, associated with the Ahom kingdom, a significant archaeological site.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/f/f1/Malinithan_Temple_Arunachal.jpg/800px-Malinithan_Temple_Arunachal.jpg"];
      architectureStyle = "Nagara";
      darshanTimings = [
        { timingLabel = "General Darshan"; openTime = "06:00"; closeTime = "18:00"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Morning Puja"; time = "06:00"; description = "Morning worship"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 51; description = "General donation at the temple." },
      ];
      contactInfo = { phone = null; email = null; website = null };
      nonHinduRestriction = false;
      averageVisitDuration = 2;
      tags = ["shakti","arunachal pradesh","archaeological","brahmaputra","ancient"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(17, t17);

    let t18 : TempleTypes.Temple = {
      id = 18;
      name = "Ita Fort Temple (Itanagar)";
      deity = "Various Hindu Deities";
      state = "Arunachal Pradesh";
      city = "Itanagar";
      district = "Papum Pare";
      address = "Ita Fort, Itanagar, Arunachal Pradesh 791111";
      description = "An ancient brick fort temple from the 14th-15th century CE, a national heritage monument.";
      history = "Built by the Jitari dynasty around 1400 CE, the fort contains temple ruins and is considered sacred.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/a/a9/Ita_Fort_Itanagar.jpg/800px-Ita_Fort_Itanagar.jpg"];
      architectureStyle = "Brick fort temple";
      darshanTimings = [
        { timingLabel = "General Visit"; openTime = "09:00"; closeTime = "17:00"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Morning Puja"; time = "09:00"; description = "Morning worship"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 51; description = "General donation at the temple." },
      ];
      contactInfo = { phone = null; email = null; website = null };
      nonHinduRestriction = false;
      averageVisitDuration = 2;
      tags = ["arunachal pradesh","itanagar","fort","heritage","ancient"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(18, t18);

    let t19 : TempleTypes.Temple = {
      id = 19;
      name = "Parshuram Kund Temple";
      deity = "Sage Parshuram";
      state = "Arunachal Pradesh";
      city = "Lohit";
      district = "Lohit";
      address = "Lohit River, Lohit District, Arunachal Pradesh 792121";
      description = "A sacred pilgrimage site on the Lohit River where Parshuram is said to have washed away his sins.";
      history = "Mentioned in Hindu scriptures, thousands of pilgrims visit during Makar Sankranti for a holy dip.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/b/b6/Parsuram_Kund_Arunachal.jpg/800px-Parsuram_Kund_Arunachal.jpg"];
      architectureStyle = "Natural sacred site";
      darshanTimings = [
        { timingLabel = "General Visit"; openTime = "06:00"; closeTime = "18:00"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Morning Puja"; time = "06:00"; description = "Morning worship"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 51; description = "General donation at the temple." },
      ];
      contactInfo = { phone = null; email = null; website = null };
      nonHinduRestriction = false;
      averageVisitDuration = 2;
      tags = ["arunachal pradesh","pilgrimage","lohit","parshuram","makar sankranti"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(19, t19);

    let t20 : TempleTypes.Temple = {
      id = 20;
      name = "Ganga Lake Shongser Temple";
      deity = "Goddess Ganga";
      state = "Arunachal Pradesh";
      city = "Tawang";
      district = "Tawang";
      address = "Shongser Lake, Tawang, Arunachal Pradesh 790104";
      description = "A sacred lake temple at 12,000 feet altitude, revered by both Buddhists and Hindus.";
      history = "Associated with Buddhist legends and considered a sacred site where offerings are made at the lakeside.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/c/c7/Ganga_Lake_Tawang.jpg/800px-Ganga_Lake_Tawang.jpg"];
      architectureStyle = "Himalayan";
      darshanTimings = [
        { timingLabel = "General Visit"; openTime = "07:00"; closeTime = "18:00"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Morning Puja"; time = "07:00"; description = "Morning worship at the lake"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 51; description = "General donation at the temple." },
      ];
      contactInfo = { phone = null; email = null; website = null };
      nonHinduRestriction = false;
      averageVisitDuration = 2;
      tags = ["arunachal pradesh","tawang","lake","himalaya","sacred"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(20, t20);

    // --- ASSAM (IDs 21-25) ---
    let t21 : TempleTypes.Temple = {
      id = 21;
      name = "Kamakhya Temple (Guwahati)";
      deity = "Goddess Kamakhya (Shakti)";
      state = "Assam";
      city = "Guwahati";
      district = "Kamrup";
      address = "Nilachal Hill, Guwahati, Assam 781010";
      description = "One of the most powerful Shakti Peethas in India, dedicated to Goddess Kamakhya on Nilachal Hill.";
      history = "One of the 51 Shakti Peethas, the current temple was rebuilt in 1565 CE after destruction by Kala Pahar.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/d/d9/Kamakhya_Temple_Guwahati.jpg/800px-Kamakhya_Temple_Guwahati.jpg"];
      architectureStyle = "Nilachal (Assamese Tantric)";
      darshanTimings = [
        { timingLabel = "General Darshan"; openTime = "08:00"; closeTime = "13:00"; breakStart = ?"13:00"; breakEnd = ?"14:30" },
      ];
      poojaSchedule = [
        { name = "Morning Puja"; time = "08:00"; description = "Morning worship"; isIncluded = true; price = null },
        { name = "Evening Aarti"; time = "17:00"; description = "Evening aarti"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 51; description = "General donation at the temple." },
      ];
      contactInfo = { phone = ?"+91-361-2636256"; email = null; website = ?"https://www.kamakhyatemple.org" };
      nonHinduRestriction = false;
      averageVisitDuration = 3;
      tags = ["shakti peetha","assam","guwahati","kamakhya","tantric","ambubachi"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(21, t21);

    let t22 : TempleTypes.Temple = {
      id = 22;
      name = "Umananda Temple";
      deity = "Lord Shiva (Umananda)";
      state = "Assam";
      city = "Guwahati";
      district = "Kamrup";
      address = "Peacock Island, Brahmaputra River, Guwahati, Assam";
      description = "A Shiva temple on Peacock Island (Umananda Island) in the middle of Brahmaputra River.";
      history = "Built by Ahom king Gadadhar Singha in 1694 CE, accessible by ferry, surrounded by rare golden langurs.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/e/e2/Umananda_Temple_Assam.jpg/800px-Umananda_Temple_Assam.jpg"];
      architectureStyle = "Ahom";
      darshanTimings = [
        { timingLabel = "General Darshan"; openTime = "07:00"; closeTime = "17:00"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Morning Puja"; time = "07:00"; description = "Morning worship"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 51; description = "General donation at the temple." },
      ];
      contactInfo = { phone = null; email = null; website = null };
      nonHinduRestriction = false;
      averageVisitDuration = 3;
      tags = ["shiva","assam","guwahati","brahmaputra","island","ahom"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(22, t22);

    let t23 : TempleTypes.Temple = {
      id = 23;
      name = "Hayagriva Madhava Temple (Hajo)";
      deity = "Lord Hayagriva Madhava (Vishnu)";
      state = "Assam";
      city = "Hajo";
      district = "Kamrup";
      address = "Monikut Hill, Hajo, Assam 781102";
      description = "An ancient Vaishnava temple on Monikut Hill where Buddha is believed to have attained nirvana according to some traditions.";
      history = "An ancient temple sacred to both Hindus and Buddhists, dating back to the Gupta period.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/f/f3/Hayagriva_Madhava_Hajo.jpg/800px-Hayagriva_Madhava_Hajo.jpg"];
      architectureStyle = "Assamese";
      darshanTimings = [
        { timingLabel = "General Darshan"; openTime = "06:00"; closeTime = "18:00"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Morning Puja"; time = "06:00"; description = "Morning worship"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 51; description = "General donation at the temple." },
      ];
      contactInfo = { phone = null; email = null; website = null };
      nonHinduRestriction = false;
      averageVisitDuration = 2;
      tags = ["vishnu","assam","hajo","vaishnava","buddhist","ancient"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(23, t23);

    let t24 : TempleTypes.Temple = {
      id = 24;
      name = "Navagraha Temple (Guwahati)";
      deity = "Nine Planetary Deities (Navagraha)";
      state = "Assam";
      city = "Guwahati";
      district = "Kamrup";
      address = "Chitrachal Hill, Guwahati, Assam 781009";
      description = "A unique temple dedicated to the nine planetary deities (Navagraha) on Citrachal Hill.";
      history = "Built in the 18th century CE by the Ahom kings, an important center for astrological observations.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/a/a4/Navagraha_Temple_Guwahati.jpg/800px-Navagraha_Temple_Guwahati.jpg"];
      architectureStyle = "Ahom";
      darshanTimings = [
        { timingLabel = "General Darshan"; openTime = "06:00"; closeTime = "18:00"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Navagraha Puja"; time = "07:00"; description = "Planetary worship ceremony"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 51; description = "General donation at the temple." },
      ];
      contactInfo = { phone = null; email = null; website = null };
      nonHinduRestriction = false;
      averageVisitDuration = 2;
      tags = ["navagraha","assam","guwahati","planets","ahom","astrology"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(24, t24);

    let t25 : TempleTypes.Temple = {
      id = 25;
      name = "Madan Kamdev Temple (Baihata)";
      deity = "Lord Kamdev";
      state = "Assam";
      city = "Baihata Chariali";
      district = "Kamrup";
      address = "Baihata Chariali, Kamrup District, Assam";
      description = "An ancient temple complex known as the Khajuraho of the East, with erotic sculptures.";
      history = "Dates back to the 9th-11th century CE, the temple was built by the Pala dynasty of Assam.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/b/b5/Madan_Kamdev_Temple_Assam.jpg/800px-Madan_Kamdev_Temple_Assam.jpg"];
      architectureStyle = "Pala";
      darshanTimings = [
        { timingLabel = "General Visit"; openTime = "08:00"; closeTime = "17:00"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Morning Puja"; time = "08:00"; description = "Morning worship"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 51; description = "General donation at the temple." },
      ];
      contactInfo = { phone = null; email = null; website = null };
      nonHinduRestriction = false;
      averageVisitDuration = 2;
      tags = ["assam","kamdev","archaeological","pala","ancient","sculptures"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(25, t25);

    // --- BIHAR (IDs 26-30) ---
    let t26 : TempleTypes.Temple = {
      id = 26;
      name = "Mahabodhi Temple (Bodh Gaya)";
      deity = "Lord Buddha";
      state = "Bihar";
      city = "Bodh Gaya";
      district = "Gaya";
      address = "Bodh Gaya, Gaya District, Bihar 824231";
      description = "A UNESCO World Heritage Site and one of the most sacred Buddhist temples, marking where Buddha attained enlightenment.";
      history = "Originally built by Emperor Ashoka in the 3rd century BCE, the current temple dates to the 5th-6th century CE.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/5/55/Mahabodhi_Temple_Bodhgaya.jpg/800px-Mahabodhi_Temple_Bodhgaya.jpg"];
      architectureStyle = "Gupta";
      darshanTimings = [
        { timingLabel = "General Visit"; openTime = "05:00"; closeTime = "21:00"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Morning Prayer"; time = "05:00"; description = "Morning Buddhist prayers"; isIncluded = true; price = null },
        { name = "Evening Prayer"; time = "18:00"; description = "Evening Buddhist prayers"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 100; description = "General donation at the temple." },
      ];
      contactInfo = { phone = ?"+91-631-2200789"; email = null; website = ?"https://www.mahabodhi.com" };
      nonHinduRestriction = false;
      averageVisitDuration = 3;
      tags = ["buddhist","bihar","bodh gaya","unesco","ashoka","enlightenment","buddha"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(26, t26);

    let t27 : TempleTypes.Temple = {
      id = 27;
      name = "Vishnupad Temple (Gaya)";
      deity = "Lord Vishnu";
      state = "Bihar";
      city = "Gaya";
      district = "Gaya";
      address = "Falgu River Bank, Gaya, Bihar 823001";
      description = "Built around an ancient footprint of Lord Vishnu, a major Hindu pilgrimage center for Pind Daan rituals.";
      history = "Rebuilt by Queen Ahilyabai Holkar in 1787 CE on the bank of the Falgu River.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/c/c8/Vishnupad_Temple_Gaya.jpg/800px-Vishnupad_Temple_Gaya.jpg"];
      architectureStyle = "Nagara";
      darshanTimings = [
        { timingLabel = "General Darshan"; openTime = "05:00"; closeTime = "21:00"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Morning Puja"; time = "05:00"; description = "Morning worship"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 51; description = "General donation at the temple." },
      ];
      contactInfo = { phone = null; email = null; website = null };
      nonHinduRestriction = true;
      averageVisitDuration = 2;
      tags = ["vishnu","bihar","gaya","pind daan","pilgrimage","falgu"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(27, t27);

    let t28 : TempleTypes.Temple = {
      id = 28;
      name = "Mundeshwari Temple";
      deity = "Goddess Mundeshwari (Shakti)";
      state = "Bihar";
      city = "Ramgarh";
      district = "Kaimur";
      address = "Mundeshwari Hills, Kaimur District, Bihar 821110";
      description = "Considered the world's oldest functional Hindu temple, dating to 635 CE, dedicated to Shakti and Shiva.";
      history = "Dated by ASI to 635 CE based on an inscription, making it potentially the oldest operating Hindu temple.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/d/d0/Mundeshwari_Temple_Bihar.jpg/800px-Mundeshwari_Temple_Bihar.jpg"];
      architectureStyle = "Nagara (Early)";
      darshanTimings = [
        { timingLabel = "General Darshan"; openTime = "06:00"; closeTime = "18:00"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Morning Puja"; time = "06:00"; description = "Morning worship"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 51; description = "General donation at the temple." },
      ];
      contactInfo = { phone = null; email = null; website = null };
      nonHinduRestriction = false;
      averageVisitDuration = 2;
      tags = ["shakti","bihar","oldest temple","kaimur","shiva","ancient"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(28, t28);

    let t29 : TempleTypes.Temple = {
      id = 29;
      name = "Mandar Hill Temple";
      deity = "Lord Madhusudan (Vishnu)";
      state = "Bihar";
      city = "Banka";
      district = "Banka";
      address = "Mandar Hill, Banka District, Bihar 813104";
      description = "Sacred hill associated with the churning of the cosmic ocean (Samudra Manthan) in Hindu mythology.";
      history = "According to Puranas, Mount Mandar was used as the churning rod during Samudra Manthan, and carries footprints of Vishnu.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/e/e3/Mandar_Hill_Bihar.jpg/800px-Mandar_Hill_Bihar.jpg"];
      architectureStyle = "Rock cut";
      darshanTimings = [
        { timingLabel = "General Visit"; openTime = "06:00"; closeTime = "18:00"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Morning Puja"; time = "06:00"; description = "Morning worship"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 51; description = "General donation at the temple." },
      ];
      contactInfo = { phone = null; email = null; website = null };
      nonHinduRestriction = false;
      averageVisitDuration = 3;
      tags = ["vishnu","bihar","samudra manthan","pilgrimage","hill temple","mythological"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(29, t29);

    let t30 : TempleTypes.Temple = {
      id = 30;
      name = "Patan Devi Temple (Patna)";
      deity = "Goddess Patan Devi (Shakti)";
      state = "Bihar";
      city = "Patna";
      district = "Patna";
      address = "Patna City, Patna, Bihar 800008";
      description = "One of the Shakti Peethas of Patna, a major religious center for the city.";
      history = "An ancient temple in Patna City, believed to be one of the 51 Shakti Peethas.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/f/f5/Patan_Devi_Temple_Patna.jpg/800px-Patan_Devi_Temple_Patna.jpg"];
      architectureStyle = "North Indian";
      darshanTimings = [
        { timingLabel = "General Darshan"; openTime = "05:00"; closeTime = "21:00"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Morning Puja"; time = "05:00"; description = "Morning worship"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 51; description = "General donation at the temple." },
      ];
      contactInfo = { phone = null; email = null; website = null };
      nonHinduRestriction = false;
      averageVisitDuration = 2;
      tags = ["shakti peetha","bihar","patna","devi","pilgrimage"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(30, t30);

    // --- CHHATTISGARH (IDs 31-35) ---
    let t31 : TempleTypes.Temple = {
      id = 31;
      name = "Dongargarh Mata Temple (Bambleshwari)";
      deity = "Goddess Bambleshwari Mata";
      state = "Chhattisgarh";
      city = "Dongargarh";
      district = "Rajnandgaon";
      address = "Dongargarh Hill, Rajnandgaon, Chhattisgarh 491445";
      description = "A hilltop shrine dedicated to Bambleshwari Mata, accessible by ropeway, attracting millions during Navratri.";
      history = "The temple is believed to be over 2500 years old, with mythology connecting it to King Veer Singh of Kamarupa.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/a/a6/Dongargarh_Mata_Temple.jpg/800px-Dongargarh_Mata_Temple.jpg"];
      architectureStyle = "Hill Shrine";
      darshanTimings = [
        { timingLabel = "General Darshan"; openTime = "05:00"; closeTime = "22:00"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Morning Aarti"; time = "05:00"; description = "Morning aarti at the hilltop temple"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 51; description = "General donation at the temple." },
      ];
      contactInfo = { phone = null; email = null; website = null };
      nonHinduRestriction = false;
      averageVisitDuration = 3;
      tags = ["chhattisgarh","mata","navratri","hilltop","ropeway","shakti"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(31, t31);

    let t32 : TempleTypes.Temple = {
      id = 32;
      name = "Danteshwari Temple (Dantewada)";
      deity = "Goddess Danteshwari (Shakti)";
      state = "Chhattisgarh";
      city = "Dantewada";
      district = "Dantewada";
      address = "Dantewada, Chhattisgarh 494552";
      description = "One of the 52 Shakti Peethas, dedicated to Goddess Danteshwari, the patron deity of the Bastar region.";
      history = "An ancient temple where the Danta (tooth) of Goddess Sati is believed to have fallen, making it a Shakti Peetha.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/b/b8/Danteshwari_Temple_Dantewada.jpg/800px-Danteshwari_Temple_Dantewada.jpg"];
      architectureStyle = "Nagara";
      darshanTimings = [
        { timingLabel = "General Darshan"; openTime = "06:00"; closeTime = "20:00"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Morning Puja"; time = "06:00"; description = "Morning worship"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 51; description = "General donation at the temple." },
      ];
      contactInfo = { phone = null; email = null; website = null };
      nonHinduRestriction = false;
      averageVisitDuration = 2;
      tags = ["shakti peetha","chhattisgarh","bastar","danteshwari","ancient"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(32, t32);

    let t33 : TempleTypes.Temple = {
      id = 33;
      name = "Bhoramdeo Temple";
      deity = "Lord Shiva (Bhoramdeo)";
      state = "Chhattisgarh";
      city = "Kawardha";
      district = "Kabirdham";
      address = "Bhoramdeo, Kabirdham District, Chhattisgarh 491995";
      description = "Known as the Khajuraho of Chhattisgarh for its beautiful erotic sculptures and Nagara-style architecture.";
      history = "Built in the 10th-11th century CE by the Nagvanshi dynasty, featuring intricate sculptures similar to Khajuraho.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/c/c9/Bhoramdeo_Temple_Chhattisgarh.jpg/800px-Bhoramdeo_Temple_Chhattisgarh.jpg"];
      architectureStyle = "Nagara";
      darshanTimings = [
        { timingLabel = "General Visit"; openTime = "08:00"; closeTime = "18:00"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Morning Puja"; time = "08:00"; description = "Morning worship"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 51; description = "General donation at the temple." },
      ];
      contactInfo = { phone = null; email = null; website = null };
      nonHinduRestriction = false;
      averageVisitDuration = 3;
      tags = ["shiva","chhattisgarh","nagara","sculptures","ancient","heritage"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(33, t33);

    let t34 : TempleTypes.Temple = {
      id = 34;
      name = "Rajim Temple Complex (Rajivalochana)";
      deity = "Lord Rajivalochana (Vishnu)";
      state = "Chhattisgarh";
      city = "Rajim";
      district = "Gariaband";
      address = "Rajim, Gariaband District, Chhattisgarh 493885";
      description = "A pilgrimage center called the Prayag of Chhattisgarh, at the confluence of three rivers.";
      history = "The Rajivalochana temple dates to the 7th century CE, built during the Nala-Sarabhapuria period.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/d/d1/Rajim_Temple_Chhattisgarh.jpg/800px-Rajim_Temple_Chhattisgarh.jpg"];
      architectureStyle = "Nagara";
      darshanTimings = [
        { timingLabel = "General Darshan"; openTime = "06:00"; closeTime = "21:00"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Morning Puja"; time = "06:00"; description = "Morning worship"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 51; description = "General donation at the temple." },
      ];
      contactInfo = { phone = null; email = null; website = null };
      nonHinduRestriction = false;
      averageVisitDuration = 3;
      tags = ["vishnu","chhattisgarh","rajim","triveni sangam","pilgrimage"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(34, t34);

    let t35 : TempleTypes.Temple = {
      id = 35;
      name = "Chandrahasini Mata Temple";
      deity = "Goddess Chandrahasini Mata";
      state = "Chhattisgarh";
      city = "Chandrapur";
      district = "Janjgir-Champa";
      address = "Chandrapur, Janjgir-Champa, Chhattisgarh";
      description = "A temple of the smiling goddess, situated at the confluence of Mahanadi and Jonk rivers.";
      history = "An ancient temple at the Mahanadi river confluence, attracting large crowds during Navratri.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/e/e4/Chandrahasini_Temple_CG.jpg/800px-Chandrahasini_Temple_CG.jpg"];
      architectureStyle = "Chhattisgarhi";
      darshanTimings = [
        { timingLabel = "General Darshan"; openTime = "06:00"; closeTime = "21:00"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Morning Aarti"; time = "06:00"; description = "Morning aarti"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 51; description = "General donation at the temple." },
      ];
      contactInfo = { phone = null; email = null; website = null };
      nonHinduRestriction = false;
      averageVisitDuration = 2;
      tags = ["chhattisgarh","mata","navratri","mahanadi","pilgrimage"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(35, t35);

    // --- GOA (IDs 36-40) ---
    let t36 : TempleTypes.Temple = {
      id = 36;
      name = "Shri Mangueshi Temple (Ponda)";
      deity = "Lord Mangueshi (Shiva)";
      state = "Goa";
      city = "Ponda";
      district = "North Goa";
      address = "Priol, Ponda, North Goa 403401";
      description = "The richest and most famous temple in Goa, dedicated to Lord Mangueshi, a form of Shiva.";
      history = "Originally from Old Goa, the deity was moved here in the 17th century to protect from Portuguese rule.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/f/f6/Mangueshi_Temple_Goa.jpg/800px-Mangueshi_Temple_Goa.jpg"];
      architectureStyle = "Goan Hindu (Baroque influenced)";
      darshanTimings = [
        { timingLabel = "General Darshan"; openTime = "06:00"; closeTime = "21:30"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Morning Puja"; time = "06:00"; description = "Morning worship"; isIncluded = true; price = null },
        { name = "Evening Aarti"; time = "19:00"; description = "Evening aarti"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 51; description = "General donation at the temple." },
      ];
      contactInfo = { phone = ?"+91-832-2334236"; email = null; website = null };
      nonHinduRestriction = false;
      averageVisitDuration = 2;
      tags = ["shiva","goa","ponda","goan architecture","portuguese era"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(36, t36);

    let t37 : TempleTypes.Temple = {
      id = 37;
      name = "Shantadurga Temple (Kavlem)";
      deity = "Goddess Shantadurga";
      state = "Goa";
      city = "Kavlem";
      district = "South Goa";
      address = "Kavlem, Ponda, South Goa 403401";
      description = "One of the most important temples in Goa, Shantadurga is a form of Parvati who pacified Shiva and Vishnu.";
      history = "The deity was moved from Quelossim in the 17th century to escape Portuguese religious persecution.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/a/a1/Shantadurga_Temple_Goa.jpg/800px-Shantadurga_Temple_Goa.jpg"];
      architectureStyle = "Goan Hindu";
      darshanTimings = [
        { timingLabel = "General Darshan"; openTime = "06:00"; closeTime = "21:00"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Morning Puja"; time = "06:00"; description = "Morning worship"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 51; description = "General donation at the temple." },
      ];
      contactInfo = { phone = null; email = null; website = null };
      nonHinduRestriction = false;
      averageVisitDuration = 2;
      tags = ["shakti","goa","parvati","shantadurga","goan temples"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(37, t37);

    let t38 : TempleTypes.Temple = {
      id = 38;
      name = "Mahalasa Narayani Temple (Mardol)";
      deity = "Goddess Mahalasa (Mohini-Lakshmi)";
      state = "Goa";
      city = "Mardol";
      district = "North Goa";
      address = "Mardol, Ponda, North Goa 403404";
      description = "A unique temple dedicated to Mahalasa, considered a feminine form of Vishnu (Mohini) or Lakshmi.";
      history = "The idol was originally from Verna and was moved to Mardol in the 16th century to escape Portuguese destruction.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/b/b2/Mahalasa_Temple_Mardol_Goa.jpg/800px-Mahalasa_Temple_Mardol_Goa.jpg"];
      architectureStyle = "Goan Hindu";
      darshanTimings = [
        { timingLabel = "General Darshan"; openTime = "06:00"; closeTime = "21:00"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Morning Puja"; time = "06:00"; description = "Morning worship"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 51; description = "General donation at the temple." },
      ];
      contactInfo = { phone = null; email = null; website = null };
      nonHinduRestriction = false;
      averageVisitDuration = 2;
      tags = ["vishnu","goa","mahalasa","ponda","lakshmi","mohini"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(38, t38);

    let t39 : TempleTypes.Temple = {
      id = 39;
      name = "Tambdi Surla Mahadev Temple";
      deity = "Lord Mahadev (Shiva)";
      state = "Goa";
      city = "Bhagwan Mahaveer";
      district = "South Goa";
      address = "Tambdi Surla, Sanguem Taluka, South Goa 403704";
      description = "The oldest surviving temple in Goa, built in the Kadamba-Hemadpanthi style, deep in the Western Ghats.";
      history = "Built in the 12th century CE by the Kadamba dynasty, it is the only surviving example of Kadamba-Hemadpanthi style.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/d/d5/Tambdi_Surla_Temple_Goa.jpg/800px-Tambdi_Surla_Temple_Goa.jpg"];
      architectureStyle = "Kadamba-Hemadpanthi";
      darshanTimings = [
        { timingLabel = "General Visit"; openTime = "07:00"; closeTime = "18:00"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Morning Puja"; time = "07:00"; description = "Morning worship"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 51; description = "General donation at the temple." },
      ];
      contactInfo = { phone = null; email = null; website = null };
      nonHinduRestriction = false;
      averageVisitDuration = 3;
      tags = ["shiva","goa","ancient","kadamba","western ghats","heritage"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(39, t39);

    let t40 : TempleTypes.Temple = {
      id = 40;
      name = "Mahalaxmi Temple (Bandora)";
      deity = "Goddess Mahalaxmi";
      state = "Goa";
      city = "Bandora";
      district = "North Goa";
      address = "Bandora, Ponda, North Goa 403401";
      description = "One of Goa's most venerated temples dedicated to Goddess Mahalaxmi, goddess of wealth and prosperity.";
      history = "Dates to the 15th century, it survived the Portuguese inquisition and remains an important pilgrimage site.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/c/c3/Mahalaxmi_Temple_Bandora.jpg/800px-Mahalaxmi_Temple_Bandora.jpg"];
      architectureStyle = "Goan Hindu";
      darshanTimings = [
        { timingLabel = "General Darshan"; openTime = "06:00"; closeTime = "21:00"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Morning Puja"; time = "06:00"; description = "Morning worship"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 51; description = "General donation at the temple." },
      ];
      contactInfo = { phone = null; email = null; website = null };
      nonHinduRestriction = false;
      averageVisitDuration = 2;
      tags = ["lakshmi","goa","bandora","ponda","wealth","prosperity"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(40, t40);

    // --- GUJARAT (IDs 41-44) ---
    let t41 : TempleTypes.Temple = {
      id = 41;
      name = "Dwarkadheesh Temple (Dwarka)";
      deity = "Lord Dwarkadhish (Krishna)";
      state = "Gujarat";
      city = "Dwarka";
      district = "Devbhumi Dwarka";
      address = "Dwarka, Devbhumi Dwarka, Gujarat 361335";
      description = "One of the Char Dham pilgrimage sites and the legendary capital of Lord Krishna's kingdom.";
      history = "The original temple built by Krishna's grandson Vajranabha, rebuilt multiple times, current temple from 15th-16th century.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/e/e6/Dwarkadheesh_Temple_Dwarka.jpg/800px-Dwarkadheesh_Temple_Dwarka.jpg"];
      architectureStyle = "Nagara (Chalukya)";
      darshanTimings = [
        { timingLabel = "General Darshan"; openTime = "06:30"; closeTime = "21:30"; breakStart = ?"12:30"; breakEnd = ?"17:00" },
      ];
      poojaSchedule = [
        { name = "Mangala Aarti"; time = "06:30"; description = "Morning aarti"; isIncluded = true; price = null },
        { name = "Sandhya Aarti"; time = "19:30"; description = "Evening aarti"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 101; description = "General donation at the temple." },
      ];
      contactInfo = { phone = ?"+91-2892-234090"; email = null; website = null };
      nonHinduRestriction = true;
      averageVisitDuration = 4;
      tags = ["krishna","gujarat","char dham","dwarka","vaishnava","pilgrimage"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(41, t41);

    let t42 : TempleTypes.Temple = {
      id = 42;
      name = "Ambaji Temple (Banaskantha)";
      deity = "Goddess Ambaji (Amba Mata)";
      state = "Gujarat";
      city = "Ambaji";
      district = "Banaskantha";
      address = "Ambaji, Banaskantha District, Gujarat 385110";
      description = "One of the 51 Shakti Peethas, the temple has no idol but a sacred yantra is worshipped.";
      history = "One of the most important Shakti Peethas in Gujarat, the heart of Goddess Sati is believed to have fallen here.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/f/f8/Ambaji_Temple_Gujarat.jpg/800px-Ambaji_Temple_Gujarat.jpg"];
      architectureStyle = "Nagara";
      darshanTimings = [
        { timingLabel = "General Darshan"; openTime = "07:00"; closeTime = "21:30"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Morning Aarti"; time = "07:00"; description = "Morning aarti"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 51; description = "General donation at the temple." },
      ];
      contactInfo = { phone = ?"+91-2749-262009"; email = null; website = null };
      nonHinduRestriction = false;
      averageVisitDuration = 3;
      tags = ["shakti peetha","gujarat","ambaji","yantra","mata","navratri"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(42, t42);

    let t43 : TempleTypes.Temple = {
      id = 43;
      name = "Akshardham Temple (Gandhinagar)";
      deity = "Lord Swaminarayan";
      state = "Gujarat";
      city = "Gandhinagar";
      district = "Gandhinagar";
      address = "Gandhinagar, Gujarat 382016";
      description = "A magnificent Swaminarayan Hindu temple with intricate pink sandstone carvings and spiritual exhibitions.";
      history = "Built in 1992 by Pramukh Swami Maharaj, carved by 7000 craftsmen in pure pink Rajasthan sandstone.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/a/a3/Akshardham_Gandhinagar_Gujarat.jpg/800px-Akshardham_Gandhinagar_Gujarat.jpg"];
      architectureStyle = "Swaminarayan";
      darshanTimings = [
        { timingLabel = "General Darshan"; openTime = "09:30"; closeTime = "18:30"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Morning Aarti"; time = "09:30"; description = "Morning aarti"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 101; description = "General donation at the temple." },
      ];
      contactInfo = { phone = ?"+91-79-23214044"; email = null; website = ?"https://www.akshardham.com" };
      nonHinduRestriction = false;
      averageVisitDuration = 4;
      tags = ["swaminarayan","gujarat","gandhinagar","marble","modern","baps"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(43, t43);

    let t44 : TempleTypes.Temple = {
      id = 44;
      name = "Sun Temple (Modhera)";
      deity = "Lord Surya (Sun God)";
      state = "Gujarat";
      city = "Modhera";
      district = "Mehsana";
      address = "Modhera, Mehsana District, Gujarat 384212";
      description = "A stunning 11th-century sun temple with intricate carvings, built so the rising sun illuminates the inner sanctum.";
      history = "Built by Bhimdev I of the Chaulukya dynasty in 1026 CE, one of the finest examples of Solanki architecture.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/b/b4/Sun_Temple_Modhera_Gujarat.jpg/800px-Sun_Temple_Modhera_Gujarat.jpg"];
      architectureStyle = "Solanki (Maru-Gurjara)";
      darshanTimings = [
        { timingLabel = "General Visit"; openTime = "07:00"; closeTime = "18:00"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Morning Puja"; time = "07:00"; description = "Morning sun worship"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 51; description = "General donation at the temple." },
      ];
      contactInfo = { phone = null; email = null; website = null };
      nonHinduRestriction = false;
      averageVisitDuration = 3;
      tags = ["surya","gujarat","modhera","solanki","heritage","sun temple","archaeological"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(44, t44);

    // --- HARYANA (IDs 45-49) ---
    let t45 : TempleTypes.Temple = {
      id = 45;
      name = "Sthaneshwar Mahadev Temple (Kurukshetra)";
      deity = "Lord Shiva (Sthaneshwar)";
      state = "Haryana";
      city = "Kurukshetra";
      district = "Kurukshetra";
      address = "Sthanesar, Kurukshetra, Haryana 136118";
      description = "An ancient temple where the Pandavas are believed to have worshipped Shiva before the Mahabharata battle.";
      history = "One of the most sacred Shaiva sites in Haryana, mentioned in Mahabharata, where Pandavas received Shiva's blessings.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/c/c5/Sthaneshwar_Mahadev_Kurukshetra.jpg/800px-Sthaneshwar_Mahadev_Kurukshetra.jpg"];
      architectureStyle = "North Indian";
      darshanTimings = [
        { timingLabel = "General Darshan"; openTime = "05:00"; closeTime = "21:00"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Morning Puja"; time = "05:00"; description = "Morning worship"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 51; description = "General donation at the temple." },
      ];
      contactInfo = { phone = null; email = null; website = null };
      nonHinduRestriction = false;
      averageVisitDuration = 2;
      tags = ["shiva","haryana","kurukshetra","mahabharata","pandavas","pilgrimage"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(45, t45);

    let t46 : TempleTypes.Temple = {
      id = 46;
      name = "Mata Mansa Devi Temple (Panchkula)";
      deity = "Goddess Mansa Devi";
      state = "Haryana";
      city = "Panchkula";
      district = "Panchkula";
      address = "Bilaspur, Panchkula, Haryana 134109";
      description = "One of the most visited temples in Haryana, dedicated to Goddess Mansa Devi on the Shivalik foothills.";
      history = "An ancient Shakti temple associated with the Shakti Peethas tradition, major pilgrim center during Navratri.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/d/d6/Mansa_Devi_Temple_Panchkula.jpg/800px-Mansa_Devi_Temple_Panchkula.jpg"];
      architectureStyle = "North Indian";
      darshanTimings = [
        { timingLabel = "General Darshan"; openTime = "04:00"; closeTime = "22:00"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Morning Aarti"; time = "04:00"; description = "Morning aarti"; isIncluded = true; price = null },
        { name = "Evening Aarti"; time = "19:00"; description = "Evening aarti"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 51; description = "General donation at the temple." },
      ];
      contactInfo = { phone = ?"+91-172-2752174"; email = null; website = null };
      nonHinduRestriction = false;
      averageVisitDuration = 3;
      tags = ["shakti","haryana","panchkula","navratri","shivalik","mata"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(46, t46);

    let t47 : TempleTypes.Temple = {
      id = 47;
      name = "Brahma Sarovar Sannihit Sarovar Temple";
      deity = "Lord Brahma";
      state = "Haryana";
      city = "Kurukshetra";
      district = "Kurukshetra";
      address = "Brahma Sarovar, Kurukshetra, Haryana 136118";
      description = "The largest sarovar (tank) in India, believed to have been created by Brahma, sacred for solar eclipse rituals.";
      history = "Mentioned in the Mahabharata and associated with the solar eclipse rituals, the Sannihit Sarovar is equally sacred.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/e/e7/Brahma_Sarovar_Kurukshetra.jpg/800px-Brahma_Sarovar_Kurukshetra.jpg"];
      architectureStyle = "Sacred Lake Complex";
      darshanTimings = [
        { timingLabel = "General Visit"; openTime = "05:00"; closeTime = "21:00"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Morning Puja"; time = "05:00"; description = "Morning worship at the sacred tank"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 51; description = "General donation at the temple." },
      ];
      contactInfo = { phone = null; email = null; website = null };
      nonHinduRestriction = false;
      averageVisitDuration = 2;
      tags = ["brahma","haryana","kurukshetra","sarovar","solar eclipse","pilgrimage"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(47, t47);

    let t48 : TempleTypes.Temple = {
      id = 48;
      name = "Devi Talab Mandir (Panipat)";
      deity = "Goddess Devi";
      state = "Haryana";
      city = "Panipat";
      district = "Panipat";
      address = "Panipat, Haryana 132103";
      description = "A prominent temple on the banks of a sacred tank (talab), major pilgrimage center in Panipat.";
      history = "An ancient temple where the goddess is believed to have appeared to protect the city during its famous battles.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/f/f9/Devi_Talab_Panipat.jpg/800px-Devi_Talab_Panipat.jpg"];
      architectureStyle = "North Indian";
      darshanTimings = [
        { timingLabel = "General Darshan"; openTime = "05:00"; closeTime = "21:00"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Morning Puja"; time = "05:00"; description = "Morning worship"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 51; description = "General donation at the temple." },
      ];
      contactInfo = { phone = null; email = null; website = null };
      nonHinduRestriction = false;
      averageVisitDuration = 2;
      tags = ["shakti","haryana","panipat","devi","ancient","temple tank"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(48, t48);

    let t49 : TempleTypes.Temple = {
      id = 49;
      name = "Geeta Mandir (Kurukshetra)";
      deity = "Lord Krishna (Geeta teachings)";
      state = "Haryana";
      city = "Kurukshetra";
      district = "Kurukshetra";
      address = "Kurukshetra, Haryana 136118";
      description = "A temple dedicated to the Bhagavad Geeta, with walls inscribed with the complete Gita text.";
      history = "Built to commemorate the divine discourse of the Bhagavad Geeta delivered on the Kurukshetra battlefield.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/a/a5/Geeta_Mandir_Kurukshetra.jpg/800px-Geeta_Mandir_Kurukshetra.jpg"];
      architectureStyle = "Modern North Indian";
      darshanTimings = [
        { timingLabel = "General Darshan"; openTime = "06:00"; closeTime = "21:00"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Morning Puja"; time = "06:00"; description = "Morning worship"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 51; description = "General donation at the temple." },
      ];
      contactInfo = { phone = null; email = null; website = null };
      nonHinduRestriction = false;
      averageVisitDuration = 2;
      tags = ["krishna","haryana","kurukshetra","bhagavad gita","mahabharata","modern"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(49, t49);

    // --- HIMACHAL PRADESH (ID 50) ---
    let t50 : TempleTypes.Temple = {
      id = 50;
      name = "Hidimba Devi Temple (Manali)";
      deity = "Goddess Hidimba Devi";
      state = "Himachal Pradesh";
      city = "Manali";
      district = "Kullu";
      address = "Dhungri Village, Manali, Himachal Pradesh 175131";
      description = "A unique temple built over a sacred rock where Hidimba Devi meditated, surrounded by cedar forests.";
      history = "Built in 1553 CE by Maharaja Bahadur Singh, dedicated to Hidimba, wife of Bhima from the Mahabharata.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/b/b6/Hidimba_Devi_Temple_Manali.jpg/800px-Hidimba_Devi_Temple_Manali.jpg"];
      architectureStyle = "Pagoda (Himachali)";
      darshanTimings = [
        { timingLabel = "General Darshan"; openTime = "08:00"; closeTime = "18:00"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Morning Puja"; time = "08:00"; description = "Morning worship"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 51; description = "General donation at the temple." },
      ];
      contactInfo = { phone = null; email = null; website = null };
      nonHinduRestriction = false;
      averageVisitDuration = 2;
      tags = ["himachal pradesh","manali","devi","mahabharata","pagoda","cedar forest"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(50, t50);

    // --- HIMACHAL PRADESH (IDs 51-54) ---
    let t51 : TempleTypes.Temple = {
      id = 51;
      name = "Jwala Ji Temple (Jawalamukhi)";
      deity = "Goddess Jwala Ji (Flaming Devi)";
      state = "Himachal Pradesh";
      city = "Jawalamukhi";
      district = "Kangra";
      address = "Jawalamukhi, Kangra District, Himachal Pradesh 176031";
      description = "One of the 51 Shakti Peethas where natural gas flames are worshipped as manifestations of the goddess.";
      history = "An ancient Shakti Peetha where 9 eternal flames burn naturally from the earth, first mentioned by the Pandavas.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/c/c7/Jwala_Ji_Temple_Kangra.jpg/800px-Jwala_Ji_Temple_Kangra.jpg"];
      architectureStyle = "Himachali";
      darshanTimings = [
        { timingLabel = "General Darshan"; openTime = "05:00"; closeTime = "21:00"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Morning Aarti"; time = "05:00"; description = "Morning fire worship"; isIncluded = true; price = null },
        { name = "Evening Aarti"; time = "19:00"; description = "Evening fire worship"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 51; description = "General donation at the temple." },
      ];
      contactInfo = { phone = null; email = null; website = null };
      nonHinduRestriction = false;
      averageVisitDuration = 3;
      tags = ["shakti peetha","himachal pradesh","kangra","natural flame","jyota"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(51, t51);

    let t52 : TempleTypes.Temple = {
      id = 52;
      name = "Bajreshwari Mata Temple (Kangra)";
      deity = "Goddess Bajreshwari Mata";
      state = "Himachal Pradesh";
      city = "Kangra";
      district = "Kangra";
      address = "Kangra Town, Kangra District, Himachal Pradesh 176001";
      description = "One of the 51 Shakti Peethas in the ancient town of Kangra, rebuilt after the 1905 Kangra earthquake.";
      history = "An ancient Shakti Peetha temple, destroyed and plundered multiple times, rebuilt in early 20th century.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/d/d8/Bajreshwari_Temple_Kangra.jpg/800px-Bajreshwari_Temple_Kangra.jpg"];
      architectureStyle = "Himachali";
      darshanTimings = [
        { timingLabel = "General Darshan"; openTime = "06:00"; closeTime = "21:00"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Morning Puja"; time = "06:00"; description = "Morning worship"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 51; description = "General donation at the temple." },
      ];
      contactInfo = { phone = null; email = null; website = null };
      nonHinduRestriction = false;
      averageVisitDuration = 2;
      tags = ["shakti peetha","himachal pradesh","kangra","mata","devi"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(52, t52);

    let t53 : TempleTypes.Temple = {
      id = 53;
      name = "Chamunda Devi Temple (Palampur)";
      deity = "Goddess Chamunda Devi";
      state = "Himachal Pradesh";
      city = "Palampur";
      district = "Kangra";
      address = "Chamunda Nandikeshwar Dham, Palampur, Himachal Pradesh";
      description = "A powerful Shakti temple on the banks of the Ban Ganga River, surrounded by Dhauladhar mountains.";
      history = "An ancient temple where Chamunda (a form of Durga who killed demons Chanda and Munda) is worshipped.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/e/e9/Chamunda_Devi_Temple_HP.jpg/800px-Chamunda_Devi_Temple_HP.jpg"];
      architectureStyle = "Himachali Pagoda";
      darshanTimings = [
        { timingLabel = "General Darshan"; openTime = "06:00"; closeTime = "21:00"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Morning Puja"; time = "06:00"; description = "Morning worship"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 51; description = "General donation at the temple." },
      ];
      contactInfo = { phone = null; email = null; website = null };
      nonHinduRestriction = false;
      averageVisitDuration = 2;
      tags = ["shakti","himachal pradesh","chamunda","kangra","dhauladhar"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(53, t53);

    let t54 : TempleTypes.Temple = {
      id = 54;
      name = "Jakhu Temple (Shimla)";
      deity = "Lord Hanuman";
      state = "Himachal Pradesh";
      city = "Shimla";
      district = "Shimla";
      address = "Jakhu Hill, Shimla, Himachal Pradesh 171001";
      description = "The highest temple in Shimla at 8048 feet, topped by a 108-foot Hanuman statue visible from the city.";
      history = "Believed to be the spot where Hanuman rested while searching for Sanjeevani herb to revive Lakshmana.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/f/f0/Jakhu_Temple_Shimla.jpg/800px-Jakhu_Temple_Shimla.jpg"];
      architectureStyle = "Himachali";
      darshanTimings = [
        { timingLabel = "General Darshan"; openTime = "07:00"; closeTime = "19:00"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Morning Puja"; time = "07:00"; description = "Morning worship"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 51; description = "General donation at the temple." },
      ];
      contactInfo = { phone = null; email = null; website = null };
      nonHinduRestriction = false;
      averageVisitDuration = 2;
      tags = ["hanuman","himachal pradesh","shimla","hilltop","mahabharata"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(54, t54);

    // --- JHARKHAND (IDs 55-59) ---
    let t55 : TempleTypes.Temple = {
      id = 55;
      name = "Baidyanath Temple (Deoghar)";
      deity = "Lord Baidyanath (Shiva)";
      state = "Jharkhand";
      city = "Deoghar";
      district = "Deoghar";
      address = "Deoghar, Jharkhand 814112";
      description = "One of the twelve Jyotirlingas, also one of the 51 Shakti Peethas, making it uniquely double-sacred.";
      history = "According to legend, Ravana placed his ten heads as offerings to get boons from Shiva here, and Shiva appeared as Baidyanath.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/a/a7/Baidyanath_Temple_Deoghar.jpg/800px-Baidyanath_Temple_Deoghar.jpg"];
      architectureStyle = "Nagara";
      darshanTimings = [
        { timingLabel = "General Darshan"; openTime = "04:00"; closeTime = "21:30"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Morning Aarti"; time = "04:00"; description = "Early morning aarti"; isIncluded = true; price = null },
        { name = "Evening Aarti"; time = "19:00"; description = "Evening aarti"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 101; description = "General donation at the temple." },
      ];
      contactInfo = { phone = ?"+91-6432-222369"; email = null; website = null };
      nonHinduRestriction = false;
      averageVisitDuration = 4;
      tags = ["jyotirlinga","shakti peetha","jharkhand","shiva","deoghar","ravana","shravan"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(55, t55);

    let t56 : TempleTypes.Temple = {
      id = 56;
      name = "Rajrappa Chinnamasta Temple";
      deity = "Goddess Chinnamasta (Shakti)";
      state = "Jharkhand";
      city = "Ramgarh";
      district = "Ramgarh";
      address = "Rajrappa, Ramgarh District, Jharkhand 829122";
      description = "A major Shakti temple at the confluence of Damodar and Bhairavi rivers, depicting the headless form of Shakti.";
      history = "One of the 52 Shakti Peethas, the temple is visited by over a million pilgrims during Navratri.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/b/b8/Rajrappa_Temple_Jharkhand.jpg/800px-Rajrappa_Temple_Jharkhand.jpg"];
      architectureStyle = "Nagara";
      darshanTimings = [
        { timingLabel = "General Darshan"; openTime = "05:00"; closeTime = "20:00"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Morning Puja"; time = "05:00"; description = "Morning worship"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 51; description = "General donation at the temple." },
      ];
      contactInfo = { phone = null; email = null; website = null };
      nonHinduRestriction = false;
      averageVisitDuration = 3;
      tags = ["shakti peetha","jharkhand","chinnamasta","ramgarh","damodar","navratri"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(56, t56);

    let t57 : TempleTypes.Temple = {
      id = 57;
      name = "Pahari Mandir (Ranchi)";
      deity = "Lord Shiva";
      state = "Jharkhand";
      city = "Ranchi";
      district = "Ranchi";
      address = "Pahari Mandir Road, Ranchi, Jharkhand 834001";
      description = "Ranchi's most famous temple perched on a hilltop, accessible via 468 steps with panoramic city views.";
      history = "A prominent Shiva temple that has stood atop the Ranchi hill for over 300 years, central to city's spiritual life.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/c/c9/Pahari_Mandir_Ranchi.jpg/800px-Pahari_Mandir_Ranchi.jpg"];
      architectureStyle = "Nagara";
      darshanTimings = [
        { timingLabel = "General Darshan"; openTime = "06:00"; closeTime = "20:00"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Morning Puja"; time = "06:00"; description = "Morning worship"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 51; description = "General donation at the temple." },
      ];
      contactInfo = { phone = null; email = null; website = null };
      nonHinduRestriction = false;
      averageVisitDuration = 2;
      tags = ["shiva","jharkhand","ranchi","hilltop","city views","pilgrimage"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(57, t57);

    let t58 : TempleTypes.Temple = {
      id = 58;
      name = "Parasnath Hill Jain Temples";
      deity = "Jain Tirthankaras (Parasnath)";
      state = "Jharkhand";
      city = "Giridih";
      district = "Giridih";
      address = "Parasnath Hill, Giridih, Jharkhand 825401";
      description = "The highest peak in Jharkhand with 24 Jain temples, a major pilgrimage site for Jains.";
      history = "Considered sacred as 20 of 24 Jain Tirthankaras attained moksha here; pilgrims trek 27km circuit around the hill.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/d/d0/Parasnath_Hill_Jharkhand.jpg/800px-Parasnath_Hill_Jharkhand.jpg"];
      architectureStyle = "Jain";
      darshanTimings = [
        { timingLabel = "General Darshan"; openTime = "05:00"; closeTime = "18:00"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Morning Puja"; time = "05:00"; description = "Morning Jain prayer"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 101; description = "General donation at the temple." },
      ];
      contactInfo = { phone = null; email = null; website = null };
      nonHinduRestriction = false;
      averageVisitDuration = 6;
      tags = ["jain","jharkhand","giridih","parasnath","pilgrimage","trek","tirthankaras"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(58, t58);

    let t59 : TempleTypes.Temple = {
      id = 59;
      name = "Jagannath Temple (Ranchi)";
      deity = "Lord Jagannath";
      state = "Jharkhand";
      city = "Ranchi";
      district = "Ranchi";
      address = "Jagannathpur, Ranchi, Jharkhand 834001";
      description = "A replica of the famous Puri Jagannath Temple, built in 1691 CE, hosts Jharkhand's biggest Rath Yatra.";
      history = "Built in 1691 CE by Thakur Ani Nath Shahdeo of Ranchi, it is famous for its grand Rath Yatra chariot festival.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/e/e1/Jagannath_Temple_Ranchi.jpg/800px-Jagannath_Temple_Ranchi.jpg"];
      architectureStyle = "Kalinga";
      darshanTimings = [
        { timingLabel = "General Darshan"; openTime = "06:00"; closeTime = "21:00"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Morning Puja"; time = "06:00"; description = "Morning worship"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 51; description = "General donation at the temple." },
      ];
      contactInfo = { phone = null; email = null; website = null };
      nonHinduRestriction = false;
      averageVisitDuration = 2;
      tags = ["jagannath","jharkhand","ranchi","rath yatra","vaishnava","kalinga"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(59, t59);

    // --- KARNATAKA (IDs 60-64) ---
    let t60 : TempleTypes.Temple = {
      id = 60;
      name = "Virupaksha Temple (Hampi)";
      deity = "Lord Virupaksha (Shiva)";
      state = "Karnataka";
      city = "Hampi";
      district = "Vijayanagara";
      address = "Hampi, Vijayanagara District, Karnataka 583239";
      description = "A UNESCO World Heritage Site temple at Hampi, continuously worshipped for over 1500 years.";
      history = "One of the oldest functioning temples in India, dating to the 7th century, expanded greatly by the Vijayanagara kings.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/e/e7/Virupaksha_Temple_Hampi_Karnataka.jpg/800px-Virupaksha_Temple_Hampi_Karnataka.jpg"];
      architectureStyle = "Vijayanagara (Dravidian)";
      darshanTimings = [
        { timingLabel = "General Darshan"; openTime = "06:00"; closeTime = "21:00"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Morning Puja"; time = "06:00"; description = "Morning worship"; isIncluded = true; price = null },
        { name = "Evening Aarti"; time = "18:30"; description = "Evening aarti"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 51; description = "General donation at the temple." },
      ];
      contactInfo = { phone = ?"+91-8394-241239"; email = null; website = null };
      nonHinduRestriction = false;
      averageVisitDuration = 4;
      tags = ["shiva","karnataka","hampi","unesco","vijayanagara","heritage"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(60, t60);

    let t61 : TempleTypes.Temple = {
      id = 61;
      name = "Udupi Sri Krishna Matha";
      deity = "Lord Sri Krishna";
      state = "Karnataka";
      city = "Udupi";
      district = "Udupi";
      address = "Car Street, Udupi, Karnataka 576101";
      description = "A famous Vaishnava temple and pilgrimage center established by philosopher-saint Sri Madhvacharya.";
      history = "Founded by Madhvacharya in the 13th century CE, the Udupi paryaya system of priest rotation continues today.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/f/f2/Udupi_Krishna_Matha.jpg/800px-Udupi_Krishna_Matha.jpg"];
      architectureStyle = "Tulu Nadu (Dravidian)";
      darshanTimings = [
        { timingLabel = "General Darshan"; openTime = "05:30"; closeTime = "20:30"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Morning Puja"; time = "05:30"; description = "Morning worship"; isIncluded = true; price = null },
        { name = "Madhyanna Puja"; time = "12:00"; description = "Noon worship"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 51; description = "General donation at the temple." },
      ];
      contactInfo = { phone = ?"+91-820-2529091"; email = null; website = ?"https://www.udupikrishnamatha.org" };
      nonHinduRestriction = false;
      averageVisitDuration = 3;
      tags = ["krishna","karnataka","udupi","madhvacharya","vaishnava","matha"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(61, t61);

    let t62 : TempleTypes.Temple = {
      id = 62;
      name = "Chamundeshwari Temple (Mysuru)";
      deity = "Goddess Chamundeshwari (Durga)";
      state = "Karnataka";
      city = "Mysuru";
      district = "Mysuru";
      address = "Chamundi Hill, Mysuru, Karnataka 570010";
      description = "Perched atop Chamundi Hills at 3489 feet, this temple to the patron goddess of Mysore is reached via 1000 steps.";
      history = "The temple dates back to the 12th century CE and was expanded by the Wodeyar kings of Mysore.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/a/a8/Chamundeshwari_Temple_Mysore.jpg/800px-Chamundeshwari_Temple_Mysore.jpg"];
      architectureStyle = "Hoysala-Dravidian";
      darshanTimings = [
        { timingLabel = "General Darshan"; openTime = "07:30"; closeTime = "20:30"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Morning Puja"; time = "07:30"; description = "Morning worship"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 51; description = "General donation at the temple." },
      ];
      contactInfo = { phone = ?"+91-821-2442398"; email = null; website = null };
      nonHinduRestriction = false;
      averageVisitDuration = 3;
      tags = ["shakti","karnataka","mysuru","chamundi","dasara","wodeyar"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(62, t62);

    let t63 : TempleTypes.Temple = {
      id = 63;
      name = "Dharmasthala Temple (Sri Manjunatha)";
      deity = "Lord Sri Manjunatha (Shiva)";
      state = "Karnataka";
      city = "Dharmasthala";
      district = "Dakshina Kannada";
      address = "Dharmasthala, Dakshina Kannada, Karnataka 574216";
      description = "A unique temple managed by a Jain family yet dedicated to Lord Shiva, famous for massive free food service.";
      history = "The temple tradition was established in the 16th century CE by the Heggade family, who manage it to this day.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/b/b9/Dharmasthala_Temple_Karnataka.jpg/800px-Dharmasthala_Temple_Karnataka.jpg"];
      architectureStyle = "Kerala-Tulu Nadu (Dravidian)";
      darshanTimings = [
        { timingLabel = "General Darshan"; openTime = "06:30"; closeTime = "21:00"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Morning Puja"; time = "06:30"; description = "Morning worship"; isIncluded = true; price = null },
        { name = "Evening Puja"; time = "18:00"; description = "Evening worship"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "Annadana"; amount = 501; description = "Contribution to free food service." },
      ];
      contactInfo = { phone = ?"+91-8256-277022"; email = null; website = ?"https://dharmasthala.in" };
      nonHinduRestriction = false;
      averageVisitDuration = 4;
      tags = ["shiva","karnataka","dharmasthala","jain","free food","annadana","mangalore"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(63, t63);

    let t64 : TempleTypes.Temple = {
      id = 64;
      name = "Kukke Subramanya Temple";
      deity = "Lord Subramanya (Kumara/Murugan)";
      state = "Karnataka";
      city = "Subramanya";
      district = "Dakshina Kannada";
      address = "Subramanya, Dakshina Kannada, Karnataka 574238";
      description = "A famous snake temple dedicated to Subramanya, believed to cure skin diseases and Sarpa Dosha.";
      history = "Located at the foot of the Western Ghats, the temple was established by Veda Vyasa according to the Skanda Purana.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/c/c0/Kukke_Subramanya_Temple_Karnataka.jpg/800px-Kukke_Subramanya_Temple_Karnataka.jpg"];
      architectureStyle = "Kerala-Tulu Nadu (Dravidian)";
      darshanTimings = [
        { timingLabel = "General Darshan"; openTime = "06:00"; closeTime = "20:30"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Morning Puja"; time = "06:00"; description = "Morning worship"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 51; description = "General donation at the temple." },
      ];
      contactInfo = { phone = ?"+91-8257-258714"; email = null; website = null };
      nonHinduRestriction = false;
      averageVisitDuration = 3;
      tags = ["murugan","karnataka","snake temple","sarpa dosha","western ghats","dakshina kannada"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(64, t64);

    // --- KERALA (IDs 65-68) ---
    let t65 : TempleTypes.Temple = {
      id = 65;
      name = "Sabarimala Ayyappa Temple";
      deity = "Lord Ayyappa";
      state = "Kerala";
      city = "Pathanamthitta";
      district = "Pathanamthitta";
      address = "Sabarimala, Pathanamthitta, Kerala 689627";
      description = "The world's second largest pilgrimage after Mecca, visited by 30-50 million devotees annually.";
      history = "An ancient temple accessible only on foot through forests, open mainly during Mandalam and Makaravilakku seasons.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/d/d1/Sabarimala_Temple_Kerala.jpg/800px-Sabarimala_Temple_Kerala.jpg"];
      architectureStyle = "Kerala";
      darshanTimings = [
        { timingLabel = "Pilgrimage Season"; openTime = "05:00"; closeTime = "22:00"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Morning Puja"; time = "05:00"; description = "Morning worship during season"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 101; description = "General donation at the temple." },
      ];
      contactInfo = { phone = null; email = null; website = ?"https://sabarimala.kerala.gov.in" };
      nonHinduRestriction = true;
      averageVisitDuration = 6;
      tags = ["ayyappa","kerala","pilgrimage","forest","mandalam","makaravilakku","celibacy"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(65, t65);

    let t66 : TempleTypes.Temple = {
      id = 66;
      name = "Guruvayur Sree Krishna Temple";
      deity = "Lord Guruvayurappan (Krishna)";
      state = "Kerala";
      city = "Guruvayur";
      district = "Thrissur";
      address = "Temple Road, Guruvayur, Thrissur, Kerala 680101";
      description = "Known as Dwarka of the South, one of the most important Vaishnava pilgrimage centers in India.";
      history = "According to legend, Guru (Brihaspati) and Vayu consecrated the idol brought by Vasudeva (Krishna's father) here.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/e/e2/Guruvayur_Temple_Kerala.jpg/800px-Guruvayur_Temple_Kerala.jpg"];
      architectureStyle = "Kerala";
      darshanTimings = [
        { timingLabel = "General Darshan"; openTime = "03:00"; closeTime = "21:30"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Nirmalya Darshan"; time = "03:00"; description = "Early morning viewing"; isIncluded = true; price = null },
        { name = "Athazha Puja"; time = "20:30"; description = "Night worship"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 101; description = "General donation at the temple." },
      ];
      contactInfo = { phone = ?"+91-487-2556334"; email = null; website = ?"https://guruvayurtemple.in" };
      nonHinduRestriction = true;
      averageVisitDuration = 4;
      tags = ["krishna","kerala","guruvayur","vaishnava","thrissur","elephant"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(66, t66);

    let t67 : TempleTypes.Temple = {
      id = 67;
      name = "Ettumanoor Mahadeva Temple";
      deity = "Lord Mahadeva (Shiva)";
      state = "Kerala";
      city = "Ettumanoor";
      district = "Kottayam";
      address = "Ettumanoor, Kottayam, Kerala 686631";
      description = "A rich and ancient Shiva temple famous for its golden flagpole and elaborate Ezharaponnana (7.5 golden elephants).";
      history = "One of the oldest temples in Kerala, the presiding deity Shiva is in the form of a lingam and considered highly powerful.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/f/f3/Ettumanoor_Temple_Kerala.jpg/800px-Ettumanoor_Temple_Kerala.jpg"];
      architectureStyle = "Kerala";
      darshanTimings = [
        { timingLabel = "General Darshan"; openTime = "05:00"; closeTime = "20:00"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Morning Puja"; time = "05:00"; description = "Morning worship"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 51; description = "General donation at the temple." },
      ];
      contactInfo = { phone = ?"+91-481-2537200"; email = null; website = null };
      nonHinduRestriction = true;
      averageVisitDuration = 3;
      tags = ["shiva","kerala","kottayam","golden elephant","ettumanoor","ezharaponnana"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(67, t67);

    let t68 : TempleTypes.Temple = {
      id = 68;
      name = "Chottanikkara Bhagavathy Temple";
      deity = "Goddess Chottanikkara Amma (Bhagavathy)";
      state = "Kerala";
      city = "Chottanikkara";
      district = "Ernakulam";
      address = "Chottanikkara, Ernakulam, Kerala 682312";
      description = "A famous Devi temple known for mental health healing rituals, visited by thousands seeking relief from mental ailments.";
      history = "An ancient temple where the goddess takes three forms throughout the day: Saraswati in morning, Lakshmi at noon, Durga at dusk.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/a/a9/Chottanikkara_Temple_Kerala.jpg/800px-Chottanikkara_Temple_Kerala.jpg"];
      architectureStyle = "Kerala";
      darshanTimings = [
        { timingLabel = "General Darshan"; openTime = "04:00"; closeTime = "20:30"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Morning Puja"; time = "04:00"; description = "Morning worship"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 51; description = "General donation at the temple." },
      ];
      contactInfo = { phone = ?"+91-484-2683125"; email = null; website = null };
      nonHinduRestriction = false;
      averageVisitDuration = 3;
      tags = ["shakti","kerala","ernakulam","mental healing","bhagavathy","devi"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(68, t68);

    // --- MADHYA PRADESH (IDs 69-73) ---
    let t69 : TempleTypes.Temple = {
      id = 69;
      name = "Khajuraho Temple Complex";
      deity = "Lord Shiva, Vishnu, Jain Tirthankaras";
      state = "Madhya Pradesh";
      city = "Khajuraho";
      district = "Chhatarpur";
      address = "Khajuraho, Chhatarpur District, Madhya Pradesh 471606";
      description = "A UNESCO World Heritage Site with 25 remaining temples famous for intricate erotic sculptures.";
      history = "Built between 950-1050 CE by the Chandela dynasty, originally 85 temples, showcasing Nagara architecture at its peak.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/b/b0/Khajuraho_Temple_Complex.jpg/800px-Khajuraho_Temple_Complex.jpg"];
      architectureStyle = "Nagara (Chandela)";
      darshanTimings = [
        { timingLabel = "General Darshan"; openTime = "06:00"; closeTime = "18:00"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Morning Puja"; time = "06:00"; description = "Morning worship"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 51; description = "General donation at the temple." },
      ];
      contactInfo = { phone = null; email = null; website = ?"https://asi.nic.in/khajuraho" };
      nonHinduRestriction = false;
      averageVisitDuration = 5;
      tags = ["shiva","madhya pradesh","khajuraho","unesco","chandela","erotic sculptures","nagara"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(69, t69);

    let t70 : TempleTypes.Temple = {
      id = 70;
      name = "Mahakaleshwar Temple (Ujjain)";
      deity = "Lord Mahakaleshwar (Shiva)";
      state = "Madhya Pradesh";
      city = "Ujjain";
      district = "Ujjain";
      address = "Jaisinghpura, Ujjain, Madhya Pradesh 456001";
      description = "One of the twelve Jyotirlingas, the only self-manifested (Swayambhu) linga facing south, site of famous Bhasma Aarti.";
      history = "An ancient Jyotirlinga, the current temple was built by Peshwa Baji Rao I in the 18th century CE.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Mahakaleshwar_Temple_Ujjain.jpg/800px-Mahakaleshwar_Temple_Ujjain.jpg"];
      architectureStyle = "Bhumija (Nagara)";
      darshanTimings = [
        { timingLabel = "General Darshan"; openTime = "04:00"; closeTime = "23:00"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Bhasma Aarti"; time = "04:00"; description = "Famous ash aarti"; isIncluded = false; price = ?250 },
        { name = "Evening Aarti"; time = "19:00"; description = "Evening worship"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 101; description = "General donation at the temple." },
      ];
      contactInfo = { phone = ?"+91-734-2550563"; email = null; website = ?"https://mahakaleshwar.nic.in" };
      nonHinduRestriction = false;
      averageVisitDuration = 4;
      tags = ["jyotirlinga","shiva","madhya pradesh","ujjain","bhasma aarti","kumbh mela"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(70, t70);

    let t71 : TempleTypes.Temple = {
      id = 71;
      name = "Omkareshwar Temple";
      deity = "Lord Omkareshwar (Shiva)";
      state = "Madhya Pradesh";
      city = "Mandhata";
      district = "Khandwa";
      address = "Mandhata Island, Narmada River, Khandwa, Madhya Pradesh 450554";
      description = "One of the twelve Jyotirlingas on Mandhata Island in the Narmada River, shaped like the Om symbol.";
      history = "An ancient Jyotirlinga on a naturally Om-shaped island, deeply connected to the Narmada parikrama tradition.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/d/d2/Omkareshwar_Temple_MP.jpg/800px-Omkareshwar_Temple_MP.jpg"];
      architectureStyle = "Nagara";
      darshanTimings = [
        { timingLabel = "General Darshan"; openTime = "05:00"; closeTime = "22:00"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Morning Puja"; time = "05:00"; description = "Morning worship"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 101; description = "General donation at the temple." },
      ];
      contactInfo = { phone = ?"+91-7280-271253"; email = null; website = null };
      nonHinduRestriction = false;
      averageVisitDuration = 4;
      tags = ["jyotirlinga","shiva","madhya pradesh","narmada","island","omkar"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(71, t71);

    let t72 : TempleTypes.Temple = {
      id = 72;
      name = "Ram Raja Temple (Orchha)";
      deity = "Lord Ram Raja";
      state = "Madhya Pradesh";
      city = "Orchha";
      district = "Tikamgarh";
      address = "Orchha, Tikamgarh District, Madhya Pradesh 472246";
      description = "The only temple in India where Ram is worshipped as a king (Raja) with a royal salute (gun salute) each day.";
      history = "Built in 1554 CE during Bundela dynasty rule; Ram's idol was originally brought from Ayodhya and could not be moved.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/e/e3/Orchha_Ram_Raja_Temple.jpg/800px-Orchha_Ram_Raja_Temple.jpg"];
      architectureStyle = "Bundeli";
      darshanTimings = [
        { timingLabel = "General Darshan"; openTime = "08:00"; closeTime = "20:00"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Morning Puja"; time = "08:00"; description = "Morning worship with gun salute"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 51; description = "General donation at the temple." },
      ];
      contactInfo = { phone = null; email = null; website = null };
      nonHinduRestriction = false;
      averageVisitDuration = 3;
      tags = ["rama","madhya pradesh","orchha","bundela","ram raja","gun salute"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(72, t72);

    let t73 : TempleTypes.Temple = {
      id = 73;
      name = "Bhojpur Shiva Temple";
      deity = "Lord Shiva";
      state = "Madhya Pradesh";
      city = "Bhojpur";
      district = "Raisen";
      address = "Bhojpur, Raisen District, Madhya Pradesh 464993";
      description = "An unfinished 11th-century Shiva temple with one of the largest Shiva lingas in India at 7.5 feet height.";
      history = "Built by Raja Bhoj of the Paramara dynasty in 1010 CE, the temple was never completed but remains architecturally stunning.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/f/f4/Bhojpur_Temple_MP.jpg/800px-Bhojpur_Temple_MP.jpg"];
      architectureStyle = "Paramara Nagara";
      darshanTimings = [
        { timingLabel = "General Darshan"; openTime = "07:00"; closeTime = "18:00"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Morning Puja"; time = "07:00"; description = "Morning worship"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 51; description = "General donation at the temple." },
      ];
      contactInfo = { phone = null; email = null; website = null };
      nonHinduRestriction = false;
      averageVisitDuration = 2;
      tags = ["shiva","madhya pradesh","bhojpur","paramara","large lingam","unfinished"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(73, t73);

    // --- MAHARASHTRA (IDs 74-76) ---
    let t74 : TempleTypes.Temple = {
      id = 74;
      name = "Trimbakeshwar Temple (Nashik)";
      deity = "Lord Trimbakeshwar (Shiva)";
      state = "Maharashtra";
      city = "Trimbak";
      district = "Nashik";
      address = "Trimbak, Nashik District, Maharashtra 422212";
      description = "One of the twelve Jyotirlingas, unique for having three faces (Brahma, Vishnu, Shiva) in one lingam.";
      history = "An ancient Jyotirlinga at the source of Godavari River, rebuilt by Peshwa Nana Sahib Peshwa in 1755 CE.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/a/a0/Trimbakeshwar_Temple_Nashik.jpg/800px-Trimbakeshwar_Temple_Nashik.jpg"];
      architectureStyle = "Hemadpanthi Nagara";
      darshanTimings = [
        { timingLabel = "General Darshan"; openTime = "05:30"; closeTime = "21:00"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Morning Puja"; time = "05:30"; description = "Morning worship"; isIncluded = true; price = null },
        { name = "Evening Aarti"; time = "19:30"; description = "Evening aarti"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 101; description = "General donation at the temple." },
      ];
      contactInfo = { phone = ?"+91-2594-233063"; email = null; website = null };
      nonHinduRestriction = true;
      averageVisitDuration = 3;
      tags = ["jyotirlinga","shiva","maharashtra","nashik","godavari","kumbh mela"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(74, t74);

    let t75 : TempleTypes.Temple = {
      id = 75;
      name = "Mahalaxmi Temple (Kolhapur)";
      deity = "Goddess Mahalaxmi (Ambabai)";
      state = "Maharashtra";
      city = "Kolhapur";
      district = "Kolhapur";
      address = "Bhavani Mandap, Kolhapur, Maharashtra 416012";
      description = "One of the 51 Shakti Peethas and one of the six holiest Shakti temples (Shat Shaktipeethas), very ancient.";
      history = "One of the oldest temples in Maharashtra, dating to the 7th century CE, built in the Hemadpanthi style.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/b/b1/Mahalaxmi_Temple_Kolhapur.jpg/800px-Mahalaxmi_Temple_Kolhapur.jpg"];
      architectureStyle = "Hemadpanthi";
      darshanTimings = [
        { timingLabel = "General Darshan"; openTime = "04:30"; closeTime = "22:00"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Kakad Aarti"; time = "04:30"; description = "Early morning aarti"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 51; description = "General donation at the temple." },
      ];
      contactInfo = { phone = ?"+91-231-2655885"; email = null; website = null };
      nonHinduRestriction = false;
      averageVisitDuration = 3;
      tags = ["shakti peetha","maharashtra","kolhapur","mahalaxmi","shat shaktipeetha"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(75, t75);

    let t76 : TempleTypes.Temple = {
      id = 76;
      name = "Vitthal Rukmini Temple (Pandharpur)";
      deity = "Lord Vitthal (Vithoba)";
      state = "Maharashtra";
      city = "Pandharpur";
      district = "Solapur";
      address = "Pandharpur, Solapur District, Maharashtra 413304";
      description = "The most sacred Vaishnava pilgrimage site in Maharashtra, destination of the famous Wari pilgrimage.";
      history = "Dating to the 13th century CE, the temple is the center of the Warkari bhakti movement started by saints like Tukaram and Dnyaneshwar.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/c/c2/Pandharpur_Vitthal_Temple.jpg/800px-Pandharpur_Vitthal_Temple.jpg"];
      architectureStyle = "Hemadpanthi";
      darshanTimings = [
        { timingLabel = "General Darshan"; openTime = "05:00"; closeTime = "23:00"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Kakad Aarti"; time = "05:00"; description = "Early morning aarti"; isIncluded = true; price = null },
        { name = "Shej Aarti"; time = "22:00"; description = "Night aarti"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 101; description = "General donation at the temple." },
      ];
      contactInfo = { phone = ?"+91-2186-223333"; email = null; website = null };
      nonHinduRestriction = true;
      averageVisitDuration = 4;
      tags = ["vitthal","maharashtra","pandharpur","wari","varkari","bhakti","tukaram"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(76, t76);

    // --- MANIPUR (IDs 77-81) ---
    let t77 : TempleTypes.Temple = {
      id = 77;
      name = "Shri Shri Govindaji Temple (Imphal)";
      deity = "Lord Govindaji (Krishna)";
      state = "Manipur";
      city = "Imphal";
      district = "Imphal West";
      address = "Kangla Palace Compound, Imphal, Manipur 795001";
      description = "The most important Vaishnava temple in Manipur, housing twin idols of Govinda and Baladev.";
      history = "Established in 1846 CE by Maharaja Nara Singh of Manipur, it became the state temple and religious center.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/d/d3/Govindaji_Temple_Imphal.jpg/800px-Govindaji_Temple_Imphal.jpg"];
      architectureStyle = "Meitei (Manipuri)";
      darshanTimings = [
        { timingLabel = "General Darshan"; openTime = "06:00"; closeTime = "20:00"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Morning Puja"; time = "06:00"; description = "Morning worship"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 51; description = "General donation at the temple." },
      ];
      contactInfo = { phone = null; email = null; website = null };
      nonHinduRestriction = false;
      averageVisitDuration = 2;
      tags = ["krishna","manipur","imphal","govindaji","vaishnava","meitei"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(77, t77);

    let t78 : TempleTypes.Temple = {
      id = 78;
      name = "Bijoy Govinda Temple (Imphal)";
      deity = "Lord Bijoy Govinda (Krishna)";
      state = "Manipur";
      city = "Imphal";
      district = "Imphal East";
      address = "Imphal East, Manipur 795005";
      description = "A major Krishna temple in Imphal, one of the important Vaishnava pilgrimage sites in Manipur.";
      history = "Established in the early 19th century, an important center for Meitei Vaishnavism in Manipur.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/e/e4/Bijoy_Govinda_Temple_Manipur.jpg/800px-Bijoy_Govinda_Temple_Manipur.jpg"];
      architectureStyle = "Meitei";
      darshanTimings = [
        { timingLabel = "General Darshan"; openTime = "06:00"; closeTime = "20:00"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Morning Puja"; time = "06:00"; description = "Morning worship"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 51; description = "General donation at the temple." },
      ];
      contactInfo = { phone = null; email = null; website = null };
      nonHinduRestriction = false;
      averageVisitDuration = 2;
      tags = ["krishna","manipur","imphal","vaishnava","meitei"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(78, t78);

    let t79 : TempleTypes.Temple = {
      id = 79;
      name = "Thangjing Temple (Moirang)";
      deity = "Lord Thangjing (Guardian deity)";
      state = "Manipur";
      city = "Moirang";
      district = "Bishnupur";
      address = "Moirang, Bishnupur District, Manipur 795133";
      description = "A sacred temple to Lord Thangjing, the guardian deity of the Manipuri people, near Loktak Lake.";
      history = "One of the most ancient Meitei sacred sites, Thangjing is a deity revered in pre-Vaishnava Meitei religion.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/f/f5/Thangjing_Temple_Manipur.jpg/800px-Thangjing_Temple_Manipur.jpg"];
      architectureStyle = "Meitei traditional";
      darshanTimings = [
        { timingLabel = "General Darshan"; openTime = "06:00"; closeTime = "18:00"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Morning Puja"; time = "06:00"; description = "Morning worship"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 51; description = "General donation at the temple." },
      ];
      contactInfo = { phone = null; email = null; website = null };
      nonHinduRestriction = false;
      averageVisitDuration = 2;
      tags = ["meitei","manipur","bishnupur","loktak","guardian deity","ancient"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(79, t79);

    let t80 : TempleTypes.Temple = {
      id = 80;
      name = "Khongjom War Memorial (Thoubal)";
      deity = "Martyrs of Manipur (War Memorial)";
      state = "Manipur";
      city = "Thoubal";
      district = "Thoubal";
      address = "Khongjom, Thoubal District, Manipur 795138";
      description = "A memorial and shrine to the Manipuri warriors who fought the British in 1891, a place of great reverence.";
      history = "Commemorates the Battle of Khongjom (1891) where Manipuri forces fought valiantly against the British East India Company.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/a/a6/Khongjom_War_Memorial_Manipur.jpg/800px-Khongjom_War_Memorial_Manipur.jpg"];
      architectureStyle = "Memorial";
      darshanTimings = [
        { timingLabel = "Visiting Hours"; openTime = "07:00"; closeTime = "17:00"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Tribute Ceremony"; time = "09:00"; description = "Morning tribute"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 51; description = "General donation." },
      ];
      contactInfo = { phone = null; email = null; website = null };
      nonHinduRestriction = false;
      averageVisitDuration = 2;
      tags = ["manipur","thoubal","war memorial","1891","british","patriots"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(80, t80);

    let t81 : TempleTypes.Temple = {
      id = 81;
      name = "Kangla Palace Shri Shri Pakhangba Temple";
      deity = "Lord Pakhangba (Serpent deity)";
      state = "Manipur";
      city = "Imphal";
      district = "Imphal West";
      address = "Kangla Fort, Imphal, Manipur 795001";
      description = "The sacred seat of Meitei royalty and religion, housing the divine serpent deity Pakhangba.";
      history = "Kangla was the sacred palace of Manipuri kings for 2000 years; Pakhangba is the chief deity of Meitei cosmology.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/b/b7/Kangla_Palace_Imphal_Manipur.jpg/800px-Kangla_Palace_Imphal_Manipur.jpg"];
      architectureStyle = "Meitei royal";
      darshanTimings = [
        { timingLabel = "General Darshan"; openTime = "07:00"; closeTime = "17:00"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Morning Puja"; time = "07:00"; description = "Morning worship"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 51; description = "General donation at the temple." },
      ];
      contactInfo = { phone = null; email = null; website = null };
      nonHinduRestriction = false;
      averageVisitDuration = 3;
      tags = ["pakhangba","manipur","imphal","kangla","meitei","royal","serpent deity"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(81, t81);

    // --- MEGHALAYA (IDs 82-86) ---
    let t82 : TempleTypes.Temple = {
      id = 82;
      name = "Nartiang Durga Temple";
      deity = "Goddess Durga";
      state = "Meghalaya";
      city = "Nartiang";
      district = "West Jaintia Hills";
      address = "Nartiang, West Jaintia Hills, Meghalaya 793150";
      description = "A famous Durga temple associated with the Jaintia kings, with a large monolithic structure nearby.";
      history = "Built by the Jaintia kings as a seat of royal power, the goddess was worshipped before battles and coronations.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/c/c8/Nartiang_Durga_Temple_Meghalaya.jpg/800px-Nartiang_Durga_Temple_Meghalaya.jpg"];
      architectureStyle = "Jaintia";
      darshanTimings = [
        { timingLabel = "General Darshan"; openTime = "06:00"; closeTime = "18:00"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Morning Puja"; time = "06:00"; description = "Morning worship"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 51; description = "General donation at the temple." },
      ];
      contactInfo = { phone = null; email = null; website = null };
      nonHinduRestriction = false;
      averageVisitDuration = 2;
      tags = ["durga","meghalaya","jaintia","west jaintia hills","ancient","shakti"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(82, t82);

    let t83 : TempleTypes.Temple = {
      id = 83;
      name = "Mawphlang Sacred Forest Grove";
      deity = "Labasa (Forest deity)";
      state = "Meghalaya";
      city = "Mawphlang";
      district = "East Khasi Hills";
      address = "Mawphlang, East Khasi Hills, Meghalaya 793119";
      description = "A sacred ancient forest grove preserved for centuries by the Khasi people, a unique form of living temple.";
      history = "The sacred grove has been maintained by the Blah clan for over 600 years, no one is allowed to take anything from it.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/d/d9/Mawphlang_Sacred_Grove.jpg/800px-Mawphlang_Sacred_Grove.jpg"];
      architectureStyle = "Sacred Natural Forest";
      darshanTimings = [
        { timingLabel = "Visiting Hours"; openTime = "08:00"; closeTime = "17:00"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Forest Ritual"; time = "09:00"; description = "Traditional Khasi ritual"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 51; description = "General donation." },
      ];
      contactInfo = { phone = null; email = null; website = null };
      nonHinduRestriction = false;
      averageVisitDuration = 3;
      tags = ["meghalaya","khasi","sacred grove","forest","nature","indigenous"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(83, t83);

    let t84 : TempleTypes.Temple = {
      id = 84;
      name = "Jakrem Thermal Spring Shrine";
      deity = "Nature and Healing Deities";
      state = "Meghalaya";
      city = "Jakrem";
      district = "Ri Bhoi";
      address = "Jakrem, Ri Bhoi District, Meghalaya";
      description = "A sacred thermal spring site where pilgrims bathe for healing and make offerings to nature deities.";
      history = "A traditional Khasi sacred site for centuries, the thermal springs are believed to have curative properties.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/e/e0/Jakrem_Temple_Meghalaya.jpg/800px-Jakrem_Temple_Meghalaya.jpg"];
      architectureStyle = "Sacred Natural Site";
      darshanTimings = [
        { timingLabel = "Visiting Hours"; openTime = "06:00"; closeTime = "18:00"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Morning Ritual"; time = "06:00"; description = "Morning healing ritual"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 51; description = "General donation." },
      ];
      contactInfo = { phone = null; email = null; website = null };
      nonHinduRestriction = false;
      averageVisitDuration = 3;
      tags = ["meghalaya","thermal spring","khasi","healing","nature worship"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(84, t84);

    let t85 : TempleTypes.Temple = {
      id = 85;
      name = "Uma Devi Temple (Shillong)";
      deity = "Goddess Uma Devi (Parvati)";
      state = "Meghalaya";
      city = "Shillong";
      district = "East Khasi Hills";
      address = "Shillong, East Khasi Hills, Meghalaya 793001";
      description = "A prominent Hindu temple in Shillong dedicated to Goddess Uma Devi, popular among Bengali community.";
      history = "Established by Bengali Hindu settlers, it remains an important temple in Shillong's diverse religious landscape.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/f/f1/Uma_Devi_Temple_Shillong.jpg/800px-Uma_Devi_Temple_Shillong.jpg"];
      architectureStyle = "Bengali";
      darshanTimings = [
        { timingLabel = "General Darshan"; openTime = "06:00"; closeTime = "20:00"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Morning Puja"; time = "06:00"; description = "Morning worship"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 51; description = "General donation at the temple." },
      ];
      contactInfo = { phone = null; email = null; website = null };
      nonHinduRestriction = false;
      averageVisitDuration = 2;
      tags = ["parvati","meghalaya","shillong","bengali","uma devi","shakti"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(85, t85);

    let t86 : TempleTypes.Temple = {
      id = 86;
      name = "Kyllang Rock Sacred Site";
      deity = "Khasi ancestral deities";
      state = "Meghalaya";
      city = "Mairang";
      district = "West Khasi Hills";
      address = "Kyllang Rock, Mairang, West Khasi Hills, Meghalaya";
      description = "A massive granite dome rock considered sacred by the Khasi people, used for traditional rituals.";
      history = "The Kyllang Rock has been a sacred site for the Khasi people for centuries, associated with ancestral spirits.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/a/a7/Kyllang_Rock_Meghalaya.jpg/800px-Kyllang_Rock_Meghalaya.jpg"];
      architectureStyle = "Natural Sacred Site";
      darshanTimings = [
        { timingLabel = "Visiting Hours"; openTime = "07:00"; closeTime = "17:00"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Traditional Ritual"; time = "09:00"; description = "Khasi ancestral ritual"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 51; description = "General donation." },
      ];
      contactInfo = { phone = null; email = null; website = null };
      nonHinduRestriction = false;
      averageVisitDuration = 2;
      tags = ["meghalaya","khasi","rock","sacred","ancestral","west khasi hills"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(86, t86);

    // --- MIZORAM (IDs 87-91) ---
    let t87 : TempleTypes.Temple = {
      id = 87;
      name = "Solomon's Temple (Aizawl)";
      deity = "Christian (historic landmark)";
      state = "Mizoram";
      city = "Aizawl";
      district = "Aizawl";
      address = "Aizawl, Mizoram 796001";
      description = "A large and iconic Christian church that serves as a spiritual and architectural landmark of Aizawl.";
      history = "A significant church in Mizoram's predominantly Christian state, reflecting the deep Christian faith of the Mizo people.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/c/c9/Solomons_Temple_Aizawl.jpg/800px-Solomons_Temple_Aizawl.jpg"];
      architectureStyle = "Modern Christian";
      darshanTimings = [
        { timingLabel = "Visiting Hours"; openTime = "08:00"; closeTime = "18:00"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Sunday Service"; time = "09:00"; description = "Weekly Sunday service"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 51; description = "General donation." },
      ];
      contactInfo = { phone = null; email = null; website = null };
      nonHinduRestriction = false;
      averageVisitDuration = 2;
      tags = ["christian","mizoram","aizawl","church","landmark","mizo"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(87, t87);

    let t88 : TempleTypes.Temple = {
      id = 88;
      name = "Bethlehem Vengthlang Church (Aizawl)";
      deity = "Christian (historic)";
      state = "Mizoram";
      city = "Aizawl";
      district = "Aizawl";
      address = "Vengthlang, Aizawl, Mizoram 796001";
      description = "One of the oldest and most historically significant churches in Mizoram, a pilgrimage site for Christians.";
      history = "Established during the early Christian missionary period in Mizoram, a key site in the spread of Christianity in northeast India.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/b/b8/Bethlehem_Church_Aizawl.jpg/800px-Bethlehem_Church_Aizawl.jpg"];
      architectureStyle = "Colonial Christian";
      darshanTimings = [
        { timingLabel = "Visiting Hours"; openTime = "08:00"; closeTime = "18:00"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Sunday Service"; time = "09:00"; description = "Weekly Sunday service"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 51; description = "General donation." },
      ];
      contactInfo = { phone = null; email = null; website = null };
      nonHinduRestriction = false;
      averageVisitDuration = 2;
      tags = ["christian","mizoram","aizawl","church","missionary","historic"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(88, t88);

    let t89 : TempleTypes.Temple = {
      id = 89;
      name = "Reiek Heritage Village Shrine";
      deity = "Mizo ancestral spirits";
      state = "Mizoram";
      city = "Reiek";
      district = "Mamit";
      address = "Reiek Village, Mamit District, Mizoram 796441";
      description = "A traditional Mizo village and heritage site preserving ancient customs and sacred practices atop a hill.";
      history = "Reiek is a recreated traditional Mizo village where ancestral customs and sacred sites are preserved as living heritage.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/d/d0/Reiek_Village_Mizoram.jpg/800px-Reiek_Village_Mizoram.jpg"];
      architectureStyle = "Traditional Mizo";
      darshanTimings = [
        { timingLabel = "Visiting Hours"; openTime = "08:00"; closeTime = "17:00"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Heritage Ceremony"; time = "10:00"; description = "Traditional Mizo ceremony"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 51; description = "General donation." },
      ];
      contactInfo = { phone = null; email = null; website = null };
      nonHinduRestriction = false;
      averageVisitDuration = 3;
      tags = ["mizoram","mizo","heritage","ancestral","village","traditional","mamit"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(89, t89);

    let t90 : TempleTypes.Temple = {
      id = 90;
      name = "Vantawng Falls Sacred Site";
      deity = "Nature spirits (Vantawng)";
      state = "Mizoram";
      city = "Thenzawl";
      district = "Serchhip";
      address = "Vantawng Falls, Thenzawl, Serchhip District, Mizoram 796181";
      description = "The highest waterfall in Mizoram and one of the highest in India, a sacred natural site for the Mizo people.";
      history = "Long regarded as sacred by the Mizo people who believe nature spirits reside in and around the falls.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/f/f2/Vantawng_Falls_Mizoram.jpg/800px-Vantawng_Falls_Mizoram.jpg"];
      architectureStyle = "Sacred Natural Site";
      darshanTimings = [
        { timingLabel = "Visiting Hours"; openTime = "06:00"; closeTime = "18:00"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Nature Ritual"; time = "07:00"; description = "Sacred water ritual"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 51; description = "General donation." },
      ];
      contactInfo = { phone = null; email = null; website = null };
      nonHinduRestriction = false;
      averageVisitDuration = 3;
      tags = ["mizoram","waterfall","nature","sacred","serchhip","mizo traditions"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(90, t90);

    let t91 : TempleTypes.Temple = {
      id = 91;
      name = "Lunglei Church (Historic)";
      deity = "Christian (historic)";
      state = "Mizoram";
      city = "Lunglei";
      district = "Lunglei";
      address = "Lunglei, Mizoram 796701";
      description = "A historic church in the second largest city of Mizoram, one of the earliest Christian establishments in the region.";
      history = "Established by Welsh missionaries in the early 20th century, it played a pivotal role in the Christianization of Mizoram.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/e/e1/Lunglei_Church_Mizoram.jpg/800px-Lunglei_Church_Mizoram.jpg"];
      architectureStyle = "Colonial Church";
      darshanTimings = [
        { timingLabel = "Visiting Hours"; openTime = "08:00"; closeTime = "18:00"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Sunday Service"; time = "09:00"; description = "Weekly Sunday service"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 51; description = "General donation." },
      ];
      contactInfo = { phone = null; email = null; website = null };
      nonHinduRestriction = false;
      averageVisitDuration = 2;
      tags = ["christian","mizoram","lunglei","church","welsh missionaries","historic"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(91, t91);

    // --- NAGALAND (IDs 92-95) ---
    let t92 : TempleTypes.Temple = {
      id = 92;
      name = "Kachari Ruins Temple (Dimapur)";
      deity = "Kachari ancestors and deities";
      state = "Nagaland";
      city = "Dimapur";
      district = "Dimapur";
      address = "Dimapur, Nagaland 797112";
      description = "Ancient ruins of the medieval Kachari kingdom, comprising mushroom-shaped monolith structures considered sacred.";
      history = "The ruins date to the 10th-16th century CE Kachari kingdom, thought to have been a royal temple complex.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/a/a8/Kachari_Ruins_Dimapur.jpg/800px-Kachari_Ruins_Dimapur.jpg"];
      architectureStyle = "Kachari (medieval)";
      darshanTimings = [
        { timingLabel = "Visiting Hours"; openTime = "08:00"; closeTime = "17:00"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Morning Visit"; time = "08:00"; description = "Morning guided visit"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 51; description = "General donation." },
      ];
      contactInfo = { phone = null; email = null; website = null };
      nonHinduRestriction = false;
      averageVisitDuration = 2;
      tags = ["nagaland","dimapur","kachari","ruins","archaeological","medieval","monolith"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(92, t92);

    let t93 : TempleTypes.Temple = {
      id = 93;
      name = "Dzukou Valley Sacred Site";
      deity = "Nature deities of Naga people";
      state = "Nagaland";
      city = "Kohima";
      district = "Kohima";
      address = "Dzukou Valley, Kohima, Nagaland 797001";
      description = "A beautiful valley at 2452m altitude, considered sacred by Naga tribes, famous for seasonal flowers.";
      history = "The valley holds spiritual significance for Naga people who have revered it as a sacred natural site for generations.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/c/c0/Dzukou_Valley_Nagaland.jpg/800px-Dzukou_Valley_Nagaland.jpg"];
      architectureStyle = "Sacred Natural Valley";
      darshanTimings = [
        { timingLabel = "Trekking Season"; openTime = "06:00"; closeTime = "18:00"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Nature Offering"; time = "07:00"; description = "Traditional Naga nature offering"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 51; description = "General donation." },
      ];
      contactInfo = { phone = null; email = null; website = null };
      nonHinduRestriction = false;
      averageVisitDuration = 6;
      tags = ["nagaland","kohima","naga","sacred valley","nature","flowers","trek"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(93, t93);

    let t94 : TempleTypes.Temple = {
      id = 94;
      name = "Japfu Peak Sacred Site";
      deity = "Nature spirits";
      state = "Nagaland";
      city = "Kohima";
      district = "Kohima";
      address = "Japfu Peak, Kohima, Nagaland 797001";
      description = "The second highest peak in Nagaland with sacred significance for local Naga tribes, offering panoramic views.";
      history = "A historically significant peak in Naga tribal territory, revered as a sacred mountain since ancient times.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/b/b9/Japfu_Peak_Nagaland.jpg/800px-Japfu_Peak_Nagaland.jpg"];
      architectureStyle = "Sacred Natural Peak";
      darshanTimings = [
        { timingLabel = "Trekking Hours"; openTime = "06:00"; closeTime = "17:00"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Summit Ritual"; time = "08:00"; description = "Traditional ritual at summit"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 51; description = "General donation." },
      ];
      contactInfo = { phone = null; email = null; website = null };
      nonHinduRestriction = false;
      averageVisitDuration = 4;
      tags = ["nagaland","kohima","naga","sacred peak","mountain","trek","nature"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(94, t94);

    let t95 : TempleTypes.Temple = {
      id = 95;
      name = "Shiv Mandir (Dimapur)";
      deity = "Lord Shiva";
      state = "Nagaland";
      city = "Dimapur";
      district = "Dimapur";
      address = "Dimapur, Nagaland 797112";
      description = "A prominent Shiva temple serving the Hindu community in Nagaland's commercial capital city.";
      history = "Built to serve the growing Hindu migrant community in Dimapur, it represents religious diversity in Nagaland.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/d/d1/Shiv_Mandir_Dimapur.jpg/800px-Shiv_Mandir_Dimapur.jpg"];
      architectureStyle = "North Indian";
      darshanTimings = [
        { timingLabel = "General Darshan"; openTime = "06:00"; closeTime = "20:00"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Morning Puja"; time = "06:00"; description = "Morning worship"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 51; description = "General donation at the temple." },
      ];
      contactInfo = { phone = null; email = null; website = null };
      nonHinduRestriction = false;
      averageVisitDuration = 2;
      tags = ["shiva","nagaland","dimapur","hindu","mandir","community"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(95, t95);

    // --- ODISHA (IDs 96-99) ---
    let t96 : TempleTypes.Temple = {
      id = 96;
      name = "Lingaraj Temple (Bhubaneswar)";
      deity = "Lord Lingaraj (Shiva-Vishnu)";
      state = "Odisha";
      city = "Bhubaneswar";
      district = "Khordha";
      address = "Old Town, Bhubaneswar, Odisha 751002";
      description = "The largest temple in Bhubaneswar and one of the finest examples of Kalinga architecture, dedicated to Hari-Hara.";
      history = "Built primarily in the 11th century CE by the Somavamshi dynasty, the temple represents the pinnacle of Kalinga temple art.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/f/f3/Lingaraj_Temple_Bhubaneswar.jpg/800px-Lingaraj_Temple_Bhubaneswar.jpg"];
      architectureStyle = "Kalinga (Deula)";
      darshanTimings = [
        { timingLabel = "General Darshan"; openTime = "05:00"; closeTime = "21:00"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Morning Puja"; time = "05:00"; description = "Morning worship"; isIncluded = true; price = null },
        { name = "Evening Aarti"; time = "19:00"; description = "Evening aarti"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 51; description = "General donation at the temple." },
      ];
      contactInfo = { phone = null; email = null; website = null };
      nonHinduRestriction = true;
      averageVisitDuration = 3;
      tags = ["shiva","odisha","bhubaneswar","kalinga","hari-hara","somavamshi"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(96, t96);

    let t97 : TempleTypes.Temple = {
      id = 97;
      name = "Konark Sun Temple";
      deity = "Lord Surya (Sun God)";
      state = "Odisha";
      city = "Konark";
      district = "Puri";
      address = "Konark, Puri District, Odisha 752111";
      description = "A UNESCO World Heritage Site designed as a massive chariot with 12 pairs of wheels, an architectural masterpiece.";
      history = "Built in the 13th century CE by King Narasimhadeva I of the Eastern Ganga dynasty, now a national symbol of India.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/a/a0/Konark_Sun_Temple_Odisha.jpg/800px-Konark_Sun_Temple_Odisha.jpg"];
      architectureStyle = "Kalinga (Chariot style)";
      darshanTimings = [
        { timingLabel = "General Darshan"; openTime = "06:00"; closeTime = "20:00"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Morning Visit"; time = "06:00"; description = "Morning guided visit"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 51; description = "General donation at the temple." },
      ];
      contactInfo = { phone = null; email = null; website = ?"https://asi.nic.in/konark" };
      nonHinduRestriction = false;
      averageVisitDuration = 4;
      tags = ["surya","odisha","konark","unesco","chariot","eastern ganga","sun"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(97, t97);

    let t98 : TempleTypes.Temple = {
      id = 98;
      name = "Mukteswar Temple (Bhubaneswar)";
      deity = "Lord Shiva";
      state = "Odisha";
      city = "Bhubaneswar";
      district = "Khordha";
      address = "Old Town, Bhubaneswar, Odisha 751002";
      description = "A 10th-century gem of Kalinga architecture, called the 'Gem of Odisha Architecture' for its torana gateway.";
      history = "Built circa 950 CE, this small but exquisite temple is considered the crowning achievement of early Kalinga architecture.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/b/b1/Mukteswar_Temple_Bhubaneswar.jpg/800px-Mukteswar_Temple_Bhubaneswar.jpg"];
      architectureStyle = "Kalinga (early)";
      darshanTimings = [
        { timingLabel = "General Darshan"; openTime = "06:00"; closeTime = "18:00"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Morning Puja"; time = "06:00"; description = "Morning worship"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 51; description = "General donation at the temple." },
      ];
      contactInfo = { phone = null; email = null; website = null };
      nonHinduRestriction = false;
      averageVisitDuration = 2;
      tags = ["shiva","odisha","bhubaneswar","kalinga","10th century","torana","gem"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(98, t98);

    let t99 : TempleTypes.Temple = {
      id = 99;
      name = "Kalijai Temple (Chilika Lake)";
      deity = "Goddess Kalijai";
      state = "Odisha";
      city = "Chilika";
      district = "Puri";
      address = "Kalijai Island, Chilika Lake, Puri District, Odisha";
      description = "A small island temple in Asia's largest brackish water lake, accessible only by boat, sacred to fishermen.";
      history = "Associated with the legend of a young bride who drowned in Chilika Lake and became the goddess Kalijai.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/c/c2/Kalijai_Temple_Chilika.jpg/800px-Kalijai_Temple_Chilika.jpg"];
      architectureStyle = "Odia";
      darshanTimings = [
        { timingLabel = "General Darshan"; openTime = "06:00"; closeTime = "18:00"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Morning Puja"; time = "06:00"; description = "Morning worship"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 51; description = "General donation at the temple." },
      ];
      contactInfo = { phone = null; email = null; website = null };
      nonHinduRestriction = false;
      averageVisitDuration = 3;
      tags = ["shakti","odisha","chilika lake","island temple","kalijai","fishermen","boat"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(99, t99);

    let t100 : TempleTypes.Temple = {
      id = 100;
      name = "Durgiana Temple (Amritsar)";
      deity = "Goddess Durga and Lakshmi";
      state = "Punjab";
      city = "Amritsar";
      district = "Amritsar";
      address = "Lohgarh Gate, Amritsar, Punjab 143001";
      description = "Known as the Silver Temple, it resembles the Golden Temple in design but is dedicated to Goddess Durga.";
      history = "Built in the 16th century on a sacred tank, rebuilt in 1921 by Harsai Mal Kapoor, considered equal in sanctity to Golden Temple.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/d/d3/Durgiana_Temple_Amritsar.jpg/800px-Durgiana_Temple_Amritsar.jpg"];
      architectureStyle = "Sikh-Hindu fusion";
      darshanTimings = [
        { timingLabel = "General Darshan"; openTime = "05:00"; closeTime = "21:00"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Morning Puja"; time = "05:00"; description = "Morning worship"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 51; description = "General donation at the temple." },
      ];
      contactInfo = { phone = null; email = null; website = null };
      nonHinduRestriction = false;
      averageVisitDuration = 2;
      tags = ["durga","punjab","amritsar","silver temple","lakshmi","sikh style"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(100, t100);

    let t101 : TempleTypes.Temple = {
      id = 101;
      name = "Anandpur Sahib Gurudwara";
      deity = "Sikh Guru Gobind Singh (sacred)";
      state = "Punjab";
      city = "Anandpur Sahib";
      district = "Rupnagar";
      address = "Anandpur Sahib, Rupnagar District, Punjab 140118";
      description = "A major Sikh holy site where Guru Gobind Singh founded the Khalsa in 1699 CE.";
      history = "Founded by Guru Tegh Bahadur in 1665 CE and famous as the place where the Khalsa Panth was born on Baisakhi 1699.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/e/e4/Anandpur_Sahib_Punjab.jpg/800px-Anandpur_Sahib_Punjab.jpg"];
      architectureStyle = "Sikh";
      darshanTimings = [
        { timingLabel = "General Darshan"; openTime = "04:00"; closeTime = "22:00"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Morning Ardas"; time = "04:00"; description = "Morning prayers"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 101; description = "Contribution to the Gurudwara." },
      ];
      contactInfo = { phone = null; email = null; website = null };
      nonHinduRestriction = false;
      averageVisitDuration = 3;
      tags = ["sikh","punjab","anandpur sahib","khalsa","guru gobind singh","vaisakhi"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(101, t101);

    let t102 : TempleTypes.Temple = {
      id = 102;
      name = "Fatehgarh Sahib Gurudwara";
      deity = "Martyrs of Fatehgarh Sahib (sacred)";
      state = "Punjab";
      city = "Fatehgarh Sahib";
      district = "Fatehgarh Sahib";
      address = "Fatehgarh Sahib, Punjab 140406";
      description = "A sacred Sikh shrine commemorating the martyrdom of Guru Gobind Singh's two younger sons.";
      history = "Marks the site where the two younger sons of Guru Gobind Singh were bricked alive by Mughal forces in 1704 CE.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/f/f5/Fatehgarh_Sahib_Punjab.jpg/800px-Fatehgarh_Sahib_Punjab.jpg"];
      architectureStyle = "Sikh";
      darshanTimings = [
        { timingLabel = "General Darshan"; openTime = "05:00"; closeTime = "21:00"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Morning Ardas"; time = "05:00"; description = "Morning prayers"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 51; description = "Contribution to the Gurudwara." },
      ];
      contactInfo = { phone = null; email = null; website = null };
      nonHinduRestriction = false;
      averageVisitDuration = 2;
      tags = ["sikh","punjab","martyr","guru gobind singh","mughal","fatehgarh sahib"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(102, t102);

    let t103 : TempleTypes.Temple = {
      id = 103;
      name = "Ram Tirath Temple (Amritsar)";
      deity = "Sage Valmiki and Lord Rama";
      state = "Punjab";
      city = "Amritsar";
      district = "Amritsar";
      address = "Ram Tirath, Amritsar, Punjab 143001";
      description = "A sacred site where Goddess Sita gave birth to Lav and Kush, and Valmiki wrote the Ramayana.";
      history = "One of the most ancient sacred sites in Punjab, believed to be the ashram of Sage Valmiki where Sita took shelter.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/a/a1/Ram_Tirath_Temple_Amritsar.jpg/800px-Ram_Tirath_Temple_Amritsar.jpg"];
      architectureStyle = "North Indian";
      darshanTimings = [
        { timingLabel = "General Darshan"; openTime = "06:00"; closeTime = "20:00"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Morning Puja"; time = "06:00"; description = "Morning worship"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 51; description = "General donation at the temple." },
      ];
      contactInfo = { phone = null; email = null; website = null };
      nonHinduRestriction = false;
      averageVisitDuration = 2;
      tags = ["rama","punjab","amritsar","valmiki","sita","ramayana","ancient"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(103, t103);

    let t104 : TempleTypes.Temple = {
      id = 104;
      name = "Ranakpur Jain Temple";
      deity = "Lord Adinatha (1st Jain Tirthankara)";
      state = "Rajasthan";
      city = "Ranakpur";
      district = "Pali";
      address = "Ranakpur, Pali District, Rajasthan 306702";
      description = "One of the largest and most important Jain temples, with 1444 uniquely carved marble pillars.";
      history = "Built in the 15th century CE by Dharna Shah under Rana Kumbha's patronage, it took over 65 years to complete.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/b/b2/Ranakpur_Jain_Temple_Rajasthan.jpg/800px-Ranakpur_Jain_Temple_Rajasthan.jpg"];
      architectureStyle = "Jain (marble)";
      darshanTimings = [
        { timingLabel = "General Darshan"; openTime = "06:00"; closeTime = "17:00"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Morning Puja"; time = "06:00"; description = "Morning worship"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 51; description = "General donation at the temple." },
      ];
      contactInfo = { phone = null; email = null; website = null };
      nonHinduRestriction = false;
      averageVisitDuration = 3;
      tags = ["jain","rajasthan","ranakpur","marble","1444 pillars","adinatha","pali"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(104, t104);

    let t105 : TempleTypes.Temple = {
      id = 105;
      name = "Dilwara Jain Temples (Mount Abu)";
      deity = "Jain Tirthankaras";
      state = "Rajasthan";
      city = "Mount Abu";
      district = "Sirohi";
      address = "Mount Abu, Sirohi District, Rajasthan 307501";
      description = "A complex of five magnificent Jain temples renowned for their extraordinary marble carvings and architecture.";
      history = "Built between 11th-13th centuries CE by the Chaulukya (Solanki) dynasty, considered among the finest Jain temples.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/c/c3/Dilwara_Temple_Mount_Abu.jpg/800px-Dilwara_Temple_Mount_Abu.jpg"];
      architectureStyle = "Jain marble (Solanki)";
      darshanTimings = [
        { timingLabel = "General Darshan"; openTime = "06:00"; closeTime = "18:00"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Morning Puja"; time = "06:00"; description = "Morning worship"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 51; description = "General donation at the temple." },
      ];
      contactInfo = { phone = null; email = null; website = null };
      nonHinduRestriction = false;
      averageVisitDuration = 4;
      tags = ["jain","rajasthan","mount abu","marble","solanki","dilwara","sirohi"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(105, t105);

    let t106 : TempleTypes.Temple = {
      id = 106;
      name = "Brahma Temple (Pushkar)";
      deity = "Lord Brahma";
      state = "Rajasthan";
      city = "Pushkar";
      district = "Ajmer";
      address = "Pushkar, Ajmer District, Rajasthan 305022";
      description = "One of the very few temples dedicated to Brahma in the world, the creator of the universe.";
      history = "Built in the 14th century CE, the original temple is believed to have been constructed 2000 years ago by the sage Vishwamitra.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/d/d4/Brahma_Temple_Pushkar.jpg/800px-Brahma_Temple_Pushkar.jpg"];
      architectureStyle = "Nagara";
      darshanTimings = [
        { timingLabel = "General Darshan"; openTime = "06:30"; closeTime = "20:30"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Morning Puja"; time = "06:30"; description = "Morning worship"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 51; description = "General donation at the temple." },
      ];
      contactInfo = { phone = null; email = null; website = null };
      nonHinduRestriction = false;
      averageVisitDuration = 2;
      tags = ["brahma","rajasthan","pushkar","ajmer","unique","creator","pilgrimage"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(106, t106);

    let t107 : TempleTypes.Temple = {
      id = 107;
      name = "Eklingji Temple (Udaipur)";
      deity = "Lord Eklingji (Shiva)";
      state = "Rajasthan";
      city = "Kailashpuri";
      district = "Udaipur";
      address = "Kailashpuri, Udaipur, Rajasthan 313202";
      description = "The patron deity of the Mewar dynasty, a beautiful white marble temple complex with 108 temples.";
      history = "Originally built in 971 CE by Bappa Rawal, the founder of the Mewar dynasty, who considered Shiva his personal deity.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/e/e5/Eklingji_Temple_Udaipur.jpg/800px-Eklingji_Temple_Udaipur.jpg"];
      architectureStyle = "Maru-Gurjara";
      darshanTimings = [
        { timingLabel = "General Darshan"; openTime = "04:30"; closeTime = "19:30"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Morning Puja"; time = "04:30"; description = "Morning worship"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 51; description = "General donation at the temple." },
      ];
      contactInfo = { phone = ?"+91-2953-285522"; email = null; website = null };
      nonHinduRestriction = true;
      averageVisitDuration = 3;
      tags = ["shiva","rajasthan","udaipur","mewar","bappa rawal","108 temples","marble"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(107, t107);

    let t108 : TempleTypes.Temple = {
      id = 108;
      name = "Karni Mata Temple (Bikaner)";
      deity = "Goddess Karni Mata (Durga)";
      state = "Rajasthan";
      city = "Deshnoke";
      district = "Bikaner";
      address = "Deshnoke, Bikaner, Rajasthan 334801";
      description = "Famous worldwide as the Rat Temple, home to 20,000+ sacred rats (kabbas) who are revered as holy.";
      history = "Built in the early 20th century for Karni Mata, a mystic saint considered an incarnation of Durga, famous for its sacred rats.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/f/f6/Karni_Mata_Temple_Bikaner.jpg/800px-Karni_Mata_Temple_Bikaner.jpg"];
      architectureStyle = "Mughal-Rajput";
      darshanTimings = [
        { timingLabel = "General Darshan"; openTime = "04:00"; closeTime = "22:00"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Morning Puja"; time = "04:00"; description = "Morning worship"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 51; description = "General donation at the temple." },
      ];
      contactInfo = { phone = ?"+91-151-2251788"; email = null; website = null };
      nonHinduRestriction = false;
      averageVisitDuration = 2;
      tags = ["karni mata","rajasthan","bikaner","rat temple","durga","unique","deshnoke"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(108, t108);

    let t109 : TempleTypes.Temple = {
      id = 109;
      name = "Rumtek Monastery (Gangtok)";
      deity = "Lord Buddha (Karma Kagyu sect)";
      state = "Sikkim";
      city = "Rumtek";
      district = "East Sikkim";
      address = "Rumtek, East Sikkim, Sikkim 737135";
      description = "The largest monastery in Sikkim and the seat of the Karma Kagyu lineage outside Tibet.";
      history = "Originally built in 1740 CE and rebuilt by the 16th Karmapa Rangjung Rigpe Dorje in 1961, housing rare Buddhist artifacts.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/a/a2/Rumtek_Monastery_Sikkim.jpg/800px-Rumtek_Monastery_Sikkim.jpg"];
      architectureStyle = "Tibetan Buddhist";
      darshanTimings = [
        { timingLabel = "General Visit"; openTime = "06:00"; closeTime = "18:00"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Morning Prayer"; time = "06:00"; description = "Morning Buddhist prayers"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 51; description = "Donation to the monastery." },
      ];
      contactInfo = { phone = null; email = null; website = null };
      nonHinduRestriction = false;
      averageVisitDuration = 3;
      tags = ["buddhist","sikkim","rumtek","karma kagyu","karmapa","monastery"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(109, t109);

    let t110 : TempleTypes.Temple = {
      id = 110;
      name = "Pemayangtse Monastery";
      deity = "Lord Buddha (Nyingma sect)";
      state = "Sikkim";
      city = "Pelling";
      district = "West Sikkim";
      address = "Pelling, West Sikkim, Sikkim 737113";
      description = "One of the oldest and most important monasteries in Sikkim with a stunning 7-storey wooden model of Guru Rinpoche's palace.";
      history = "Founded in 1705 CE by Lama Lhatsun Chenpo, one of the founders of the Sikkimese kingdom, a key Nyingma monastery.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/b/b3/Pemayangtse_Monastery_Sikkim.jpg/800px-Pemayangtse_Monastery_Sikkim.jpg"];
      architectureStyle = "Tibetan Buddhist (Nyingma)";
      darshanTimings = [
        { timingLabel = "General Visit"; openTime = "07:00"; closeTime = "17:00"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Morning Prayer"; time = "07:00"; description = "Morning Buddhist prayers"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 51; description = "Donation to the monastery." },
      ];
      contactInfo = { phone = null; email = null; website = null };
      nonHinduRestriction = false;
      averageVisitDuration = 3;
      tags = ["buddhist","sikkim","pelling","nyingma","guru rinpoche","monastery"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(110, t110);

    let t111 : TempleTypes.Temple = {
      id = 111;
      name = "Enchey Monastery (Gangtok)";
      deity = "Lord Buddha (Nyingma)";
      state = "Sikkim";
      city = "Gangtok";
      district = "East Sikkim";
      address = "Enchey Road, Gangtok, Sikkim 737101";
      description = "A 200-year-old Nyingma monastery perched on a hilltop in Gangtok, known for its annual Cham dance festival.";
      history = "Built in 1840 CE on a site blessed by Tantric master Druptob Karchen, home of the famous Chaam masked dance festival.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/c/c4/Enchey_Monastery_Sikkim.jpg/800px-Enchey_Monastery_Sikkim.jpg"];
      architectureStyle = "Tibetan Buddhist";
      darshanTimings = [
        { timingLabel = "General Visit"; openTime = "07:00"; closeTime = "18:00"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Morning Prayer"; time = "07:00"; description = "Morning Buddhist prayers"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 51; description = "Donation to the monastery." },
      ];
      contactInfo = { phone = null; email = null; website = null };
      nonHinduRestriction = false;
      averageVisitDuration = 2;
      tags = ["buddhist","sikkim","gangtok","nyingma","cham dance","monastery"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(111, t111);

    let t112 : TempleTypes.Temple = {
      id = 112;
      name = "Tashiding Monastery";
      deity = "Lord Buddha (Nyingma)";
      state = "Sikkim";
      city = "Tashiding";
      district = "West Sikkim";
      address = "Tashiding, West Sikkim, Sikkim 737111";
      description = "Considered the most sacred monastery in Sikkim, holding the Bumchu ritual with holy water every year.";
      history = "Founded in 1717 CE, the Bumchu (sacred vase) ritual held annually at Tashiding is believed to predict the year's fortune.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/d/d5/Tashiding_Monastery_Sikkim.jpg/800px-Tashiding_Monastery_Sikkim.jpg"];
      architectureStyle = "Tibetan Buddhist (Nyingma)";
      darshanTimings = [
        { timingLabel = "General Visit"; openTime = "07:00"; closeTime = "17:00"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Morning Prayer"; time = "07:00"; description = "Morning Buddhist prayers"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 51; description = "Donation to the monastery." },
      ];
      contactInfo = { phone = null; email = null; website = null };
      nonHinduRestriction = false;
      averageVisitDuration = 3;
      tags = ["buddhist","sikkim","tashiding","nyingma","bumchu","most sacred","monastery"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(112, t112);

    let t113 : TempleTypes.Temple = {
      id = 113;
      name = "Namchi Char Dham (South Sikkim)";
      deity = "Char Dham deities";
      state = "Sikkim";
      city = "Namchi";
      district = "South Sikkim";
      address = "Solophok Hill, Namchi, South Sikkim, Sikkim 737126";
      description = "A unique complex with replicas of all four Char Dham pilgrimage sites and the world's tallest Guru Padmasambhava statue.";
      history = "Built by the Sikkim government in 2004, it brings all major Hindu pilgrimage sites to one location in the Himalayan foothills.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/e/e6/Namchi_Char_Dham_Sikkim.jpg/800px-Namchi_Char_Dham_Sikkim.jpg"];
      architectureStyle = "Multi-style (replica)";
      darshanTimings = [
        { timingLabel = "General Darshan"; openTime = "08:00"; closeTime = "18:00"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Morning Puja"; time = "08:00"; description = "Morning worship"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 51; description = "General donation at the complex." },
      ];
      contactInfo = { phone = null; email = null; website = null };
      nonHinduRestriction = false;
      averageVisitDuration = 4;
      tags = ["char dham","sikkim","namchi","guru padmasambhava","south sikkim","modern"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(113, t113);

    let t114 : TempleTypes.Temple = {
      id = 114;
      name = "Brihadeeswarar Temple (Thanjavur)";
      deity = "Lord Brihadeeswara (Shiva)";
      state = "Tamil Nadu";
      city = "Thanjavur";
      district = "Thanjavur";
      address = "Brihadeeswara Road, Thanjavur, Tamil Nadu 613001";
      description = "A UNESCO World Heritage Site and masterpiece of Chola architecture with a 216-foot vimana (tower).";
      history = "Built by King Raja Raja Chola I in 1010 CE, the granite capstone alone weighs 80 tonnes and is a marvel of Dravidian engineering.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/f/f7/Brihadeeswarar_Temple_Thanjavur.jpg/800px-Brihadeeswarar_Temple_Thanjavur.jpg"];
      architectureStyle = "Dravidian (Chola)";
      darshanTimings = [
        { timingLabel = "General Darshan"; openTime = "06:00"; closeTime = "20:30"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Morning Puja"; time = "06:00"; description = "Morning worship"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 51; description = "General donation at the temple." },
      ];
      contactInfo = { phone = ?"+91-4362-274390"; email = null; website = null };
      nonHinduRestriction = false;
      averageVisitDuration = 4;
      tags = ["shiva","tamil nadu","thanjavur","chola","unesco","216 feet","raja raja"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(114, t114);

    let t115 : TempleTypes.Temple = {
      id = 115;
      name = "Ramanathaswamy Temple (Rameswaram)";
      deity = "Lord Ramanathaswamy (Shiva)";
      state = "Tamil Nadu";
      city = "Rameswaram";
      district = "Ramanathapuram";
      address = "Rameswaram Island, Ramanathapuram, Tamil Nadu 623526";
      description = "One of the Char Dham pilgrimage sites with the longest corridor in India (1220 meters) and 22 sacred wells.";
      history = "The Jyotirlinga here is said to have been installed by Lord Rama to atone for killing Ravana (a Brahmin) after the Lanka battle.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/a/a3/Ramanathaswamy_Temple_Rameswaram.jpg/800px-Ramanathaswamy_Temple_Rameswaram.jpg"];
      architectureStyle = "Dravidian";
      darshanTimings = [
        { timingLabel = "General Darshan"; openTime = "05:00"; closeTime = "21:00"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Morning Puja"; time = "05:00"; description = "Morning worship"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 51; description = "General donation at the temple." },
      ];
      contactInfo = { phone = ?"+91-4573-221223"; email = null; website = null };
      nonHinduRestriction = false;
      averageVisitDuration = 5;
      tags = ["shiva","tamil nadu","rameswaram","char dham","jyotirlinga","longest corridor","22 wells"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(115, t115);

    let t116 : TempleTypes.Temple = {
      id = 116;
      name = "Nataraja Temple (Chidambaram)";
      deity = "Lord Nataraja (Dancing Shiva)";
      state = "Tamil Nadu";
      city = "Chidambaram";
      district = "Cuddalore";
      address = "Chidambaram, Cuddalore District, Tamil Nadu 608001";
      description = "The world's only temple where Shiva is worshipped as Nataraja (cosmic dancer), one of the Pancha Bhuta Stalagams.";
      history = "Dating to the 2nd century CE, this massive temple complex covers 40 acres and was a major Chola religious center.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/b/b4/Nataraja_Temple_Chidambaram.jpg/800px-Nataraja_Temple_Chidambaram.jpg"];
      architectureStyle = "Dravidian (Chola)";
      darshanTimings = [
        { timingLabel = "General Darshan"; openTime = "05:30"; closeTime = "21:00"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Morning Puja"; time = "05:30"; description = "Morning worship"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 51; description = "General donation at the temple." },
      ];
      contactInfo = { phone = ?"+91-4144-220373"; email = null; website = null };
      nonHinduRestriction = false;
      averageVisitDuration = 4;
      tags = ["nataraja","tamil nadu","chidambaram","pancha bhuta","dancing shiva","chola","akasha lingam"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(116, t116);

    let t117 : TempleTypes.Temple = {
      id = 117;
      name = "Shore Temple (Mahabalipuram)";
      deity = "Lord Shiva and Vishnu";
      state = "Tamil Nadu";
      city = "Mahabalipuram";
      district = "Chengalpattu";
      address = "Mahabalipuram, Chengalpattu, Tamil Nadu 603104";
      description = "A UNESCO World Heritage Site of stunning stone temple on the seashore, the oldest structural stone temple in South India.";
      history = "Built in the early 8th century CE during the reign of Narasimhavarman II (Rajasimha) of the Pallava dynasty.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/c/c5/Shore_Temple_Mahabalipuram.jpg/800px-Shore_Temple_Mahabalipuram.jpg"];
      architectureStyle = "Dravidian (Pallava)";
      darshanTimings = [
        { timingLabel = "General Darshan"; openTime = "06:00"; closeTime = "18:00"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Morning Puja"; time = "06:00"; description = "Morning worship"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 50; description = "Entry fee / donation." },
      ];
      contactInfo = { phone = null; email = null; website = ?"https://asi.nic.in/mahabalipuram" };
      nonHinduRestriction = false;
      averageVisitDuration = 3;
      tags = ["shiva","vishnu","tamil nadu","mahabalipuram","pallava","unesco","shore","ancient"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(117, t117);

    let t118 : TempleTypes.Temple = {
      id = 118;
      name = "Bhadrachalam Temple";
      deity = "Lord Sita Ramachandra (Rama)";
      state = "Telangana";
      city = "Bhadrachalam";
      district = "Bhadradri Kothagudem";
      address = "Bhadrachalam, Bhadradri Kothagudem, Telangana 507111";
      description = "A major Vaishnava temple where Sita, Rama, and Lakshmana are worshipped, famous for Sri Rama Navami celebrations.";
      history = "The current temple was built in the 17th century CE by Gopanna (Bhakta Ramadas) who used state treasury funds and was imprisoned.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/d/d6/Bhadrachalam_Temple_Telangana.jpg/800px-Bhadrachalam_Temple_Telangana.jpg"];
      architectureStyle = "Dravidian";
      darshanTimings = [
        { timingLabel = "General Darshan"; openTime = "04:00"; closeTime = "21:00"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Morning Puja"; time = "04:00"; description = "Morning worship"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 51; description = "General donation at the temple." },
      ];
      contactInfo = { phone = ?"+91-8743-222333"; email = null; website = null };
      nonHinduRestriction = false;
      averageVisitDuration = 3;
      tags = ["rama","telangana","bhadrachalam","vaishnava","ramadas","godavari","rama navami"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(118, t118);

    let t119 : TempleTypes.Temple = {
      id = 119;
      name = "Birla Mandir (Hyderabad)";
      deity = "Lord Venkateswara (Vishnu)";
      state = "Telangana";
      city = "Hyderabad";
      district = "Hyderabad";
      address = "Hill Fort Road, Hyderabad, Telangana 500063";
      description = "A stunning white marble temple built atop a rocky hill, offering panoramic views of Hyderabad city.";
      history = "Built in 1976 by the Birla family using pure white Rajasthani marble, it blends South and North Indian architecture.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/e/e7/Birla_Mandir_Hyderabad.jpg/800px-Birla_Mandir_Hyderabad.jpg"];
      architectureStyle = "Nagara-Dravidian fusion (marble)";
      darshanTimings = [
        { timingLabel = "General Darshan"; openTime = "07:00"; closeTime = "21:00"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Morning Puja"; time = "07:00"; description = "Morning worship"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 51; description = "General donation at the temple." },
      ];
      contactInfo = { phone = ?"+91-40-23234285"; email = null; website = null };
      nonHinduRestriction = false;
      averageVisitDuration = 2;
      tags = ["vishnu","telangana","hyderabad","birla","white marble","hilltop","modern"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(119, t119);

    let t120 : TempleTypes.Temple = {
      id = 120;
      name = "Yadadri Lakshmi Narasimha Temple";
      deity = "Lord Lakshmi Narasimha (Vishnu)";
      state = "Telangana";
      city = "Yadadri";
      district = "Yadadri Bhuvanagiri";
      address = "Yadagirigutta, Yadadri Bhuvanagiri, Telangana 508115";
      description = "A recently renovated and expanded temple to Narasimha, one of the most visited temples in Telangana.";
      history = "An ancient temple where Narasimha appeared to saint Yadav Brugi, recently renovated with golden spires by the Telangana government.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/f/f8/Yadadri_Temple_Telangana.jpg/800px-Yadadri_Temple_Telangana.jpg"];
      architectureStyle = "Dravidian (renovated)";
      darshanTimings = [
        { timingLabel = "General Darshan"; openTime = "04:00"; closeTime = "21:00"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Morning Puja"; time = "04:00"; description = "Morning worship"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 51; description = "General donation at the temple." },
      ];
      contactInfo = { phone = ?"+91-8682-270222"; email = null; website = null };
      nonHinduRestriction = false;
      averageVisitDuration = 3;
      tags = ["narasimha","telangana","yadadri","vishnu","renovated","golden spires"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(120, t120);

    let t121 : TempleTypes.Temple = {
      id = 121;
      name = "Thousand Pillar Temple (Warangal)";
      deity = "Lord Shiva, Vishnu, and Surya";
      state = "Telangana";
      city = "Warangal";
      district = "Warangal";
      address = "Hanamkonda, Warangal, Telangana 506001";
      description = "An 11th-century temple with exquisite star-shaped platform and 1000 sculpted pillars in the Chalukyan style.";
      history = "Built in 1163 CE by King Rudra Deva of the Kakatiya dynasty, it survived the 14th-century Delhi Sultanate destruction.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/a/a4/Thousand_Pillar_Temple_Warangal.jpg/800px-Thousand_Pillar_Temple_Warangal.jpg"];
      architectureStyle = "Kakatiya (Chalukyan)";
      darshanTimings = [
        { timingLabel = "General Darshan"; openTime = "06:00"; closeTime = "18:00"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Morning Puja"; time = "06:00"; description = "Morning worship"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 51; description = "General donation at the temple." },
      ];
      contactInfo = { phone = null; email = null; website = null };
      nonHinduRestriction = false;
      averageVisitDuration = 3;
      tags = ["shiva","telangana","warangal","kakatiya","thousand pillars","chalukya","medieval"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(121, t121);

    let t122 : TempleTypes.Temple = {
      id = 122;
      name = "Vemulawada Raja Rajeshwara Temple";
      deity = "Lord Raja Rajeshwara (Shiva)";
      state = "Telangana";
      city = "Vemulawada";
      district = "Rajanna Sircilla";
      address = "Vemulawada, Rajanna Sircilla, Telangana 505302";
      description = "One of the most popular Shiva temples in Telangana with a distinctive architecture and enormous devotee footfall.";
      history = "An ancient temple believed to have been established in the 9th century CE, also known as Dakshina Kashi (Varanasi of the South).";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/b/b5/Vemulawada_Temple_Telangana.jpg/800px-Vemulawada_Temple_Telangana.jpg"];
      architectureStyle = "Dravidian";
      darshanTimings = [
        { timingLabel = "General Darshan"; openTime = "04:00"; closeTime = "21:00"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Morning Puja"; time = "04:00"; description = "Morning worship"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 51; description = "General donation at the temple." },
      ];
      contactInfo = { phone = null; email = null; website = null };
      nonHinduRestriction = false;
      averageVisitDuration = 3;
      tags = ["shiva","telangana","vemulawada","dakshina kashi","rajanna sircilla","pilgrimage"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(122, t122);

    let t123 : TempleTypes.Temple = {
      id = 123;
      name = "Tripura Sundari Temple (Udaipur)";
      deity = "Goddess Tripura Sundari (Shakti)";
      state = "Tripura";
      city = "Udaipur";
      district = "Gomati";
      address = "Udaipur, Gomati District, Tripura 799120";
      description = "One of the 51 Shakti Peethas in Tripura, the state goddess temple, originally known as Matabari.";
      history = "Built in 1501 CE by Maharaja Dhanya Manikya of Tripura, considered one of the 51 Shakti Peethas.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/c/c6/Tripura_Sundari_Temple.jpg/800px-Tripura_Sundari_Temple.jpg"];
      architectureStyle = "Bengal terracotta";
      darshanTimings = [
        { timingLabel = "General Darshan"; openTime = "05:30"; closeTime = "20:30"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Morning Puja"; time = "05:30"; description = "Morning worship"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 51; description = "General donation at the temple." },
      ];
      contactInfo = { phone = null; email = null; website = null };
      nonHinduRestriction = false;
      averageVisitDuration = 3;
      tags = ["shakti peetha","tripura","udaipur","tripura sundari","gomati","state goddess"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(123, t123);

    let t124 : TempleTypes.Temple = {
      id = 124;
      name = "Chaturdasha Devata Temple (Agartala)";
      deity = "Fourteen Hindu Deities";
      state = "Tripura";
      city = "Agartala";
      district = "West Tripura";
      address = "Old Agartala, Tripura 799012";
      description = "A unique temple dedicated to fourteen deities simultaneously, the royal temple of the Manikya dynasty.";
      history = "Built in 1501 CE, this was the royal temple of the Tripura kings of the Manikya dynasty, annually worshipped during Kharchi festival.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/d/d7/Chaturdasha_Temple_Agartala.jpg/800px-Chaturdasha_Temple_Agartala.jpg"];
      architectureStyle = "Bengal";
      darshanTimings = [
        { timingLabel = "General Darshan"; openTime = "06:00"; closeTime = "20:00"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Morning Puja"; time = "06:00"; description = "Morning worship"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 51; description = "General donation at the temple." },
      ];
      contactInfo = { phone = null; email = null; website = null };
      nonHinduRestriction = false;
      averageVisitDuration = 2;
      tags = ["tripura","agartala","fourteen gods","manikya","kharchi puja","royal"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(124, t124);

    let t125 : TempleTypes.Temple = {
      id = 125;
      name = "Unakoti Rock Carvings Temple";
      deity = "Lord Shiva (rock cut)";
      state = "Tripura";
      city = "Unakoti";
      district = "Unakoti";
      address = "Unakoti, Unakoti District, Tripura 799270";
      description = "Ancient rock-cut carvings of 99,99,999 Hindu deities carved into the hillside, a unique pilgrimage site in Tripura.";
      history = "Dating to the 7th-9th century CE, the name Unakoti means 'one less than a crore', referring to the number of carved images.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Unakoti_Rock_Carvings_Tripura.jpg/800px-Unakoti_Rock_Carvings_Tripura.jpg"];
      architectureStyle = "Rock cut (medieval)";
      darshanTimings = [
        { timingLabel = "General Visit"; openTime = "07:00"; closeTime = "17:00"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Morning Puja"; time = "07:00"; description = "Morning worship"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 20; description = "Entry fee / donation." },
      ];
      contactInfo = { phone = null; email = null; website = null };
      nonHinduRestriction = false;
      averageVisitDuration = 4;
      tags = ["shiva","tripura","unakoti","rock cut","ancient","archaeological","9th century"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(125, t125);

    let t126 : TempleTypes.Temple = {
      id = 126;
      name = "Kamalasagar Kali Temple";
      deity = "Goddess Kali";
      state = "Tripura";
      city = "Kamalasagar";
      district = "West Tripura";
      address = "Kamalasagar, West Tripura, Tripura 799010";
      description = "A Kali temple on the banks of Kamalasagar Lake, with the Bangladesh border visible from the temple premises.";
      history = "An ancient Kali temple that once stood at the edge of the Tripura kingdom's border, now at the India-Bangladesh border.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/f/f9/Kamalasagar_Kali_Temple.jpg/800px-Kamalasagar_Kali_Temple.jpg"];
      architectureStyle = "Bengal";
      darshanTimings = [
        { timingLabel = "General Darshan"; openTime = "06:00"; closeTime = "18:00"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Morning Puja"; time = "06:00"; description = "Morning worship"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 51; description = "General donation at the temple." },
      ];
      contactInfo = { phone = null; email = null; website = null };
      nonHinduRestriction = false;
      averageVisitDuration = 2;
      tags = ["kali","tripura","kamalasagar","border temple","west tripura","lake"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(126, t126);

    let t127 : TempleTypes.Temple = {
      id = 127;
      name = "Neermahal Water Palace Temple";
      deity = "Various Hindu deities";
      state = "Tripura";
      city = "Melaghar";
      district = "Sepahijala";
      address = "Rudrasagar Lake, Melaghar, Sepahijala, Tripura 799115";
      description = "A beautiful palace-temple complex built on Rudrasagar Lake, combining Hindu and Muslim architectural styles.";
      history = "Built between 1930-1938 CE by Maharaja Bir Bikram Kishore Manikya, this water palace served as a summer residence with temple areas.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/a/a5/Neermahal_Water_Palace_Tripura.jpg/800px-Neermahal_Water_Palace_Tripura.jpg"];
      architectureStyle = "Indo-Saracenic";
      darshanTimings = [
        { timingLabel = "General Visit"; openTime = "08:00"; closeTime = "17:00"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Morning Puja"; time = "08:00"; description = "Morning worship"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 50; description = "Entry fee / donation." },
      ];
      contactInfo = { phone = null; email = null; website = null };
      nonHinduRestriction = false;
      averageVisitDuration = 3;
      tags = ["tripura","neermahal","water palace","rudrasagar","manikya","lake","palace"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(127, t127);

    let t128 : TempleTypes.Temple = {
      id = 128;
      name = "Ram Temple (Ayodhya)";
      deity = "Lord Ram Lalla";
      state = "Uttar Pradesh";
      city = "Ayodhya";
      district = "Ayodhya";
      address = "Ram Janmabhoomi, Ayodhya, Uttar Pradesh 224123";
      description = "The birthplace of Lord Rama, one of the holiest sites in Hinduism, with a newly built grand temple inaugurated in 2024.";
      history = "The Ram Janmabhoomi site has been revered for millennia as Lord Rama's birthplace, the new temple consecrated on January 22, 2024.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/b/b6/Ram_Mandir_Ayodhya.jpg/800px-Ram_Mandir_Ayodhya.jpg"];
      architectureStyle = "Nagara (Nagar style)";
      darshanTimings = [
        { timingLabel = "General Darshan"; openTime = "07:00"; closeTime = "21:00"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Morning Puja"; time = "07:00"; description = "Morning worship"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 101; description = "General donation at the temple." },
      ];
      contactInfo = { phone = null; email = null; website = ?"https://srjbtkshetra.org" };
      nonHinduRestriction = false;
      averageVisitDuration = 4;
      tags = ["rama","uttar pradesh","ayodhya","ram lalla","janmabhoomi","2024","new temple"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(128, t128);

    let t129 : TempleTypes.Temple = {
      id = 129;
      name = "Banke Bihari Temple (Vrindavan)";
      deity = "Lord Banke Bihari (Krishna)";
      state = "Uttar Pradesh";
      city = "Vrindavan";
      district = "Mathura";
      address = "Vrindavan, Mathura District, Uttar Pradesh 281121";
      description = "One of the most famous Krishna temples in Vrindavan, where the black idol of Bihari Ji is worshipped with extraordinary devotion.";
      history = "Established in 1864 CE by the descendants of saint Swami Haridas, the idol was revealed to Swami Haridas in the 16th century.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/c/c7/Banke_Bihari_Temple_Vrindavan.jpg/800px-Banke_Bihari_Temple_Vrindavan.jpg"];
      architectureStyle = "Rajasthani";
      darshanTimings = [
        { timingLabel = "General Darshan"; openTime = "07:45"; closeTime = "21:00"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Morning Puja"; time = "07:45"; description = "Morning worship"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 51; description = "General donation at the temple." },
      ];
      contactInfo = { phone = null; email = null; website = null };
      nonHinduRestriction = false;
      averageVisitDuration = 3;
      tags = ["krishna","uttar pradesh","vrindavan","mathura","banke bihari","haridas","vaishnava"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(129, t129);

    let t130 : TempleTypes.Temple = {
      id = 130;
      name = "Krishna Janmabhoomi Temple (Mathura)";
      deity = "Lord Krishna";
      state = "Uttar Pradesh";
      city = "Mathura";
      district = "Mathura";
      address = "Krishna Janmabhoomi, Mathura, Uttar Pradesh 281001";
      description = "The birthplace of Lord Krishna, one of the most sacred sites in Vaishnavism and Hinduism.";
      history = "The current complex was built next to the 17th century Shahi Idgah mosque, marking where Krishna was born in a prison cell.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/d/d8/Krishna_Janmabhoomi_Mathura.jpg/800px-Krishna_Janmabhoomi_Mathura.jpg"];
      architectureStyle = "Nagara";
      darshanTimings = [
        { timingLabel = "General Darshan"; openTime = "05:00"; closeTime = "21:00"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Morning Puja"; time = "05:00"; description = "Morning worship"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 51; description = "General donation at the temple." },
      ];
      contactInfo = { phone = ?"+91-565-2403151"; email = null; website = null };
      nonHinduRestriction = false;
      averageVisitDuration = 3;
      tags = ["krishna","uttar pradesh","mathura","janmabhoomi","birthplace","vaishnava","pilgrim"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(130, t130);

    let t131 : TempleTypes.Temple = {
      id = 131;
      name = "Vindhyavasini Temple (Mirzapur)";
      deity = "Goddess Vindhyavasini (Shakti)";
      state = "Uttar Pradesh";
      city = "Vindhyachal";
      district = "Mirzapur";
      address = "Vindhyachal, Mirzapur, Uttar Pradesh 231307";
      description = "A major Shakti Peetha on the Vindhya mountains on the banks of the Ganga, one of the most visited in UP.";
      history = "One of the 51 Shakti Peethas, the goddess chose to reside in the Vindhya mountains, referenced in the Devi Bhagavata Purana.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/e/e9/Vindhyavasini_Temple_Mirzapur.jpg/800px-Vindhyavasini_Temple_Mirzapur.jpg"];
      architectureStyle = "Nagara";
      darshanTimings = [
        { timingLabel = "General Darshan"; openTime = "05:00"; closeTime = "21:00"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Morning Puja"; time = "05:00"; description = "Morning worship"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 51; description = "General donation at the temple." },
      ];
      contactInfo = { phone = null; email = null; website = null };
      nonHinduRestriction = false;
      averageVisitDuration = 3;
      tags = ["shakti peetha","uttar pradesh","mirzapur","vindhyavasini","ganga","vindhya"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(131, t131);

    let t132 : TempleTypes.Temple = {
      id = 132;
      name = "Badrinath Temple (Chamoli)";
      deity = "Lord Badrinath (Vishnu)";
      state = "Uttarakhand";
      city = "Badrinath";
      district = "Chamoli";
      address = "Badrinath, Chamoli, Uttarakhand 246422";
      description = "One of the Char Dham sites and Divya Desams, a high-altitude Vishnu temple between the Nar and Narayan peaks.";
      history = "Established by Adi Shankaracharya in the 8th century CE, the temple is open only 6 months a year due to Himalayan winters.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/f/f0/Badrinath_Temple_Uttarakhand.jpg/800px-Badrinath_Temple_Uttarakhand.jpg"];
      architectureStyle = "Himalayan (Garhwal)";
      darshanTimings = [
        { timingLabel = "General Darshan"; openTime = "04:30"; closeTime = "21:00"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Maha Abhishek"; time = "04:30"; description = "Morning ritual"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 101; description = "General donation at the temple." },
      ];
      contactInfo = { phone = ?"+91-1381-222232"; email = null; website = null };
      nonHinduRestriction = false;
      averageVisitDuration = 4;
      tags = ["vishnu","uttarakhand","badrinath","char dham","divya desam","himalaya","adi shankaracharya"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(132, t132);

    let t133 : TempleTypes.Temple = {
      id = 133;
      name = "Gangotri Temple (Uttarkashi)";
      deity = "Goddess Ganga Devi";
      state = "Uttarakhand";
      city = "Gangotri";
      district = "Uttarkashi";
      address = "Gangotri, Uttarkashi, Uttarakhand 249193";
      description = "One of the Char Dham sites at 3048m altitude, where the Ganges is worshipped at the point near its source glacier.";
      history = "The temple was built in the 18th century CE by Amar Singh Thapa, the Gorkha commander, near the source of the holy Ganges.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/a/a6/Gangotri_Temple_Uttarakhand.jpg/800px-Gangotri_Temple_Uttarakhand.jpg"];
      architectureStyle = "Himalayan";
      darshanTimings = [
        { timingLabel = "General Darshan"; openTime = "06:15"; closeTime = "14:00"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Morning Puja"; time = "06:15"; description = "Morning worship"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 51; description = "General donation at the temple." },
      ];
      contactInfo = { phone = null; email = null; website = null };
      nonHinduRestriction = false;
      averageVisitDuration = 3;
      tags = ["ganga","uttarakhand","gangotri","char dham","himalaya","river source","gangotri glacier"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(133, t133);

    let t134 : TempleTypes.Temple = {
      id = 134;
      name = "Yamunotri Temple (Uttarkashi)";
      deity = "Goddess Yamuna Devi";
      state = "Uttarakhand";
      city = "Yamunotri";
      district = "Uttarkashi";
      address = "Yamunotri, Uttarkashi, Uttarakhand 249141";
      description = "One of the Char Dham sites at the source of the Yamuna River, accessible via a 6km trek from Janki Chatti.";
      history = "The temple was built by Maharani Guleria of Jaipur in the 19th century CE near hot springs and the Yamuna glacier.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/b/b7/Yamunotri_Temple_Uttarakhand.jpg/800px-Yamunotri_Temple_Uttarakhand.jpg"];
      architectureStyle = "Himalayan";
      darshanTimings = [
        { timingLabel = "General Darshan"; openTime = "06:00"; closeTime = "20:00"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Morning Puja"; time = "06:00"; description = "Morning worship"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 51; description = "General donation at the temple." },
      ];
      contactInfo = { phone = null; email = null; website = null };
      nonHinduRestriction = false;
      averageVisitDuration = 5;
      tags = ["yamuna","uttarakhand","yamunotri","char dham","himalaya","trek","river source"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(134, t134);

    let t135 : TempleTypes.Temple = {
      id = 135;
      name = "Har Ki Pauri Ghat (Haridwar)";
      deity = "Lord Vishnu and Goddess Ganga";
      state = "Uttarakhand";
      city = "Haridwar";
      district = "Haridwar";
      address = "Har Ki Pauri, Haridwar, Uttarakhand 249401";
      description = "The most sacred ghat in Haridwar where Ganga aarti at sunset attracts thousands daily, hosting the Kumbh Mela.";
      history = "Believed to have been created by King Vikramaditya in memory of his brother Bhartrihari, who meditated here until death.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/c/c8/Har_Ki_Pauri_Haridwar.jpg/800px-Har_Ki_Pauri_Haridwar.jpg"];
      architectureStyle = "Sacred Ghat Complex";
      darshanTimings = [
        { timingLabel = "General Visit"; openTime = "05:00"; closeTime = "22:00"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Ganga Aarti"; time = "18:00"; description = "Evening Ganga Aarti at the ghat"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 51; description = "General donation at the ghat." },
      ];
      contactInfo = { phone = null; email = null; website = null };
      nonHinduRestriction = false;
      averageVisitDuration = 3;
      tags = ["ganga","uttarakhand","haridwar","aarti","kumbh mela","ghat","vishnu"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(135, t135);

    let t136 : TempleTypes.Temple = {
      id = 136;
      name = "Dakshineswar Kali Temple (Kolkata)";
      deity = "Goddess Bhavatarini Kali";
      state = "West Bengal";
      city = "Kolkata";
      district = "North 24 Parganas";
      address = "Dakshineswar, Kolkata, West Bengal 700076";
      description = "A famous Kali temple on the banks of Hooghly River, where Ramakrishna Paramahamsa served as a priest.";
      history = "Built in 1855 CE by Rani Rashmoni, the temple became the spiritual center for Ramakrishna Paramahamsa's mystic experiences.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/d/d9/Dakshineswar_Kali_Temple.jpg/800px-Dakshineswar_Kali_Temple.jpg"];
      architectureStyle = "Bengal (Navaratna)";
      darshanTimings = [
        { timingLabel = "General Darshan"; openTime = "06:00"; closeTime = "20:30"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Morning Puja"; time = "06:00"; description = "Morning worship"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 51; description = "General donation at the temple." },
      ];
      contactInfo = { phone = ?"+91-33-25643831"; email = null; website = ?"https://dakshineswartemple.org" };
      nonHinduRestriction = false;
      averageVisitDuration = 3;
      tags = ["kali","west bengal","kolkata","ramakrishna","hooghly","rani rashmoni"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(136, t136);

    let t137 : TempleTypes.Temple = {
      id = 137;
      name = "Kalighat Temple (Kolkata)";
      deity = "Goddess Kali (Kalighat Kali)";
      state = "West Bengal";
      city = "Kolkata";
      district = "Kolkata";
      address = "Kalighat, Kolkata, West Bengal 700026";
      description = "One of the 51 Shakti Peethas where the right toe of Goddess Sati fell, and the deity who gave Kolkata its name.";
      history = "One of the oldest temples in Kolkata, the present structure was built in 1809 CE; the name Kalighat became Calcutta (Kolkata).";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/e/e0/Kalighat_Temple_Kolkata.jpg/800px-Kalighat_Temple_Kolkata.jpg"];
      architectureStyle = "Bengal Aat-chala";
      darshanTimings = [
        { timingLabel = "General Darshan"; openTime = "05:00"; closeTime = "22:00"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Morning Puja"; time = "05:00"; description = "Morning worship"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 51; description = "General donation at the temple." },
      ];
      contactInfo = { phone = ?"+91-33-24793674"; email = null; website = null };
      nonHinduRestriction = false;
      averageVisitDuration = 2;
      tags = ["kali","shakti peetha","west bengal","kolkata","kolkata origin","aat-chala"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(137, t137);

    let t138 : TempleTypes.Temple = {
      id = 138;
      name = "Belur Math (Howrah)";
      deity = "Ramakrishna Paramahamsa (Universal Divinity)";
      state = "West Bengal";
      city = "Howrah";
      district = "Howrah";
      address = "Belur, Howrah, West Bengal 711202";
      description = "The global headquarters of the Ramakrishna Mission, with a temple blending Hindu, Christian, and Islamic architectural styles.";
      history = "Established by Swami Vivekananda in 1897 CE on the banks of the Ganges, the main temple was completed in 1938.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/f/f1/Belur_Math_Howrah.jpg/800px-Belur_Math_Howrah.jpg"];
      architectureStyle = "Indo-Saracenic fusion";
      darshanTimings = [
        { timingLabel = "General Visit"; openTime = "06:30"; closeTime = "20:00"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Morning Puja"; time = "06:30"; description = "Morning worship"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 51; description = "Donation to Ramakrishna Mission." },
      ];
      contactInfo = { phone = ?"+91-33-26549700"; email = null; website = ?"https://belurmath.org" };
      nonHinduRestriction = false;
      averageVisitDuration = 3;
      tags = ["ramakrishna","west bengal","howrah","vivekananda","mission","universal","ganga"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(138, t138);

    let t139 : TempleTypes.Temple = {
      id = 139;
      name = "Tarakeswar Temple (Hooghly)";
      deity = "Lord Tarakeswar (Shiva)";
      state = "West Bengal";
      city = "Tarakeswar";
      district = "Hooghly";
      address = "Tarakeswar, Hooghly District, West Bengal 712410";
      description = "A major Shiva pilgrimage site in West Bengal, visited by millions during Shravan month and Charak festival.";
      history = "An ancient temple where Lord Shiva appeared to King Bishnudas of Kalna in a dream and led him to the self-manifested lingam.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/a/a2/Tarakeswar_Temple_Bengal.jpg/800px-Tarakeswar_Temple_Bengal.jpg"];
      architectureStyle = "Bengal Aat-chala";
      darshanTimings = [
        { timingLabel = "General Darshan"; openTime = "05:00"; closeTime = "21:00"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Morning Puja"; time = "05:00"; description = "Morning worship"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 51; description = "General donation at the temple." },
      ];
      contactInfo = { phone = ?"+91-3212-255045"; email = null; website = null };
      nonHinduRestriction = false;
      averageVisitDuration = 2;
      tags = ["shiva","west bengal","hooghly","tarakeswar","shravan","charak","pilgrimage"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(139, t139);

    let t140 : TempleTypes.Temple = {
      id = 140;
      name = "Bishnupur Terracotta Temples";
      deity = "Lord Madan Mohan (Krishna)";
      state = "West Bengal";
      city = "Bishnupur";
      district = "Bankura";
      address = "Bishnupur, Bankura District, West Bengal 722122";
      description = "A group of 17th-18th century terracotta temples of unique Bengal Sultanate style, a UNESCO tentative list site.";
      history = "Built by the Malla kings of Bishnupur from the 17th century using locally made terracotta bricks instead of stone.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/b/b3/Bishnupur_Terracotta_Temple.jpg/800px-Bishnupur_Terracotta_Temple.jpg"];
      architectureStyle = "Bengal terracotta";
      darshanTimings = [
        { timingLabel = "General Visit"; openTime = "06:00"; closeTime = "18:00"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Morning Puja"; time = "06:00"; description = "Morning worship"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 50; description = "Entry fee / donation." },
      ];
      contactInfo = { phone = null; email = null; website = null };
      nonHinduRestriction = false;
      averageVisitDuration = 4;
      tags = ["krishna","west bengal","bishnupur","bankura","terracotta","malla kings","heritage"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(140, t140);

    let t141 : TempleTypes.Temple = {
      id = 141;
      name = "Akshardham Temple (Delhi)";
      deity = "Lord Swaminarayan (Akshar Purushottam)";
      state = "Delhi";
      city = "New Delhi";
      district = "New Delhi";
      address = "NH-24, New Delhi 110092";
      description = "The world's largest Hindu temple complex by area (Guinness record), with exhibitions on 10,000 years of Indian culture.";
      history = "Built by BAPS Swaminarayan Sanstha in 2005 CE, crafted by 11,000 artisans using pink sandstone and white marble.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/c/c4/Akshardham_Delhi.jpg/800px-Akshardham_Delhi.jpg"];
      architectureStyle = "Rajput-Chalukya fusion";
      darshanTimings = [
        { timingLabel = "General Darshan"; openTime = "09:30"; closeTime = "20:00"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Morning Puja"; time = "09:30"; description = "Morning worship"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 170; description = "Entry fee for exhibitions." },
      ];
      contactInfo = { phone = ?"+91-11-43442344"; email = null; website = ?"https://akshardham.com" };
      nonHinduRestriction = false;
      averageVisitDuration = 5;
      tags = ["swaminarayan","delhi","guinness record","baps","akshardham","largest temple","modern"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(141, t141);

    let t142 : TempleTypes.Temple = {
      id = 142;
      name = "Lotus Temple (Bahai House of Worship)";
      deity = "Universal Divinity (Bahai)";
      state = "Delhi";
      city = "New Delhi";
      district = "South Delhi";
      address = "Bahapur, New Delhi, Delhi 110019";
      description = "An architectural marvel shaped like a lotus flower, open to people of all faiths for prayer and meditation.";
      history = "Completed in 1986 CE, designed by architect Fariborz Sahba, it has won numerous architectural awards and hosts 4 million visitors annually.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/d/d5/Lotus_Temple_Delhi.jpg/800px-Lotus_Temple_Delhi.jpg"];
      architectureStyle = "Modern (Bahai)";
      darshanTimings = [
        { timingLabel = "General Visit"; openTime = "09:00"; closeTime = "17:30"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Silent Meditation"; time = "09:00"; description = "Open meditation for all faiths"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 0; description = "Free entry, donations welcome." },
      ];
      contactInfo = { phone = ?"+91-11-26444029"; email = null; website = null };
      nonHinduRestriction = false;
      averageVisitDuration = 2;
      tags = ["bahai","delhi","lotus","all faiths","architecture","award-winning","1986"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(142, t142);

    let t143 : TempleTypes.Temple = {
      id = 143;
      name = "Birla Mandir Lakshmi Narayan (Delhi)";
      deity = "Lord Lakshmi Narayan (Vishnu and Lakshmi)";
      state = "Delhi";
      city = "New Delhi";
      district = "New Delhi";
      address = "Mandir Marg, New Delhi, Delhi 110001";
      description = "The first large Hindu temple built in Delhi after independence, inaugurated by Mahatma Gandhi on the condition it be open to all castes.";
      history = "Built by the Birla family in 1938 CE and inaugurated by Mahatma Gandhi, who insisted on open access for all including Dalits.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/e/e6/Birla_Mandir_Delhi.jpg/800px-Birla_Mandir_Delhi.jpg"];
      architectureStyle = "Orissan-Rajput";
      darshanTimings = [
        { timingLabel = "General Darshan"; openTime = "06:00"; closeTime = "21:00"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Morning Puja"; time = "06:00"; description = "Morning worship"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 51; description = "General donation at the temple." },
      ];
      contactInfo = { phone = ?"+91-11-23363241"; email = null; website = null };
      nonHinduRestriction = false;
      averageVisitDuration = 2;
      tags = ["vishnu","delhi","birla","lakshmi narayan","gandhi","1938","all castes"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(143, t143);

    let t144 : TempleTypes.Temple = {
      id = 144;
      name = "Chattarpur Temple (Delhi)";
      deity = "Goddess Katyayani Mata (Durga)";
      state = "Delhi";
      city = "New Delhi";
      district = "South West Delhi";
      address = "Mehrauli-Gurgaon Road, New Delhi, Delhi 110074";
      description = "One of the largest temple complexes in Delhi, with multiple shrines spread across 70 acres dedicated mainly to Mata Katyayani.";
      history = "Built by devotee Nagpal Baba in 1974 CE, it has grown into a massive complex with over 20 temples, especially popular during Navratri.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/f/f7/Chattarpur_Temple_Delhi.jpg/800px-Chattarpur_Temple_Delhi.jpg"];
      architectureStyle = "South Indian Dravidian";
      darshanTimings = [
        { timingLabel = "General Darshan"; openTime = "04:00"; closeTime = "22:00"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Morning Puja"; time = "04:00"; description = "Morning worship"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 51; description = "General donation at the temple." },
      ];
      contactInfo = { phone = ?"+91-11-26806008"; email = null; website = null };
      nonHinduRestriction = false;
      averageVisitDuration = 3;
      tags = ["durga","delhi","chattarpur","katyayani","navratri","large complex","south delhi"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(144, t144);

    let t145 : TempleTypes.Temple = {
      id = 145;
      name = "ISKCON Temple Delhi (Radha Parthasarathi)";
      deity = "Radha Parthasarathi (Krishna)";
      state = "Delhi";
      city = "New Delhi";
      district = "South Delhi";
      address = "Sant Nagar, East of Kailash, New Delhi, Delhi 110065";
      description = "One of the largest ISKCON temples in the world, a stunning white marble structure dedicated to Krishna.";
      history = "Built by ISKCON in 1998 CE, the temple showcases classical Rajasthani architecture and hosts grand Janmashtami celebrations.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/a/a3/ISKCON_Temple_Delhi.jpg/800px-ISKCON_Temple_Delhi.jpg"];
      architectureStyle = "Rajasthani marble";
      darshanTimings = [
        { timingLabel = "General Darshan"; openTime = "04:30"; closeTime = "21:00"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Mangala Arati"; time = "04:30"; description = "Morning arati"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 101; description = "Donation to ISKCON temple." },
      ];
      contactInfo = { phone = ?"+91-11-26237290"; email = null; website = ?"https://iskcondelhi.com" };
      nonHinduRestriction = false;
      averageVisitDuration = 3;
      tags = ["krishna","delhi","iskcon","radha","marble","janmashtami","1998"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(145, t145);

    let t146 : TempleTypes.Temple = {
      id = 146;
      name = "Raghunath Temple (Jammu)";
      deity = "Lord Raghunath (Rama)";
      state = "Jammu & Kashmir";
      city = "Jammu";
      district = "Jammu";
      address = "Raghunath Bazaar, Jammu, Jammu & Kashmir 180001";
      description = "One of the largest temple complexes in North India with 7 temples in one compound, housing numerous idols from all major Hindu deities.";
      history = "Built over 1846-1860 CE by Maharaja Gulab Singh and Ranbir Singh, it features the largest temple complex in northern India.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/b/b4/Raghunath_Temple_Jammu.jpg/800px-Raghunath_Temple_Jammu.jpg"];
      architectureStyle = "North Indian Nagara";
      darshanTimings = [
        { timingLabel = "General Darshan"; openTime = "06:00"; closeTime = "20:00"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Morning Puja"; time = "06:00"; description = "Morning worship"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 51; description = "General donation at the temple." },
      ];
      contactInfo = { phone = ?"+91-191-2573700"; email = null; website = null };
      nonHinduRestriction = false;
      averageVisitDuration = 3;
      tags = ["rama","jammu kashmir","jammu","raghunath","dogra","largest complex","north india"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(146, t146);

    let t147 : TempleTypes.Temple = {
      id = 147;
      name = "Shankaracharya Temple (Srinagar)";
      deity = "Lord Shiva";
      state = "Jammu & Kashmir";
      city = "Srinagar";
      district = "Srinagar";
      address = "Shankaracharya Hill, Srinagar, Jammu & Kashmir 190001";
      description = "An ancient Shiva temple atop Shankaracharya Hill at 1100 feet, offering panoramic views of Srinagar and Dal Lake.";
      history = "The temple dates back to 371 BCE according to legend, renovated by Emperor Ashoka's son Jaluka, a historically significant site.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/c/c5/Shankaracharya_Temple_Srinagar.jpg/800px-Shankaracharya_Temple_Srinagar.jpg"];
      architectureStyle = "Kashmiri (ancient)";
      darshanTimings = [
        { timingLabel = "General Darshan"; openTime = "07:00"; closeTime = "17:00"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Morning Puja"; time = "07:00"; description = "Morning worship"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 51; description = "General donation at the temple." },
      ];
      contactInfo = { phone = null; email = null; website = null };
      nonHinduRestriction = false;
      averageVisitDuration = 3;
      tags = ["shiva","jammu kashmir","srinagar","hilltop","dal lake","ancient","kashmiri"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(147, t147);

    let t148 : TempleTypes.Temple = {
      id = 148;
      name = "Bahu Fort Temple (Jammu)";
      deity = "Goddess Kali Mata (Bahu Kali)";
      state = "Jammu & Kashmir";
      city = "Jammu";
      district = "Jammu";
      address = "Bahu Fort, Jammu, Jammu & Kashmir 180004";
      description = "An ancient fort temple dedicated to Goddess Kali inside the historic Bahu Fort on a cliff above the Tawi River.";
      history = "The Bahu Fort is over 3000 years old, built by Raja Bahu Lochan; the Kali temple inside is a major pilgrimage site.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/d/d6/Bahu_Fort_Temple_Jammu.jpg/800px-Bahu_Fort_Temple_Jammu.jpg"];
      architectureStyle = "Dogra fort temple";
      darshanTimings = [
        { timingLabel = "General Darshan"; openTime = "05:00"; closeTime = "20:00"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Morning Puja"; time = "05:00"; description = "Morning worship"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 51; description = "General donation at the temple." },
      ];
      contactInfo = { phone = null; email = null; website = null };
      nonHinduRestriction = false;
      averageVisitDuration = 2;
      tags = ["kali","jammu kashmir","jammu","bahu fort","kali mata","tawi river","ancient"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(148, t148);

    let t149 : TempleTypes.Temple = {
      id = 149;
      name = "Kheer Bhawani Temple (Ganderbal)";
      deity = "Goddess Kheer Bhawani (Shakti)";
      state = "Jammu & Kashmir";
      city = "Tulmul";
      district = "Ganderbal";
      address = "Tulmul, Ganderbal, Jammu & Kashmir 191201";
      description = "A sacred Shakti temple in a spring that changes color to predict future events, a major pilgrimage for Kashmiri Pandits.";
      history = "Dedicated to Goddess Kheer Bhawani, the spring is said to change color - white to red - as an omen of bad times ahead.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/e/e7/Kheer_Bhawani_Temple_Kashmir.jpg/800px-Kheer_Bhawani_Temple_Kashmir.jpg"];
      architectureStyle = "Kashmiri";
      darshanTimings = [
        { timingLabel = "General Darshan"; openTime = "06:00"; closeTime = "18:00"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Morning Puja"; time = "06:00"; description = "Morning worship"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 51; description = "General donation at the temple." },
      ];
      contactInfo = { phone = null; email = null; website = null };
      nonHinduRestriction = false;
      averageVisitDuration = 2;
      tags = ["shakti","jammu kashmir","ganderbal","kashmiri pandits","color-changing spring","kheer"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(149, t149);

    let t150 : TempleTypes.Temple = {
      id = 150;
      name = "Hemis Monastery (Leh)";
      deity = "Lord Buddha (Drukpa Kagyu)";
      state = "Ladakh";
      city = "Hemis";
      district = "Leh";
      address = "Hemis, Leh District, Ladakh 194401";
      description = "The largest and wealthiest monastery in Ladakh, famous for its annual Hemis Festival with giant thangka display.";
      history = "Founded in 1630 CE by Stagsang Raspa Nawang Gyatso under Ladakhi King Sengge Namgyal, known for rare manuscripts.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/f/f8/Hemis_Monastery_Ladakh.jpg/800px-Hemis_Monastery_Ladakh.jpg"];
      architectureStyle = "Tibetan Buddhist (Drukpa)";
      darshanTimings = [
        { timingLabel = "General Visit"; openTime = "08:00"; closeTime = "17:00"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Morning Prayer"; time = "08:00"; description = "Morning Buddhist prayers"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 50; description = "Entry fee / donation." },
      ];
      contactInfo = { phone = null; email = null; website = null };
      nonHinduRestriction = false;
      averageVisitDuration = 3;
      tags = ["buddhist","ladakh","hemis","drukpa kagyu","festival","thangka","largest monastery"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(150, t150);

    let t151 : TempleTypes.Temple = {
      id = 151;
      name = "Thiksey Monastery (Leh)";
      deity = "Lord Buddha (Gelug sect)";
      state = "Ladakh";
      city = "Thiksey";
      district = "Leh";
      address = "Thiksey, Leh District, Ladakh 194401";
      description = "A 12-story hilltop monastery resembling the Potala Palace in Tibet, with an impressive 15-meter Maitreya Buddha statue.";
      history = "Founded in the 15th century CE, it is one of the most impressive monastery complexes in Ladakh with 500 monks.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/a/a4/Thiksey_Monastery_Ladakh.jpg/800px-Thiksey_Monastery_Ladakh.jpg"];
      architectureStyle = "Tibetan Buddhist (Gelug)";
      darshanTimings = [
        { timingLabel = "General Visit"; openTime = "07:00"; closeTime = "18:00"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Morning Prayer"; time = "07:00"; description = "Morning Buddhist prayers"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 50; description = "Entry fee / donation." },
      ];
      contactInfo = { phone = null; email = null; website = null };
      nonHinduRestriction = false;
      averageVisitDuration = 3;
      tags = ["buddhist","ladakh","thiksey","gelug","maitreya buddha","potala","12 stories"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(151, t151);

    let t152 : TempleTypes.Temple = {
      id = 152;
      name = "Diskit Monastery (Nubra Valley)";
      deity = "Lord Buddha (Gelug sect)";
      state = "Ladakh";
      city = "Diskit";
      district = "Leh";
      address = "Diskit Village, Nubra Valley, Leh, Ladakh 194401";
      description = "The oldest and largest monastery in Nubra Valley, famous for its 32-meter Maitreya Buddha statue with views of sand dunes.";
      history = "Founded in the 14th century CE by Changzem Tserab Zangpo, a disciple of Tsongkhapa, the founder of the Gelug sect.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/c/c6/Diskit_Monastery_Nubra.jpg/800px-Diskit_Monastery_Nubra.jpg"];
      architectureStyle = "Tibetan Buddhist (Gelug)";
      darshanTimings = [
        { timingLabel = "General Visit"; openTime = "08:00"; closeTime = "17:00"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Morning Prayer"; time = "08:00"; description = "Morning Buddhist prayers"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 50; description = "Entry fee / donation." },
      ];
      contactInfo = { phone = null; email = null; website = null };
      nonHinduRestriction = false;
      averageVisitDuration = 3;
      tags = ["buddhist","ladakh","diskit","nubra valley","maitreya","gelug","sand dunes"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(152, t152);

    let t153 : TempleTypes.Temple = {
      id = 153;
      name = "Spituk Monastery (Leh)";
      deity = "Lord Buddha (Gelug sect) and Mahakala";
      state = "Ladakh";
      city = "Spituk";
      district = "Leh";
      address = "Spituk, Leh District, Ladakh 194101";
      description = "A 1000-year-old monastery near Leh airport, famous for the annual Spituk Gustor festival with Cham mask dances.";
      history = "Founded in the 11th century CE, the monastery houses a masked idol of Mahakala that is unveiled only once a year.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/b/b5/Spituk_Monastery_Ladakh.jpg/800px-Spituk_Monastery_Ladakh.jpg"];
      architectureStyle = "Tibetan Buddhist (Gelug)";
      darshanTimings = [
        { timingLabel = "General Visit"; openTime = "07:00"; closeTime = "18:00"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Morning Prayer"; time = "07:00"; description = "Morning Buddhist prayers"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 50; description = "Entry fee / donation." },
      ];
      contactInfo = { phone = null; email = null; website = null };
      nonHinduRestriction = false;
      averageVisitDuration = 2;
      tags = ["buddhist","ladakh","spituk","gelug","mahakala","gustor festival","1000 years"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(153, t153);

    let t154 : TempleTypes.Temple = {
      id = 154;
      name = "Alchi Monastery (Leh)";
      deity = "Lord Buddha (ancient Kashmiri Buddhist)";
      state = "Ladakh";
      city = "Alchi";
      district = "Leh";
      address = "Alchi Village, Leh District, Ladakh 194101";
      description = "The oldest monastery in Ladakh with 11th-century Kashmiri-style paintings, a UNESCO tentative list site.";
      history = "Founded around 1000 CE by Rinchen Zangpo, the 'Great Translator', containing the oldest surviving Buddhist art in the region.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/d/d7/Alchi_Monastery_Ladakh.jpg/800px-Alchi_Monastery_Ladakh.jpg"];
      architectureStyle = "Early Kashmiri Buddhist";
      darshanTimings = [
        { timingLabel = "General Visit"; openTime = "08:00"; closeTime = "17:00"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Morning Prayer"; time = "08:00"; description = "Morning Buddhist prayers"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 50; description = "Entry fee / donation." },
      ];
      contactInfo = { phone = null; email = null; website = null };
      nonHinduRestriction = false;
      averageVisitDuration = 3;
      tags = ["buddhist","ladakh","alchi","kashmiri art","11th century","oldest monastery","1000 CE"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(154, t154);

    let t155 : TempleTypes.Temple = {
      id = 155;
      name = "Manakula Vinayagar Temple (Puducherry)";
      deity = "Lord Manakula Vinayagar (Ganesha)";
      state = "Puducherry";
      city = "Puducherry";
      district = "Puducherry";
      address = "Manakula Vinayagar Koil St, Puducherry 605001";
      description = "The most famous temple in Puducherry, where an elephant named Lakshmi blesses devotees with its trunk.";
      history = "An ancient temple that survived Portuguese colonial rule; when the Portuguese tried to demolish it in 1735, the idol reappeared miraculously.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Manakula_Vinayagar_Temple_Pondicherry.jpg/800px-Manakula_Vinayagar_Temple_Pondicherry.jpg"];
      architectureStyle = "Dravidian";
      darshanTimings = [
        { timingLabel = "General Darshan"; openTime = "05:45"; closeTime = "21:30"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Morning Puja"; time = "05:45"; description = "Morning worship"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 51; description = "General donation at the temple." },
      ];
      contactInfo = { phone = ?"+91-413-2336650"; email = null; website = null };
      nonHinduRestriction = false;
      averageVisitDuration = 2;
      tags = ["ganesha","puducherry","pondicherry","elephant lakshmi","colonial era","vinayagar"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(155, t155);

    let t156 : TempleTypes.Temple = {
      id = 156;
      name = "Vedapuri Eswarar Temple (Puducherry)";
      deity = "Lord Eswarar (Shiva)";
      state = "Puducherry";
      city = "Puducherry";
      district = "Puducherry";
      address = "Villianur Road, Puducherry 605110";
      description = "An ancient Shiva temple in Puducherry with 5 festivals celebrated annually and a sacred tank.";
      history = "One of the most ancient temples in Puducherry, revered for centuries as a major Shaiva pilgrimage site.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/f/f9/Vedapuri_Eswarar_Temple_Pondicherry.jpg/800px-Vedapuri_Eswarar_Temple_Pondicherry.jpg"];
      architectureStyle = "Dravidian";
      darshanTimings = [
        { timingLabel = "General Darshan"; openTime = "06:00"; closeTime = "12:00"; breakStart = null; breakEnd = null },
        { timingLabel = "Evening Darshan"; openTime = "16:00"; closeTime = "20:00"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Morning Puja"; time = "06:00"; description = "Morning worship"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 51; description = "General donation at the temple." },
      ];
      contactInfo = { phone = null; email = null; website = null };
      nonHinduRestriction = false;
      averageVisitDuration = 2;
      tags = ["shiva","puducherry","pondicherry","ancient","shaiva"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(156, t156);

    let t157 : TempleTypes.Temple = {
      id = 157;
      name = "Varadaraja Perumal Temple (Puducherry)";
      deity = "Lord Varadaraja Perumal (Vishnu)";
      state = "Puducherry";
      city = "Puducherry";
      district = "Puducherry";
      address = "Mudaliarpet, Puducherry 605004";
      description = "A major Vaishnava temple in Puducherry with magnificent gopuram, dedicated to Lord Vishnu.";
      history = "An important Vaishnava pilgrimage site in Puducherry, attracting devotees from across Tamil Nadu.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/a/a0/Varadaraja_Perumal_Pondicherry.jpg/800px-Varadaraja_Perumal_Pondicherry.jpg"];
      architectureStyle = "Dravidian";
      darshanTimings = [
        { timingLabel = "General Darshan"; openTime = "06:00"; closeTime = "12:00"; breakStart = null; breakEnd = null },
        { timingLabel = "Evening Darshan"; openTime = "16:00"; closeTime = "20:00"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Morning Puja"; time = "06:00"; description = "Morning worship"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 51; description = "General donation at the temple." },
      ];
      contactInfo = { phone = null; email = null; website = null };
      nonHinduRestriction = false;
      averageVisitDuration = 2;
      tags = ["vishnu","puducherry","pondicherry","vaishnava","perumal"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(157, t157);

    let t158 : TempleTypes.Temple = {
      id = 158;
      name = "Villianur Sri Gokilambal Temple";
      deity = "Goddess Gokilambal (Parvati)";
      state = "Puducherry";
      city = "Villianur";
      district = "Puducherry";
      address = "Villianur, Puducherry 605110";
      description = "Famous for a 10-day chariot festival with one of the largest temple chariots in South India.";
      history = "An ancient Shiva-Parvati temple in Villianur known for its spectacular chariot festival drawing huge crowds.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/b/b1/Tiruchendur_Murugan_Temple.jpg/800px-Tiruchendur_Murugan_Temple.jpg"];
      architectureStyle = "Dravidian";
      darshanTimings = [
        { timingLabel = "General Darshan"; openTime = "06:00"; closeTime = "12:00"; breakStart = null; breakEnd = null },
        { timingLabel = "Evening Darshan"; openTime = "16:00"; closeTime = "20:00"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Morning Puja"; time = "06:00"; description = "Morning worship"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 51; description = "General donation at the temple." },
      ];
      contactInfo = { phone = null; email = null; website = null };
      nonHinduRestriction = false;
      averageVisitDuration = 2;
      tags = ["parvati","puducherry","villianur","chariot festival","dravidian"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(158, t158);

    let t159 : TempleTypes.Temple = {
      id = 159;
      name = "Arulmigu Maniyakavinayagar Temple";
      deity = "Lord Vinayagar (Ganesha)";
      state = "Puducherry";
      city = "Puducherry";
      district = "Puducherry";
      address = "Mission Street, Puducherry 605001";
      description = "A popular Ganesha temple in the heart of Puducherry, visited by devotees seeking blessings before important events.";
      history = "An old established Ganesha temple in Puducherry, important for the Tamil Hindu community in the union territory.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/c/c2/Gokilambal_Temple_Pondicherry.jpg/800px-Gokilambal_Temple_Pondicherry.jpg"];
      architectureStyle = "Dravidian";
      darshanTimings = [
        { timingLabel = "General Darshan"; openTime = "06:00"; closeTime = "12:00"; breakStart = null; breakEnd = null },
        { timingLabel = "Evening Darshan"; openTime = "16:00"; closeTime = "20:00"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Morning Puja"; time = "06:00"; description = "Morning worship"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 51; description = "General donation at the temple." },
      ];
      contactInfo = { phone = null; email = null; website = null };
      nonHinduRestriction = false;
      averageVisitDuration = 1;
      tags = ["ganesha","puducherry","pondicherry","vinayagar","blessings"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(159, t159);

    let t160 : TempleTypes.Temple = {
      id = 160;
      name = "Cellular Jail National Memorial (Port Blair)";
      deity = "National Martyrs Memorial";
      state = "Andaman & Nicobar Islands";
      city = "Port Blair";
      district = "South Andaman";
      address = "Atlanta Point, Port Blair, Andaman & Nicobar 744101";
      description = "A colonial-era prison turned national memorial and pilgrimage site for Indian freedom fighters.";
      history = "Built 1896-1906 CE by the British to exile freedom fighters; Veer Savarkar was imprisoned here; now a national monument.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/d/d3/Cellular_Jail_Port_Blair.jpg/800px-Cellular_Jail_Port_Blair.jpg"];
      architectureStyle = "Colonial Prison (national memorial)";
      darshanTimings = [
        { timingLabel = "General Visit"; openTime = "09:00"; closeTime = "17:00"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "Entry Fee"; amount = 30; description = "Entry fee for the memorial." },
      ];
      contactInfo = { phone = ?"+91-3192-232282"; email = null; website = null };
      nonHinduRestriction = false;
      averageVisitDuration = 3;
      tags = ["andaman","port blair","freedom fighters","savarkar","national memorial","colonial","prison"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(160, t160);

    let t161 : TempleTypes.Temple = {
      id = 161;
      name = "Samudrika Temple (Port Blair)";
      deity = "Goddess Samudrika Devi";
      state = "Andaman & Nicobar Islands";
      city = "Port Blair";
      district = "South Andaman";
      address = "Port Blair, Andaman & Nicobar 744101";
      description = "A temple dedicated to the ocean goddess, beloved by the fishing community of Port Blair.";
      history = "Established by early Bengali settlers in Port Blair, the temple serves the Hindu community on the island.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/e/e4/Samudrika_Temple_Andaman.jpg/800px-Samudrika_Temple_Andaman.jpg"];
      architectureStyle = "Bengali";
      darshanTimings = [
        { timingLabel = "General Darshan"; openTime = "06:00"; closeTime = "12:00"; breakStart = null; breakEnd = null },
        { timingLabel = "Evening Darshan"; openTime = "16:00"; closeTime = "20:00"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Morning Puja"; time = "06:00"; description = "Morning worship"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 51; description = "General donation at the temple." },
      ];
      contactInfo = { phone = null; email = null; website = null };
      nonHinduRestriction = false;
      averageVisitDuration = 2;
      tags = ["andaman","port blair","ocean goddess","fishing community","bengali"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(161, t161);

    let t162 : TempleTypes.Temple = {
      id = 162;
      name = "Ram Mandir Port Blair";
      deity = "Lord Rama";
      state = "Andaman & Nicobar Islands";
      city = "Port Blair";
      district = "South Andaman";
      address = "Haddo, Port Blair, Andaman & Nicobar 744102";
      description = "A prominent Rama temple serving the Hindu community in the Andaman Islands.";
      history = "Built by the Hindu community in Port Blair, it has become an important religious and social center on the islands.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/f/f5/Ram_Mandir_Port_Blair.jpg/800px-Ram_Mandir_Port_Blair.jpg"];
      architectureStyle = "North Indian";
      darshanTimings = [
        { timingLabel = "General Darshan"; openTime = "06:00"; closeTime = "12:00"; breakStart = null; breakEnd = null },
        { timingLabel = "Evening Darshan"; openTime = "16:00"; closeTime = "20:00"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Morning Puja"; time = "06:00"; description = "Morning worship"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 51; description = "General donation at the temple." },
      ];
      contactInfo = { phone = null; email = null; website = null };
      nonHinduRestriction = false;
      averageVisitDuration = 2;
      tags = ["rama","andaman","port blair","hindu community","island temple"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(162, t162);

    let t163 : TempleTypes.Temple = {
      id = 163;
      name = "Mansa Devi Temple (Panchkula)";
      deity = "Goddess Mansa Devi";
      state = "Chandigarh";
      city = "Panchkula";
      district = "Panchkula";
      address = "Bilaspur, Panchkula, Haryana/Chandigarh 134109";
      description = "A major Shakti temple in the Shivalik foothills near Chandigarh, visited by over a million pilgrims annually.";
      history = "An ancient temple on the Shivalik hills dedicated to Goddess Mansa Devi, who fulfills all wishes of devotees.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/a/a6/Mansa_Devi_Temple_Chandigarh.jpg/800px-Mansa_Devi_Temple_Chandigarh.jpg"];
      architectureStyle = "North Indian";
      darshanTimings = [
        { timingLabel = "General Darshan"; openTime = "05:00"; closeTime = "21:00"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Morning Aarti"; time = "05:00"; description = "Morning aarti worship"; isIncluded = true; price = null },
        { name = "Evening Aarti"; time = "19:00"; description = "Evening aarti worship"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 51; description = "General donation at the temple." },
      ];
      contactInfo = { phone = ?"+91-172-2752174"; email = null; website = null };
      nonHinduRestriction = false;
      averageVisitDuration = 3;
      tags = ["shakti","chandigarh","panchkula","mansa devi","shivalik","navratri","pilgrimage"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(163, t163);

    let t164 : TempleTypes.Temple = {
      id = 164;
      name = "Chandi Mandir (Chandigarh)";
      deity = "Goddess Chandi (Durga)";
      state = "Chandigarh";
      city = "Chandigarh";
      district = "Chandigarh";
      address = "Panchkula Road, Chandigarh 160101";
      description = "A prominent Durga temple in Chandigarh, famous for the Navratri celebrations attracting thousands.";
      history = "One of the most visited temples in the Chandigarh tricity area, the temple was established to serve the growing city's spiritual needs.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/b/b7/Chandi_Mandir_Panchkula.jpg/800px-Chandi_Mandir_Panchkula.jpg"];
      architectureStyle = "North Indian";
      darshanTimings = [
        { timingLabel = "General Darshan"; openTime = "05:00"; closeTime = "21:00"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Morning Aarti"; time = "05:00"; description = "Morning aarti worship"; isIncluded = true; price = null },
        { name = "Evening Aarti"; time = "19:00"; description = "Evening aarti worship"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 51; description = "General donation at the temple." },
      ];
      contactInfo = { phone = null; email = null; website = null };
      nonHinduRestriction = false;
      averageVisitDuration = 2;
      tags = ["durga","chandigarh","chandi","navratri","tricity","pilgrimage"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(164, t164);

    let t165 : TempleTypes.Temple = {
      id = 165;
      name = "ISKCON Temple Chandigarh";
      deity = "Radha Madanmohan (Krishna)";
      state = "Chandigarh";
      city = "Chandigarh";
      district = "Chandigarh";
      address = "Sector 36-B, Chandigarh 160036";
      description = "A beautiful Vaishnava temple in Chandigarh's Sector 36, known for cultural programs and prasadam.";
      history = "Established by ISKCON to spread Vaishnava culture in Chandigarh, hosting large Janmashtami and Ratha Yatra events.";
      images = ["https://upload.wikimedia.org/wikipedia/commons/thumb/c/c8/ISKCON_Chandigarh.jpg/800px-ISKCON_Chandigarh.jpg"];
      architectureStyle = "Vaishnava (modern)";
      darshanTimings = [
        { timingLabel = "General Darshan"; openTime = "04:30"; closeTime = "13:00"; breakStart = null; breakEnd = null },
        { timingLabel = "Evening Darshan"; openTime = "16:00"; closeTime = "21:00"; breakStart = null; breakEnd = null },
      ];
      poojaSchedule = [
        { name = "Mangala Aarti"; time = "04:30"; description = "Early morning aarti"; isIncluded = true; price = null },
        { name = "Evening Aarti"; time = "19:00"; description = "Evening aarti worship"; isIncluded = true; price = null },
      ];
      specialDarshans = [];
      festivalCalendar = [];
      donationOptions = [
        { donationType = "General Donation"; amount = 101; description = "General donation at the temple." },
      ];
      contactInfo = { phone = ?"+91-172-2637000"; email = null; website = null };
      nonHinduRestriction = false;
      averageVisitDuration = 2;
      tags = ["krishna","chandigarh","iskcon","radha","janmashtami","vaishnava","modern"];
      createdAt = now;
      updatedAt = now;
    };
    temples.add(165, t165);
  };
};
