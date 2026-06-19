import CommonTypes "common";

module {
  public type Faq = {
    id : CommonTypes.FaqId;
    templeId : CommonTypes.TempleId;
    question : Text;
    answer : Text;
    createdAt : CommonTypes.Timestamp;
    updatedAt : CommonTypes.Timestamp;
  };

  public type FaqInput = {
    templeId : CommonTypes.TempleId;
    question : Text;
    answer : Text;
  };
};
