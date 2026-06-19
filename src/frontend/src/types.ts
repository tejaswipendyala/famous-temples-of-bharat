export interface Temple {
  id: string;
  name: string;
  deity: string;
  description: string;
  history: string;
  city: string;
  state: string;
  address: string;
  latitude: number;
  longitude: number;
  imageUrl: string;
  darshanaTimings: DarshanaSlot[];
  poojas: Pooja[];
  specialDays: SpecialDay[];
  donationInfo: string;
  entryFee: string;
  category: TempleCategory;
  nearbyPlaces: NearbyPlace[];
  faqs: FAQ[];
  reviews: Review[];
  isBookmarked?: boolean;
}

export interface TempleCard {
  id: string;
  name: string;
  deity: string;
  city: string;
  state: string;
  imageUrl: string;
  darshanaTimings: DarshanaSlot[];
  category: TempleCategory;
  isBookmarked?: boolean;
}

export interface DarshanaSlot {
  label: string;
  openTime: string;
  closeTime: string;
}

export interface Pooja {
  name: string;
  time: string;
  description: string;
  cost: string;
}

export interface SpecialDay {
  name: string;
  date: string;
  description: string;
}

export interface NearbyPlace {
  id: string;
  name: string;
  type: NearbyPlaceType;
  distance: string;
  description: string;
  address: string;
}

export type NearbyPlaceType =
  | "restaurant"
  | "hotel"
  | "museum"
  | "waterpark"
  | "shopping"
  | "viewpoint";

export type TempleCategory =
  | "UNESCO Heritage"
  | "Jyotirlinga"
  | "Shakti Peetha"
  | "Char Dham"
  | "Pancha Bhuta Stalagam"
  | "Divya Desam"
  | "Heritage";

export interface FAQ {
  id: string;
  question: string;
  answer: string;
  category?: string;
}

export interface Review {
  id: string;
  userId: string;
  userName: string;
  rating: number;
  comment: string;
  createdAt: string;
}

export interface UserProfile {
  name: string;
  email?: string;
  role: "admin" | "user";
  bookmarks: string[];
  createdAt?: string;
}

export interface SearchFilters {
  query: string;
  state?: string;
  deity?: string;
  category?: TempleCategory;
  sortBy?: "name" | "state" | "rating";
}
