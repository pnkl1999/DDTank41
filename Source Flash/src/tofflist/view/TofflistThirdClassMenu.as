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
   
   public class TofflistThirdClassMenu extends Sprite implements Disposeable
   {
      
      public static const DAY:String = "day";
      
      public static const TOTAL:String = "total";
      
      public static const WEEK:String = "week";
       
      
      private var _resourceArr:Array;
      
      private var _selectedButtonGroup:SelectedButtonGroup;
      
      private var _styleLinkArr:Array;
      
      public function TofflistThirdClassMenu()
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
         var _loc2_:Array = [DAY,WEEK,TOTAL];
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
      
      public function selectType(param1:String, param2:String) : void
      {
         switch(TofflistModel.firstMenuType)
         {
            case TofflistStairMenu.PERSONAL:
            case TofflistStairMenu.CROSS_SERVER_PERSONAL:
               switch(TofflistModel.secondMenuType)
               {
                  case TofflistTwoGradeMenu.BATTLE:
                     this._resourceArr[0].btn.enable = this._resourceArr[1].btn.enable = false;
                     this._resourceArr[2].btn.enable = true;
                     this._selectedButtonGroup.selectIndex = 2;
                     this.type = TOTAL;
                     break;
                  case TofflistTwoGradeMenu.MATCHES:
                     this._resourceArr[0].btn.enable = this._resourceArr[2].btn.enable = false;
                     this._selectedButtonGroup.selectIndex = 1;
                     this.type = WEEK;
                     break;
                  default:
                     this._resourceArr[0].btn.enable = this._resourceArr[1].btn.enable = this._resourceArr[2].btn.enable = true;
                     this._selectedButtonGroup.selectIndex = 1;
                     this.type = WEEK;
               }
               break;
            case TofflistStairMenu.CONSORTIA:
            case TofflistStairMenu.CROSS_SERVER_CONSORTIA:
               switch(TofflistModel.secondMenuType)
               {
                  case TofflistTwoGradeMenu.BATTLE:
                  case TofflistTwoGradeMenu.LEVEL:
                     this._resourceArr[0].btn.enable = this._resourceArr[1].btn.enable = false;
                     this._resourceArr[2].btn.enable = true;
                     this._selectedButtonGroup.selectIndex = 2;
                     this.type = TOTAL;
                     break;
                  default:
                     this._resourceArr[0].btn.enable = this._resourceArr[1].btn.enable = this._resourceArr[2].btn.enable = true;
                     this._selectedButtonGroup.selectIndex = 1;
                     this.type = WEEK;
               }
         }
      }
      
      public function get type() : String
      {
         return TofflistModel.thirdMenuType;
      }
      
      public function set type(param1:String) : void
      {
         TofflistModel.thirdMenuType = param1;
         dispatchEvent(new TofflistEvent(TofflistEvent.TOFFLIST_TOOL_BAR_SELECT,this.type));
      }
      
      public function updateStyleXY(param1:int = 0) : void
      {
         var _loc2_:SelectedButton = null;
         var _loc8_:Point = null;
         _loc2_ = null;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc7_:int = 0;
         _loc8_ = null;
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
            if(_loc2_)
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
