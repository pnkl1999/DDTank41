package tofflist.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SelectedButton;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.SoundManager;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import tofflist.TofflistEvent;
   import tofflist.TofflistModel;
   
   public class TofflistTwoGradeMenu extends Sprite implements Disposeable
   {
      
      public static const ACHIEVEMENTPOINT:String = "achievementpoint";
      
      public static const ASSETS:String = "assets";
      
      public static const BATTLE:String = "battle";
      
      public static const GESTE:String = "geste";
      
      public static const LEVEL:String = "level";
      
      public static const CHARM:String = "charm";
      
      public static const MATCHES:String = "matches";
       
      
      private var _resourceArr:Array;
      
      private var _selectedButtonGroup:SelectedButtonGroup;
      
      private var _styleLinkArr:Array;
      
      public function TofflistTwoGradeMenu()
      {
         super();
      }
      
      public function dispose() : void
      {
         var _loc1_:SelectedButton = null;
         var _loc2_:uint = 0;
         var _loc3_:uint = this._resourceArr.length;
         while(_loc2_ < _loc3_)
         {
            _loc1_ = this._resourceArr[_loc2_].btn;
            _loc1_.removeEventListener(MouseEvent.CLICK,this.__selectToolBarHandler);
            ObjectUtils.disposeObject(_loc1_);
            _loc1_ = null;
            this._resourceArr[_loc2_] = null;
            _loc2_++;
         }
         this._resourceArr = null;
         this._styleLinkArr = null;
      }
      
      public function set resourceLink(param1:String) : void
      {
         var _loc3_:SelectedButton = null;
         var _loc7_:Object = null;
         var _loc2_:Array = [BATTLE,LEVEL,ACHIEVEMENTPOINT,ASSETS,CHARM,MATCHES];
         this._resourceArr = [];
         this._selectedButtonGroup = new SelectedButtonGroup(false,1);
         var _loc4_:Array = param1.replace(/(\s*)|(\s*$)/g,"").split("|");
         var _loc5_:uint = 0;
         var _loc6_:uint = _loc4_.length;
         while(_loc5_ < _loc6_)
         {
            _loc7_ = {};
            _loc7_.id = _loc4_[_loc5_].split("#")[0];
            _loc7_.className = _loc4_[_loc5_].split("#")[1];
            _loc3_ = ComponentFactory.Instance.creatComponentByStylename(_loc7_.className);
            _loc3_.name = _loc2_[_loc5_];
            addChild(_loc3_);
            _loc3_.addEventListener(MouseEvent.CLICK,this.__selectToolBarHandler);
            this._selectedButtonGroup.addSelectItem(_loc3_);
            _loc7_.btn = _loc3_;
            this._resourceArr.push(_loc7_);
            _loc5_++;
         }
         this._selectedButtonGroup.selectIndex = 0;
      }
      
      public function set setAllStyleXY(param1:String) : void
      {
         this._styleLinkArr = param1.replace(/(\s*)|(\s*$)/g,"").split("~");
         this.updateStyleXY();
      }
      
      public function setParentType(param1:String) : void
      {
         this.type = BATTLE;
         this._selectedButtonGroup.selectIndex = 0;
         if(param1 == TofflistStairMenu.PERSONAL)
         {
            this.updateStyleXY();
         }
         else if(param1 == TofflistStairMenu.CROSS_SERVER_PERSONAL)
         {
            this.updateStyleXY(1);
         }
         else
         {
            this.updateStyleXY(2);
         }
      }
      
      public function get type() : String
      {
         return TofflistModel.secondMenuType;
      }
      
      public function set type(param1:String) : void
      {
         TofflistModel.secondMenuType = param1;
         dispatchEvent(new TofflistEvent(TofflistEvent.TOFFLIST_TOOL_BAR_SELECT,this.type));
      }
      
      public function updateStyleXY(param1:int = 0) : void
      {
         var _loc2_:SelectedButton = null;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc7_:int = 0;
         var _loc8_:Point = null;
         var _loc5_:uint = this._resourceArr.length;
         _loc3_ = 0;
         while(_loc3_ < _loc5_)
         {
            _loc2_ = this._resourceArr[_loc3_].btn;
            _loc2_.visible = false;
            _loc3_++;
         }
         var _loc6_:Array = this._styleLinkArr[param1].split("|");
         _loc5_ = _loc6_.length;
         _loc3_ = 0;
         while(_loc3_ < _loc5_)
         {
            _loc2_ = null;
            _loc7_ = _loc6_[_loc3_].split("#")[0];
            _loc4_ = 0;
            while(_loc4_ < this._resourceArr.length)
            {
               if(_loc7_ == this._resourceArr[_loc4_].id)
               {
                  _loc2_ = this._resourceArr[_loc4_].btn;
                  break;
               }
               _loc4_++;
            }
            if(_loc2_ && _loc2_.name != "null")
            {
               _loc8_ = new Point();
               _loc8_.x = _loc6_[_loc3_].split("#")[1].split(",")[0];
               _loc8_.y = _loc6_[_loc3_].split("#")[1].split(",")[1];
               _loc2_.x = _loc8_.x;
               _loc2_.y = _loc8_.y;
               _loc2_.visible = true;
            }
            _loc3_++;
         }
      }
      
      private function __selectToolBarHandler(param1:MouseEvent) : void
      {
         if(this.type == param1.currentTarget.name)
         {
            return;
         }
         SoundManager.instance.play("008");
         this.type = param1.currentTarget.name;
      }
   }
}
