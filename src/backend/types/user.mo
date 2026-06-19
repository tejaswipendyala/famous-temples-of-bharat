import CommonTypes "common";

module {
  public type UserRole = { #user; #admin };

  public type UserProfile = {
    name : Text;
    email : Text;
    role : UserRole;
    bookmarkedTemples : [CommonTypes.TempleId];
    visitHistory : [CommonTypes.TempleId];
    createdAt : CommonTypes.Timestamp;
  };

  public type UserSummary = {
    principal : CommonTypes.UserId;
    name : Text;
    email : Text;
    role : UserRole;
    createdAt : CommonTypes.Timestamp;
  };
};
