package ddt.utils
{
   import com.pickgliss.utils.MD5;
   import ddt.manager.PlayerManager;
   import flash.net.URLVariables;
   
   public class RequestVairableCreater
   {
       
      
      public function RequestVairableCreater()
      {
         super();
      }
      
      public static function creatWidthKey(param1:Boolean) : URLVariables
      {
         var _loc2_:URLVariables = new URLVariables();
         _loc2_["selfid"] = PlayerManager.Instance.Self.ID;
         _loc2_["key"] = MD5.hash(PlayerManager.Instance.Account.Password);
         if(param1)
         {
            _loc2_["rnd"] = Math.random();
         }
         return _loc2_;
      }
   }
}
