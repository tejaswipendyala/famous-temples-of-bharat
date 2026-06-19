import Map "mo:core/Map";
import Time "mo:core/Time";
import Runtime "mo:core/Runtime";
import AccessControl "mo:caffeineai-authorization/access-control";
import MixinAuthorization "mo:caffeineai-authorization/MixinAuthorization";
import OutCall "mo:caffeineai-http-outcalls/outcall";
import CommonTypes "types/common";
import DonationTypes "types/stripe-donations";
import TempleLib "lib/temple";
import UserLib "lib/user";
import FaqLib "lib/faq";
import ReviewLib "lib/review";
import DonationLib "lib/stripe-donations";
import TempleApi "mixins/temple-api";
import UserApi "mixins/user-api";
import FaqApi "mixins/faq-api";
import ReviewApi "mixins/review-api";

actor {
  let accessControlState = AccessControl.initState();
  include MixinAuthorization(accessControlState);

  let temples : TempleLib.TempleMap = Map.empty();
  let templeCounter = { var next : Nat = 1 };

  let users : UserLib.UserMap = Map.empty();

  let faqs : FaqLib.FaqMap = Map.empty();
  let faqCounter = { var next : Nat = 1 };

  let reviews : ReviewLib.ReviewMap = Map.empty();
  let reviewCounter = { var next : Nat = 1 };

  let donations : DonationLib.DonationMap = Map.empty();
  let donationCounter = { var next : Nat = 1 };

  let stripeConfig = {
    var secretKey = "STRIPE_SECRET_KEY";
    var allowedCountries : [Text] = ["IN", "US", "GB", "CA", "AU"];
  };

  // Seed sample data on every canister initialization to guarantee correct state
  do {
    let now = Time.now();
    TempleLib.seedSampleData(temples, now);
    templeCounter.next := temples.size() + 1;
    let newFaqId = FaqLib.seedSampleData(faqs, 1, now);
    faqCounter.next := newFaqId;
  };

  include TempleApi(accessControlState, temples, templeCounter);
  include UserApi(accessControlState, users);
  include FaqApi(accessControlState, faqs, faqCounter);
  include ReviewApi(accessControlState, reviews, reviewCounter);

  // Required by Caffeine platform: HTTP outcall response transformation for Stripe
  public query func transform(input : OutCall.TransformationInput) : async OutCall.TransformationOutput {
    OutCall.transform(input);
  };

  // Required by Caffeine platform: check if Stripe is configured with a real key
  public query func isStripeConfigured() : async Bool {
    stripeConfig.secretKey != "" and stripeConfig.secretKey != "STRIPE_SECRET_KEY";
  };

  // Required by Caffeine platform: update Stripe configuration (admin only)
  public shared ({ caller }) func setStripeConfiguration(secretKey : Text, allowedCountries : [Text]) : async () {
    if (not AccessControl.hasPermission(accessControlState, caller, #admin)) {
      Runtime.trap("Unauthorized: Only admins can set Stripe configuration");
    };
    stripeConfig.secretKey := secretKey;
    stripeConfig.allowedCountries := allowedCountries;
  };

  // Required by Caffeine platform: create a Stripe checkout session for temple donation
  public shared ({ caller }) func createCheckoutSession(
    input : DonationTypes.CreateDonationInput
  ) : async DonationTypes.DonationCheckoutResult {
    if (caller.isAnonymous()) {
      Runtime.trap("Must be logged in to donate");
    };
    let config = {
      secretKey = stripeConfig.secretKey;
      allowedCountries = stripeConfig.allowedCountries;
    };
    await DonationLib.createCheckoutSession(
      donations,
      temples,
      donationCounter,
      config,
      caller,
      input,
      transform,
    );
  };

  // Required by Caffeine platform: get status of a Stripe checkout session
  public shared ({ caller }) func getStripeSessionStatus(sessionId : Text) : async Bool {
    if (caller.isAnonymous()) {
      Runtime.trap("Must be logged in to check session status");
    };
    let config = {
      secretKey = stripeConfig.secretKey;
      allowedCountries = stripeConfig.allowedCountries;
    };
    await DonationLib.confirmDonation(donations, config, sessionId, transform);
  };

  // Get all donations for a specific temple (admin only)
  public query ({ caller }) func getDonationsByTemple(
    templeId : CommonTypes.TempleId
  ) : async [DonationTypes.DonationRecord] {
    if (not AccessControl.hasPermission(accessControlState, caller, #admin)) {
      Runtime.trap("Unauthorized: Only admins can view donation records");
    };
    DonationLib.getDonationsByTemple(donations, templeId);
  };

  // Get donation stats for a specific temple (admin only)
  public query ({ caller }) func getDonationStats(
    templeId : CommonTypes.TempleId
  ) : async DonationTypes.DonationStats {
    if (not AccessControl.hasPermission(accessControlState, caller, #admin)) {
      Runtime.trap("Unauthorized: Only admins can view donation stats");
    };
    DonationLib.getDonationStats(donations, templeId);
  };

  // Get donation stats across all temples (admin only)
  public query ({ caller }) func getAllDonationStats() : async [DonationTypes.DonationStats] {
    if (not AccessControl.hasPermission(accessControlState, caller, #admin)) {
      Runtime.trap("Unauthorized: Only admins can view donation stats");
    };
    DonationLib.getAllDonationStats(donations);
  };
};
