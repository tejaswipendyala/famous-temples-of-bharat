import Map "mo:core/Map";
import List "mo:core/List";
import Principal "mo:core/Principal";
import CommonTypes "../types/common";
import ReviewTypes "../types/review";

module {
  public type ReviewMap = Map.Map<CommonTypes.ReviewId, ReviewTypes.Review>;

  public func add(
    reviews : ReviewMap,
    nextReviewId : Nat,
    input : ReviewTypes.ReviewInput,
    userId : CommonTypes.UserId,
    now : CommonTypes.Timestamp,
  ) : ReviewTypes.Review {
    let review : ReviewTypes.Review = {
      id = nextReviewId;
      templeId = input.templeId;
      userId = userId;
      rating = input.rating;
      comment = input.comment;
      createdAt = now;
    };
    reviews.add(nextReviewId, review);
    review;
  };

  public func getByTemple(reviews : ReviewMap, templeId : CommonTypes.TempleId) : [ReviewTypes.Review] {
    List.fromIter<ReviewTypes.Review>(reviews.values())
      .filter(func(r) { r.templeId == templeId })
      .toArray();
  };

  public func hasReviewed(
    reviews : ReviewMap,
    templeId : CommonTypes.TempleId,
    userId : CommonTypes.UserId,
  ) : Bool {
    reviews.any(func(_, r) {
      r.templeId == templeId and Principal.equal(r.userId, userId)
    });
  };
};
