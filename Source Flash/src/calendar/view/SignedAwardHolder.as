package calendar.view
{
   import calendar.CalendarModel;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.DaylyGiveInfo;
   import ddt.manager.ItemManager;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.geom.Point;
   
   public class SignedAwardHolder extends Sprite implements Disposeable
   {
       
      
      private var _back:DisplayObject;
      
      private var _model:CalendarModel;
      
      private var _awardCells:Vector.<SignAwardCell>;
      
      public function SignedAwardHolder(param1:CalendarModel)
      {
         this._awardCells = new Vector.<SignAwardCell>();
         super();
         this._model = param1;
         this.configUI();
      }
      
      public function setAwardsByCount(param1:int) : void
      {
         var _loc2_:Point = null;
         var _loc3_:int = 0;
         var _loc4_:DaylyGiveInfo = null;
         var _loc5_:SignAwardCell = null;
         _loc2_ = null;
         _loc3_ = 0;
         _loc4_ = null;
         _loc5_ = null;
         this.clean();
         _loc2_ = ComponentFactory.Instance.creatCustomObject("Calendar.Award.cell.TopLeft");
         _loc3_ = 0;
         for each(_loc4_ in this._model.awards)
         {
            if(_loc4_.AwardDays == param1)
            {
               _loc5_ = ComponentFactory.Instance.creatCustomObject("SignAwardCell");
               this._awardCells.push(_loc5_);
               _loc5_.info = ItemManager.Instance.getTemplateById(_loc4_.TemplateID);
               _loc5_.x = _loc2_.x + _loc3_ * 132;
               _loc5_.y = _loc2_.y;
               _loc5_.setCount(_loc4_.Count);
               addChild(_loc5_);
               _loc3_++;
            }
         }
      }
      
      public function clean() : void
      {
         var _loc1_:SignAwardCell = null;
         var _loc2_:int = 0;
         while(_loc2_ < this._awardCells.length)
         {
            _loc1_ = this._awardCells[_loc2_] as SignAwardCell;
            ObjectUtils.disposeObject(_loc1_);
            _loc1_ = null;
            _loc2_++;
         }
         this._awardCells.splice(0,this._awardCells.length);
      }
      
      private function configUI() : void
      {
         this._back = ComponentFactory.Instance.creatComponentByStylename("Calendar.AwardHolderBack");
         addChild(this._back);
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeObject(this._back);
         this._back = null;
         this.clean();
         this._model = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
