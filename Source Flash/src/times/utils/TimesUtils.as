package times.utils
{
   import com.pickgliss.ui.ComponentFactory;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.Shape;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.getDefinitionByName;
   import times.TimesController;
   import times.data.TimesEvent;
   import times.data.TimesPicInfo;
   
   public class TimesUtils
   {
      
      private static var _reg:RegExp = /\{(\d+)\}/;
       
      
      public function TimesUtils()
      {
         super();
      }
      
      public static function setPos(param1:*, param2:String) : void
      {
         var _loc3_:Point = ComponentFactory.Instance.creatCustomObject(param2);
         param1.x = _loc3_.x;
         param1.y = _loc3_.y;
      }
      
      public static function getWords(param1:String, ... rest) : String
      {
         var _loc6_:int = 0;
         var _loc3_:XML = ComponentFactory.Instance.getCustomStyle(param1);
         var _loc4_:String = _loc3_.@value;
         var _loc5_:Object = _reg.exec(_loc4_);
         while(_loc5_ && rest.length > 0)
         {
            _loc6_ = int(_loc5_[1]);
            if(_loc6_ >= 0 && _loc6_ < rest.length)
            {
               _loc4_ = _loc4_.replace(_reg,rest[_loc6_]);
            }
            else
            {
               _loc4_ = _loc4_.replace(_reg,"{}");
            }
            _loc5_ = _reg.exec(_loc4_);
         }
         return _loc4_;
      }
      
      public static function createCell(param1:Loader, param2:TimesPicInfo) : Array
      {
         var _loc3_:Array = null;
         var _loc4_:MovieClip = null;
         var _loc5_:MovieClip = null;
         var _loc6_:int = 0;
         var _loc8_:String = null;
         var _loc9_:* = undefined;
         var _loc10_:int = 0;
         var _loc11_:* = undefined;
         var _loc12_:Shape = null;
         var _loc13_:Shape = null;
         if(param1 && param1.content as MovieClip)
         {
            _loc4_ = param1.content as MovieClip;
            _loc6_ = _loc4_.numChildren;
            _loc9_ = getDefinitionByName("bagAndInfo.cell.CellFactory");
            _loc10_ = 0;
            while(_loc10_ < _loc6_)
            {
               _loc5_ = _loc4_.getChildAt(_loc10_) as MovieClip;
               if(_loc5_ != null)
               {
                  _loc8_ = _loc5_.name;
                  if(_loc8_.substr(0,4) == "good")
                  {
                     if(!_loc3_)
                     {
                        _loc3_ = [];
                     }
                     _loc12_ = new Shape();
                     _loc12_.graphics.lineStyle(1,16777215,0);
                     _loc12_.graphics.drawRect(0,0,_loc5_.width,_loc5_.height);
                     _loc11_ = _loc9_.instance.createWeeklyItemCell(_loc12_,_loc8_.substr(5));
                     _loc11_.x = _loc5_.x;
                     _loc11_.y = _loc5_.y;
                     _loc11_.alpha = 0;
                     _loc3_.push(_loc11_);
                  }
                  else if(_loc8_.substr(0,8) == "purchase")
                  {
                     TimesController.Instance.dispatchEvent(new TimesEvent(TimesEvent.PUSH_TIP_ITEMS,param2,[_loc5_]));
                     if(!_loc3_)
                     {
                        _loc3_ = [];
                     }
                     _loc13_ = new Shape();
                     _loc13_.graphics.lineStyle(1,16777215,0);
                     _loc13_.graphics.drawRect(0,0,_loc5_.width,_loc5_.height);
                     _loc11_ = _loc9_.instance.createWeeklyItemCell(_loc13_,_loc8_.substr(9));
                     _loc11_.x = _loc5_.x;
                     _loc11_.y = _loc5_.y;
                     _loc11_.alpha = 0;
                     _loc11_.addEventListener(MouseEvent.CLICK,quickBuy);
                     _loc11_.buttonMode = true;
                     _loc3_.push(_loc11_);
                  }
               }
               _loc10_++;
            }
         }
         var _loc7_:int = 0;
         if(_loc4_ && _loc3_ && _loc3_.length > 0)
         {
            while(_loc4_.numChildren == _loc6_ && _loc6_ > _loc7_)
            {
               if(_loc4_.getChildAt(_loc7_).name.substr(0,4) == "good")
               {
                  _loc4_.removeChildAt(_loc7_);
                  _loc6_--;
               }
               else
               {
                  _loc7_++;
               }
            }
         }
         if(_loc3_)
         {
            TimesController.Instance.dispatchEvent(new TimesEvent(TimesEvent.PUSH_TIP_CELLS,param2,_loc3_));
         }
         return _loc3_;
      }
      
      private static function quickBuy(param1:MouseEvent) : void
      {
         var _loc2_:TimesPicInfo = new TimesPicInfo();
         _loc2_.templateID = int(param1.currentTarget.info.TemplateID);
         TimesController.Instance.dispatchEvent(new TimesEvent(TimesEvent.PURCHASE,_loc2_));
      }
   }
}
