package trainer.view
{
   import bagAndInfo.cell.BaseCell;
   import flash.display.Sprite;
   
   public class LevelRewardList extends Sprite
   {
       
      
      private var _cells:Vector.<BaseCell>;
      
      public function LevelRewardList()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         this._cells = new Vector.<BaseCell>();
      }
      
      public function addCell(param1:BaseCell) : void
      {
         this._cells.push(param1);
         addChild(param1);
         this.arrangeCell();
      }
      
      private function arrangeCell() : void
      {
         var _loc1_:int = 0;
         _loc1_ = 0;
         _loc1_ = 0;
         while(_loc1_ < this._cells.length)
         {
            this._cells[_loc1_].scaleX = this._cells[_loc1_].scaleY = 1;
            if(_loc1_ == 0)
            {
               addChild(this._cells[0]);
               this._cells[0].x = this._cells[0].y = 0;
            }
            else
            {
               addChild(this._cells[_loc1_]);
               this._cells[_loc1_].x = this._cells[_loc1_ - 1].x + this._cells[_loc1_ - 1].width + 20;
            }
            _loc1_++;
         }
      }
      
      public function disopse() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this._cells.length)
         {
            this._cells[_loc1_].dispose();
            _loc1_++;
         }
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
