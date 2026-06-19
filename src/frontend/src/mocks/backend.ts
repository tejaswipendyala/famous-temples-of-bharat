import type { backendInterface, Temple, TempleSummary, UserProfile, UserRole, UserRole__1, PaginatedResult, Faq, Review, DonationCheckoutResult, DonationStats, DonationRecord, TransformationInput, TransformationOutput } from "../backend";
import { Principal } from "@icp-sdk/core/principal";

const now = BigInt(Date.now()) * BigInt(1_000_000);

const temple1: Temple = {
  id: BigInt(1),
  name: "Tirumala Venkateswara Temple (Tirupati Balaji)",
  deity: "Lord Venkateswara (Balaji)",
  state: "Andhra Pradesh",
  city: "Tirupati",
  district: "Tirupati",
  address: "Tirumala Hills, Tirupati, Andhra Pradesh 517504",
  description: "One of the most visited and richest temples in the world, the Tirumala Venkateswara Temple is dedicated to Lord Venkateswara, a form of Vishnu. Situated atop the seven hills of Tirumala, it draws over 50,000 pilgrims daily.",
  history: "The Tirumala Venkateswara Temple has a history spanning over a thousand years. The main shrine was built during the Pallava dynasty in the 9th century CE. Over centuries, it received patronage from Vijayanagara kings and various dynasties.",
  images: ["https://upload.wikimedia.org/wikipedia/commons/thumb/a/a7/Tirumala_temple1.jpg/800px-Tirumala_temple1.jpg"],
  architectureStyle: "Dravidian",
  darshanTimings: [
    { timingLabel: "Suprabhata Seva (Early Morning)", openTime: "03:00", closeTime: "03:30", breakStart: undefined, breakEnd: undefined },
    { timingLabel: "Regular Darshan", openTime: "06:00", closeTime: "23:00", breakStart: "13:00", breakEnd: "15:00" },
  ],
  poojaSchedule: [
    { name: "Suprabhata Seva", time: "03:00", description: "The awakening ritual of the deity", isIncluded: false, price: BigInt(300) },
    { name: "Archana", time: "07:00", description: "Chanting of 108 names of the Lord with flower offerings", isIncluded: true, price: undefined },
    { name: "Rajabhogam (Noon Naivedyam)", time: "12:00", description: "Grand noon offering of food to the Lord", isIncluded: true, price: undefined },
  ],
  specialDarshans: [
    { name: "Sarva Darshan (Free Darshan)", description: "General queue darshan — no prior booking needed", price: BigInt(0), availableDays: ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"] },
    { name: "Seva Darshan (SSD)", description: "Special Entry Darshan with token — 4 hour wait approximately", price: BigInt(300), availableDays: ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"] },
  ],
  festivalCalendar: [
    { name: "Brahmotsavam", date: "September/October (9 days)", significance: "The grand annual festival with deity processions on various vahanas" },
    { name: "Vaikunta Ekadashi", date: "December/January", significance: "The most auspicious day when the Vaikunta Dwaram opens; lakhs of pilgrims gather" },
  ],
  donationOptions: [
    { donationType: "Hundi (General Donation)", amount: BigInt(100), description: "General donation into the main Hundi of the temple" },
    { donationType: "Anna Prasadam Trust", amount: BigInt(500), description: "Donation towards free meal for pilgrims" },
  ],
  contactInfo: { phone: "+91-877-2277777", email: "info@tirumala.org", website: "https://www.tirumala.org" },
  nonHinduRestriction: true,
  averageVisitDuration: BigInt(6),
  tags: ["vaishnava", "andhra pradesh", "richest temple", "world famous", "pilgrimage", "vishnu"],
  createdAt: now,
  updatedAt: now,
};

const temple2: Temple = {
  id: BigInt(2),
  name: "Kashi Vishwanath Temple",
  deity: "Lord Shiva (Vishwanath)",
  state: "Uttar Pradesh",
  city: "Varanasi",
  district: "Varanasi",
  address: "Lahori Tola, Varanasi, Uttar Pradesh 221001",
  description: "The Kashi Vishwanath Temple is one of the most famous Hindu temples dedicated to Lord Shiva, located in the holy city of Varanasi. It is one of the 12 Jyotirlingas.",
  history: "The current temple was built in 1780 CE by Maratha ruler Ahilyabai Holkar. The Kashi Vishwanath Dham corridor was inaugurated in December 2021.",
  images: ["https://upload.wikimedia.org/wikipedia/commons/thumb/c/c5/Kashi_Vishwanath_Temple_1.jpg/800px-Kashi_Vishwanath_Temple_1.jpg"],
  architectureStyle: "Nagara",
  darshanTimings: [
    { timingLabel: "Mangala Aarti (Early Morning)", openTime: "03:00", closeTime: "04:00", breakStart: undefined, breakEnd: undefined },
    { timingLabel: "Regular Darshan", openTime: "04:00", closeTime: "23:00", breakStart: "12:00", breakEnd: "13:00" },
  ],
  poojaSchedule: [
    { name: "Mangala Aarti", time: "03:00", description: "The auspicious early morning aarti", isIncluded: false, price: BigInt(251) },
    { name: "Rudra Abhishek", time: "06:00", description: "Sacred bathing of the Shivalinga with Panchamrit", isIncluded: false, price: BigInt(500) },
    { name: "Sandhya Aarti", time: "19:00", description: "Magnificent evening aarti", isIncluded: true, price: undefined },
  ],
  specialDarshans: [
    { name: "VIP Darshan (Paid)", description: "Skip the queue with a paid ticket for faster darshan", price: BigInt(300), availableDays: ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"] },
    { name: "General Darshan (Free)", description: "Free darshan — queue wait time varies from 1–5 hours", price: BigInt(0), availableDays: ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"] },
  ],
  festivalCalendar: [
    { name: "Maha Shivaratri", date: "February/March", significance: "The most important festival — celebrated with all-night vigil and special poojas" },
    { name: "Dev Deepawali", date: "October/November (Kartik Purnima)", significance: "All 84 ghats of Varanasi illuminated with millions of lamps" },
  ],
  donationOptions: [
    { donationType: "General Donation", amount: BigInt(101), description: "Donation for daily rituals and maintenance of the temple" },
    { donationType: "Deepam (Lamp) Seva", amount: BigInt(501), description: "Sponsor a perpetual lamp burning before the Jyotirlinga" },
  ],
  contactInfo: { phone: "+91-542-2392021", email: "info@shrikashivishwanath.org", website: "https://shrikashivishwanath.org" },
  nonHinduRestriction: true,
  averageVisitDuration: BigInt(3),
  tags: ["shaiva", "uttar pradesh", "jyotirlinga", "varanasi", "ganga", "moksha"],
  createdAt: now,
  updatedAt: now,
};

const temple3: Temple = {
  id: BigInt(3),
  name: "Meenakshi Amman Temple",
  deity: "Goddess Meenakshi (Parvati) & Lord Sundareswarar (Shiva)",
  state: "Tamil Nadu",
  city: "Madurai",
  district: "Madurai",
  address: "Madurai Main, Madurai, Tamil Nadu 625001",
  description: "A historic Hindu temple known for its towering gopurams adorned with thousands of mythological sculptures. The temple complex covers 14 acres with 14 gopurams.",
  history: "The temple has a history spanning over 2500 years. It was the royal temple of the Pandya kingdom and has been a center of Tamil culture for centuries.",
  images: ["https://upload.wikimedia.org/wikipedia/commons/thumb/3/3a/Meenakshi_amman_temple.jpg/800px-Meenakshi_amman_temple.jpg"],
  architectureStyle: "Dravidian",
  darshanTimings: [
    { timingLabel: "Morning Darshan", openTime: "05:00", closeTime: "12:30", breakStart: undefined, breakEnd: undefined },
    { timingLabel: "Evening Darshan", openTime: "16:00", closeTime: "22:00", breakStart: undefined, breakEnd: undefined },
  ],
  poojaSchedule: [
    { name: "Thiruvanandal (Kalasanthi)", time: "05:30", description: "The first pooja of the day", isIncluded: true, price: undefined },
    { name: "Ardhajamam", time: "21:00", description: "Night pooja — Lord Sundareswarar taken to Meenakshi's chamber", isIncluded: true, price: undefined },
  ],
  specialDarshans: [
    { name: "General Darshan (Free)", description: "Free entry for Hindus throughout the day", price: BigInt(0), availableDays: ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"] },
    { name: "Friday Evening Procession", description: "Spectacular procession of Lord Sundareswarar to Goddess Meenakshi's chamber", price: BigInt(0), availableDays: ["Friday"] },
  ],
  festivalCalendar: [
    { name: "Chithirai Festival (Meenakshi Tirukalyanam)", date: "April/May", significance: "The grand celestial wedding of Goddess Meenakshi and Lord Sundareswarar" },
    { name: "Navaratri", date: "September/October (9 days)", significance: "Nine nights of goddess worship with special poojas" },
  ],
  donationOptions: [
    { donationType: "General Donation", amount: BigInt(100), description: "Donation to HR & CE board for temple maintenance" },
    { donationType: "Elephant Care Donation", amount: BigInt(500), description: "Donation for the upkeep of the temple elephants" },
  ],
  contactInfo: { phone: "+91-452-2340761", email: "hrmadurai@gmail.com", website: "https://www.maduraimeenakshi.org" },
  nonHinduRestriction: true,
  averageVisitDuration: BigInt(4),
  tags: ["shakti", "tamil nadu", "dravidian", "madurai", "meenakshi", "gopuram", "south india"],
  createdAt: now,
  updatedAt: now,
};

const sampleTemples = [temple1, temple2, temple3];

const toSummary = (t: Temple): TempleSummary => ({
  id: t.id,
  name: t.name,
  deity: t.deity,
  state: t.state,
  city: t.city,
  district: t.district,
  address: t.address,
  images: t.images,
  architectureStyle: t.architectureStyle,
  nonHinduRestriction: t.nonHinduRestriction,
  averageVisitDuration: t.averageVisitDuration,
  tags: t.tags,
});

const sampleFaqs: Faq[] = [
  {
    id: BigInt(1),
    question: "What is the best time to visit Tirupati Balaji temple?",
    answer: "The best time to visit is early morning during Suprabhata Seva (3 AM). Weekdays are less crowded. Avoid peak festival seasons unless you wish to witness the grand celebrations.",
    templeId: BigInt(1),
    createdAt: now,
    updatedAt: now,
  },
  {
    id: BigInt(2),
    question: "Are non-Hindus allowed inside the temple?",
    answer: "Entry restrictions vary by temple. Tirupati, Kashi Vishwanath, Jagannath, and Meenakshi temples restrict entry to Hindus only. The Golden Temple (Amritsar) welcomes all religions. Please check individual temple policies.",
    templeId: BigInt(1),
    createdAt: now,
    updatedAt: now,
  },
];

const sampleProfile: UserProfile = {
  name: "Devotee User",
  email: "devotee@example.com",
  role: "user" as unknown as UserRole,
  visitHistory: [BigInt(1), BigInt(2)],
  bookmarkedTemples: [BigInt(1)],
  createdAt: now,
};

export const mockBackend: backendInterface = {
  addFAQ: async (input) => ({
    id: BigInt(99),
    question: input.question,
    answer: input.answer,
    templeId: input.templeId,
    createdAt: now,
    updatedAt: now,
  }),

  addReview: async (input) => ({
    id: BigInt(99),
    userId: Principal.anonymous(),
    templeId: input.templeId,
    rating: input.rating,
    comment: input.comment,
    createdAt: now,
  }),

  addTemple: async (input) => ({
    ...input,
    id: BigInt(99),
    createdAt: now,
    updatedAt: now,
  }),

  _initializeAccessControl: async () => undefined,

  assignCallerUserRole: async () => undefined,

  bookmarkTemple: async () => true,

  deleteFAQ: async () => true,

  deleteTemple: async () => true,

  getAllTemples: async () => sampleTemples,

  getCallerUserProfile: async () => sampleProfile,

  getCallerUserRole: async () => "user" as unknown as UserRole__1,

  getFAQs: async () => sampleFaqs,

  getReviews: async (): Promise<Review[]> => [
    {
      id: BigInt(1),
      userId: Principal.anonymous(),
      templeId: BigInt(1),
      rating: BigInt(5),
      comment: "A truly divine experience. The darshan was peaceful and the prasadam was blessed. Highly recommend visiting during Brahmotsavam.",
      createdAt: now,
    },
  ],

  getTemple: async (id) => sampleTemples.find(t => t.id === id) ?? null,

  getUserProfile: async () => sampleProfile,

  getUsers: async () => [
    { principal: Principal.anonymous(), name: "Admin User", email: "admin@temple.in", role: "admin" as unknown as UserRole, createdAt: now },
    { principal: Principal.anonymous(), name: "Devotee User", email: "devotee@example.com", role: "user" as unknown as UserRole, createdAt: now },
  ],

  isAdmin: async () => false,

  isCallerAdmin: async () => false,

  removeBookmark: async () => true,

  saveCallerUserProfile: async () => undefined,

  searchTemples: async (params): Promise<PaginatedResult> => {
    const term = params.searchTerm.toLowerCase();
    const filtered = sampleTemples.filter(t =>
      !term || 
      t.name.toLowerCase().includes(term) ||
      t.deity.toLowerCase().includes(term) ||
      t.city.toLowerCase().includes(term) ||
      t.state.toLowerCase().includes(term)
    );
    const offset = Number(params.pagination.offset);
    const limit = Number(params.pagination.limit);
    return {
      items: filtered.slice(offset, offset + limit).map(toSummary),
      total: BigInt(filtered.length),
      offset: params.pagination.offset,
      limit: params.pagination.limit,
    };
  },

  setUserRole: async () => true,

  createCheckoutSession: async (input): Promise<DonationCheckoutResult> => ({
    sessionId: "cs_mock_session_id",
    checkoutUrl: "https://checkout.stripe.com/mock",
    donationId: BigInt(1),
  }),

  getAllDonationStats: async (): Promise<DonationStats[]> => [],

  getDonationStats: async (templeId): Promise<DonationStats> => ({
    templeId,
    templeName: "Mock Temple",
    totalDonations: BigInt(0),
    totalAmount: BigInt(0),
    completedCount: BigInt(0),
    pendingCount: BigInt(0),
  }),

  getDonationsByTemple: async (): Promise<DonationRecord[]> => [],

  getStripeSessionStatus: async () => false,

  isStripeConfigured: async () => false,

  setStripeConfiguration: async () => undefined,

  transform: async (input: TransformationInput): Promise<TransformationOutput> => ({
    status: input.response.status,
    headers: [],
    body: input.response.body,
  }),

  updateFAQ: async (id, input) => ({
    id,
    question: input.question,
    answer: input.answer,
    templeId: input.templeId,
    createdAt: now,
    updatedAt: now,
  }),

  updateTemple: async (id, input) => ({
    ...input,
    id,
    createdAt: now,
    updatedAt: now,
  }),
};
