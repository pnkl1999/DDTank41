package church.view.weddingRoomList
{
   import com.pickgliss.ui.ComponentFactory;
   import ddt.manager.LanguageMgr;
   import flash.geom.Point;
   
   public class CalculateDate
   {
       
      
      public function CalculateDate()
      {
         super();
      }
      
      public static function start(param1:Date) : Array
      {
         var _loc2_:Date = new Date();
         var _loc3_:Array = new Array();
         var _loc4_:Point = ComponentFactory.Instance.creatCustomObject("church.view.weddingRoomList.pointout");
         var _loc5_:int = (_loc2_.valueOf() - param1.valueOf()) / (60 * 60000);
         if(_loc5_ >= 720)
         {
            _loc3_[0] = "<font COLOR=\'#FF0000\'>" + LanguageMgr.GetTranslation("church.weddingRoom.frame.AddWeddingRoomFrame.exceedmounth") + "</font>";
            _loc3_[1] = "<font COLOR=\'#FF0000\'>" + String(_loc4_.y) + "</font>";
         }
         else if(_loc5_ >= 24 && _loc5_ < 720)
         {
            _loc3_[0] = "<font COLOR=\'#FF0000\'>" + String(int(_loc5_ / 24)) + LanguageMgr.GetTranslation("church.weddingRoom.frame.AddWeddingRoomFrame.day") + "</font>";
            _loc3_[1] = "<font COLOR=\'#FF0000\'>" + String(_loc4_.x) + "</font>";
         }
         else if(_loc5_ < 24)
         {
            _loc3_[0] = LanguageMgr.GetTranslation("church.weddingRoom.frame.AddWeddingRoomFrame.notenoughday");
            _loc3_[1] = "<font COLOR=\'#FF0000\'>" + String(_loc4_.x) + "</font>";
         }
         return _loc3_;
      }
      
      public static function needMoney(param1:Date) : int
      {
         var _loc4_:int = 0;
         var _loc2_:Date = new Date();
         var _loc3_:int = (_loc2_.valueOf() - param1.valueOf()) / (60 * 60000);
         if(_loc3_ >= 720)
         {
            _loc4_ = 999;
         }
         else
         {
            _loc4_ = 5214;
         }
         return _loc4_;
      }
   }
}
