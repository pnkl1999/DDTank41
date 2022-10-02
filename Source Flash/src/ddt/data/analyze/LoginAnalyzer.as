package ddt.data.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.ChurchRoomInfo;
   import ddt.manager.ChurchManager;
   import ddt.manager.PlayerManager;
   import im.IMController;
   
   public class LoginAnalyzer extends DataAnalyzer
   {
       
      
      public var tempPassword:String;
      
      public function LoginAnalyzer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc2_:XML = new XML(param1);
         var _loc3_:String = _loc2_.@value;
         message = _loc2_.@message;
         if(_loc3_ == "true")
         {
            PlayerManager.Instance.Self.beginChanges();
            ObjectUtils.copyPorpertiesByXML(PlayerManager.Instance.Self,_loc2_..Item[0]);
            PlayerManager.Instance.Self.commitChanges();
            PlayerManager.Instance.Account.Password = this.tempPassword;
            ChurchManager.instance.selfRoom = _loc2_..Item[0].@IsCreatedMarryRoom == "false"?null:new ChurchRoomInfo();
            onAnalyzeComplete();
            IMController.Instance.setupRecentContactsList();
         }
         else
         {
            onAnalyzeError();
         }
      }
   }
}
