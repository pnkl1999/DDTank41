package auctionHouse.event
{
   import flash.events.Event;
   
   public class AuctionHouseEvent extends Event
   {
      
      public static const CHANGE_STATE:String = "changeState";
      
      public static const GET_GOOD_CATEGORY:String = "getGoodCateGory";
      
      public static const SELECT_STRIP:String = "selectStrip";
      
      public static const DELET_AUCTION:String = "deleteAuction";
      
      public static const ADD_AUCTION:String = "addAuction";
      
      public static const UPDATE_PAGE:String = "updatePage";
      
      public static const PRE_PAGE:String = "prePage";
      
      public static const NEXT_PAGE:String = "nextPage";
      
      public static const SORT_CHANGE:String = "sortChange";
      
      public static const BROWSE_TYPE_CHANGE:String = "browseTypeChange";
       
      
      public function AuctionHouseEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         super(param1,param2,param3);
      }
   }
}
