import CommonTypes "common";

module {
  public type TempleId = CommonTypes.TempleId;

  public type DarshanTiming = {
    timingLabel : Text;
    openTime : Text;
    closeTime : Text;
    breakStart : ?Text;
    breakEnd : ?Text;
  };

  public type Pooja = {
    name : Text;
    time : Text;
    description : Text;
    isIncluded : Bool;
    price : ?Nat;
  };

  public type SpecialDarshan = {
    name : Text;
    description : Text;
    price : Nat;
    availableDays : [Text];
  };

  public type Festival = {
    name : Text;
    date : Text;
    significance : Text;
  };

  public type DonationOption = {
    donationType : Text;
    amount : Nat;
    description : Text;
  };

  public type ContactInfo = {
    phone : ?Text;
    email : ?Text;
    website : ?Text;
  };

  public type Temple = {
    id : TempleId;
    name : Text;
    deity : Text;
    state : Text;
    city : Text;
    district : Text;
    address : Text;
    description : Text;
    history : Text;
    images : [Text];
    architectureStyle : Text;
    darshanTimings : [DarshanTiming];
    poojaSchedule : [Pooja];
    specialDarshans : [SpecialDarshan];
    festivalCalendar : [Festival];
    donationOptions : [DonationOption];
    contactInfo : ContactInfo;
    nonHinduRestriction : Bool;
    averageVisitDuration : Nat;
    tags : [Text];
    createdAt : CommonTypes.Timestamp;
    updatedAt : CommonTypes.Timestamp;
  };

  public type TempleInput = {
    name : Text;
    deity : Text;
    state : Text;
    city : Text;
    district : Text;
    address : Text;
    description : Text;
    history : Text;
    images : [Text];
    architectureStyle : Text;
    darshanTimings : [DarshanTiming];
    poojaSchedule : [Pooja];
    specialDarshans : [SpecialDarshan];
    festivalCalendar : [Festival];
    donationOptions : [DonationOption];
    contactInfo : ContactInfo;
    nonHinduRestriction : Bool;
    averageVisitDuration : Nat;
    tags : [Text];
  };

  public type TempleSummary = {
    id : TempleId;
    name : Text;
    deity : Text;
    state : Text;
    city : Text;
    district : Text;
    address : Text;
    images : [Text];
    architectureStyle : Text;
    nonHinduRestriction : Bool;
    averageVisitDuration : Nat;
    tags : [Text];
  };
};
