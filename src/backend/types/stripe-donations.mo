import CommonTypes "common";

module {
  public type DonationId = Nat;

  public type DonationStatus = {
    #pending;
    #completed;
    #failed;
  };

  public type DonationRecord = {
    id : DonationId;
    templeId : CommonTypes.TempleId;
    donor : CommonTypes.UserId;
    amount : Nat;
    currency : Text;
    stripeSessionId : Text;
    status : DonationStatus;
    templeName : Text;
    createdAt : CommonTypes.Timestamp;
    updatedAt : CommonTypes.Timestamp;
  };

  public type CreateDonationInput = {
    templeId : CommonTypes.TempleId;
    amount : Nat;
    currency : Text;
    successUrl : Text;
    cancelUrl : Text;
  };

  public type DonationCheckoutResult = {
    sessionId : Text;
    checkoutUrl : Text;
    donationId : DonationId;
  };

  public type DonationStats = {
    templeId : CommonTypes.TempleId;
    templeName : Text;
    totalDonations : Nat;
    totalAmount : Nat;
    completedCount : Nat;
    pendingCount : Nat;
  };
};
