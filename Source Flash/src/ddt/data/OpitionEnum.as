package ddt.data
{
   import ddt.manager.PlayerManager;
   
   public class OpitionEnum
   {
      
      public static const RefusedBeFriend:int = 1;
      
      public static const RefusedPrivateChat:int = 4;
      
      public static const IsShowPetSprite:int = 64;
       
      
      public function OpitionEnum()
      {
         super();
      }
      
      public static function setOpitionState(param1:Boolean, param2:int) : int
      {
         var _loc3_:int = PlayerManager.Instance.Self.OptionOnOff;
         if(param1)
         {
            _loc3_ |= param2;
         }
         else
         {
            _loc3_ = ~param2 & _loc3_;
         }
         return _loc3_;
      }
   }
}
