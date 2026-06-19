import Time "mo:core/Time";
import Runtime "mo:core/Runtime";
import AccessControl "mo:caffeineai-authorization/access-control";
import CommonTypes "../types/common";
import TempleTypes "../types/temple";
import TempleLib "../lib/temple";

mixin (
  accessControlState : AccessControl.AccessControlState,
  temples : TempleLib.TempleMap,
  templeCounter : { var next : Nat },
) {
  public query func searchTemples(params : CommonTypes.SearchParams) : async CommonTypes.PaginatedResult<TempleTypes.TempleSummary> {
    TempleLib.search(temples, params);
  };

  public query func getTemple(id : CommonTypes.TempleId) : async ?TempleTypes.Temple {
    TempleLib.get(temples, id);
  };

  public query func getAllTemples() : async [TempleTypes.Temple] {
    TempleLib.getAll(temples);
  };

  public shared ({ caller }) func addTemple(input : TempleTypes.TempleInput) : async TempleTypes.Temple {
    if (not AccessControl.hasPermission(accessControlState, caller, #admin)) {
      Runtime.trap("Unauthorized: Only admins can add temples");
    };
    let id = templeCounter.next;
    templeCounter.next += 1;
    TempleLib.add(temples, id, input, Time.now());
  };

  public shared ({ caller }) func updateTemple(id : CommonTypes.TempleId, input : TempleTypes.TempleInput) : async ?TempleTypes.Temple {
    if (not AccessControl.hasPermission(accessControlState, caller, #admin)) {
      Runtime.trap("Unauthorized: Only admins can update temples");
    };
    TempleLib.update(temples, id, input, Time.now());
  };

  public shared ({ caller }) func deleteTemple(id : CommonTypes.TempleId) : async Bool {
    if (not AccessControl.hasPermission(accessControlState, caller, #admin)) {
      Runtime.trap("Unauthorized: Only admins can delete temples");
    };
    TempleLib.remove(temples, id);
  };
};
