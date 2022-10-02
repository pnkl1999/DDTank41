package im
{
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.net.URLVariables;
   import road7th.utils.StringHelper;
   
   public class AddCommunityFriend
   {
       
      
      public function AddCommunityFriend(param1:String, param2:String)
      {
         super();
         if(StringHelper.isNullOrEmpty(PathManager.solveCommunityFriend))
         {
            return;
         }
         var _loc3_:URLLoader = new URLLoader();
         _loc3_.addEventListener(Event.COMPLETE,this.__addFriendComplete);
         _loc3_.addEventListener(IOErrorEvent.IO_ERROR,this.__addFriendError);
         var _loc4_:URLRequest = new URLRequest(PathManager.solveCommunityFriend);
         var _loc5_:URLVariables = new URLVariables();
         _loc5_["fuid"] = PlayerManager.Instance.Self.LoginName;
         _loc5_["fnick"] = PlayerManager.Instance.Self.NickName;
         _loc5_["tuid"] = param1;
         _loc5_["tnick"] = param2;
         _loc4_.data = _loc5_;
         _loc3_.load(_loc4_);
      }
      
      private function __addFriendComplete(param1:Event) : void
      {
         if((param1.currentTarget as URLLoader).data == "0")
         {
         }
      }
      
      private function __addFriendError(param1:IOErrorEvent) : void
      {
      }
   }
}
