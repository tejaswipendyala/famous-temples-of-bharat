import Time "mo:core/Time";
import Runtime "mo:core/Runtime";
import AccessControl "mo:caffeineai-authorization/access-control";
import CommonTypes "../types/common";
import FaqTypes "../types/faq";
import FaqLib "../lib/faq";

mixin (
  accessControlState : AccessControl.AccessControlState,
  faqs : FaqLib.FaqMap,
  faqCounter : { var next : Nat },
) {
  public query func getFAQs(templeId : CommonTypes.TempleId) : async [FaqTypes.Faq] {
    FaqLib.getByTemple(faqs, templeId);
  };

  public shared ({ caller }) func addFAQ(input : FaqTypes.FaqInput) : async FaqTypes.Faq {
    if (not AccessControl.hasPermission(accessControlState, caller, #admin)) {
      Runtime.trap("Unauthorized: Only admins can add FAQs");
    };
    let id = faqCounter.next;
    faqCounter.next += 1;
    FaqLib.add(faqs, id, input, Time.now());
  };

  public shared ({ caller }) func updateFAQ(id : CommonTypes.FaqId, input : FaqTypes.FaqInput) : async ?FaqTypes.Faq {
    if (not AccessControl.hasPermission(accessControlState, caller, #admin)) {
      Runtime.trap("Unauthorized: Only admins can update FAQs");
    };
    FaqLib.update(faqs, id, input, Time.now());
  };

  public shared ({ caller }) func deleteFAQ(id : CommonTypes.FaqId) : async Bool {
    if (not AccessControl.hasPermission(accessControlState, caller, #admin)) {
      Runtime.trap("Unauthorized: Only admins can delete FAQs");
    };
    FaqLib.remove(faqs, id);
  };
};
