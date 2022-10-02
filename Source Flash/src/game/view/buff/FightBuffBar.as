package game.view.buff
{
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.FightBuffInfo;
   import flash.display.Sprite;
   
   public class FightBuffBar extends Sprite implements Disposeable
   {
       
      
      private var _buffCells:Vector.<BuffCell>;
      
      public function FightBuffBar()
      {
         this._buffCells = new Vector.<BuffCell>();
         super();
         mouseEnabled = false;
         mouseChildren = false;
      }
      
      private function clearBuff() : void
      {
         var _loc1_:BuffCell = null;
         for each(_loc1_ in this._buffCells)
         {
            _loc1_.clearSelf();
         }
      }
      
      private function drawBuff() : void
      {
      }
      
      public function update(param1:Vector.<FightBuffInfo>) : void
      {
         var _loc5_:BuffCell = null;
         var _loc4_:int = 0;
         _loc5_ = null;
         this.clearBuff();
         var _loc2_:int = param1.length;
         _loc4_ = 0;
         while(_loc4_ < _loc2_)
         {
            if(_loc4_ + 1 > this._buffCells.length)
            {
               _loc5_ = new BuffCell();
               this._buffCells.push(_loc5_);
            }
            else
            {
               _loc5_ = this._buffCells[_loc4_];
            }
            _loc5_.setInfo(param1[_loc4_]);
            _loc5_.x = (_loc4_ & 3) * 24;
            _loc5_.y = -(_loc4_ >> 2) * 24;
            addChild(_loc5_);
            _loc4_++;
         }
      }
      
      public function dispose() : void
      {
         var _loc1_:BuffCell = this._buffCells.shift();
         while(_loc1_)
         {
            ObjectUtils.disposeObject(_loc1_);
            _loc1_ = this._buffCells.shift();
         }
         this._buffCells = null;
      }
   }
}
