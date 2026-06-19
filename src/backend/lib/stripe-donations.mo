import Map "mo:core/Map";
import List "mo:core/List";
import Runtime "mo:core/Runtime";
import Time "mo:core/Time";
import Stripe "mo:caffeineai-stripe/stripe";
import OutCall "mo:caffeineai-http-outcalls/outcall";
import CommonTypes "../types/common";
import DonationTypes "../types/stripe-donations";
import TempleTypes "../types/temple";

module {
  public type DonationMap = Map.Map<DonationTypes.DonationId, DonationTypes.DonationRecord>;
  public type TempleMap = Map.Map<CommonTypes.TempleId, TempleTypes.Temple>;

  func extractJsonStringField(json : Text, fieldPattern : Text) : Text {
    if (json.contains(#text fieldPattern)) {
      let parts = json.split(#text fieldPattern);
      switch (parts.next()) {
        case (null) {};
        case (?_) {
          switch (parts.next()) {
            case (?afterPattern) {
              switch (afterPattern.split(#text "\"").next()) {
                case (?value) {
                  if (value.size() > 0) {
                    return value;
                  };
                };
                case (_) {};
              };
            };
            case (null) {};
          };
        };
      };
    };
    "";
  };

  func extractCheckoutUrl(json : Text) : Text {
    let v1 = extractJsonStringField(json, "\"url\":\"");
    if (v1.size() > 0) return v1;
    extractJsonStringField(json, "\"url\": \"");
  };

  func extractSessionId(json : Text) : Text {
    let v1 = extractJsonStringField(json, "\"id\":\"cs_");
    if (v1.size() > 0) return "cs_" # v1;
    let v2 = extractJsonStringField(json, "\"id\": \"cs_");
    if (v2.size() > 0) return "cs_" # v2;
    "";
  };

  public func createCheckoutSession(
    donations : DonationMap,
    temples : TempleMap,
    counter : { var next : Nat },
    config : Stripe.StripeConfiguration,
    caller : CommonTypes.UserId,
    input : DonationTypes.CreateDonationInput,
    transform : OutCall.Transform,
  ) : async DonationTypes.DonationCheckoutResult {
    let temple = switch (temples.get(input.templeId)) {
      case (?t) t;
      case null Runtime.trap("Temple not found");
    };

    let item : Stripe.ShoppingItem = {
      currency = input.currency;
      productName = "Donation to " # temple.name;
      productDescription = "Support " # temple.name # " temple in " # temple.city # ", " # temple.state;
      priceInCents = input.amount;
      quantity = 1;
    };

    let now = Time.now();
    let donationId = counter.next;
    counter.next += 1;

    let sessionJson = await Stripe.createCheckoutSession(
      config,
      caller,
      [item],
      input.successUrl,
      input.cancelUrl,
      transform,
    );

    let sessionId = extractSessionId(sessionJson);
    let checkoutUrl = extractCheckoutUrl(sessionJson);

    let record : DonationTypes.DonationRecord = {
      id = donationId;
      templeId = input.templeId;
      donor = caller;
      amount = input.amount;
      currency = input.currency;
      stripeSessionId = sessionId;
      status = #pending;
      templeName = temple.name;
      createdAt = now;
      updatedAt = now;
    };

    donations.add(donationId, record);

    {
      sessionId = sessionId;
      checkoutUrl = checkoutUrl;
      donationId = donationId;
    };
  };

  public func confirmDonation(
    donations : DonationMap,
    config : Stripe.StripeConfiguration,
    sessionId : Text,
    transform : OutCall.Transform,
  ) : async Bool {
    let now = Time.now();
    let match = donations.entries().find(
      func(entry : (DonationTypes.DonationId, DonationTypes.DonationRecord)) : Bool {
        entry.1.stripeSessionId == sessionId
      }
    );

    switch (match) {
      case (null) false;
      case (?entry) {
        let id = entry.0;
        let record = entry.1;
        let stripeStatus = await Stripe.getSessionStatus(config, sessionId, transform);
        let newStatus : DonationTypes.DonationStatus = switch (stripeStatus) {
          case (#completed(_)) #completed;
          case (#failed(_)) #failed;
        };
        donations.add(id, { record with status = newStatus; updatedAt = now });
        true;
      };
    };
  };

  public func getDonationsByTemple(
    donations : DonationMap,
    templeId : CommonTypes.TempleId,
  ) : [DonationTypes.DonationRecord] {
    List.fromIter<(DonationTypes.DonationId, DonationTypes.DonationRecord)>(donations.entries())
      .filterMap<(DonationTypes.DonationId, DonationTypes.DonationRecord), DonationTypes.DonationRecord>(
        func(entry) {
          if (entry.1.templeId == templeId) ?entry.1 else null
        }
      ).toArray();
  };

  public func getDonationStats(
    donations : DonationMap,
    templeId : CommonTypes.TempleId,
  ) : DonationTypes.DonationStats {
    var totalAmount = 0;
    var completedCount = 0;
    var pendingCount = 0;
    var templeName = "";

    donations.forEach(func(donId, r) {
      if (r.templeId == templeId) {
        templeName := r.templeName;
        switch (r.status) {
          case (#completed) {
            totalAmount += r.amount;
            completedCount += 1;
          };
          case (#pending) {
            pendingCount += 1;
          };
          case (#failed) {};
        };
      };
    });

    {
      templeId = templeId;
      templeName = templeName;
      totalDonations = completedCount + pendingCount;
      totalAmount = totalAmount;
      completedCount = completedCount;
      pendingCount = pendingCount;
    };
  };

  public func getAllDonationStats(
    donations : DonationMap,
  ) : [DonationTypes.DonationStats] {
    let statsMap = Map.empty<CommonTypes.TempleId, DonationTypes.DonationStats>();

    donations.forEach(func(donId, r) {
      let existing = statsMap.get(r.templeId);
      let current : DonationTypes.DonationStats = switch (existing) {
        case (?s) s;
        case null {
          {
            templeId = r.templeId;
            templeName = r.templeName;
            totalDonations = 0;
            totalAmount = 0;
            completedCount = 0;
            pendingCount = 0;
          };
        };
      };
      let updated : DonationTypes.DonationStats = switch (r.status) {
        case (#completed) {
          {
            current with
            totalDonations = current.totalDonations + 1;
            totalAmount = current.totalAmount + r.amount;
            completedCount = current.completedCount + 1;
          };
        };
        case (#pending) {
          {
            current with
            totalDonations = current.totalDonations + 1;
            pendingCount = current.pendingCount + 1;
          };
        };
        case (#failed) current;
      };
      statsMap.add(r.templeId, updated);
    });

    List.fromIter<(CommonTypes.TempleId, DonationTypes.DonationStats)>(statsMap.entries())
      .map<(CommonTypes.TempleId, DonationTypes.DonationStats), DonationTypes.DonationStats>(
        func(entry) { entry.1 }
      ).toArray();
  };
};
