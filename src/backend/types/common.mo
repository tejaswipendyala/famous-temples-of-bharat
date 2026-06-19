module {
  public type TempleId = Nat;
  public type UserId = Principal;
  public type FaqId = Nat;
  public type ReviewId = Nat;
  public type Timestamp = Int;

  public type PaginationParams = {
    offset : Nat;
    limit : Nat;
  };

  public type SearchParams = {
    searchTerm : Text;
    stateFilter : ?Text;
    cityFilter : ?Text;
    pagination : PaginationParams;
  };

  public type PaginatedResult<T> = {
    items : [T];
    total : Nat;
    offset : Nat;
    limit : Nat;
  };
};
