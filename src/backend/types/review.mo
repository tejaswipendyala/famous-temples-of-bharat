import CommonTypes "common";

module {
  public type Review = {
    id : CommonTypes.ReviewId;
    templeId : CommonTypes.TempleId;
    userId : CommonTypes.UserId;
    rating : Nat;
    comment : Text;
    createdAt : CommonTypes.Timestamp;
  };

  public type ReviewInput = {
    templeId : CommonTypes.TempleId;
    rating : Nat;
    comment : Text;
  };
};
