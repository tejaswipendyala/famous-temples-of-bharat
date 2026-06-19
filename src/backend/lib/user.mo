import Map "mo:core/Map";
import List "mo:core/List";
import Principal "mo:core/Principal";
import CommonTypes "../types/common";
import UserTypes "../types/user";

module {
  public type UserMap = Map.Map<CommonTypes.UserId, UserTypes.UserProfile>;

  public func getOrCreate(
    users : UserMap,
    principal : CommonTypes.UserId,
    now : CommonTypes.Timestamp,
  ) : UserTypes.UserProfile {
    switch (users.get(principal)) {
      case (?p) p;
      case null {
        let newProfile : UserTypes.UserProfile = {
          name = "";
          email = "";
          role = #user;
          bookmarkedTemples = [];
          visitHistory = [];
          createdAt = now;
        };
        users.add(principal, newProfile);
        newProfile;
      };
    };
  };

  public func get(users : UserMap, principal : CommonTypes.UserId) : ?UserTypes.UserProfile {
    users.get(principal);
  };

  public func save(
    users : UserMap,
    principal : CommonTypes.UserId,
    profile : UserTypes.UserProfile,
  ) {
    users.add(principal, profile);
  };

  public func setRole(
    users : UserMap,
    principal : CommonTypes.UserId,
    role : UserTypes.UserRole,
  ) : Bool {
    switch (users.get(principal)) {
      case null false;
      case (?p) {
        users.add(principal, { p with role = role });
        true;
      };
    };
  };

  public func addBookmark(
    users : UserMap,
    principal : CommonTypes.UserId,
    templeId : CommonTypes.TempleId,
  ) : Bool {
    switch (users.get(principal)) {
      case null false;
      case (?p) {
        let alreadyBookmarked = p.bookmarkedTemples.any(func(id) { id == templeId });
        if (alreadyBookmarked) return true;
        let updated = p.bookmarkedTemples.concat([templeId]);
        users.add(principal, { p with bookmarkedTemples = updated });
        true;
      };
    };
  };

  public func removeBookmark(
    users : UserMap,
    principal : CommonTypes.UserId,
    templeId : CommonTypes.TempleId,
  ) : Bool {
    switch (users.get(principal)) {
      case null false;
      case (?p) {
        let updated = p.bookmarkedTemples.filter(func(id) { id != templeId });
        users.add(principal, { p with bookmarkedTemples = updated });
        true;
      };
    };
  };

  public func addVisit(
    users : UserMap,
    principal : CommonTypes.UserId,
    templeId : CommonTypes.TempleId,
  ) {
    switch (users.get(principal)) {
      case null {};
      case (?p) {
        let alreadyVisited = p.visitHistory.any(func(id) { id == templeId });
        if (not alreadyVisited) {
          let updated = p.visitHistory.concat([templeId]);
          users.add(principal, { p with visitHistory = updated });
        };
      };
    };
  };

  public func getAll(users : UserMap) : [UserTypes.UserSummary] {
    let entries = users.entries();
    List.fromIter<(CommonTypes.UserId, UserTypes.UserProfile)>(entries)
      .map<(CommonTypes.UserId, UserTypes.UserProfile), UserTypes.UserSummary>(
        func(entry) { toSummary(entry.0, entry.1) }
      ).toArray();
  };

  public func toSummary(principal : CommonTypes.UserId, profile : UserTypes.UserProfile) : UserTypes.UserSummary {
    {
      principal = principal;
      name = profile.name;
      email = profile.email;
      role = profile.role;
      createdAt = profile.createdAt;
    };
  };
};
