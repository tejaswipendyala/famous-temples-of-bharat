import Time "mo:core/Time";
import Runtime "mo:core/Runtime";
import AccessControl "mo:caffeineai-authorization/access-control";
import CommonTypes "../types/common";
import UserTypes "../types/user";
import UserLib "../lib/user";

mixin (
  accessControlState : AccessControl.AccessControlState,
  users : UserLib.UserMap,
) {
  public query ({ caller }) func getCallerUserProfile() : async ?UserTypes.UserProfile {
    if (not AccessControl.hasPermission(accessControlState, caller, #user)) {
      Runtime.trap("Unauthorized: Login required");
    };
    UserLib.get(users, caller);
  };

  public shared ({ caller }) func saveCallerUserProfile(profile : UserTypes.UserProfile) : async () {
    if (not AccessControl.hasPermission(accessControlState, caller, #user)) {
      Runtime.trap("Unauthorized: Login required");
    };
    // Preserve existing role unless caller is admin
    let existingProfile = UserLib.get(users, caller);
    let safeProfile = switch (existingProfile) {
      case null { { profile with role = #user } };
      case (?existing) { { profile with role = existing.role } };
    };
    UserLib.save(users, caller, safeProfile);
  };

  public query ({ caller }) func getUserProfile(user : CommonTypes.UserId) : async ?UserTypes.UserProfile {
    if (not AccessControl.hasPermission(accessControlState, caller, #user)) {
      Runtime.trap("Unauthorized: Login required");
    };
    UserLib.get(users, user);
  };

  public shared ({ caller }) func bookmarkTemple(templeId : CommonTypes.TempleId) : async Bool {
    if (not AccessControl.hasPermission(accessControlState, caller, #user)) {
      Runtime.trap("Unauthorized: Login required");
    };
    // Ensure user profile exists
    ignore UserLib.getOrCreate(users, caller, Time.now());
    UserLib.addBookmark(users, caller, templeId);
  };

  public shared ({ caller }) func removeBookmark(templeId : CommonTypes.TempleId) : async Bool {
    if (not AccessControl.hasPermission(accessControlState, caller, #user)) {
      Runtime.trap("Unauthorized: Login required");
    };
    UserLib.removeBookmark(users, caller, templeId);
  };

  public query ({ caller }) func getUsers() : async [UserTypes.UserSummary] {
    if (not AccessControl.hasPermission(accessControlState, caller, #admin)) {
      Runtime.trap("Unauthorized: Only admins can list all users");
    };
    UserLib.getAll(users);
  };

  public shared ({ caller }) func setUserRole(user : CommonTypes.UserId, role : UserTypes.UserRole) : async Bool {
    if (not AccessControl.hasPermission(accessControlState, caller, #admin)) {
      Runtime.trap("Unauthorized: Only admins can change user roles");
    };
    UserLib.setRole(users, user, role);
  };

  public query ({ caller }) func isAdmin() : async Bool {
    AccessControl.isAdmin(accessControlState, caller);
  };
};
