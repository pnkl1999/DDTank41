package ddt.view.tips
{
   import com.pickgliss.ui.ComponentFactory;
   import flash.display.Bitmap;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   
   public class LevelPicCreater
   {
      
      private static const pathTip:String = "asset.core.leveltip.";
      
      public static var LEVELTIPCLASSES:Array = ["Level_Tip_0","Level_Tip_1","Level_Tip_2","Level_Tip_3","Level_Tip_4","Level_Tip_5","Level_Tip_6","Level_Tip_7","Level_Tip_8","Level_Tip_9"];
       
      
      public function LevelPicCreater()
      {
         super();
      }
      
      public static function creatLelvePic(param1:int) : Sprite
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Bitmap = null;
         var _loc6_:Bitmap = null;
         var _loc2_:Sprite = new Sprite();
         if(param1 < 10)
         {
            _loc2_.addChild(ComponentFactory.Instance.creatBitmap(pathTip + LEVELTIPCLASSES[param1]));
         }
         else if(param1 > 9)
         {
            _loc3_ = int(param1 / 10);
            _loc4_ = param1 % 10;
            _loc5_ = ComponentFactory.Instance.creatBitmap(pathTip + LEVELTIPCLASSES[_loc3_]);
            _loc6_ = ComponentFactory.Instance.creatBitmap(pathTip + LEVELTIPCLASSES[_loc4_]);
            _loc6_.x = _loc5_.width;
            _loc2_.addChild(_loc5_);
            _loc2_.addChild(_loc6_);
         }
         return _loc2_;
      }
      
      public static function creatLevelPicInContainer(param1:DisplayObjectContainer, param2:int, param3:int, param4:int, param5:Boolean = true) : void
      {
         var _loc7_:Bitmap = null;
         var _loc8_:Bitmap = null;
         var _loc6_:uint = 0;
         _loc7_ = null;
         _loc8_ = null;
         if(param2 > 9)
         {
            _loc6_ = Math.floor(param2 / 10);
            _loc7_ = ComponentFactory.Instance.creat(pathTip + LEVELTIPCLASSES[_loc6_]);
            _loc7_.x = param3 - 4;
            _loc7_.y = param4;
            param1.addChild(_loc7_);
            _loc6_ = param2 % 10;
            _loc8_ = ComponentFactory.Instance.creat(pathTip + LEVELTIPCLASSES[_loc6_]);
            _loc8_.x = _loc7_.x + _loc7_.width - 3;
            _loc8_.y = _loc7_.y;
            param1.addChild(_loc8_);
         }
         else if(param5)
         {
            _loc6_ = 0;
            _loc7_ = ComponentFactory.Instance.creat(pathTip + LEVELTIPCLASSES[_loc6_]);
            _loc7_.x = param3 - 4;
            _loc7_.y = param4;
            param1.addChild(_loc7_);
            _loc6_ = param2;
            _loc8_ = ComponentFactory.Instance.creat(pathTip + LEVELTIPCLASSES[_loc6_]);
            _loc8_.x = _loc7_.x + _loc7_.width - 3;
            _loc8_.y = _loc7_.y;
            param1.addChild(_loc8_);
         }
         else
         {
            _loc6_ = param2;
            _loc8_ = ComponentFactory.Instance.creat(pathTip + LEVELTIPCLASSES[_loc6_]);
            _loc8_.x = param3;
            _loc8_.y = param4;
            param1.addChild(_loc8_);
         }
      }
   }
}
