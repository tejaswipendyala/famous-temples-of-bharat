import Time "mo:core/Time";
import Runtime "mo:core/Runtime";
import AccessControl "mo:caffeineai-authorization/access-control";
import CommonTypes "../types/common";
import ReviewTypes "../types/review";
import ReviewLib "../lib/review";

mixin (
  accessControlState : AccessControl.AccessControlState,
  reviews : ReviewLib.ReviewMap,
  reviewCounter : { var next : Nat },
) {
  public query func getReviews(templeId : CommonTypes.TempleId) : async [ReviewTypes.Review] {
    ReviewLib.getByTemple(reviews, templeId);
  };

  public shared ({ caller }) func addReview(input : ReviewTypes.ReviewInput) : async ReviewTypes.Review {
    if (not AccessControl.hasPermission(accessControlState, caller, #user)) {
      Runtime.trap("Unauthorized: Login required to submit a review");
    };
    if (input.rating < 1 or input.rating > 5) {
      Runtime.trap("Rating must be between 1 and 5");
    };
    if (ReviewLib.hasReviewed(reviews, input.templeId, caller)) {
      Runtime.trap("You have already reviewed this temple");
    };
    let id = reviewCounter.next;
    reviewCounter.next += 1;
    ReviewLib.add(reviews, id, input, caller, Time.now());
  };
};
