import Runtime "mo:core/Runtime";
import OutCall "mo:caffeineai-http-outcalls/outcall";
import Stripe "mo:caffeineai-stripe/stripe";
import AccessControl "mo:caffeineai-authorization/access-control";
import CommonTypes "../types/common";
import DonationTypes "../types/stripe-donations";
import DonationLib "../lib/stripe-donations";
import TempleLib "../lib/temple";

mixin (
  accessControlState : AccessControl.AccessControlState,
  donations : DonationLib.DonationMap,
  donationCounter : { var next : Nat },
  temples : TempleLib.TempleMap,
  stripeConfig : { var secretKey : Text; var allowedCountries : [Text] },
) {
  // Required by Caffeine platform: HTTP outcall response transformation
  public query func transform(input : OutCall.TransformationInput) : async OutCall.TransformationOutput {
    OutCall.transform(input);
  };

  // Required by Caffeine platform: check if Stripe is configured with a real key
  public query func isStripeConfigured() : async Bool {
    stripeConfig.secretKey != "" and stripeConfig.secretKey != "STRIPE_SECRET_KEY";
  };

  // Required by Caffeine platform: update Stripe secret key (admin only)
  public shared ({ caller }) func setStripeConfiguration(secretKey : Text, allowedCountries : [Text]) : async () {
    if (not AccessControl.hasPermission(accessControlState, caller, #admin)) {
      Runtime.trap("Unauthorized: Only admins can set Stripe configuration");
    };
    stripeConfig.secretKey := secretKey;
    stripeConfig.allowedCountries := allowedCountries;
  };

  // Required by Caffeine platform: create a Stripe checkout session
  public shared ({ caller }) func createCheckoutSession(
    input : DonationTypes.CreateDonationInput
  ) : async DonationTypes.DonationCheckoutResult {
    if (caller.isAnonymous()) {
      Runtime.trap("Must be logged in to donate");
    };
    let config : Stripe.StripeConfiguration = {
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
    let config : Stripe.StripeConfiguration = {
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
