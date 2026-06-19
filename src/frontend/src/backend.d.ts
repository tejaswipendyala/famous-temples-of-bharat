import type { Principal } from "@icp-sdk/core/principal";
export interface Some<T> {
    __kind__: "Some";
    value: T;
}
export interface None {
    __kind__: "None";
}
export type Option<T> = Some<T> | None;
export type Timestamp = bigint;
export interface TransformationOutput {
    status: bigint;
    body: Uint8Array;
    headers: Array<http_header>;
}
export interface FaqInput {
    question: string;
    answer: string;
    templeId: TempleId;
}
export interface SearchParams {
    cityFilter?: string;
    pagination: PaginationParams;
    searchTerm: string;
    stateFilter?: string;
}
export interface UserSummary {
    principal: UserId;
    name: string;
    createdAt: Timestamp;
    role: UserRole;
    email: string;
}
export interface TransformationInput {
    context: Uint8Array;
    response: http_request_result;
}
export interface Pooja {
    name: string;
    time: string;
    description: string;
    price?: bigint;
    isIncluded: boolean;
}
export interface PaginatedResult {
    total: bigint;
    offset: bigint;
    limit: bigint;
    items: Array<TempleSummary>;
}
export type ReviewId = bigint;
export type FaqId = bigint;
export interface DarshanTiming {
    closeTime: string;
    timingLabel: string;
    breakStart?: string;
    breakEnd?: string;
    openTime: string;
}
export interface Review {
    id: ReviewId;
    userId: UserId;
    createdAt: Timestamp;
    comment: string;
    templeId: TempleId;
    rating: bigint;
}
export interface DonationOption {
    donationType: string;
    description: string;
    amount: bigint;
}
export interface CreateDonationInput {
    cancelUrl: string;
    currency: string;
    templeId: TempleId;
    amount: bigint;
    successUrl: string;
}
export interface TempleInput {
    poojaSchedule: Array<Pooja>;
    contactInfo: ContactInfo;
    nonHinduRestriction: boolean;
    city: string;
    name: string;
    tags: Array<string>;
    architectureStyle: string;
    description: string;
    history: string;
    district: string;
    donationOptions: Array<DonationOption>;
    state: string;
    averageVisitDuration: bigint;
    address: string;
    specialDarshans: Array<SpecialDarshan>;
    festivalCalendar: Array<Festival>;
    deity: string;
    darshanTimings: Array<DarshanTiming>;
    images: Array<string>;
}
export interface SpecialDarshan {
    name: string;
    description: string;
    availableDays: Array<string>;
    price: bigint;
}
export interface Temple {
    id: TempleId;
    poojaSchedule: Array<Pooja>;
    contactInfo: ContactInfo;
    nonHinduRestriction: boolean;
    city: string;
    name: string;
    createdAt: Timestamp;
    tags: Array<string>;
    architectureStyle: string;
    description: string;
    history: string;
    district: string;
    donationOptions: Array<DonationOption>;
    updatedAt: Timestamp;
    state: string;
    averageVisitDuration: bigint;
    address: string;
    specialDarshans: Array<SpecialDarshan>;
    festivalCalendar: Array<Festival>;
    deity: string;
    darshanTimings: Array<DarshanTiming>;
    images: Array<string>;
}
export interface ContactInfo {
    email?: string;
    website?: string;
    phone?: string;
}
export interface Festival {
    date: string;
    name: string;
    significance: string;
}
export interface DonationCheckoutResult {
    donationId: DonationId;
    checkoutUrl: string;
    sessionId: string;
}
export interface http_header {
    value: string;
    name: string;
}
export interface http_request_result {
    status: bigint;
    body: Uint8Array;
    headers: Array<http_header>;
}
export interface PaginationParams {
    offset: bigint;
    limit: bigint;
}
export type UserId = Principal;
export interface TempleSummary {
    id: TempleId;
    nonHinduRestriction: boolean;
    city: string;
    name: string;
    tags: Array<string>;
    architectureStyle: string;
    district: string;
    state: string;
    averageVisitDuration: bigint;
    address: string;
    deity: string;
    images: Array<string>;
}
export interface Faq {
    id: FaqId;
    question: string;
    createdAt: Timestamp;
    answer: string;
    updatedAt: Timestamp;
    templeId: TempleId;
}
export interface DonationRecord {
    id: DonationId;
    status: DonationStatus;
    createdAt: Timestamp;
    templeName: string;
    updatedAt: Timestamp;
    currency: string;
    templeId: TempleId;
    stripeSessionId: string;
    amount: bigint;
    donor: UserId;
}
export interface DonationStats {
    pendingCount: bigint;
    completedCount: bigint;
    templeName: string;
    totalAmount: bigint;
    templeId: TempleId;
    totalDonations: bigint;
}
export type DonationId = bigint;
export interface ReviewInput {
    comment: string;
    templeId: TempleId;
    rating: bigint;
}
export interface UserProfile {
    visitHistory: Array<TempleId>;
    name: string;
    createdAt: Timestamp;
    role: UserRole;
    email: string;
    bookmarkedTemples: Array<TempleId>;
}
export type TempleId = bigint;
export enum DonationStatus {
    pending = "pending",
    completed = "completed",
    failed = "failed"
}
export enum UserRole {
    admin = "admin",
    user = "user"
}
export enum UserRole__1 {
    admin = "admin",
    user = "user",
    guest = "guest"
}
export interface backendInterface {
    addFAQ(input: FaqInput): Promise<Faq>;
    addReview(input: ReviewInput): Promise<Review>;
    addTemple(input: TempleInput): Promise<Temple>;
    assignCallerUserRole(user: Principal, role: UserRole__1): Promise<void>;
    bookmarkTemple(templeId: TempleId): Promise<boolean>;
    createCheckoutSession(input: CreateDonationInput): Promise<DonationCheckoutResult>;
    deleteFAQ(id: FaqId): Promise<boolean>;
    deleteTemple(id: TempleId): Promise<boolean>;
    getAllDonationStats(): Promise<Array<DonationStats>>;
    getAllTemples(): Promise<Array<Temple>>;
    getCallerUserProfile(): Promise<UserProfile | null>;
    getCallerUserRole(): Promise<UserRole__1>;
    getDonationStats(templeId: TempleId): Promise<DonationStats>;
    getDonationsByTemple(templeId: TempleId): Promise<Array<DonationRecord>>;
    getFAQs(templeId: TempleId): Promise<Array<Faq>>;
    getReviews(templeId: TempleId): Promise<Array<Review>>;
    getStripeSessionStatus(sessionId: string): Promise<boolean>;
    getTemple(id: TempleId): Promise<Temple | null>;
    getUserProfile(user: UserId): Promise<UserProfile | null>;
    getUsers(): Promise<Array<UserSummary>>;
    isAdmin(): Promise<boolean>;
    isCallerAdmin(): Promise<boolean>;
    isStripeConfigured(): Promise<boolean>;
    removeBookmark(templeId: TempleId): Promise<boolean>;
    saveCallerUserProfile(profile: UserProfile): Promise<void>;
    searchTemples(params: SearchParams): Promise<PaginatedResult>;
    setStripeConfiguration(secretKey: string, allowedCountries: Array<string>): Promise<void>;
    setUserRole(user: UserId, role: UserRole): Promise<boolean>;
    transform(input: TransformationInput): Promise<TransformationOutput>;
    updateFAQ(id: FaqId, input: FaqInput): Promise<Faq | null>;
    updateTemple(id: TempleId, input: TempleInput): Promise<Temple | null>;
}
